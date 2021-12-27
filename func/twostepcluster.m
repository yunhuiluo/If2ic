function dataCluSquare = twostepcluster(data_train,opt)
%% 聚类后再聚类
% ex:
% data_train.filesTr = dataTrain.filesTr(1:568,:);
% data_train.cmTr = dataTrain.cmTr(1:568,:);
% data_train.featureTr = dataTrain.featureTr(1:568,:);
% data_train.feat4Cheng = dataTrain.feat4Cheng(1:568,:);
% data_train.illSetTr = dataTrain.illSetTr(1:568,:);
% data_train.illSet8Tr_nor = dataTrain.illSet8Tr_nor(1:568,:);
% data_train.gtIllumTr = dataTrain.gtIllumTr(1:568,:);
% data_train.idxNo = dataTrain.idxNo(1:568,:);
% data_train.adjacentAngleError= dataTrain.adjacentAngleError(1:568,:);
% data_train.colorangle = dataTrain.colorangle(1:568,:);
% dataCluSquare=twostepcluster(data_train,opt);
%%
if nargin<2
    opt=genCNCOptions();
end
k1=opt.k1;
k2=opt.k2;
%%
filesTr = data_train.filesTr;
cmTr = data_train.cmTr;
featureTr = data_train.featureTr;
feat4Cheng = data_train.feat4Cheng;
illSetTr = data_train.illSetTr;
illSet8Tr_nor = data_train.illSet8Tr_nor;
gtIllumTr = data_train.gtIllumTr;
idxNo = data_train.idxNo;
adjacentAngleError= data_train.adjacentAngleError;
colorangle = data_train.colorangle;
illSet8TrNor = data_train.illSet8TrNor;
fisFeatCDF = data_train.fisFeatCDF;
fisFeatIIF = data_train.fisFeatIIF;
meanUnitaryAlgo = data_train.meanUnitaryAlgo;
%% 根据cm分成k1组;同时files,lgt,cm都对应分组
tic
minN=0;
while minN<30*k2
    [idx1, C1] = kmeans(data_train.(opt.cluster1Feature),k1,'Distance','sqeuclidean','MaxIter',10000); %kmean clustering
    [N,~] = histcounts(idx1);
    minN=min(N);
end
%
Subset.filesTr=cell(k1,1);
Subset.cmTr = cell(k1,1);
Subset.featureTr=cell(k1,1);
Subset.feat4Cheng=cell(k1,1);
Subset.illSetTr=cell(k1,1);
Subset.illSet8Tr_nor=cell(k1,1);
Subset.gtIllumTr=cell(k1,1);
Subset.idxNo=cell(k1,1);
Subset.adjacentAngleError=cell(k1,1);
Subset.colorangle=cell(k1,1);
Subset.illSet8TrNor=cell(k1,1);
Subset.fisFeatCDF=cell(k1,1);
Subset.fisFeatIIF=cell(k1,1);
Subset.meanUnitaryAlgo=cell(k1,1);
for i=1:k1
    Subset.filesTr{i}=filesTr(idx1==i);% 因为a()表示一个cell，而a{}表示该cell中的内容，因此改变cell数组中的内容时常用a{}
    Subset.cmTr{i}=cmTr(idx1==i,:);
    Subset.featureTr{i}=featureTr(idx1==i,:);
    Subset.feat4Cheng{i}=feat4Cheng(idx1==i,:);
    Subset.illSetTr{i}=illSetTr(idx1==i);
    Subset.illSet8Tr_nor{i}=illSet8Tr_nor(idx1==i);
    Subset.gtIllumTr{i}=gtIllumTr(idx1==i,:);
    Subset.idxNo{i}=idxNo(idx1==i,:);
    Subset.adjacentAngleError{i}=adjacentAngleError(idx1==i,:);
    Subset.colorangle{i}=colorangle(idx1==i,:);
    Subset.illSet8TrNor{i}=illSet8TrNor(idx1==i,:);
    Subset.fisFeatCDF{i}=fisFeatCDF(idx1==i,:);
    Subset.fisFeatIIF{i}=fisFeatIIF(idx1==i,:);
    Subset.meanUnitaryAlgo{i}=meanUnitaryAlgo(idx1==i,:);    
