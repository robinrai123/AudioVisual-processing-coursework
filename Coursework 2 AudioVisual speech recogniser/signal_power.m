function [power] = signal_power(d)
    power = mean(d.^2);
end

