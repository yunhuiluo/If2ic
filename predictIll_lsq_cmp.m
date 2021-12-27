function [gt_est_all,gt_all]=predictIll_lsq_cmp(if2icClu,featureSets,featSetName,featName,M,H,notWeight,iShow)
%%
if nargin<6
    notWeight=0;
    iShow=0;
elseif nargin<7
    iShow=0;
end
%%
if strncmpi(featSetName,'twoStepTrain',10)
    featSetName='twoStepTrainFeatSet';
    trainAndTestFeatSetName='twoStepTrainAndTestFeatSet';
    Mpos = 'twoStepMpos';
elseif strncmpi(featSetName,'twoStepKfcmTrain',10)
    featSetName='twoStepKfcmTrainFeatSet';
    trainAndTestFeatSetName='twoStepKfcmTrainAndTestFeatSet';
    Mpos = 'twoStepKfcmMpos';
elseif strncmpi(featSetName,'kmeans',6)
    featSetName='kmeansTrainFeatSet';
    trainAndTestFeatSetName='kmeansTrainAndTestFeatSet';
    Mpos = 'kmeansMpos';
elseif strncmpi(featSetName,'fcm',3)
    featSetName='fcmTrainFeatSet';
    trainAndTestFeatSetName='fcmTrainAndTestFeatSet';
    Mpos = 'fcmMpos';
else
    featSetName='kfcmTrainFeatSet';
    trainAndTestFeatSetName='kfcmTrainAndTestFeatSet';
    Mpos = 'kfcmMpos';
end
%%
num=size(featureSets.(trainAndTestFeatSetName).gt,1);
Nc=size(featureSets.(featSetName).gt,2);
gt_est_all=zeros(num,3);
for i=1:num
    mNo=if2icClu.(Mpos)(i,1);
    M_c=zeros(size(M{mNo,1}));
    H_c=zeros(3,3);
    if notWeight==0
        for k=1:Nc
            M_c=M_c+M{mNo,k}*if2icClu.(Mpos)(i,2+k);
            if ~isempty(H)
                H_c=H_c+H{mNo,k}*if2icClu.(Mpos)(i,2+k);
            end
        end
    else
        M_c=M{mNo,if2icClu.(Mpos)(i,2)};
        if ~isempty(H)
            H_c=H{mNo,if2icClu.(Mpos)(i,2)};
        end
    end
    gt_est_all(i,:)=featureSets.(trainAndTestFeatSetName).(featName)(i,:)*M_c;
    if ~isempty(H)
        gt_est_all(i,:)=(H_c*gt_est_all(i,:)')';
    end
end
gt_all=featureSets.(trainAndTestFeatSetName).gt;
%%
if iShow
    [minAngle, meanAngle, medianAngle, trimeanAngle, best25, worst25, average, maxAngle]=...
        calculateExtendedAngularStatistics(gt_est_all, gt_all);
    displayCalculatedAngularErrorStatistics(minAngle, meanAngle,...
        medianAngle, trimeanAngle, best25, worst25, average, maxAngle);
end