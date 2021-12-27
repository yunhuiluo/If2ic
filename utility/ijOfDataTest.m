function ijDataTest = ijOfDataTest (data_test, model,opt)
%%
para=genCNCOptions();

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
    featureFirst = data_test.(para.cluster1Feature)(i,:);
    %data = adjacentAngleError(i,:);
    %data=data.^2;
    %data=[sum(data(:,1:7),2) sum(data(:,8:13),2) sum(data(:,14:18),2) sum(data(:,19:22),2) ...
    %    sum(data(:,23:25),2) sum(data(:,26:27),2) data(:,28)];
    %data=data./repmat(sum(data, 2), 1, 7);
    featureSecond = data_test.(para.cluster2Feature)(i,:);
    [iClus,jClus] = locateRegionIJ(featureFirst,featureSecond,model);
    ijDataTest(i,1)=iClus;
    ijDataTest(i,2)=jClus;
end



