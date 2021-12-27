function out = distKFCM(center, data, kernel_b)
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

