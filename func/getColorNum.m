function [nc,n0] = getColorNum(img)
% requititate color with 6 bits
% img=imread('D:\nutstore\我的坚果云\QLU\paper\paper_IlluminationEst\Illum_Est_Matlab\fuzzyTmp\resultImg\Cubep\test.jpg');
% img=imread(dataTrain.filesTr{1637,1});%img1=imread(dataTrain.filesTr{1,1});
% nc0 = size(unique(reshape(img, [], 3), 'rows'), 1)
% nc = getColorNum(img)
% [nc,n0] = getColorNum(img)
ccc=double(img); % 256*256*256
if isa(img,'uint16')   
    ddd=fix(ccc*64/256/256);
else
    ddd=fix(ccc*64/256);
end
nc = size(unique(reshape(ddd, [], 3), 'rows'), 1);
if nargout==2
    n0= size(unique(reshape(img, [], 3), 'rows'), 1);
end

