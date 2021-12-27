function A_sRGB=correctColorBalance(A,illuminant)
B_lin = chromadapt(A, illuminant, 'ColorSpace', 'linear-rgb',...
    'Method','bradford');

grayim = rgb2gray(B_lin); % Consider only gray channel
grayscale = 0.25/mean(grayim(:));
bright_srgb = min(1,B_lin * grayscale);

A_sRGB = lin2rgb(bright_srgb);
%figure,imshow(A_sRGB,'InitialMagnification',25);