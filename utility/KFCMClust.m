function [center, U, obj_fcn] = KFCMClust(data, cluster_n, kernel_b,options)
% FCMClust.m   ����ģ��C��ֵ�����ݼ�data��Ϊcluster_n�� 
%
% �÷���
%   1.  [center,U,obj_fcn] = KFCMClust(Data,N_cluster,kernel_b,options);
%   2.  [center,U,obj_fcn] = KFCMClust(Data,N_cluster,kernel_b);
%   3.  [center,U,obj_fcn] = KFCMClust(Data,N_cluster);
%   
% ���룺
%   data        ---- nxm����,��ʾn������,ÿ����������m��ά����ֵ
%   N_cluster   ---- ����,��ʾ�ۺ�������Ŀ,�������
%   kernel_b    ---- ��˹�˲���b                           ��ȱʡֵ��150��
%   options     ---- 4x1��������
%       options(1):  �����Ⱦ���U��ָ����>1                  (ȱʡֵ: 2.0)
%       options(2):  ����������                           (ȱʡֵ: 100)
%       options(3):  ��������С�仯��,������ֹ����           (ȱʡֵ: 1e-5)
%       options(4):  ÿ�ε����Ƿ������Ϣ��־                (ȱʡֵ: 1)
% �����
%   center      ---- ��������
%   U           ---- �����Ⱦ���
%   obj_fcn     ---- Ŀ�꺯��ֵ
%   Example:
%       data = rand(100,2);
%       [center,U,obj_fcn] = KFCMClust(data,2);
%       plot(data(:,1), data(:,2),'o');
%       hold on;
%       maxU = max(U);
%       index1 = find(U(1,:) == maxU);
%       index2 = find(U(2,:) == maxU);
%       line(data(index1,1),data(index1,2),'marker','*','color','g');
%       line(data(index2,1),data(index2,2),'marker','*','color','r');
%       plot([center([1 2],1)],[center([1 2],2)],'*','color','k')
%       hold off;

%   Author: Genial
%   Date:   2005.5

%  һ��ͼ����ʾ�෽ͼƬ��montage


error(nargchk(2,4,nargin));    %��������������

data_n = size(data, 1); % ���data�ĵ�һά(rows)��,����������
in_n = size(data, 2);   % ���data�ĵڶ�ά(columns)����������ֵ����,Ŀǰû����
% Ĭ�ϲ�������
default_b = 150;         % ��˹�˺�������
default_options = [2;	% �����Ⱦ���U��ָ��
    100;                % ���������� 
    1e-5;               % ��������С�仯��,������ֹ����
    1];                 % ÿ�ε����Ƿ������Ϣ��־ 

if nargin == 2,
    kernel_b = default_b;
	options = default_options;
elseif nargin == 3,
    options = default_options;
else    %������options������ʱ������
	% ����������������3��ô�͵���Ĭ�ϵ�option;
    %����û�����opition������4����ô�ͽ�ʣ���Ĭ��option����;
	if length(options) < 4, 
		tmp = default_options;
		tmp(1:length(options)) = options;
		options = tmp;
    end
    % ����options��������ֵΪ0(��NaN),������ʱΪ1
	nan_index = find(isnan(options)==1);
    %��denfault_options�ж�Ӧλ�õĲ�����ֵ��options�в�������λ��.
	options(nan_index) = default_options(nan_index);
	if options(1) <= 1,
        %���options�е�ָ��m������1����
		error('The exponent should be greater than 1!');
	end
end
%��options �еķ����ֱ�ֵ���ĸ�����;
expo = options(1);          % �����Ⱦ���U��ָ��
max_iter = options(2);		% ���������� 
min_impro = options(3);		% ��������С�仯��,������ֹ����
display = options(4);		% ÿ�ε����Ƿ������Ϣ��־ 

obj_fcn = zeros(max_iter, 1);	% ��ʼ���������obj_fcn
U = initkfcm(cluster_n, data_n);	% ��ʼ��ģ���������,ʹU�����������Ϊ1

% ��ʼ���������ģ����������ݵ�������ѡȡcluster_n��������Ϊ�������ġ���Ȼ��
% �������ĳЩ����֪ʶѡȡ���Ļ����ܹ��ﵽ�ӿ��ȶ���Ч������Ŀǰ���߱��⹦��
index = randperm(data_n);   % �����������������
center_old = data(index(1:cluster_n),:);  % ѡȡ������е�������ǰcluster_n��

% Main loop  ��Ҫѭ��
for i = 1:max_iter,
    %�ڵ�k��ѭ���иı��������ceneter,�ͷ��亯��U��������ֵ;
	[U, center, obj_fcn(i)] = stepkfcm(data,U,center_old, expo, kernel_b);
	if display, 
		fprintf('KFCM:Iteration count = %d, obj. fcn = %f\n', i, obj_fcn(i));
    end
    center_old = center;    % ���µľ������Ĵ����ϵľ�������
	% ��ֹ�����б�
	if i > 1,
		if abs(obj_fcn(i) - obj_fcn(i-1)) < min_impro, break; end,
	end
end

iter_n = i;	% ʵ�ʵ������� 
obj_fcn(iter_n+1:max_iter) = [];


% �Ӻ���
function U = initkfcm(cluster_n, data_n)
% ��ʼ��fcm�������Ⱥ�������
% ����:
%   cluster_n   ---- �������ĸ���
%   data_n      ---- ��������
% �����
%   U           ---- ��ʼ���������Ⱦ���
U = rand(cluster_n, data_n);
col_sum = sum(U);
U = U./col_sum(ones(cluster_n, 1), :);



% �Ӻ���
function [U_new,center_new,obj_fcn] = stepkfcm(data,U,center,expo,kernel_b)
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
kdist = distkfcm(center_new, data, kernel_b);    % ����������
obj_fcn = sum(sum((kdist.^2).*mf));  % ����Ŀ�꺯��ֵ (5.11)ʽ
tmp = kdist.^(-1/(expo-1));     
U_new = tmp./(ones(cluster_n, 1)*sum(tmp)); 



% �Ӻ���
function out = distkfcm(center, data, kernel_b)
% �������������������ĵľ���
% ���룺
%   center     ---- ��������
%   data       ---- ������
% �����
%   out        ---- ����
cluster_n = size(center, 1);
data_n = size(data, 1);
out = zeros(cluster_n, data_n);
for i = 1:cluster_n % ��ÿ���������� 
    vi = center(i,:);
    out(i,:) = 2-2*gaussKernel(vi,data,kernel_b);
end



% �Ӻ���
function out = gaussKernel(center,data,kernel_b)
% ��˹�˺�������
% ����:
%   center      ---- ģ����������
%   data        ---- �������ݵ�
%   kernel_b    ---- ��˹�˲���
% �����
%   out         ---- ��˹�˼�����
if nargin == 2
    kernel_b = 150;
end
dist = zeros(size(center, 1), size(data, 1));
for k = 1:size(center, 1), % ��ÿһ����������
    % ÿһ��ѭ��������������㵽һ���������ĵľ���
    dist(k, :) = sqrt(sum(((data-ones(size(data,1),1)*center(k,:)).^2)',1));
end
out = exp(-dist.^2/kernel_b^2);
%max(dist),min(dist)



