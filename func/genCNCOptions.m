function opt=genCNCOptions(varargin)
%% default
opt.k1=1;
opt.k2=1;
opt.cluster1Feature='featureTr';% cmTr, featureTr,feat4Cheng,adjacentAngleError,illSet8TrNor
opt.cluster2Feature='adjacentAngleError';% cmTr, featureTr,feat4Cheng,adjacentAngleError,illSet8TrNor
opt.method='rgb'; % log,rgb
opt.optimization=false;

opt.indMethod = [1 2 7 8];
opt.chkCutPoint = 0.8;
opt.NumClusters = 5;
opt.EpochNumber = 60;
opt.InitialStepSize =  0.01;
%
opt.thdMean = 2.14;
opt.thdWorst =5.18;
%
opt.sigma=3;
opt.gamma=0.000625;
%
opt.epsonThd = 0.1;
opt.deltaThd = 0.1;
opt.weightThd = 0.1;
%%
if nargin>1 && numel(varargin)>1
    for v=1:2:numel(varargin)-1
        %disp(['varargin{' num2str(v) '} class is ' class(varargin{v})]);
        opt.(varargin{v})=varargin{v+1};
    end
end
