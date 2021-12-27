function out = gaussKernel(center,data,kernel_b)
% 高斯核函数计算
% 输入:
%   center      ---- 模糊聚类中心
%   data        ---- 样本数据点
%   kernel_b    ---- 高斯核参数
% 输出：
%   out         ---- 高斯核计算结果
if nargin == 2
    kernel_b = 150;
end
dist = zeros(size(center, 1), size(data, 1));
for k = 1:size(center, 1) % 对每一个聚类中心
    % 每一次循环求得所有样本点到一个聚类中心的距离
    dist(k, :) = sqrt(sum(((data-ones(size(data,1),1)*center(k,:)).^2)',1));
end
out = exp(-dist.^2/kernel_b^2);
