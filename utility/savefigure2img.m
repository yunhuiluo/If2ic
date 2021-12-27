function savefigure2img(imgname)
%% 获取figure界面
%     首先  imshow(uint8(data),'border','tight','initialmagnification','fit');  
% 
%    这是显示图片图片的意思，uint8（data）是图片data以无符号八位数格式显示，这里的data是matlab工作区保存图片像素值的矩阵，后面的参数是去除留白，不用修改，照抄就好。
% 
%    然后set (gcf,'Position',[0,0,图片的宽度,图片的高度]); 就可以save as为eps格式进行插入了。
frame = getframe(gcf);
%% 转为图像
im = frame2im(frame);
%% 保存
imwrite(im,imgname);
end