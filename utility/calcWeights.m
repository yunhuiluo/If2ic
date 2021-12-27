function [eta,omega,weights] = calcWeights(c1f,c2f,model,opt)
%%
% opt.sigma=1;
% opt.gamma=0.0625;
% model = result.Models(1).model;
k1=model.dataCluSquare.k1;
k2=model.dataCluSquare.k2;
C1=model.dataCluSquare.C1;
C2=model.dataCluSquare.C2;
%% eta = weights: c1f,C1
d=pdist2(c1f,C1,'squaredeuclidean');
ker = exp(-d./opt.sigma^2);
ker = 1./d;
eta = max(opt.gamma,ker);
eta = eta./(sum(eta(:)));

%%
omega=zeros(k1,k2);
for i=1:k1
    d=pdist2(c2f,C2{i},'cosine');
    ker = exp(-d./opt.sigma^2);
    %d=exp(d);
    ker=1./d/sum(1./d);
    omega(i,:) = max(opt.gamma,ker);
    omega(i,:) = omega(i,:)./(sum(omega(i,:),2));
end
%%
weights = diag(eta)*omega;
weights(weights<opt.weightThd)=0;
weights=weights./sum(weights(:));