function [noisyData] = masking(speechData, noiseFile, snr)
 

if noiseFile ~= ""
    [noiseData, fs] = audioread(noiseFile);
    
    noiseData = noiseData * find_alpha(speechData,noiseData,snr);

    noisyData = speechData + noiseData(1:length(speechData));
% 
   % soundsc(noisyData,16000);
% 
    %pause();

    %soundsc(speechData,16000);
end

frameDuration = 0.02; %20 ms period
frameLength = 16000 * 0.02;
numSamples = length(speechData);

numFrames = floor(numSamples / frameLength);

numBins = 16000 * 0.02; %sup, probably wanna turn this into frameLength

ibm = zeros(numFrames*2 - 1,numBins); % accounts for overlapping

maskedMag = zeros(numFrames*2 - 1,numBins);

enhanced = zeros(numSamples,1);

for frame = 1:numFrames*2 - 1 % excluding last frame that exceeds index - inconsequential loss(more likely to be silence)

    firstSample = (frame - 1) * frameLength * 0.5 + 1 ; % half and start index at 1

    lastSample = firstSample + frameLength - 1; % Incrementing by framelength - 1. Example: 1 + (512 - 1) = 512

    shortTimeFrame = speechData(firstSample:lastSample);

    frameEmphasised = filter([1, -0.97],1,shortTimeFrame);

    shortTimeFrame = frameEmphasised;
    
    %[magSpec, phaseData] = magAndPhase(shortTimeFrame, frameLength);
      
    speechTimeFrame = hann(length(shortTimeFrame)) .* speechData(firstSample:lastSample);

    noiseTimeFrame = hann(length(shortTimeFrame)) .* noiseData(firstSample:lastSample);

    noisyTimeFrame = hann(length(shortTimeFrame)) .* noisyData(firstSample:lastSample);

    [magSpecSpeech, phaseSpeech] = magAndPhase(speechTimeFrame, frameLength);

    [magSpecNoise, phaseNoise] = magAndPhase(noiseTimeFrame, frameLength);

    [magSpecNoise, phaseNoisy] = magAndPhase(noisyTimeFrame, frameLength);

      for bin=1:numBins
              ibm( frame, bin ) = signal_power(magSpecSpeech(bin))/signal_power(magSpecNoise(bin));
              ibm(frame, bin) = ibm(frame, bin);
       end

%       for bin=1:numBins
%           if magSpecSpeech(bin) > magSpecNoise(bin)
%               ibm( frame, bin ) = 1;
%           else
%               ibm( frame, bin ) = 0;
%           end
%       end

     maskedMag(frame,:) = ibm(frame,:) .* transpose(magSpecNoise);

     %phaseNoisy(frame);

     realSpec = maskedMag(frame,:) .* transpose(cos(phaseNoisy));

     imagSpec = maskedMag(frame,:) .* transpose(sin(phaseNoisy));
     
     complexSpec = realSpec + j * imagSpec;
     
     maskedFrame = real(ifft( complexSpec ));

     eFrameHann = transpose(hann(frameLength) .* transpose(maskedFrame(1:frameLength)));

     enhanced((frame-1)*(frameLength/2)+1:(frame-1)*(frameLength/2)+frameLength) = enhanced( (frame-1)*(frameLength/2)+1:(frame-1)*(frameLength/2)+frameLength ) + transpose(eFrameHann(1:frameLength));

end


end
