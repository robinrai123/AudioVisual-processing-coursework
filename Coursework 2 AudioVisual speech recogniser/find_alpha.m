function [alpha] = find_alpha(speech, noise, target_SNR)
    alpha = sqrt(signal_power(speech)/signal_power(noise) * (10 ^ (-target_SNR /10)));
end