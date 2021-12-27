function [M,H,feat,gt_gt,gt_est]=feat2Ill_lsq_cmp(featureSets,featSetName,featName,bShowMsg,method)
%% regression modeling using lsqnonneg or lsqminnorm
% featSetName={'kmeansTrainFeatSet','fcmTrainFeatSet','kfcmTrainFeatSet'};
% [M,feat,gt_gt,gt_est]=feat2Ill_lsq_cmp(featureSets,'kmeansTrainFeatSet','f1_cm',1);
% M=feat2Ill_lsq_cmp(featureSets,'kmeansTrainFeatSet','f1_cm',1);
%%
if nargin<4
    bShowMsg=0;
    method='lsqnonneg';
elseif nargin<5
     method='lsqnonneg';
end
%%
[m,n]=size(featureSets.(featSetName).gt);
M = cell(m,n);
H = cell(m,n);
feat = cell(m,n);
gt_gt = cell(m,n);
gt_est = cell(m,n);
for i=1:m
    for j=1:n
        A=featureSets.(featSetName).(featName){i,j};
        B=featureSets.(featSetName).gt{i,j};
        if strcmpi(method,'lsqnonneg')
            M{i,j}=[lsqnonneg(A,B(:,1)) lsqnonneg(A,B(:,2)) lsqnonneg(A,B(:,3))];
        elseif strcmpi(method,'lsqminnorm')
            M{i,j}=lsqminnorm(A,B);
        elseif strcmpi(method,'pinv')
            M{i,j}=pinv(A)*B;
        else
            M{i,j}=(A'*A)\(A'*B);
        end
        % estimate
        feat{i,j}=A;
        gt_gt{i,j}=B;
        gt_est{i,j}=A*M{i,j};
        %
        ge=gt_est{i,j};
        gt=gt_gt{i,j};
        [H{i,j},~] = als_apap(ge,gt);
        
        try
            if bShowMsg
                [minAngle, meanAngle, medianAngle, trimeanAngle, best25, worst25, average, maxAngle]=...
                    calculateExtendedAngularStatistics(gt_est{i,j}, gt_gt{i,j});
                displayCalculatedAngularErrorStatistics(minAngle, meanAngle,...
                    medianAngle, trimeanAngle, best25, worst25, average, maxAngle);
                disp([featSetName,', ',featName,', OK: fold: ' num2str(i) ';  cluster: '  num2str(j)])
            end
        catch
            disp([featSetName,', ',featName,', Something is wrong: fold: ' num2str(i) ';  cluster: '  num2str(j)])
        end
        
    end
end
