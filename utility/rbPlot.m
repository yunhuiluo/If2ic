function rb=rbPlot(rgbMat,col_Lt)
% plot normalized r and b
% rgbMat = [r g b;r g b;...];
% rgbMat = [ 1.2 2 3;3 4 5]; rb=rbPlot(rgbMat)
%%
if nargin <2
    col_Lt = 'ro';
end
r=rgbMat(:,1)./rgbMat(:,2);
b=rgbMat(:,3)./rgbMat(:,2);
if nargout==1
    rb=[r b];
end

% figure
plot(r,b,col_Lt);
axis([0 2 0 2]);
xlabel('r = R/(R+G+B)');
ylabel('b = B/(R+G+B)');
