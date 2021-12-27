function [twoStepCluResults,twoStepMpos,twoStepTrainDataNo,twoStepTestDataNo]...
    =twoStepClustering(data,opt)
% adapted from Two-step Clustering; K1=1;K2=4
% data=load('dataTrain.mat');
% data=data.dataTrain;
% iDatSelected=[3]; %datasetSelected={'Cubep','GehlerShi','gehlershi_and_cubep'};
% K1=2; K2=2;
% if2icClu.twoStepCluResults=twoStepClustering(data,iDatSelected,K1,K2);
%%
iDatSelected=opt.iDatSelected;
K1=opt.K1;
K2=opt.K2;
try
    N=opt.N;
catch
    N=3;
end
disp('It will take 140 seconds.');
%%
datasetSelected={'Cubep','GehlerShi','gehlershi_and_cubep'};% datasetSelected{1,3}
indMethodSelect={0,1,[1 2],[1 2 3 4],[1 2 7 8],[2 3 6 7 8],[1 2 3 4 5 6 7 8],[3 4 5 6]};
for numRun=1:1
    for iDatSelected=iDatSelected:iDatSelected %3
        for iK1=K1:K1% 2
            for iK2=K2:K2 %4
                for jNumClu=4 %[2 4 6]
                    for kEpochNum=30 %[30 60 90]
                        for m_indMethod =5:5 %6
                            data.selecSet=datasetSelected{1,iDatSelected}; % GehlerShi,Cubep, GS+Cube
                            % cmTr, featureTr,feat4Cheng,adjacentAngleError,illSet8TrNor; % log,rgb; indMethod = [1 2 7 8]; % auto
                            opt = genCNCOptions('k1',iK1,'k2',iK2,'method','rgb',...
                                'optimization',false,'NumClusters',jNumClu,'EpochNumber',kEpochNum,'InitialStepSize',0.01,...
                                'indMethod',indMethodSelect{1,m_indMethod},'cluster1Feature','featureTr','cluster2Feature','adjacentAngleError');
                            %
                            result = cluster2_anfis_cc(data,opt);
                            %save(fullfile('results',[data.selecSet '.mat']),'result');
                            %genResultXls(result,fullfile('results',[data.selecSet '.xlsx']));
                            %genResultOnceClusTab(result,fullfile('results','OneStepClus.xlsx'));
                            %fprintf('\n current: iterationNum=%s;\n iDatSelected=%s,\n  iK1=%s,\n iK2=%s, \n jNumClu=%s,\n kEpochNum=%s,\n  m_indMethod=%s\n',...
                            %    num2str(iDatSelected*iK1*iK2*length(m_indMethod)*length(kEpochNum)*length(jNumClu)),...
                            %    num2str(iDatSelected),num2str(iK1),num2str(iK2),num2str(jNumClu),num2str(kEpochNum),num2str(m_indMethod));
                        end
                    end
                end
            end
        end
    end
end
% the above codes used 3-fold test experiments, so the results include 3
% times of clustering and results. The clustering divisions are as follows:
% result.Models(1).model.dataCluSquare.idxNo
% result.Models(2).model.dataCluSquare.idxNo
% result.Models(3).model.dataCluSquare.idxNo
%if2icResults.kmeansCluResults=result;
%%
Mpos=zeros(size(result.foldIndices,1),2);
Mpos(:,1)=result.foldIndices;
Mpos(:,2)=(result.ijDataTest_sort(:,1)-1)*K2+result.ijDataTest_sort(:,2);
%%
trainDataNo=cell(N,K1*K2);
testDataNo=cell(N,K1*K2);
SumMpos=Mpos(:,1)*1000+Mpos(:,2);
for fold = 1 : N
    for i=1:K1
        for j=1:K2
            trainDataNo{fold,(i-1)*K2+j}=result.Models(fold).model.dataCluSquare.idxNo{i,j};
            testDataNo{fold,(i-1)*K2+j}=find(SumMpos==(fold*1000+(i-1)*K2+j));
        end
    end
end
% a=[];b=[];
% for i=1:4
%     a=[a [trainDataNo{1, i}]'];
%     b=[b [testDataNo{1, i}]'];
% end
% ab=unique([a b]');
%%
twoStepCluResults=result;
twoStepCluResults.indexTrainAndTest=result.foldIndices;
if nargout==2
    twoStepMpos=Mpos;
end
if nargout==3
    twoStepMpos=Mpos;
    twoStepTrainDataNo=trainDataNo;
end
if nargout==4
    twoStepMpos=Mpos;
    twoStepTrainDataNo=trainDataNo;
    twoStepTestDataNo=testDataNo;
end