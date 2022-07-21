function [melConversion] = mel2hertz(mel)
    melConversion = 700 * (10^(mel/2595) -1);
end