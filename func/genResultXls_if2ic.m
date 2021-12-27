function genResultXls_if2ic(result,filename)
%%
if nargin<2
    filename = 'result_if2ic.xlsx';
end
%%
try
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
catch
    k1=0; %result.opt.k1;
    k2=0; %result.opt.k2;
    cluster1Feature=0; %result.opt.cluster1Feature;% cmTr, featureTr,feat4Cheng,adjacentAngleError,illSet8TrNor
    cluster2Feature=0; %result.opt.cluster2Feature;% cmTr, featureTr,feat4Cheng,adjacentAngleError,illSet8TrNor
    method=0; %result.opt.method; % log,rgb
    optimization=0; %result.opt.optimization;
    
    indMethod='0'; %num2str(result.opt.indMethod);
    chkCutPoint=0; %=result.opt.chkCutPoint;
    NumClusters=0; %result.opt.NumClusters;
    EpochNumber=0; %result.opt.EpochNumber;
    InitialStepSize=0; %result.opt.InitialStepSize;
end
try
    clusterMethod =result.clusterMethod;
    featureMapping=result.featureMapping;
    NumClusters=result.NumClusters;
    cluster1Feature=result.clusterFeature;
    InitialStepSize=result.kernel_b;
catch
    clusterMethod='';
    featureMapping='';
    NumClusters=0;
    cluster1Feature=0;
    InitialStepSize=0;
end

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
    'indMethod','chkCutPoint','NumClusters','EpochNumber','InitialStepSize','clusterMethod', 'featureMapping', ...
    'Min','Mean','Median','Trimean','Best 25%','Worst 25%','Average','Maximum',...
    'RAE Min','RAE Mean','RAE Median','RAE Trimean','RAE Best 25%','RAE Worst 25%','RAE Average','RAE Maximum','Time'};

data_cell = {k1,k2,cluster1Feature,cluster2Feature, method,optimization,...
    indMethod,chkCutPoint,NumClusters,EpochNumber,InitialStepSize, clusterMethod, featureMapping,...
    Min_ae,Mean_ae,Median_ae,Trimean_ae,Best25_ae,Worst25_ae,Average_ae,Max_ae,...
    Min_rpe,Mean_rpe,Median_rpe,Trimean_rpe,Best25_rpe,Worst25_rpe,Average_rpe,Max_rpe,datestr(now)};
C = [title; data_cell];

try
    Cr = readcell(filename,'Sheet','Sheet1');
    
    if size(C,1)>1
        C=[Cr(:,1:30);C(2:end,:)];
    end
catch
end

writecell(C,filename,'Sheet','Sheet1');
