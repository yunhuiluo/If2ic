function [n0Vec,ncVecGSCubep,vgVec] = getColorNumOfGSCubep()
% load('dataTrain.mat')
% [n0Vec,ncVecGSCubep,vg] = getColorNumOfGSCubep();
% dataTrain.n0Vec=n0Vec;
% dataTrain.nc=ncVecGSCubep;
% dataTrain.vg=vg;
% save dataTrain dataTrain
N=2275; 
% N=5
n0Vec=zeros(1,N);
ncVecGSCubep=zeros(1,N);
vgVec=zeros(1,N);
tic
for i = 1:N
    %fn=dataTrain.filesTr{i,1};
    if i<=568
        img = proprocGehlerImg(i);
    else
        img=preprocCubepImg(i-568);
    end
    n0=size(unique(reshape(img*256, [], 3), 'rows'), 1);
    n0Vec(i)=n0;
    
    ddd=fix(img*64);
    fff=unique(reshape(ddd, [], 3), 'rows');
    nc = size(fff, 1);
    ncVecGSCubep(i)= nc;
    
    dt = delaunayTriangulation(fff);
    [~, vg] = convexHull(dt);
    vgVec(i)=vg;
    
    display(['Now:', num2str(i),'/',num2str(N),...
        ', n0=',num2str(n0),', nc=',num2str(nc),', vg=',num2str(vg)]);
    toc
end

