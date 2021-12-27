function [iClus,jClus] = locateRegionIJ(featureFirst,featureSecond,model)
%% 查询得到分组号ij，i=1,...,k1;j=1,...,k2
% featureFirst = model.dataCluSquare.featureSubSubset{1, 1}(1,:);
% data = model.dataCluSquare.adjacentAngleError{1, 1}(1,:);
% data=data.^2;
% data=[sum(data(:,1:7),2) sum(data(:,8:13),2) sum(data(:,14:18),2) sum(data(:,19:22),2) ...
%     sum(data(:,23:25),2) sum(data(:,26:27),2) data(:,28)];
% data=data./repmat(sum(data, 2), 1, 7);
% featureSecond = data;
% [iClus,jClus] = locateRegionIJ(featureFirst,featureSecond,model)
%%
C1 = model.dataCluSquare.C1;
C2 = model.dataCluSquare.C2;
%% 查询得到分组号码ij，i=1,...,k1;j=1,...,k2
% i
[dH,idH] = pdist2(C1,featureFirst,'cosine','Smallest',1); % gets naerest K faetures
i=idH;
% j
[dH,idH] = pdist2(C2{i},featureSecond,'cosine','Smallest',1); % gets naerest K faetures
j=idH;
%%
iClus = i;
jClus = j;