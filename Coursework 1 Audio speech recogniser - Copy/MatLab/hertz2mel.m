function [melConversion] = hertz2mel(frameLength)
    melConversion = 2595 * log10(1 + frameLength / 700);
end