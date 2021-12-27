function model = training_clu2anfis_rgb(data_train,opt)
%%
% data_train.filesTr = dataTrain.filesTr(1:568,:);
% data_train.cmTr = dataTrain.cmTr(1:568,:);
% data_train.featureTr = dataTrain.featureTr(1:568,:);
% data_train.illSetTr = dataTrain.illSetTr(1:568,:);
% data_train.illSet8Tr_nor = dataTrain.illSet8Tr_nor(1:568,:);
% data_train.gtIllumTr = dataTrain.gtIllumTr(1:568,:);
% data_train.idxNo = dataTrain.idxNo(1:568,:);
% data_train.adjacentAngleError= dataTrain.adjacentAngleError(1:568,:);
% data_train.colorangle = dataTrain.colorangle(1:568,:);
% model = training_clu2anfiscc(data_train,2,3);
%%
if nargin<2
    opt=genCNCOptions();
end
k1=opt.k1;
k2=opt.k2;
%% cluster the data_train into k1*k2 regions
dataCluSquare = twostepcluster(data_train,opt);
model.modelNumberK1=k1;
model.modelNumberK2=k2;
model.dataCluSquare=dataCluSquare;

%% trainning anfis model
%%
warning off;
tic;
for iRegion=1:k1
    for iCluster=1:k2
        %% input Location
        if opt.indMethod==0
            region1AE=dataCluSquare.colorangle{iRegion, iCluster};
            aemax=max(region1AE,[],2);%size(aemax);
            norRegion1AE=region1AE./aemax;
            sumNAE=sum(norRegion1AE); % size(sumNAE);
            indMethod=find(sumNAE<=min(sumNAE(sumNAE>median(sumNAE))));
            %norRegion1AE_sel=norRegion1AE(:,indMethod);
        else
            indMethod=opt.indMethod;
        end
        inputLocation=sort([indMethod*2-1 indMethod*2]);
        
        nImgInSubsub=size(dataCluSquare.illSet8Tr_nor{iRegion, iCluster},1);
        IF=zeros(nImgInSubsub,16);
        for i=1:nImgInSubsub
            IFmatrix_i=dataCluSquare.illSet8Tr_nor{iRegion, iCluster}{i, 1};
            IF(i,:)=reshape(IFmatrix_i(:,1:2)',1,[]);
        end
        %
        GTmatrix=dataCluSquare.gtIllumTr{iRegion, iCluster};
        
        for noChannel=1:3
            %% 2. trainging data; checking data
            nImgInSubsub_8per = fix(nImgInSubsub*opt.chkCutPoint); %0.85
            nImgInSubsub_2per = fix(1);
            datin=IF(nImgInSubsub_2per:nImgInSubsub_8per,inputLocation);
            datout=GTmatrix(nImgInSubsub_2per:nImgInSubsub_8per,noChannel);
            chkdatin=IF(nImgInSubsub_8per+1:nImgInSubsub,inputLocation);
            chkdatout=GTmatrix(nImgInSubsub_8per+1:nImgInSubsub,noChannel);
            
            %% 3. anfis: IF-->GT(RGB)
            % opt.NumMembershipFunctions = 3*ones(1,size(datin,2));
            % opt = genfisOptions('SubtractiveClustering','ClusterInfluenceRange',0.4);
            optFis =genfisOptions('FCMClustering','NumClusters',opt.NumClusters);
            fismat = genfis(datin,datout,optFis);
            % ---- eval
            %fuzout = evalfis(fismat,datin);
            %trnRMSE = norm(fuzout-datout)/sqrt(length(fuzout));
            % figure;
            % plot(datout);
            % hold on;
            % plot(fuzout,'o');
            % hold off;
            % title('Training Output')
            % xlabel('Number of Data')
            % ylabel('Output Value')
            % ---check
            %chkfuzout = evalfis(fismat,chkdatin);
            %chkRMSE = norm(chkfuzout-chkdatout)/sqrt(length(chkfuzout));
            % figure;
            % subplot(211);
            % plot(chkdatout);
            % hold on;
            % plot(chkfuzout,'o');
            % hold off;
            % 4. optimization
            anfisOpt = anfisOptions('InitialFIS',fismat,'EpochNumber',opt.EpochNumber,...
                'InitialStepSize',opt.InitialStepSize);
            anfisOpt.DisplayANFISInformation = 0;
            anfisOpt.DisplayErrorValues = 0;
            anfisOpt.DisplayStepSize = 0;
            anfisOpt.DisplayFinalResults = 0;
            %fismat2 = anfis([datin datout],anfisOpt);
            %
            %fuzout2 = evalfis(fismat2,datin);
            %trnRMSE2 = norm(fuzout2-datout)/sqrt(length(fuzout2));
            %chkfuzout2 = evalfis(fismat2,chkdatin);
            %chkRMSE2 = norm(chkfuzout2-chkdatout)/sqrt(length(chkfuzout2));chkRMSE2
            %
            % figure
            % subplot(212);
            % plot(chkdatout)
            % hold on
            % plot(chkfuzout2,'o')
            % hold off
            % 5.again; anfis with checking
            anfisOpt.ValidationData = [chkdatin chkdatout];
            [~,~,~,fismat4,~] = anfis([datin datout],anfisOpt);
            %[fismat3,trainError,stepSize,fismat4,chkError] = anfis([datin datout],anfisOpt);
            %x = [1:length(trainError)];
            %plot(x,trainError,'.b',x,chkError,'*r')
            %fuzout4 = evalfis(fismat4,datin);
            %trnRMSE4 = norm(fuzout4-datout)/sqrt(length(fuzout4));
            chkfuzout4 = evalfis(fismat4,chkdatin);
            %chkRMSE4 = norm(chkfuzout4-chkdatout)/sqrt(length(chkfuzout4));chkRMSE4
            
            %x = datin;
            %y = datout;
            %options = genfisOptions('GridPartition');
            %options.NumMembershipFunctions = 5;
            %fisin = genfis(x,y,options);
            %[in,out,rule] = getTunableSettings(fisin);
            
            %opt = tunefisOptions("Method","anfis");
            %opt.MethodOptions.EpochNumber=30;
            %fisout = tunefis(fisin,[in;out],x,y,opt);
            
            % ----showrule; show figure
            %     showrule(fismat4)
            %
            %     %%
            %     figure;
            %     plot(datout,'b');
            %     hold on;
            %     plot(fuzout4,'or');
            %     hold off;
            %     title('Training Output');
            %     xlabel('Number of Data');
            %     ylabel('Output Value');
            %     legend('datout','fuzout4');
            %     %
            %     figure;
            %     plot(chkdatout,'.-b')
            %     hold on
            %     plot(chkfuzout4,'o-r')
            %     % plot(chkfuzout2,'+r');
            %     title('Outputs')
            %     xlabel('Number of data')
            %     ylabel('Output value (R)')
            %     legend('chkdatout','chkfuzout4');
            %     % legend('chkdatout','chkfuzout4','chkfuzout2');
            %     %
            %     figure
            %     subplot(211);
            %     plot(trnErr)
            %     title('Training Error')
            %     xlabel('Number of Epochs')
            %     ylabel('Training Error')
            %     hold off
            %     %
            %     subplot(212);
            %     plot(chkErr)
            %     title('Checking Error')
            %     xlabel('Number of Epochs')
            %     ylabel('Checking Error')
            
            %% R£¬G£¬B
            if noChannel==1
                datoutR=datout;
                gtR=chkdatout;
                preR=chkfuzout4;
                fisModel_R=fismat4;
            end
            if noChannel==2
                datoutG=datout;
                gtG=chkdatout;
                preG=chkfuzout4;
                fisModel_G=fismat4;
            end
            if noChannel==3
                datoutB=datout;
                gtB=chkdatout;
                preB=chkfuzout4;
                fisModel_B=fismat4;
            end
            %
        end % for noChannel=1:3
        
        gt=[gtR gtG gtB];
        preRGB=[preR preG preB];
        preRGBNor=preRGB./[sum(preRGB')]';
        angle_gt_pre=zeros(size(gt,1),1);
        for i=1:size(gt,1)
            angle_gt_pre(i,1) = colorangle(gt(i,:), preRGBNor(i,:));
        end
        
        [minAngle, meanAngle, medianAngle, trimeanAngle, best25, worst25, average, maxAngle]=...
            calculateExtendedAngularStatistics(gt, preRGBNor);
        %% 7. all anfis models
        model.modelR{iRegion,iCluster}=fisModel_R;
        model.modelG{iRegion,iCluster}=fisModel_G;
        model.modelB{iRegion,iCluster}=fisModel_B;
        
        model.trainingsampleR{iRegion,iCluster}=[datin datoutR];
        model.trainingsampleG{iRegion,iCluster}=[datin datoutG];
        model.trainingsampleB{iRegion,iCluster}=[datin datoutB];
        model.modelgt{iRegion,iCluster}=gt;
        model.modelpreRGBNor{iRegion,iCluster}=preRGBNor;
        
        model.sampleNumerEachRegion(iRegion,iCluster)=nImgInSubsub;
        
        model.selectMethod{iRegion,iCluster}=indMethod;
        model.inputlocation{iRegion,iCluster}=inputLocation;
        
        model.statisticMetrics{iRegion,iCluster}=...
            [minAngle, meanAngle, medianAngle, trimeanAngle, best25, worst25, average, maxAngle];
        toc
    end
end
%%
gtChk=[];
preRGBNorChk=[];
for iRegion=1:k1
    for iCluster=1:k2
        gtChk=[gtChk;model.modelgt{iRegion,iCluster}];
        preRGBNorChk=[preRGBNorChk;model.modelpreRGBNor{iRegion,iCluster}];
    end
end
[minAngle, meanAngle, medianAngle, trimeanAngle, best25, worst25, average, maxAngle]= ...
    calculateExtendedAngularStatistics(gtChk, preRGBNorChk);
model.ChkMetrics = [minAngle, meanAngle, medianAngle, trimeanAngle, best25, worst25, average, maxAngle];
