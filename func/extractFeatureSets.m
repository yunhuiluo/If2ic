function Fs=extractFeatureSets(data,if2icClu)
%%
for fileNo=1:2275
    Fs.f1_cm(fileNo,:)=data.cmTr(fileNo,:);
    Fs.f2_corrm(fileNo,:)=phi34(data.gw(fileNo,:));
    Fs.f2_corrm_root(fileNo,:)=phi_rmp(data.gw(fileNo,:));
    Fs.f3_cdf(fileNo,:)=data.fisFeatCDF_cpt(fileNo,:);
    Fs.f4_iif(fileNo,:)=data.fisFeatIIF(fileNo,:);
    Fs.f4_iif_s4(fileNo,:)=data.fisFeatIIF(fileNo,[1 2 3 4 13 14 15 16]);
    Fs.f5_RGBuv(fileNo,:)=data.featureTr(fileNo,:);
    Fs.f6_feat4Cheng(fileNo,:)=data.feat4Cheng(fileNo,:);
    Fs.f7_comp2(fileNo,:)=[Fs.f5_RGBuv(fileNo,:) Fs.f6_feat4Cheng(fileNo,:)];
    Fs.f7_comp3(fileNo,:)=[Fs.f4_iif(fileNo,:) Fs.f5_RGBuv(fileNo,:) Fs.f6_feat4Cheng(fileNo,:)];
    Fs.f7_comp4(fileNo,:)=[Fs.f2_corrm_root(fileNo,:) Fs.f4_iif(fileNo,:) Fs.f5_RGBuv(fileNo,:) Fs.f6_feat4Cheng(fileNo,:)];
    
    Fs.gt(fileNo,:)=data.gtIllumTr(fileNo,:);
end
%%
% f1_cm=cell(m,n);
% f2_corrm=cell(m,n);
% f2_corrm_root=cell(m,n);
% f3_cdf=cell(m,n);
% f4_iif=cell(m,n);
% f4_iif_s4=cell(m,n);
% f5_RGBuv=cell(m,n);
% f6_feat4Cheng=cell(m,n);
% f7_comp2=cell(m,n);
% f7_comp3=cell(m,n);
% f7_comp4=cell(m,n);
% gt=cell(m,n);
% clu={'kmeansTrainDataNo','fcmTrainDataNo','kfcmTrainDataNo'};
% featSetName={'kmeansTrainFeatSet','fcmTrainFeatSet','kfcmTrainFeatSet'};
try
    fields = fieldnames(if2icClu);
    idx = find(strncmpi(reverse(fields),reverse('TrainDataNo'),11));
    clu=fields(idx);
    featSetName=strrep(clu,'DataNo','FeatSet');
    [m,n]=size(if2icClu.(clu{1}));
    
    for No=1:size(idx)
        cluTDN=clu{No};
        FeatureSetName=featSetName{No};
        for i=1:m
            for j=1:n
                ind=if2icClu.(cluTDN){i,j};
                Fs.(FeatureSetName).f1_cm{i,j} = Fs.f1_cm(ind,:);
                Fs.(FeatureSetName).f2_corrm{i,j} = Fs.f2_corrm(ind,:);
                Fs.(FeatureSetName).f2_corrm_root{i,j} = Fs.f2_corrm_root(ind,:);
                Fs.(FeatureSetName).f3_cdf{i,j} = Fs.f3_cdf(ind,:);
                Fs.(FeatureSetName).f4_iif{i,j} = Fs.f4_iif(ind,:);
                Fs.(FeatureSetName).f4_iif_s4{i,j} = Fs.f4_iif_s4(ind,:);
                Fs.(FeatureSetName).f5_RGBuv{i,j} = Fs.f5_RGBuv(ind,:);
                Fs.(FeatureSetName).f6_feat4Cheng{i,j}=Fs.f6_feat4Cheng(ind,:);
                Fs.(FeatureSetName).f7_comp2{i,j} = Fs.f7_comp2(ind,:);
                Fs.(FeatureSetName).f7_comp3{i,j} = Fs.f7_comp3(ind,:);
                Fs.(FeatureSetName).f7_comp4{i,j} = Fs.f7_comp4(ind,:);
                
                Fs.(FeatureSetName).gt{i,j} = Fs.gt(ind,:);
            end
        end
        
    end
catch
end
%%
try
    fields = fieldnames(if2icClu);
    idx = find(strncmpi(reverse(fields),reverse('TrainDataNo'),11));
    clu=fields(idx);
    featSetName=strrep(clu,'TrainDataNo','TrainAndTestFeatSet');
    
    for No=1:size(idx)
        cluTDN=strrep(clu{No},'TrainDataNo','CluResults');
        FeatureSetName=featSetName{No};
        ind=if2icClu.(cluTDN).indexTrainAndTest;
        Fs.(FeatureSetName).f1_cm = Fs.f1_cm(ind,:);
        Fs.(FeatureSetName).f2_corrm = Fs.f2_corrm(ind,:);
        Fs.(FeatureSetName).f2_corrm_root = Fs.f2_corrm_root(ind,:);
        Fs.(FeatureSetName).f3_cdf = Fs.f3_cdf(ind,:);
        Fs.(FeatureSetName).f4_iif = Fs.f4_iif(ind,:);
        Fs.(FeatureSetName).f4_iif_s4 = Fs.f4_iif_s4(ind,:);
        Fs.(FeatureSetName).f5_RGBuv = Fs.f5_RGBuv(ind,:);
        Fs.(FeatureSetName).f6_feat4Cheng=Fs.f6_feat4Cheng(ind,:);
        Fs.(FeatureSetName).f7_comp2 = Fs.f7_comp2(ind,:);
        Fs.(FeatureSetName).f7_comp3 = Fs.f7_comp3(ind,:);
        Fs.(FeatureSetName).f7_comp4 = Fs.f7_comp4(ind,:);
        
        Fs.(FeatureSetName).gt = Fs.gt(ind,:);
        
    end
catch
end