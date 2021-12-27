function [R,G,B]=checkRGB(r,g,b)
%% 任何实数 A， isfinite(A)、isinf(A) 和 isnan(A) 仅有一个等于 1
if isinf(r) && ~isinf(g) && ~isinf(b)
    r=1-g-b;
end
if isinf(g) && ~isinf(b) && ~isinf(r)
    g=1-r-b;
end
if isinf(b) && ~isinf(r) && ~isinf(g)
    b=1-g-r;
end
%%
if isinf(r) && isinf(g) && ~isinf(b)
    r=(1-b)/2;
    g=(1-b)/2;
end
if isinf(g) && isinf(b) && ~isinf(r)
    g=(1-r)/2;
    b=g;
end
if isinf(b) && isinf(r) && ~isinf(g)
    b=(1-g)/2;
    r=b;
end
%%
if isnan(r) || isnan(g) || isnan(b)
    r=1/3;
    g=r;
    b=r;
end
%%
R=r;
G=g;
B=b;