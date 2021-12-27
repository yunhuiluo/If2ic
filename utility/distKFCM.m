function out = distKFCM(center, data, kernel_b)
% 计算样本点距离聚类中心的距离
% 输入：
%   center     ---- 聚类中心
%   data       ---- 样本点
% 输出：
%   out        ---- 距离
cluster_n = size(center, 1);
data_n = size(data, 1);
out = zeros(cluster_n, data_n);
for i = 1:cluster_n % 对每个聚类中心 
    vi = center(i,:);
    out(i,:) = 2-2*gaussKernel(vi,data,kernel_b);
end

