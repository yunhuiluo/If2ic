function [minAngle, meanAngle, medianAngle, trimeanAngle, best25, worst25, average, maxAngle]=...
    calculateReproductionAngularStatistics(in_ill, gt_ill)
%%reproduction error
div_ill = (gt_ill ./ in_ill);
div_ill_norm = sqrt(sum(div_ill.^2,2));
angles = (dot(div_ill , (repmat([1 1 1],size(in_ill,1),1)),2))./ (div_ill_norm .* sqrt(3));
rpe=acosd(angles);
rpe(isnan(rpe))=0;
%%
angles = rpe;
minAngle=min(angles);
meanAngle=mean(angles);
trimeanAngle=trimean(angles');
medianAngle=median(angles);
maxAngle=max(angles);

sa=sort(angles);
n=numel(angles);

nn=round(n/4);
best25=mean(sa(1:nn));
worst25=mean(sa((n-nn+1):n));

average=geomean([meanAngle, medianAngle, trimeanAngle, best25, worst25]);

