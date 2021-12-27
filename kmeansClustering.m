function [kmeansCluResults,kmeansMpos,kmeansTrainDataNo,kmeansTestDataNo]...
    =kmeansClustering(data,opt)
%%
% data=load('dataTrain.mat');
% data=data.dataTrain;
% if2icClu.kmeansCluResults=kmeansClustering(data,opt)
%%
if nargin<2
    datasetSelected={'Cubep','GehlerShi','gehlershi_and_cubep'};
    iDatSelected=3;
    Nc=4;
    cluFeat='adjacentAngleError';
    preClu=0;
else
    datasetSelected=opt.datasetSelected;
    iDatSelected=opt.iDatSelected;
    Nc=opt.Nc;
    cluFeat=opt.cluFeat;
    preClu=opt.preClu;
end
%%
datasetFoldName=datasetSelected{iDatSelected};
[indices,N,L]=foldIndices(datasetFoldName); % N: fold number
%%
trainDataNo=cell(N,Nc);
testDataNo=cell(N,Nc);
for fold = 1 : N
    testing_inds = (indices == fold);
    ruleout_inds = (indices == 0);
    training_inds = ~(testing_inds | ruleout_inds);
    [data_train,data_test]=trainAndTestFeatures(data,training_inds,testing_inds);
    
    %training, testing
    if preClu==0
        kmeansdata=data.(cluFeat)(training_inds,:);
    else
        kmeansdata=data.(cluFeat);
    end
    [idx,C,sumd,D] = kmeans(kmeansdata,Nc); %showCluFig(kmeansdata,U,centers);  
    
    U_all=zeros(Nc,L);
    for i=1:L
        newRecord=data.(cluFeat)(i,:);
        d=pdist2(newRecord,C);
        d_sort=sort(d);
        d3=d_sort(Nc); % 1~3
        pos=find(d<=d3);
        weight=exp(-d(pos));
        weight=weight./sum(weight);
        U_all(:,i)=weight';
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
    
%     aa=zeros(size(training_inds));
%     b=0;
%     for kk=1:size(training_inds,1)
%         if training_inds(kk)==1
%             b=b+1;
%             aa(kk)=b;
%         end
%     end
%     for i = 1: Nc
%         TrainInd=zeros(size(training_inds));
%         pos=find(idx==i);
%         for mm=1:size(pos,1)
%             TrainInd(aa==pos(mm))=1;
%         end
%         trainDataNo{fold,i}=find(TrainInd==1);
%     end
    
    % which cluster a new record belongs to
%     data_test_fileno=find(indices == fold);
%     N_test=size(data_test_fileno,1);
%     CN_test=zeros(N_test,2);
%     for i=1:N_test
%         newRecord=data.(cluFeat)(data_test_fileno(i),:);
%         d=pdist2(newRecord,kmeansdata);
%         d_sort=sort(d);
%         d3=d_sort(1);
%         pos=d<=d3;
%         CN_test(i,:)=[data_test_fileno(i) idx(pos)];
%     end
    
%     % which records a cluster contains
%     indexAll=zeros(size(indices,1),1);
%     data_train_fileno=find(indices ~= fold);
%     indexAll_2=[data_train_fileno idx;CN_test];
%     indexAll_2_asc=sortrows(indexAll_2);
%     indexAll=indexAll_2_asc(:,2);
%     index=cell(Nc,1);
%     for i = 1: Nc
%         index{i,1}=find(indexAll==i);
%     end
    
    %
    kmeansResults.kmeansdata=kmeansdata;
    kmeansResults.Nc=Nc;
    kmeansResults.centers=C;
    kmeansResults.idx=idx;
    kmeansResults.sumd=sumd;
    kmeansResults.D=D;
    kmeansResults.indexAll=indexAll;
    kmeansResults.globalU=U_all;
    kmeansResults.U_test=U_all(:,testing_inds);
    kmeansResults.U_train=U_all(:,training_inds);
    %
    kmeansClu(fold).kmeansResults=kmeansResults;
    kmeansClu(fold).training_inds = training_inds;
    kmeansClu(fold).gt_ill_train=data_train.gtIllumTr;
    kmeansClu(fold).data_train_fileno=data_train_fileno;
    kmeansClu(fold).data_train=data_train;
    kmeansClu(fold).data_train_U=U_all(:,training_inds);
    
    kmeansClu(fold).testing_inds = testing_inds;
    kmeansClu(fold).gt_ill_test=data_test.gtIllumTr;
    kmeansClu(fold).data_test_fileno=data_test_fileno;
    kmeansClu(fold).data_test=data_test;
    kmeansClu(fold).data_test_U=U_all(:,testing_inds);
    
    kmeansClu(fold).indexTrainAndTest=find(indices~=0);
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
                Mpos(num,3:2+Nc)=kmeansClu(i).kmeansResults.globalU(:,num)';
            end
        end
    end
end
Mpos=Mpos(~ruleout_inds,:);
%%
kmeansCluResults=kmeansClu;
kmeansMpos=Mpos;
if nargout==3
    kmeansTrainDataNo=trainDataNo;
end
if nargout==4
    kmeansTrainDataNo=trainDataNo;
    kmeansTestDataNo=testDataNo;
end
