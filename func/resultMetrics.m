function result=resultMetrics(est_ill,gt_ill)
[angular_error, repproduction_error] = evaluate (est_ill , gt_ill);
result.Min_ae=min(angular_error);
result.Mean_ae=mean(angular_error);
result.Median_ae=median(angular_error);
result.Trimean_ae=trimean(angular_error');
result.Best25_ae= mean(angular_error(angular_error<=quantile(angular_error,0.25)));
result.Worst25_ae= mean(angular_error(angular_error>=quantile(angular_error,0.75)));
result.Average_ae=geomean([result.Mean_ae, result.Median_ae, result.Trimean_ae, result.Best25_ae, result.Worst25_ae]);
result.Max_ae=max(angular_error);

result.Min_rpe=min(repproduction_error);
result.Mean_rpe=mean(repproduction_error);
result.Median_rpe=median(repproduction_error);
result.Trimean_rpe=trimean(repproduction_error');
result.Best25_rpe= mean(repproduction_error(repproduction_error<=quantile(repproduction_error,0.25)));
result.Worst25_rpe= mean(repproduction_error(repproduction_error>=quantile(repproduction_error,0.75)));
result.Average_rpe=geomean([result.Mean_rpe, result.Median_rpe, result.Trimean_rpe, result.Best25_rpe, result.Worst25_rpe]);
result.Max_rpe=max(repproduction_error);