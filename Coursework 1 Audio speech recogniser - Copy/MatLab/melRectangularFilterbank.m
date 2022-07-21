function [fbank] = linearRectangularFilterbank(magSpec, numFilters, frameLength)
sectionSize = floor(frameLength/numFilters);
melLength = hz2mel(frameLength);
melLength = floor(melLength) + 1;

eachMelIndex = zeros(1, numFilters+1);

linearSpace = melLength/numFilters;

eachMelIndex(1,1) = 1;

eachSpace = 0;
for i = 2:numFilters
    eachSpace = eachSpace + linearSpace;
    eachMelIndex(1, i) = round(mel2hz(eachSpace));
end

%hold on;
for i = 1:numFilters
    r = zeros(1,frameLength);   %zero the whole thing

    r(eachMelIndex(i): eachMelIndex(i+1)) = 1;   %filling each linear division with 1s
    %plot(r);
    fbank(i) = r * magSpec;     %stuff

end
end