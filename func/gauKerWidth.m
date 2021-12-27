function sgma=gauKerWidth(data)
%  This function calculates the kernel base (sigma) for GRBF Kernel Function

%  Output:
%           sgma is the kernel width for Gaussian Radial Basis Function
%           

if (nargin < 1)
     error('No enough inputs !');
end

avgX=mean(data);     % The average of all points
d=pdist2(data,avgX); % Distance 
avgD=mean(d);       % Average of all distances 
n=size(data,1);
sgma=sqrt(sum((d-avgD).^2)/(n-1));    % Kernel width