function result = cluster2_anfis_cc(data,opt)

% *Output:
%   -est_ill: Nx3 corrected illuminant vectors
%   -Models: train models (model for each fold -- we use 3 fold validation)
%   -angular_error: Nx1 angular error between the corrected illuminant
%   vectors and ground truth vectors.
%   -repproduction_error: Nx1 reproduction error between the corrected
%   illuminant vectors and ground truth vectors.
%   -Mean_ae: mean angular error
%   -Median_ae: median angular error
%   -Best25_ae: best 25% angular error
%   -Worst25_ae: worst 25% angular error
%   -Mean_rpe: mean reproduction error
%   -Median_rpe: median reproduction error
%   -Best25_rpe: best 25% reproduction error
%   -Worst25_rpe: worst 25% reproduction error
%
%%
if nargin<2
    opt=genCNCOptions();
end
%%
try
    indices=load_folds(data.selecSet);
    N = max(unique(indices));
catch
    N = 3; % N=10; N=5;
    L = size(data.gtIllumTr,1); % L=568; L=1707; L=2275
    indices = crossvalind('Kfold', L, N); % save gehlershi_folds indices;
    % indices=[zeros(568,1);indices]; save cubep_folds indices;
    % save gehlershi_and_cubep_folds indices;
end
%%
tic
est_ill = []; ijDataTest = [];
gt_ill = [];
ind_sort=[];
for fold = 1 : N
    testing_inds = (indices == fold);
    training_inds = ~testing_inds;
    
    data_train.filesTr = data.filesTr(training_inds,:);
    data_train.cmTr = data.cmTr(training_inds,:);
    data_train.featureTr = data.featureTr(training_inds,:);
    data_train.feat4Cheng = data.feat4Cheng(training_inds,:);
    data_train.illSetTr = data.illSetTr(training_inds,:);
    data_train.illSet8Tr_nor = data.illSet8Tr_nor(training_inds,:);
    data_train.gtIllumTr = data.gtIllumTr(training_inds,:);
    data_train.idxNo = data.idxNo(training_inds,:);
    data_train.adjacentAngleError= data.adjacentAngleError(training_inds,:);
    data_train.colorangle = data.colorangle(training_inds,:);
    data_train.illSet8TrNor = data.illSet8TrNor(training_inds,:);
    data_train.fisFeatCDF = data.fisFeatCDF(training_inds,:);
    data_train.fisFeatIIF = data.fisFeatIIF(training_inds,:);
    data_train.meanUnitaryAlgo = data.meanUnitaryAlgo(training_inds,:);
    
    data_test.filesTr = data.filesTr(testing_inds,:);
    data_test.cmTr = data.cmTr(testing_inds,:);
    data_test.featureTr = data.featureTr(testing_inds,:);
    data_test.feat4Cheng = data.feat4Cheng(testing_inds,:);
    data_test.illSetTr = data.illSetTr(testing_inds,:);
    data_test.illSet8Tr_nor = data.illSet8Tr_nor(testing_inds,:);
    data_test.gtIllumTr = data.gtIllumTr(testing_inds,:);
    data_test.idxNo = data.idxNo(testing_inds,:);
    data_test.adjacentAngleError= data.adjacentAngleError(testing_inds,:);
    data_test.colorangle = data.colorangle(testing_inds,:);
    data_test.illSet8TrNor = data.illSet8TrNor(testing_inds,:);
    data_test.fisFeatCDF = data.fisFeatCDF(testing_inds,:);
    data_test.fisFeatIIF = data.fisFeatIIF(testing_inds,:);
    data_test.meanUnitaryAlgo = data.meanUnitaryAlgo(testing_inds,:);
    
    %training, testing
    if strcmpi(opt.method,'log')
        model = training_clu2anfis_log(data_train,opt);
        est_ill = [est_ill; testing_clu2anfis_log(data_test, model,opt)];
    elseif strcmpi(opt.method,'rgb')
        if opt.optimization
            model = training_clu2anfis_rgb_opt(data_train,opt);
        else
            model = training_clu2anfis_rgb(data_train,opt);
        end
        est_ill = [est_ill; testing_clu2anfis_rgb(data_test, model,opt)];
        ijDataTest = [ijDataTest;ijOfDataTest(data_test, model,opt)];
    end
    
    gt_ill = [gt_ill; data_test.gtIllumTr];
    Models(fold).model = model;
    Models(fold).data_test_fileno=find(indices == fold);
    ind_sort=[ind_sort;find(indices == fold)];
end

