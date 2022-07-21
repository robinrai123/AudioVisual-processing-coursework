%{ 
%Code modified from function dft obtained from https://towardsdatascience.com/fast-fourier-transform-937926e591cb 
%}

function [computed_dft] = dft(dis_audio)
    [N] = size(dis_audio); % get size of discrete audio array
    N = N(1); % extract number of rows
    n = 0:N(1)-1; 
    k = reshape(n,[N,1]);
    sym_matrix = k * n; % compute symmetric matrix of size row x row
    disp(size(k))
    fourier_matrix = exp(-2j * pi * sym_matrix / N); % computes the fourier matrix
    computed_dft = fourier_matrix * dis_audio; % multiply fourier matrix with discrete audio frame
end