end
toc
%% 每feature组再分成k2组；同时files,lgt,cm都对应分组
tic
idx2=cell(k1,1);
C2=cell(k1,1);
for i=1:k1
    %if k2>size(data,1),error('error: k2 is too big.'); end
    minN=0;
    while minN<20
        data=Subset.(opt.cluster2Feature){i};
        [idx, C] = kmeans(data,k2,'Distance','cosine','MaxIter',10000); %kmean clustering
        [N,~] = histcounts(idx);
        minN=min(N);
    end
    idx2{i}=idx;
    C2{i}=C;
end
%
SubSubset.filesTr = cell(k1,k2);
SubSubset.cmTr = cell(k1,k2);
SubSubset.featureTr=cell(k1,k2);
SubSubset.feat4ChengTr=cell(k1,k2);
SubSubset.illSetTr=cell(k1,k2);
SubSubset.illSet8Tr_nor=cell(k1,k2);
SubSubset.gtIllumTr = cell(k1,k2);
SubSubset.idxNo = cell(k1,k2);
SubSubset.adjacentAngleError=cell(k1,k2);
SubSubset.colorangle=cell(k1,k2);
SubSubset.illSet8TrNor=cell(k1,k2);
SubSubset.fisFeatCDF=cell(k1,k2);
SubSubset.fisFeatIIF=cell(k1,k2);
SubSubset.meanUnitaryAlgo=cell(k1,k2);
for i=1:k1
    for j=1:k2
        data=Subset.filesTr{i};    SubSubset.filesTr{i,j}=data(idx2{i}==j);
        data=Subset.cmTr{i};       SubSubset.cmTr{i,j}=data(idx2{i}==j,:);
        data=Subset.featureTr{i};  SubSubset.featureTr{i,j}=data(idx2{i}==j,:);
        data=Subset.feat4Cheng{i};  SubSubset.feat4ChengTr{i,j}=data(idx2{i}==j,:);
        data=Subset.illSetTr{i};    SubSubset.illSetTr{i,j}=data(idx2{i}==j);
        data=Subset.illSet8Tr_nor{i};    SubSubset.illSet8Tr_nor{i,j}=data(idx2{i}==j);
        data=Subset.gtIllumTr{i};  SubSubset.gtIllumTr{i,j}=data(idx2{i}==j,:);
        data=Subset.idxNo{i};  SubSubset.idxNo{i,j}=data(idx2{i}==j,:);
        data=Subset.adjacentAngleError{i};  SubSubset.adjacentAngleError{i,j}=data(idx2{i}==j,:);
        data=Subset.colorangle{i};  SubSubset.colorangle{i,j}=data(idx2{i}==j,:);
        data=Subset.illSet8TrNor{i};  SubSubset.illSet8TrNor{i,j}=data(idx2{i}==j,:);
        data=Subset.fisFeatCDF{i};  SubSubset.fisFeatCDF{i,j}=data(idx2{i}==j,:);
        data=Subset.fisFeatIIF{i};  SubSubset.fisFeatIIF{i,j}=data(idx2{i}==j,:);
        data=Subset.meanUnitaryAlgo{i};  SubSubset.meanUnitaryAlgo{i,j}=data(idx2{i}==j,:);
    end
end
toc
%%
dataCluSquare.k1 = k1;
dataCluSquare.k2 = k2;
dataCluSquare.idx1 = idx1;
dataCluSquare.C1 = C1;
dataCluSquare.idx2 = idx2;
dataCluSquare.C2 = C2;
dataCluSquare.filesTr = SubSubset.filesTr;
dataCluSquare.cmTr = SubSubset.cmTr;
dataCluSquare.featureTr = SubSubset.featureTr;
dataCluSquare.feat4ChengTr = SubSubset.feat4ChengTr;
dataCluSquare.illSetTr = SubSubset.illSetTr;
dataCluSquare.illSet8Tr_nor = SubSubset.illSet8Tr_nor;
dataCluSquare.gtIllumTr = SubSubset.gtIllumTr;
dataCluSquare.idxNo = SubSubset.idxNo;
dataCluSquare.adjacentAngleError = SubSubset.adjacentAngleError;
dataCluSquare.colorangle = SubSubset.colorangle;
dataCluSquare.illSet8TrNor = SubSubset.illSet8TrNor;
dataCluSquare.fisFeatCDF = SubSubset.fisFeatCDF;
dataCluSquare.fisFeatIIF = SubSubset.fisFeatIIF;
dataCluSquare.meanUnitaryAlgo = SubSubset.meanUnitaryAlgo;
dataCluSquare.Subset = Subset;