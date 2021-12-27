function est_ill = testing_clu2anfis_log(data_test, model,opt)
%%
if nargin<2
    opt=genCNCOptions();
end
%% init
% filesTr = data_test.filesTr;
% cmTr = data_test.cmTr;
% featureTr = data_test.featureTr;
% illSetTr = data_test.illSetTr;
illSet8Tr_nor = data_test.illSet8Tr_nor;
% illSet8TrNor = data_test.illSet8TrNor;
% gtIllumTr = data_test.gtIllumTr;
% idxNo = data_test.idxNo;
% adjacentAngleError= data_test.adjacentAngleError;
% colorangle = data_test.colorangle;
N = size(data_test.featureTr,1);
%% locate the position of (iRegion,jCluster)
ijDataTest = zeros(N,2);
for i=1:N
    featureFirst = data_test.(opt.cluster1Feature)(i,:);
    %data = adjacentAngleError(i,:);
    %data=data.^2;
    %data=[sum(data(:,1:7),2) sum(data(:,8:13),2) sum(data(:,14:18),2) sum(data(:,19:22),2) ...
    %    sum(data(:,23:25),2) sum(data(:,26:27),2) data(:,28)];
    %data=data./repmat(sum(data, 2), 1, 7);
    %dat=illSet8Tr_nor(i);
    %data=zeros(size(dat,1),3);
    %for nRow=1:size(dat,1)
    %    data(nRow,:)=mean(dat{nRow});
    %end
    featureSecond = data_test.(opt.cluster2Feature)(i,:);
    [iClus,jClus] = locateRegionIJ(featureFirst,featureSecond,model);
    ijDataTest(i,1)=iClus;
    ijDataTest(i,2)=jClus;
end
%% datin
% IF=zeros(N,16);
% datin = cell(N,1);
% for i=1:N
%     IFmatrix_i =illSet8Tr_nor{i, 1};
%     IF(i,:)=reshape(IFmatrix_i(:,1:2)',1,[]);
%     datin{i,1} = IF(i,model.inputlocation{ijDataTest(i,1),ijDataTest(i,2)});
% end
logIF = zeros(N,16);
datin = cell(N,1);
for i=1:N
    IFmatrix_i=illSet8Tr_nor{i, 1};
    logIF_i = log2([IFmatrix_i(:,2)./IFmatrix_i(:,1) IFmatrix_i(:,2)./IFmatrix_i(:,3)]);
    logIF(i,:) = reshape(logIF_i(:,1:2)',1,[]);
    datin{i,1} = logIF(i,model.inputlocation{ijDataTest(i,1),ijDataTest(i,2)});
end
%% predict
preRGBlog = zeros(N,2);
for i=1:N
    preRGBlog(i,1) = evalfis(model.modelRlog{ijDataTest(i,1),ijDataTest(i,2)},datin{i});
    preRGBlog(i,2) = evalfis(model.modelGlog{ijDataTest(i,1),ijDataTest(i,2)},datin{i});
end
est_ill = logchrom2color(preRGBlog);

%%
% [minAngle, meanAngle, medianAngle, trimeanAngle, best25, worst25, average, maxAngle]= ...
%     calculateExtendedAngularStatistics(data_test.gtIllumTr(468:568,:), est_ill(468:568,:));
% displayCalculatedAngularErrorStatistics(minAngle, meanAngle,...
%     medianAngle, trimeanAngle, best25, worst25, average, maxAngle);

