function [kfcmCluResults,kfcmCluMpos,kfcmTrainDataNo,kfcmTestDataNo]=kfcmClustering(data,opt)
%%
if nargin<2
    iDatSelected=3;
    Nc=4;
    cluFeat='adjacentAngleError';
    kernel_b= 144;
    options=[3 1000 1e-5 1];
    preClu=0;
else
    iDatSelected=opt.iDatSelected;
    Nc=opt.Nc;
    cluFeat=opt.cluFeat;
    kernel_b= opt.kernel_b;
    options=opt.options;
    preClu=opt.preClu;
end
%%
%datasetSelected={'Cubep','GehlerShi','gehlershi_and_cubep'};% datasetSelected{1,3}
datasetSelected=opt.datasetSelected;
data.selecSet=datasetSelected{1,iDatSelected};
try
    indices=load_folds(data.selecSet);
    N = max(unique(indices));
catch
    N = 3; % N=10; N=5;
    L = size(data.gtIllumTr,1); % L=568; L=1707; L=2275
    indices = crossvalind('Kfold', L, N); % save gehlershi_folds indices;
    % indices=[zeros(568,1);indices]; save cubep_folds indices;
    % save gehlershi_and_cubep_folds indices;
end
%%
trainDataNo=cell(N,Nc);
testDataNo=cell(N,Nc);
for fold = 1 : N
    testing_inds = (indices == fold); % size(find(testing_inds==1))
    ruleout_inds = (indices == 0);       % size(find(ruleout_inds==1))
    training_inds = ~(testing_inds | ruleout_inds);  % size(find(training_inds==1))
    [data_train,data_test]=trainAndTestFeatures(data,training_inds,testing_inds);
    
    % clustering
    if preClu==0
        fcmdata=data.(cluFeat)(training_inds,:);
    else
        fcmdata=data.(cluFeat);
    end
    [centers, U, obj_fcn] = KFCMClust(fcmdata, Nc, kernel_b,options);
    % showCluFig(fcmdata,U,centers);
    L=size(indices,1);
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
    
    kfcmClu(fold).fcmResults=fcmResults;
    kfcmClu(fold).training_inds = training_inds;
    kfcmClu(fold).gt_ill_train=data_train.gtIllumTr;
    kfcmClu(fold).data_train_fileno=data_train_fileno;
    kfcmClu(fold).data_train=data_train;
    kfcmClu(fold).data_train_U=U_all(:,training_inds);
    
    kfcmClu(fold).testing_inds = testing_inds;
    kfcmClu(fold).gt_ill_test=data_test.gtIllumTr;
    kfcmClu(fold).data_test_fileno=data_test_fileno;
    kfcmClu(fold).data_test=data_test;
    kfcmClu(fold).data_test_U=U_all(:,testing_inds);
    
    kfcmClu(fold).indexTrainAndTest=find(indices~=0);
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
                Mpos(num,3:2+Nc)=[kfcmClu(i).fcmResults.globalU(:,num)]';
            end
        end
    end
end
Mpos=Mpos(~ruleout_inds,:);
%%
kfcmCluResults=kfcmClu;
kfcmCluMpos=Mpos;
if nargout==3
    kfcmTrainDataNo=trainDataNo;
end
if nargout==4
    kfcmTestDataNo=testDataNo;
    kfcmTrainDataNo=trainDataNo;
end