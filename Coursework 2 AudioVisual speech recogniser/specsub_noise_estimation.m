%{
    url : https://www.youtube.com/watch?v=2BgBMNg6VsA
    Title: Matlab code for spectral enhancement using spectral subtraction
    algorithm

    url : https://dennyhermawanto.wordpress.com/2019/02/25/spectral-subtraction-matlab-code/
%}
function [enhanced] = specsub_noise_estimation(noisySignal,fs, frameDuration)

frameDuration = 0.02; %20 ms period

frameLength = fs * frameDuration;

numSamples = length(noisySignal);

numFrames = floor(numSamples / frameLength);

noiseVector = noisySignal(1 : frameLength * 15);

noiseIndex = 0;

noiseEstimate = 0;

for frame = 1: floor(length(noiseVector) / frameLength) *2 - 1 % excluding last frame that exceeds index - inconsequential loss(more likely to be silence)

    firstSample = (frame - 1) * frameLength * 0.5 + 1 ; % half and start index at 1

    lastSample = firstSample + frameLength - 1; % Incrementing by framelength - 1. Example: 1 + (512 - 1) = 512

    noiseFrame = noiseVector(firstSample:lastSample);

    hannedNoiseFrame = hann(length(noiseFrame)) .* noiseFrame;

    magNoise = abs(fft(hannedNoiseFrame));

    noiseEstimate = noiseEstimate + magNoise;

    noiseIndex = noiseIndex + 1;

end

noiseEstimate = noiseEstimate/noiseIndex;

enhanced = zeros(numSamples,1);


for frame = 1:numFrames*2 - 1 % excluding last frame that exceeds index - inconsequential loss(more likely to be silence)

    firstSample = (frame - 1) * frameLength * 0.5 + 1 ; % half and start index at 1

    lastSample = firstSample + frameLength - 1; % Incrementing by framelength - 1. Example: 1 + (512 - 1) = 512

    noisyFrame = noisySignal(firstSample:lastSample);

    %frameEmphasised = filter([1, -0.97],1,noisyFrame);

    %shortTimeFrame = frameEmphasised;

    shortTimeFrame = noisyFrame;
    
    %[magSpec, phaseData] = magAndPhase(shortTimeFrame, frameLength);
      
    hannedNoisyFrame = hann(length(shortTimeFrame)) .* noisySignal(firstSample:lastSample);

    noisyComplex = fft(hannedNoisyFrame);

    noisyMag = abs(noisyComplex);

    noisyPhase = angle(noisyComplex);

    cleanMag = noisyMag - noiseEstimate;

    cleanMag(cleanMag<0)=0;

    cleanComplex = cleanMag.* exp(noisyPhase* sqrt(-1));
        
    cleanFrame = real(ifft(cleanComplex));

    enhanced((frame-1)*(frameLength/2)+1:(frame-1)*(frameLength/2)+frameLength) = enhanced( (frame-1)*(frameLength/2)+1:(frame-1)*(frameLength/2)+frameLength ) + cleanFrame;       


end

end