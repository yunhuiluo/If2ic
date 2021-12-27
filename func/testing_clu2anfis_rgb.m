function est_ill = testing_clu2anfis_rgb (data_test, model,opt)
%%
if nargin<2
    opt=genCNCOptions();
end
%% init
% filesTr = data_test.filesTr;
% cmTr = data_test.cmTr;
featureTr = data_test.featureTr;
% illSetTr = data_test.illSetTr;
illSet8Tr_nor = data_test.illSet8Tr_nor;
% gtIllumTr = data_test.gtIllumTr;
% idxNo = data_test.idxNo;
adjacentAngleError= data_test.adjacentAngleError;
% colorangle = data_test.colorangle;
N = size(featureTr,1);
%% locate the position of (iRegion,jCluster)
ijDataTest = zeros(N,2);
for i=1:N
    featureFirst = data_test.(opt.cluster1Feature)(i,:);
    %data = adjacentAngleError(i,:);
    %data=data.^2;
    %data=[sum(data(:,1:7),2) sum(data(:,8:13),2) sum(data(:,14:18),2) sum(data(:,19:22),2) ...
    %    sum(data(:,23:25),2) sum(data(:,26:27),2) data(:,28)];
    %data=data./repmat(sum(data, 2), 1, 7);
    featureSecond = data_test.(opt.cluster2Feature)(i,:);
    [iClus,jClus] = locateRegionIJ(featureFirst,featureSecond,model);
    ijDataTest(i,1)=iClus;
    ijDataTest(i,2)=jClus;
end
%% datin
IF=zeros(N,16);
datin = cell(N,1);
for i=1:N
    IFmatrix_i =illSet8Tr_nor{i, 1};
    IF(i,:)=reshape(IFmatrix_i(:,1:2)',1,[]);
    datin{i,1} = IF(i,model.inputlocation{ijDataTest(i,1),ijDataTest(i,2)});
end
%% predict
est_ill = zeros(N,3);
for i=1:N
    est_ill(i,1) = evalfis(model.modelR{ijDataTest(i,1),ijDataTest(i,2)},datin{i});
    est_ill(i,2) = evalfis(model.modelG{ijDataTest(i,1),ijDataTest(i,2)},datin{i});
    est_ill(i,3) = evalfis(model.modelB{ijDataTest(i,1),ijDataTest(i,2)},datin{i});
end
est_ill = normalizeChromaticity(est_ill);

%%
% [minAngle, meanAngle, medianAngle, trimeanAngle, best25, worst25, average, maxAngle]= ...
%     calculateExtendedAngularStatistics(data_test.gtIllumTr(468:568,:), est_ill(468:568,:));
% displayCalculatedAngularErrorStatistics(minAngle, meanAngle,...
%     medianAngle, trimeanAngle, best25, worst25, average, maxAngle);
    
