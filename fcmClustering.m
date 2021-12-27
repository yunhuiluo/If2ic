function [fcmCluResults,fcmCluResultsMpos,fcmCluResultsTrainDataNo,fcmCluResultsTestDataNo]...
    =fcmClustering(data,opt)
%%
% data=load('dataTrain.mat');
% data=data.dataTrain;
% [if2icClu.fcmCluResults,if2icClu.fcmCluResultsMpos]=fcmClustering(data);
%%
if nargin<2
    %datasetSelected={'Cubep','GehlerShi','gehlershi_and_cubep'};
    iDatSelected=3;
    Nc=4;
    cluFeat='adjacentAngleError';
    options=[3 1000 1e-5 1];
    preClu=0;
else
    datasetSelected=opt.datasetSelected;
    iDatSelected=opt.iDatSelected;
    Nc=opt.Nc;
    cluFeat=opt.cluFeat;
    options=opt.options;
    preClu=opt.preClu;
end
%%
datasetFoldName=datasetSelected{iDatSelected};
[indices,N,L]=foldIndices(datasetFoldName); % N: fold number
ruleout_inds = (indices == 0);       % size(find(ruleout_inds==1))
%%
trainDataNo=cell(N,Nc);
testDataNo=cell(N,Nc);
for fold = 1 : N
    testing_inds = (indices == fold);
    training_inds = ~(testing_inds | ruleout_inds);  % size(find(training_inds==1))
    [data_train,data_test]=trainAndTestFeatures(data,training_inds,testing_inds);
    
    %training, testing
    if preClu==0
        fcmdata=data.(cluFeat)(training_inds,:);
    else
        fcmdata=data.(cluFeat);
    end
    [centers,U,obj_fcn] = fcm(fcmdata,Nc,options); %showCluFig(fcmdata,U,centers);
    U_all=zeros(Nc,L);
    for i=1:L
        newRecord=data.(cluFeat)(i,:);
        d=pdist2(newRecord,fcmdata);
        d_sort=sort(d);
        d3=d_sort(1);
        pos=find(d<=d3);
        weight=exp(-d(pos));
        weight=weight./sum(weight);
        tmp=U(:,pos)*weight';
        U_all(:,i)=tmp;
    end 
    U=U_all;
    
    % train Data No and test Data No in dataset
    maxU = max(U);
    indexAll=zeros(size(U,2),1);
    for i=1:size(U,2)
        indexAll(i,1)=find(U(:,i) == maxU(i));
    end
    data_train_fileno=find(training_inds==1);
    data_test_fileno=find(testing_inds==1);
    for i = 1: Nc
        aaa=indexAll;
        aaa(data_test_fileno)=0;
        trainDataNo{fold,i}=find((aaa.*~ruleout_inds)==i);
        bbb=indexAll;
        bbb(data_train_fileno)=0;
        testDataNo{fold,i}=find((bbb.*~ruleout_inds)==i);
    end
  
    % fcmResults
    fcmResults.fcmdata=fcmdata;
    fcmResults.Nc=Nc;
    fcmResults.options=options;
    fcmResults.centers=centers;
    fcmResults.globalU=U_all;
    fcmResults.U_test=U_all(:,testing_inds);
    fcmResults.U_train=U_all(:,training_inds);
    fcmResults.obj_fcn=obj_fcn;
    fcmResults.indexAll=indexAll;
    
    fcmClu(fold).fcmResults=fcmResults;    
    fcmClu(fold).training_inds = training_inds;
    fcmClu(fold).gt_ill_train=data_train.gtIllumTr;
    fcmClu(fold).data_train_fileno=data_train_fileno;
    fcmClu(fold).data_train=data_train;
    fcmClu(fold).data_train_U=U_all(:,training_inds);
    
    fcmClu(fold).testing_inds = testing_inds;
    fcmClu(fold).gt_ill_test=data_test.gtIllumTr;
    fcmClu(fold).data_test_fileno=data_test_fileno;
    fcmClu(fold).data_test=data_test;    
    fcmClu(fold).data_test_U=U_all(:,testing_inds);
    
    fcmClu(fold).indexTrainAndTest=find(indices~=0);
end
%%
Mpos=zeros(size(indices,1),2+Nc);
foldNum=size(testDataNo,1);
Nc=size(testDataNo,2);
for num=1:size(indices,1)
    for i=1:foldNum
        for j=1:Nc
            if find(testDataNo{i,j}==num)>0
                Mpos(num,1)=i;
                Mpos(num,2)=j;
                Mpos(num,3:2+Nc)=[fcmClu(i).fcmResults.globalU(:,num)]';
            end
        end
    end
end
Mpos=Mpos(~ruleout_inds,:);
%%
fcmCluResults=fcmClu;
fcmCluResultsMpos=Mpos;
if nargout==3
    fcmCluResultsTrainDataNo=trainDataNo;
end
if nargout==4
    fcmCluResultsTestDataNo=testDataNo;
    fcmCluResultsTrainDataNo=trainDataNo;
end