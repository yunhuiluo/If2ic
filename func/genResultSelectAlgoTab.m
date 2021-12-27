function genResultSelectAlgoTab(result,filename)
%%
if nargin<2
    filename = 'Table7.xlsx';   %SelectAlgoTab
end
%%
indMethod=num2str(result.opt.indMethod);
Mean_ae = result.Mean_ae;
Median_ae = result.Median_ae;
Trimean_ae = result.Trimean_ae;
Best25_ae = result.Best25_ae;
Worst25_ae = result.Worst25_ae;
%% table7
title = {'indMethod', 'Mean','Median','Trimean','Best 25%','Worst 25%'};
data_cell = {indMethod, Mean_ae,Median_ae,Trimean_ae,Best25_ae,Worst25_ae};
C = [title; data_cell];
try
    Cr = readcell(filename,'Sheet','Sheet1');
    
    if size(C,1)>1
        C=[Cr(:,1:6);C(2:end,:)];
    end
catch
end
writecell(C,filename,'Sheet','Sheet1');
