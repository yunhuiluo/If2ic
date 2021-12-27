%% init
clear; clc;
addpath('.\utility');
addpath('.\func');
data=load('dataTrain.mat');
data=data.dataTrain;
result=load('resultOptimal.mat'); 
result=result.result;
resultLsq=load('resultLsq.mat'); 
resultLsq=resultLsq.resultLsq;
%%
%[2 5 50 180 215 230 245 304 372 378 430 457 491 493 508]
imgNoGehlerShi=[430 457 491 493 508];
imgNoCubep=[2275 936 1088 1935 1228 1367 1967 1399];
%%
imgNo=imgNoGehlerShi;
N=size(imgNo,2); 
QualityResults.GehlerShi.imgNo=imgNo;
for i=1:N
    QualityResults.GehlerShi.filesRaw{i,1}=data.filesTr{imgNo(1,i),1};
    QualityResults.GehlerShi.gtIllum(i,:)=data.gtIllumTr(imgNo(1,i),:);
    QualityResults.GehlerShi.luo(i,:)=result.est_ill_sort(imgNo(1,i),:);
    QualityResults.GehlerShi.gw(i,:)=data.gw(imgNo(1,i),:);
    QualityResults.GehlerShi.wp(i,:)=data.wp(imgNo(1,i),:);
    QualityResults.GehlerShi.sog(i,:)=data.sog(imgNo(1,i),:);
    QualityResults.GehlerShi.ge1(i,:)=data.ge1(imgNo(1,i),:);
    QualityResults.GehlerShi.ge2(i,:)=data.ge2(imgNo(1,i),:);
    QualityResults.GehlerShi.pca(i,:)=data.pca(imgNo(1,i),:);
    QualityResults.GehlerShi.ggw(i,:)=data.ggw(imgNo(1,i),:);
    QualityResults.GehlerShi.lsr(i,:)=data.lsr(imgNo(1,i),:);
    QualityResults.GehlerShi.proposed(i,:)=resultLsq{2, 1}.gt_est_all(imgNo(1,i),:);
end
%% render img to sRGB color space for: gt;gw,wp,sog,ge1,ge2,pca,ggw,lsr
ffStr=cell(12,N);
A_sRGB=cell(12,N);
illuminant=ones(12,3,N); %
for i=1:N
    illuminant(1,:,i)=illuminant(1,:,i);
    illuminant(2,:,i)=QualityResults.GehlerShi.gtIllum(i,:);
    illuminant(3,:,i)=QualityResults.GehlerShi.luo(i,:);
    illuminant(4,:,i)=QualityResults.GehlerShi.gw(i,:);
    illuminant(5,:,i)=QualityResults.GehlerShi.wp(i,:);
    illuminant(6,:,i)=QualityResults.GehlerShi.sog(i,:);
    illuminant(7,:,i)=QualityResults.GehlerShi.ge1(i,:);
    illuminant(8,:,i)=QualityResults.GehlerShi.ge2(i,:);
    illuminant(9,:,i)=QualityResults.GehlerShi.pca(i,:);
    illuminant(10,:,i)=QualityResults.GehlerShi.ggw(i,:);
    illuminant(11,:,i)=QualityResults.GehlerShi.lsr(i,:);    
    illuminant(12,:,i)=QualityResults.GehlerShi.proposed(i,:);
    %
    ffStr{1,i}=fullfile('resultImg','Gehlershi',['Gehlershi',num2str(imgNo(1,i)),'_1_in','.jpg']);
    ffStr{2,i}=fullfile('resultImg','Gehlershi',['Gehlershi',num2str(imgNo(1,i)),'_2_gt','.jpg']);
    ffStr{3,i}=fullfile('resultImg','Gehlershi',['Gehlershi',num2str(imgNo(1,i)),'_3_luo','.jpg']);
    ffStr{4,i}=fullfile('resultImg','Gehlershi',['Gehlershi',num2str(imgNo(1,i)),'_4_gw','.jpg']);
    ffStr{5,i}=fullfile('resultImg','Gehlershi',['Gehlershi',num2str(imgNo(1,i)),'_5_wp','.jpg']);
    ffStr{6,i}=fullfile('resultImg','Gehlershi',['Gehlershi',num2str(imgNo(1,i)),'_6_sog','.jpg']);
    ffStr{7,i}=fullfile('resultImg','Gehlershi',['Gehlershi',num2str(imgNo(1,i)),'_7_ge1','.jpg']);
    ffStr{8,i}=fullfile('resultImg','Gehlershi',['Gehlershi',num2str(imgNo(1,i)),'_8_ge2','.jpg']);
    ffStr{9,i}=fullfile('resultImg','Gehlershi',['Gehlershi',num2str(imgNo(1,i)),'_9_pca','.jpg']);
    ffStr{10,i}=fullfile('resultImg','Gehlershi',['Gehlershi',num2str(imgNo(1,i)),'_A_ggw','.jpg']);
    ffStr{11,i}=fullfile('resultImg','Gehlershi',['Gehlershi',num2str(imgNo(1,i)),'_B_lsr','.jpg']);
    ffStr{12,i}=fullfile('resultImg','Gehlershi',['Gehlershi',num2str(imgNo(1,i)),'_proposed','.jpg']);
    %
    img = proprocGehlerImg(imgNo(1,i));
    bright_srgb=brightsRGB(img);    
    A_sRGB{1,i} = lin2rgb(bright_srgb,'OutputType','double');
    for j=2:12
        A_sRGB{j,i}=correctColorBalance(bright_srgb,illuminant(j,:,i));
    end
    %
    gt=illuminant(2,:,i);
    for j=1:12
        saveImgAndAeNoabc(A_sRGB{j,i},illuminant(j,:,i),ffStr{j,i},gt,j);
    end
