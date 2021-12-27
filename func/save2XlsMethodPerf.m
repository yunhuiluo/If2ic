function save2XlsMethodPerf(result,filename)
%%
if nargin<2
    filename = 'tempMethodPerf.xlsx'; % Combined Train and Test
end
%%
clusterMethod=result.clusterMethod;
%featureMapping=result.featureMapping;

Mean_ae = result.Mean_ae;
Median_ae = result.Median_ae;
Trimean_ae = result.Trimean_ae;
Best25_ae = result.Best25_ae;
Worst25_ae = result.Worst25_ae;
Max_ae = result.Max_ae;

Mean_rpe = result.Mean_rpe;
Median_rpe = result.Median_rpe;
Trimean_rpe = result.Trimean_rpe;
Best25_rpe = result.Best25_rpe;
Worst25_rpe = result.Worst25_rpe;
Max_rpe = result.Max_rpe;

%% table6
title = {'clusterMethod','Mean','Median','Trimean','Best 25%','Worst 25%','Maxium',...
                  'Mean_rpe','Median_rpe','Trimean_rpe','Best25%_rpe','Worst25%_rpe','Maxium_rpe'};
data_cell = {clusterMethod, Mean_ae,Median_ae,Trimean_ae,Best25_ae,Worst25_ae,Max_ae,...
                           Mean_rpe,Median_rpe,Trimean_rpe,Best25_rpe,Worst25_rpe,Max_rpe};
C = [title; data_cell];
try
    Cr = readcell(filename,'Sheet','Sheet1');
    
    if size(C,1)>1
        C=[Cr(:,1:13);C(2:end,:)];
    end
catch
end
writecell(C,filename,'Sheet','Sheet1');