%%
[angular_error, repproduction_error] = evaluate (est_ill , gt_ill);
Min_ae=min(angular_error);
Mean_ae=mean(angular_error);
Median_ae=median(angular_error);
Trimean_ae=trimean(angular_error');
Best25_ae= mean(angular_error(angular_error<=quantile(angular_error,0.25)));
Worst25_ae= mean(angular_error(angular_error>=quantile(angular_error,0.75)));
Average_ae=geomean([Mean_ae, Median_ae, Trimean_ae, Best25_ae, Worst25_ae]);
Max_ae=max(angular_error);

Min_rpe=min(repproduction_error);
Mean_rpe=mean(repproduction_error);
Median_rpe=median(repproduction_error);
Trimean_rpe=trimean(repproduction_error');
Best25_rpe= mean(repproduction_error(repproduction_error<=quantile(repproduction_error,0.25)));
Worst25_rpe= mean(repproduction_error(repproduction_error>=quantile(repproduction_error,0.75)));
Average_rpe=geomean([Mean_rpe, Median_rpe, Trimean_rpe, Best25_rpe, Worst25_rpe]);
Max_rpe=max(repproduction_error);
toc
%% sort
est_ill_sort=zeros(size(est_ill));
ijDataTest_sort=zeros(size(ijDataTest));
gt_ill_sort=zeros(size(gt_ill));

est_ill_sort(ind_sort-min(ind_sort)+1,:)=est_ill;
ijDataTest_sort(ind_sort-min(ind_sort)+1,:)=ijDataTest;
gt_ill_sort(ind_sort-min(ind_sort)+1,:)=gt_ill;
[angular_error_sort, repproduction_error_sort] = evaluate (est_ill_sort , gt_ill_sort);
%% additional correction
% est_ill_sort
% meanUnitaryAlgo=data.meanUnitaryAlgo(find(indices~=0),:);
% ae_meanUnitaryAlgo_pre=zeros(size(est_ill_sort,1),1);
% [ae_meanUnitaryAlgo_pre, ~] = evaluate (meanUnitaryAlgo, est_ill_sort);
% % bb=find(ae_meanUnitaryAlgo_pre>30);
% % est_ill_sort(bb,:)=meanUnitaryAlgo(bb,:);
% cc=find(min(est_ill_sort,[],2)<0.001);
% est_ill_sort(cc,:)=data.lsr(cc,:);
% [angular_error_sort, repproduction_error_sort] = evaluate (est_ill_sort , gt_ill_sort);
% 
% [angular_error, repproduction_error] = evaluate (est_ill_sort , gt_ill_sort);
% Min_ae=min(angular_error);
% Mean_ae=mean(angular_error);
% Median_ae=median(angular_error);
% Trimean_ae=trimean(angular_error');
% Best25_ae= mean(angular_error(angular_error<=quantile(angular_error,0.25)));
% Worst25_ae= mean(angular_error(angular_error>=quantile(angular_error,0.75)));
% Average_ae=geomean([Mean_ae, Median_ae, Trimean_ae, Best25_ae, Worst25_ae]);
% Max_ae=max(angular_error);
%% output
result.est_ill = est_ill;
result.gt_ill = gt_ill;
result.Models = Models;
result.foldIndices = indices;

result.ind_sort = ind_sort;
result.est_ill_sort = est_ill_sort;
result.ijDataTest_sort = ijDataTest_sort;
result.gt_ill_sort = gt_ill_sort;

result.angular_error = angular_error;
result.angular_error_sort = angular_error_sort;
result.Min_ae = Min_ae;
result.Mean_ae = Mean_ae;
result.Median_ae = Median_ae;
result.Trimean_ae = Trimean_ae;
result.Best25_ae = Best25_ae;
result.Worst25_ae = Worst25_ae;
result.Average_ae = Average_ae;
result.Max_ae = Max_ae;

result.repproduction_error = repproduction_error;
result.repproduction_error_sort = repproduction_error_sort;
result.Min_rpe = Min_rpe;
result.Mean_rpe = Mean_rpe;
result.Median_rpe = Median_rpe;
result.Trimean_rpe = Trimean_rpe;
result.Best25_rpe = Best25_rpe;
result.Worst25_rpe = Worst25_rpe;
result.Average_rpe = Average_rpe;
result.Max_rpe = Max_rpe;

%%
[minAngle, meanAngle, medianAngle, trimeanAngle, best25, worst25, average, maxAngle]=...
    calculateExtendedAngularStatistics(est_ill, gt_ill);
displayCalculatedAngularErrorStatistics(minAngle, meanAngle,...
    medianAngle, trimeanAngle, best25, worst25, average, maxAngle);
result.aemetrics = [minAngle, meanAngle, medianAngle, trimeanAngle, best25, worst25, average, maxAngle];
%
[minAngle, meanAngle, medianAngle, trimeanAngle, best25, worst25, average, maxAngle]=...
    calculateReproductionAngularStatistics(est_ill, gt_ill);
% displayReproductionAngularErrorStatistics(minAngle, meanAngle,...
%     medianAngle, trimeanAngle, best25, worst25, average, maxAngle);
result.raemetrics = [minAngle, meanAngle, medianAngle, trimeanAngle, best25, worst25, average, maxAngle];

%%
result.opt = opt;
