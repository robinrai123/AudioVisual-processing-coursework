function [shortTimeMag, shortTimePhase] = magAndPhase(shortFrame, frameLength)
    h = hamming(length(shortFrame));

    shortFrame = shortFrame .* h;
    %xF = fft(shortFrame);

    xF = fft(shortFrame);

    %shortTimeMag = abs(xF(1:floor(frameLength/2)));
    %shortTimeMag = shortTimeMag(1:floor(length(shortFrame)));

    shortTimeMag = abs(xF); % keep reflected portion for by inverse fourier

    shortTimePhase = angle(xF);


    %plot(shortTimeMag);
end