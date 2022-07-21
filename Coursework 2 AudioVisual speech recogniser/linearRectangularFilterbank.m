function [fbank] = linearRectangularFilterbank(magSpec, numFilters, frameLength)
sectionSize = floor(frameLength/numFilters);
x = 0;

for i = 1:numFilters
    r = zeros(1,frameLength);   %zero the whole thing
    r(x+1:x+sectionSize) = 1;   %filling each linear division with 1s
    fbank(i) = r * magSpec;     %stuff
    x = x + sectionSize;


end
end