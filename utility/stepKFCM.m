% �Ӻ���
function [U_new,center_new,obj_fcn] = stepKFCM(data,U,center,expo,kernel_b)
% ģ��C��ֵ����ʱ������һ��
% ���룺
%   data        ---- nxm����,��ʾn������,ÿ����������m��ά����ֵ
%   U           ---- �����Ⱦ���
%   center      ---- ��������
%   expo        ---- �����Ⱦ���U��ָ��         
%   kernel_b    ---- ��˹�˺����Ĳ���
% �����
%   U_new       ---- ������������µ������Ⱦ���
%   center_new  ---- ������������µľ�������
%   obj_fcn     ---- Ŀ�꺯��ֵ
feature_n = size(data,2);  % ����ά��
cluster_n = size(center,1); % �������
mf = U.^expo;       % �����Ⱦ������ָ�����㣨c��n��)

% �����µľ�������;����(5.15��ʽ
KernelMat = gaussKernel(center,data,kernel_b); % �����˹�˾���(c��n��)
num = mf.*KernelMat * data;   % ʽ(5.15)�ķ���(c��p��,pΪ����ά��)
den = sum(mf.*KernelMat,2);   % ʽ��(5.15)�ķ��ӣ�(c��,1��,��δ��չ)
center_new = num./(den*ones(1,feature_n)); % �����µľ�������(c��p��,c������)

% �����µ������Ⱦ��󣻸���(5.14)ʽ��
kdist = distKFCM(center_new, data, kernel_b);    % ����������
obj_fcn = sum(sum((kdist.^2).*mf));  % ����Ŀ�꺯��ֵ (5.11)ʽ
tmp = kdist.^(-1/(expo-1));     
U_new = tmp./(ones(cluster_n, 1)*sum(tmp)); 

