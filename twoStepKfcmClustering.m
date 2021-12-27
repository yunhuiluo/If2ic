function [twoStepKfcmCluResults,twoStepKfcmCluMpos,twoStepKfcmTrainDataNo,twoStepKfcmTestDataNo]...
    =twoStepKfcmClustering(data,opt)
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
    K1=opt.K1;
    K2=opt.K2;
end
%%
% datasetSelected={'Cubep','GehlerShi','gehlershi_and_cubep'};% datasetSelected{1,3}
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
ijDataTest = [];
% Mpos=zeros(size(indices,1),2);
Mpos=[];
for fold = 1 : N
    testing_inds = (indices == fold);
    training_inds = ~testing_inds;
    [data_train,data_test]=trainAndTestFeatures(data,training_inds,testing_inds);
    
    % clustering
        if preClu==0
            dataCluSquare = twostepkfcmcluster(data_train,opt);
        else
            dataCluSquare = twostepkfcmcluster(data,opt);
        end
    %[centers, U, obj_fcn] = twoStepKfcmClust(fcmdata, Nc, kernel_b,options);
    %dataCluSquare = twostepkfcmcluster(data_train,opt);
    %
    model.dataCluSquare=dataCluSquare;
    ijDataTest = ijOfDataTest(data_test, model,opt);
    testModelNo=(ijDataTest(:,1)-1)*K2+ijDataTest(:,2);
    testNo=find(testing_inds==1);
    foldNo=ones(length(testNo),1)*fold;
    Mpos=[Mpos;testNo foldNo testModelNo];
    %
    for i=1:K1
        for j=1:K2
            trainDataNo{fold,(i-1)*K2+j}=dataCluSquare.idxNo{i,j};
            %testDataNo{fold,(i-1)*K2+j}=find(SumMpos==(fold*1000+(i-1)*K2+j));
        end
    end
    
    % fcmResults
    fcmResults.fcmdata=dataCluSquare;
    
    twoStepKfcmClu(fold).fcmResults=fcmResults;
    twoStepKfcmClu(fold).training_inds = training_inds;
    twoStepKfcmClu(fold).gt_ill_train=data_train.gtIllumTr;
    twoStepKfcmClu(fold).data_train_fileno=find(indices ~= fold);
    twoStepKfcmClu(fold).data_train=data_train;
    
    twoStepKfcmClu(fold).testing_inds = testing_inds;
    twoStepKfcmClu(fold).gt_ill_test=data_test.gtIllumTr;
    twoStepKfcmClu(fold).data_test_fileno=find(indices == fold);
    twoStepKfcmClu(fold).data_test=data_test;
    
    twoStepKfcmClu(fold).indexTrainAndTest=find(indices~=0);
end
%%
MMpos=sortrows(Mpos);
Mpos=MMpos(:,2:3);
SumMpos=Mpos(:,1)*1000+Mpos(:,2);
for fold = 1 : N
    for i=1:K1
        for j=1:K2
            testDataNo{fold,(i-1)*K2+j}=find(SumMpos==(fold*1000+(i-1)*K2+j));
        end
    end
end
%%
twoStepKfcmCluResults=twoStepKfcmClu;
twoStepKfcmCluMpos=Mpos;
if nargout==3
    twoStepKfcmTrainDataNo=trainDataNo;
end
if nargout==4
    twoStepKfcmTestDataNo=testDataNo;
    twoStepKfcmTrainDataNo=trainDataNo;
end