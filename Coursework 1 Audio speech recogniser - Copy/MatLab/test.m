function [magSpec] = test(speechFile)

[speechData, fs] = audioread(speechFile);
if fs ~= 16000
    speechData = resample(speechDataOriginal, 16000, fs);
end
numSamples = length(speechData);



frameLength = 512;


numFrames = floor(numSamples / frameLength);


for frame = 1:numFrames*2 - 1 % excluding last frame that exceeds index - inconsequential loss(more likely to be silence)
    firstSample = (frame - 1) * frameLength * 0.5 + 1 ; % half and start index at 1
    lastSample = firstSample + frameLength - 1; % Incrementing by framelength - 1. Example: 1 + (512 - 1) = 512

    x = [num2str(firstSample),':',num2str(lastSample)];
    disp(x);

    
    shortTimeFrame = speechData(firstSample:lastSample);
    [magSpec, phaseData] = magAndPhase(shortTimeFrame, frameLength);
    plot(magSpec);
    hold on;
    
end
end