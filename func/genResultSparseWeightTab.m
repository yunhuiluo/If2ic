function genResultSparseWeightTab(ill,gt,weightThd,filename)
%%
if nargin<2
    filename = 'Table6.xlsx'; % SparseWeightTab
end
%%
[minAngle, Mean_ae, Median_ae, Trimean_ae, Best25_ae, Worst25_ae, average, maxAngle]= ...
    calculateExtendedAngularStatistics(gt, ill);

%% table7
title = {'weightThd', 'Mean','Median','Trimean','Best 25%','Worst 25%'};
data_cell = {weightThd, Mean_ae,Median_ae,Trimean_ae,Best25_ae,Worst25_ae};
C = [title; data_cell];
try
    Cr = readcell(filename,'Sheet','Sheet1');
    
    if size(C,1)>1
        C=[Cr(:,1:6);C(2:end,:)];
    end
catch
end
writecell(C,filename,'Sheet','Sheet1');