end
%%
imgNo=imgNoCubep;
N=size(imgNo,2);
QualityResults.Cubep.imgNo=imgNo;
for i=1:N
    QualityResults.Cubep.filesRaw{i,1}=data.filesTr{imgNo(1,i),1};
    QualityResults.Cubep.gtIllum(i,:)=data.gtIllumTr(imgNo(1,i),:);
    QualityResults.Cubep.luo(i,:)=result.est_ill_sort(imgNo(1,i),:);
    QualityResults.Cubep.gw(i,:)=data.gw(imgNo(1,i),:);
    QualityResults.Cubep.wp(i,:)=data.wp(imgNo(1,i),:);
    QualityResults.Cubep.sog(i,:)=data.sog(imgNo(1,i),:);
    QualityResults.Cubep.ge1(i,:)=data.ge1(imgNo(1,i),:);
    QualityResults.Cubep.ge2(i,:)=data.ge2(imgNo(1,i),:);
    QualityResults.Cubep.pca(i,:)=data.pca(imgNo(1,i),:);
    QualityResults.Cubep.ggw(i,:)=data.ggw(imgNo(1,i),:);
    QualityResults.Cubep.lsr(i,:)=data.lsr(imgNo(1,i),:);
    QualityResults.Cubep.proposed(i,:)=resultLsq{2, 1}.gt_est_all(imgNo(1,i),:);
end
%% render img to sRGB: gt;gw,wp,sog,ge1,ge2,pca,ggw,lsr
ffStr=cell(12,N);
A_sRGB=cell(12,N);
illuminant=ones(12,3,N); %
for i=1:N
    illuminant(1,:,i)=illuminant(1,:,i);
    illuminant(2,:,i)=QualityResults.Cubep.gtIllum(i,:);
    illuminant(3,:,i)=QualityResults.Cubep.luo(i,:);
    illuminant(4,:,i)=QualityResults.Cubep.gw(i,:);
    illuminant(5,:,i)=QualityResults.Cubep.wp(i,:);
    illuminant(6,:,i)=QualityResults.Cubep.sog(i,:);
    illuminant(7,:,i)=QualityResults.Cubep.ge1(i,:);
    illuminant(8,:,i)=QualityResults.Cubep.ge2(i,:);
    illuminant(9,:,i)=QualityResults.Cubep.pca(i,:);
    illuminant(10,:,i)=QualityResults.Cubep.ggw(i,:);
    illuminant(11,:,i)=QualityResults.Cubep.lsr(i,:);
    illuminant(12,:,i)=QualityResults.Cubep.proposed(i,:);
    %
    ffStr{1,i}=fullfile('resultImg','Cubep',['Cubep',num2str(imgNo(1,i)),'_1_in','.jpg']);
    ffStr{2,i}=fullfile('resultImg','Cubep',['Cubep',num2str(imgNo(1,i)),'_2_gt','.jpg']);
    ffStr{3,i}=fullfile('resultImg','Cubep',['Cubep',num2str(imgNo(1,i)),'_3_luo','.jpg']);
    ffStr{4,i}=fullfile('resultImg','Cubep',['Cubep',num2str(imgNo(1,i)),'_4_gw','.jpg']);
    ffStr{5,i}=fullfile('resultImg','Cubep',['Cubep',num2str(imgNo(1,i)),'_5_wp','.jpg']);
    ffStr{6,i}=fullfile('resultImg','Cubep',['Cubep',num2str(imgNo(1,i)),'_6_sog','.jpg']);
    ffStr{7,i}=fullfile('resultImg','Cubep',['Cubep',num2str(imgNo(1,i)),'_7_ge1','.jpg']);
    ffStr{8,i}=fullfile('resultImg','Cubep',['Cubep',num2str(imgNo(1,i)),'_8_ge2','.jpg']);
    ffStr{9,i}=fullfile('resultImg','Cubep',['Cubep',num2str(imgNo(1,i)),'_9_pca','.jpg']);
    ffStr{10,i}=fullfile('resultImg','Cubep',['Cubep',num2str(imgNo(1,i)),'_A_ggw','.jpg']);
    ffStr{11,i}=fullfile('resultImg','Cubep',['Cubep',num2str(imgNo(1,i)),'_B_lsr','.jpg']);
    ffStr{12,i}=fullfile('resultImg','Cubep',['Cubep',num2str(imgNo(1,i)),'_proposed','.jpg']);
    %
    img = preprocCubepImg(imgNo(1,i)-568);
    bright_srgb=brightsRGB(img);    
    A_sRGB{1,i} = lin2rgb(bright_srgb,'OutputType','double');
    for j=2:12
        A_sRGB{j,i}=correctColorBalance(bright_srgb,illuminant(j,:,i));
    end
    %
    gt=illuminant(2,:,i);
    for j=1:12
        saveImgAndAeNoabc(A_sRGB{j,i},illuminant(j,:,i),ffStr{j,i},gt,j);
    end
end