function img=preprocCubepImg(i,homeDir, maskOut)
% from web page of Cube+ dataset
% blackLevel removal, mask out
% img=preprocCubepImg(1707);
% A_sRGB = lin2rgb(img,'OutputType','double');
% figure,imshow(A_sRGB,'InitialMagnification',25);title('Sensor Data With sRGB Gamma Correction');
%%
if (nargin<3)
    maskOut=1;
    if (nargin<2)
        homeDir='E:\dataset\cube+\PNG';
    end
end

img=imread(fullfile(homeDir, [num2str(i), '.png']));

blackLevel=2048;
saturationLevel=max(img(:))-2;
img = (double(img) - blackLevel)/ (double(saturationLevel) - blackLevel);
img(img<0)=0;

m=zeros(size(img, 1), size(img, 2));
for ch=1:3
    m=m+double(img(:, :, ch)>=saturationLevel-blackLevel);
end
m=m>0;
if (maskOut~=0)
    m(1050:end, 2050:end)=1;
end

for ch=1:3
    channel=img(:, :, ch);
    channel(m)=0;
    img(:, :, ch)=channel;
end
end
