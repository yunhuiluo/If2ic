function savefigure2img(imgname)
%% ��ȡfigure����
%     ����  imshow(uint8(data),'border','tight','initialmagnification','fit');  
% 
%    ������ʾͼƬͼƬ����˼��uint8��data����ͼƬdata���޷��Ű�λ����ʽ��ʾ�������data��matlab����������ͼƬ����ֵ�ľ��󣬺���Ĳ�����ȥ�����ף������޸ģ��ճ��ͺá�
% 
%    Ȼ��set (gcf,'Position',[0,0,ͼƬ�Ŀ��,ͼƬ�ĸ߶�]); �Ϳ���save asΪeps��ʽ���в����ˡ�
frame = getframe(gcf);
%% תΪͼ��
im = frame2im(frame);
%% ����
imwrite(im,imgname);
end