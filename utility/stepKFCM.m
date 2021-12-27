% 子函数
function [U_new,center_new,obj_fcn] = stepKFCM(data,U,center,expo,kernel_b)
% 模糊C均值聚类时迭代的一步
% 输入：
%   data        ---- nxm矩阵,表示n个样本,每个样本具有m的维特征值
%   U           ---- 隶属度矩阵
%   center      ---- 聚类中心
%   expo        ---- 隶属度矩阵U的指数         
%   kernel_b    ---- 高斯核函数的参数
% 输出：
%   U_new       ---- 迭代计算出的新的隶属度矩阵
%   center_new  ---- 迭代计算出的新的聚类中心
%   obj_fcn     ---- 目标函数值
feature_n = size(data,2);  % 特征维数
cluster_n = size(center,1); % 聚类个数
mf = U.^expo;       % 隶属度矩阵进行指数运算（c行n列)

% 计算新的聚类中心;根据(5.15）式
KernelMat = gaussKernel(center,data,kernel_b); % 计算高斯核矩阵(c行n列)
num = mf.*KernelMat * data;   % 式(5.15)的分子(c行p列,p为特征维数)
den = sum(mf.*KernelMat,2);   % 式子(5.15)的分子，(c行,1列,尚未扩展)
center_new = num./(den*ones(1,feature_n)); % 计算新的聚类中心(c行p列,c个中心)

% 计算新的隶属度矩阵；根据(5.14)式子
kdist = distKFCM(center_new, data, kernel_b);    % 计算距离矩阵
obj_fcn = sum(sum((kdist.^2).*mf));  % 计算目标函数值 (5.11)式
tmp = kdist.^(-1/(expo-1));     
U_new = tmp./(ones(cluster_n, 1)*sum(tmp)); 

