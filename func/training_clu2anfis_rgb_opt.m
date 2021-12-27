function model = training_clu2anfis_rgb_opt(data_train,opt)
%%
% data_train.filesTr = dataTrain.filesTr(1:568,:);
% data_train.cmTr = dataTrain.cmTr(1:568,:);
% data_train.featureTr = dataTrain.featureTr(1:568,:);
% data_train.illSetTr = dataTrain.illSetTr(1:568,:);
% data_train.illSet8Tr_nor = dataTrain.illSet8Tr_nor(1:568,:);
% data_train.gtIllumTr = dataTrain.gtIllumTr(1:568,:);
% data_train.idxNo = dataTrain.idxNo(1:568,:);
% data_train.adjacentAngleError= dataTrain.adjacentAngleError(1:568,:);
% data_train.colorangle = dataTrain.colorangle(1:568,:);
% model = training_clu2anfiscc_opt(data_train,2,3);
%%
if nargin<2
    opt=genCNCOptions();
end
k1=opt.k1;
k2=opt.k2;
try
    thdMean = opt.thdMean;
    thdWorst = opt.thdWorst;
catch
    thdMean = 2.14;
    thdWorst = 5.18;
end
%%
modelTmp.ChkMetrics = 10*ones(1,8);
tic
for iter=1:100
    model = training_clu2anfis_rgb(data_train,opt);
    if (model.ChkMetrics(2)<modelTmp.ChkMetrics(2) && model.ChkMetrics(6)<modelTmp.ChkMetrics(6))
        modelTmp = model;
    end
    if (model.ChkMetrics(2)<thdMean && model.ChkMetrics(6)<thdWorst)
        bSmall = true;
        for i=1:k1
            for j=1:k2
                bSmall = model.statisticMetrics{i,j}(2)< thdMean && model.statisticMetrics{i,j}(6)<thdWorst && bSmall;
            end
        end
        if bSmall
            break;
        end
    end
end
toc
