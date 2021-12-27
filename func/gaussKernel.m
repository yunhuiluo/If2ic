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
for k = 1:size(center, 1) % ��ÿһ����������
    % ÿһ��ѭ��������������㵽һ���������ĵľ���
    dist(k, :) = sqrt(sum(((data-ones(size(data,1),1)*center(k,:)).^2)',1));
end
out = exp(-dist.^2/kernel_b^2);
