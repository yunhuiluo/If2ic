function [c1f,c2f,if_in] = retriveFeature(filenameNo,data,opt)
%
%filenameNo=1;
%opt.cluster1Feature='featureTr';% cmTr, featureTr,feat4Cheng,adjacentAngleError,illSet8TrNor
%opt.cluster2Feature='adjacentAngleError';% cmTr, featureTr,feat4Cheng,adjacentAngleError,illSet8TrNor
c1f=data.(opt.cluster1Feature)(filenameNo,:);
c2f=data.(opt.cluster2Feature)(filenameNo,:);
if_in=data.illSet8TrNor(filenameNo,:);