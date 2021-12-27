function genResultXls(result,filename)
%%
if nargin<2
    filename = 'result.xlsx';
end
%%
k1=result.opt.k1;
k2=result.opt.k2;
cluster1Feature=result.opt.cluster1Feature;% cmTr, featureTr,feat4Cheng,adjacentAngleError,illSet8TrNor
cluster2Feature=result.opt.cluster2Feature;% cmTr, featureTr,feat4Cheng,adjacentAngleError,illSet8TrNor
method=result.opt.method; % log,rgb
optimization=result.opt.optimization;

indMethod=num2str(result.opt.indMethod);
chkCutPoint=result.opt.chkCutPoint;
NumClusters=result.opt.NumClusters;
EpochNumber=result.opt.EpochNumber;
InitialStepSize=result.opt.InitialStepSize;

Min_ae = result.Min_ae;
Mean_ae = result.Mean_ae;
Median_ae = result.Median_ae;
Trimean_ae = result.Trimean_ae;
Best25_ae = result.Best25_ae;
Worst25_ae = result.Worst25_ae;
Average_ae = result.Average_ae;
Max_ae = result.Max_ae;

Min_rpe = result.Min_rpe;
Mean_rpe = result.Mean_rpe;
Median_rpe = result.Median_rpe;
Trimean_rpe = result.Trimean_rpe;
Best25_rpe = result.Best25_rpe;
Worst25_rpe = result.Worst25_rpe;
Average_rpe = result.Average_rpe;
Max_rpe = result.Max_rpe;
%% table1
title = {'k1','k2','Cluster1Feature','Cluster2Feature', 'method','optimization',...
    'indMethod','chkCutPoint','NumClusters','EpochNumber','InitialStepSize', ...
    'Min','Mean','Median','Trimean','Best 25%','Worst 25%','Average','Maximum',...
    'RAE Min','RAE Mean','RAE Median','RAE Trimean','RAE Best 25%','RAE Worst 25%','RAE Average','RAE Maximum'};

data_cell = {k1,k2,cluster1Feature,cluster2Feature, method,optimization,...
    indMethod,chkCutPoint,NumClusters,EpochNumber,InitialStepSize, ...
Min_ae,Mean_ae,Median_ae,Trimean_ae,Best25_ae,Worst25_ae,Average_ae,Max_ae,...    
Min_rpe,Mean_rpe,Median_rpe,Trimean_rpe,Best25_rpe,Worst25_rpe,Average_rpe,Max_rpe};
C = [title; data_cell];

try
    Cr = readcell(filename,'Sheet','Sheet1');
    
    if size(C,1)>1
        C=[Cr(:,1:27);C(2:end,:)];
    end
catch
end

writecell(C,filename,'Sheet','Sheet1');
