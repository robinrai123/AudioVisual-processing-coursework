function [magSpec] = featureExtraction(speechFile, ibmnoiseFile, activate_spec_sub, numChannels, numFilters, path, fileOutputName)

%Read in audio data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[speechData, fs] = audioread(speechFile);

if fs ~= 16000
    speechData = resample(speechData, 16000, fs);
    fs = 16000;
end

 if ~strcmp(ibmnoiseFile,"")
     snr = -10;
     speechData = masking(speechData,ibmnoiseFile,snr);
 end



frameDuration = 0.02; %20 ms period
frameLength = 16000 * frameDuration;
numSamples = length(speechData);

%Set number of frames
numFrames = floor(numSamples / frameLength);

if activate_spec_sub
    speechData = specsub_noise_estimation(speechData, fs, frameDuration);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%General variable initialisation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%numChannels halved to get rid of reflections/hamonics at the end
featureArray = zeros(numFrames*2 - 1,numChannels/2);
velocityArray = zeros(numFrames*2 - 1,numChannels/2);
accelerationArray = zeros(numFrames*2 - 1,numChannels/2);
energyArray = zeros(numFrames*2 - 1,1);

numBins = 512; %sup, probably wanna turn this into frameLength
ibm = zeros(numFrames*2 - 1,numBins);
maskedMag = zeros(numFrames*2 - 1,numBins);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Main for every frame loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Goes through entire audio file frame by frame
for frame = 1:numFrames*2 - 1 %Chop off last frame as overlapping would go beyond array

    %Finding indexes for frames with overlapping
    firstSample = (frame - 1) * frameLength * 0.5 + 1 ; % half and start index at 1
    lastSample = firstSample + frameLength - 1; % Incrementing by framelength - 1. Example: 1 + (512 - 1) = 512

    %Get frame
    shortTimeFrame = speechData(firstSample:lastSample);
    
    %Get energy of each frame
    energyArray(frame) = log(signal_power(shortTimeFrame));

    %Frame emphasis
    frameEmphasised = filter([1, -0.97],1,shortTimeFrame);
    shortTimeFrame = frameEmphasised;
    
    %Magnitude spectrum
    [magSpec, phaseData] = magAndPhase(shortTimeFrame, frameLength);
      
    %Filterbank    
    %fbank = melTriangularFilterbankOverlapping(magSpec, numFilters, frameLength);
    fbank = linearRectangularFilterbank(magSpec, numFilters, frameLength);

    %log
    %Prevent -Inf by not logging 0
    for i = 1:length(fbank)
        if fbank(i) == 0
            fbank(i) = eps;
        end
    end

    logVar = log(fbank);

    %DCT
    quefrency = dct(logVar);
    
    %Truncate mirrored side
    quefrencyTrun = quefrency(1:floor(length(quefrency)/2));

    %Transpose and add
    featureArray(frame,:) = transpose(quefrencyTrun); 

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Temporal vectors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%velocity feature
%For first and last frames use said frames instead of outside the index.
velocityArray(1,:) = featureArray(2,:)-featureArray(1,:);
for frame = 2:numFrames*2 - 2
    velocityArray(frame,:) = featureArray(frame+1,:)-featureArray(frame-1,:);
end
velocityArray(numFrames*2-1,:) = featureArray(numFrames*2 -1,:)-featureArray(numFrames*2 - 2,:);


%acceleration feature
accelerationArray(1,:) = velocityArray(2,:)-velocityArray(1,:);
for frame = 2:numFrames*2 - 2
    accelerationArray(frame,:) = velocityArray((frame+1),:)-velocityArray((frame-1),:);
end
accelerationArray(numFrames*2-1,:) = velocityArray(numFrames*2 -1,:)-velocityArray(numFrames*2 - 2,:);

%Merge features with temporal arrays and energu
totalFeatureArray = horzcat(featureArray,velocityArray,accelerationArray,energyArray);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Writing output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
writeHTK(path + fileOutputName, 10, numFrames*2-1 , numChannels/2 * 3+1, totalFeatureArray);
writeProtoFile(path, "proto", 18, numChannels/2 * 3+1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
