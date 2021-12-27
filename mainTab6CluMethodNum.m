%% init
% clear; clc;
% addpath('.\utility');
% addpath('.\func');
% data=load('dataTrain.mat').dataTrain;
% disp('Load data from dataTrain.mat');
%% options
opt.Nc=6;
opt.datasetSelected={'Cubep','GehlerShi','gehlershi_and_cubep','canon5D_gehlershi'};
opt.iDatSelected=3;
opt.cluFeat='adjacentAngleError'; % featureTr, adjacentAngleError, illSet8TrNor, feat4Cheng
opt.kernel_b= 143.15;
opt.kernel_b1=144;
opt.kernel_b2=200;
opt.options=[4 3000 1e-7 0];
opt.K1=2;
opt.K2=3;
opt.L=2275;
opt.preClu=0;
%% clustering
% minLimit=10;
%while minLimit>1.95
% two Step Clustering + kmeans
 [if2icClu.twoStepCluResults,if2icClu.twoStepMpos,if2icClu.twoStepTrainDataNo]...
     =twoStepClustering(data,opt);

% two Step Clustering + kfcm
[if2icClu.twoStepKfcmCluResults,if2icClu.twoStepKfcmMpos,...
    if2icClu.twoStepKfcmTrainDataNo,if2icClu.twoStepKfcmTestDataNo]...
    =twoStepKfcmClustering(data,opt);
%
% % Kmeans Clustering
[if2icClu.kmeansCluResults,if2icClu.kmeansMpos,...
    if2icClu.kmeansTrainDataNo,if2icClu.kmeansTestDataNo]=...
    kmeansClustering(data,opt);
% % FCM Clustering
[if2icClu.fcmCluResults,if2icClu.fcmMpos,...
    if2icClu.fcmTrainDataNo,if2icClu.fcmTestDataNo]=...
    fcmClustering(data,opt);
% KFCM Clustering
[if2icClu.kfcmCluResults,if2icClu.kfcmMpos,...
    if2icClu.kfcmTrainDataNo,if2icClu.kfcmTestDataNo]...
    =kfcmClustering(data,opt);
%
% method={'gw','wp','sog','ge1','ge2','pca','ggw','lsr'};
% ind=if2icClu.kfcmCluResults(1).indexTrainAndTest;
% for i=1:8
%     resultUnitary=resultMetrics(data.(method{i})(ind,:),data.gtIllumTr(ind,:));
%     resultUnitary.clusterMethod=upper(method{i});
%     save2XlsMethodPerf(resultUnitary,fullfile('results','tab7CluMethodNum.xlsx'));
% end
%% extract features
featureSets=extractFeatureSets(data,if2icClu);
%% lsq based estimation
% load('dataGSCubep_CluFeat.mat');
FeatSetNames = {'twoStepTrainFeatSet','twoStepKfcmTrainFeatSet',...
    'kmeansTrainFeatSet','fcmTrainFeatSet','kfcmTrainFeatSet'};
% featNames = {'f1_cm','f2_corrm','f2_corrm_root','f3_cdf','f4_iif','f4_iif_s4',...
%     'f5_RGBuv','f6_feat4Cheng','f7_comp2','f7_comp3','f7_comp4'};
% FeatSetNames = {'kfcmTrainFeatSet'};
% FeatSetNames = {'kmeansTrainFeatSet','fcmTrainFeatSet','kfcmTrainFeatSet'};
% featNames = {'f5_RGBuv','f7_comp2', 'f7_comp3'};
% FeatSetNames = {'twoStepKfcmTrainFeatSet','kmeansTrainFeatSet','fcmTrainFeatSet','kfcmTrainFeatSet'};
featNames = {'f7_comp3'};
resultLsq=cell(size(FeatSetNames,2),size(featNames,2));
for i=1:size(FeatSetNames,2)
    for j=1:size(featNames,2)
        try
            featSetName=FeatSetNames{i};
            featName=featNames{j};
            disp(['Method: ', featSetName,', Features: ',featName]);
            [M,H,feat,gt_gt,gt_est]=feat2Ill_lsq_cmp(featureSets,featSetName,featName,0,'lsqnonneg');
            [gt_est_all,gt_all]=predictIll_lsq_cmp(if2icClu,featureSets,featSetName,featName,M,H,1,1);
            resultLsq{i,j}=resultMetrics(gt_est_all,gt_all);
            resultLsq{i,j}.M=M;
            resultLsq{i,j}.H=H;
            resultLsq{i,j}.model.feat=feat;
            resultLsq{i,j}.model.gt_gt=gt_gt;
            resultLsq{i,j}.model.gt_est=gt_est;
            %resultLsq{i,j}.model.metrics=resultMetrics(gt_gt{1,2},gt_est{1,2});
            resultLsq{i,j}.gt_all=gt_all;
            resultLsq{i,j}.gt_est_all=gt_est_all;
            resultLsq{i,j}.clusterMethod=[featSetName, '_CluNum',num2str(opt.Nc),featName];
            resultLsq{i,j}.featureMapping=featName;
            resultLsq{i,j}.NumClusters=opt.Nc;
            resultLsq{i,j}.clusterFeature=opt.cluFeat;
            resultLsq{i,j}.kernel_b=opt.kernel_b;
            if ~strcmpi(featSetName,'kfcmTrainFeatSet')
                resultLsq{i,j}.kernel_b=0;
            end
            %minLimit=resultLsq{1, 1}.Mean_ae;
            genResultXls_if2ic(resultLsq{i,j},...
                fullfile('results',[opt.datasetSelected{opt.iDatSelected} '_if2ic_cmp.xlsx']));
            save2XlsMethodPerf(resultLsq{i,j},fullfile('results','tab7CluMethodNum.xlsx'));
        catch
        end
    end
end
%
%end
%clear i j M featSetName featName gt_all gt_est_all


