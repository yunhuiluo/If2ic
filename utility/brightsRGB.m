function bright_srgb=brightsRGB(A,scale)
%% brighten sRGB image
if nargin==1
    scale=0.25;
end
grayim = rgb2gray(A); % Consider only gray channel
grayscale = scale/mean(grayim(:));
bright_srgb = min(1,A * grayscale);