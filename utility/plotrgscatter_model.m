function plotrgscatter_model(model)
%% plot r-g chromaticity scatters for model.dataCluSquare.gtIllumSubSubset
k1 = model.modelNumberK1;
k2 = model.modelNumberK2;
legendLabel=cell(1,k1*k2);
nc=1;
clrmark={'ro','go','bo','co','mo','yo','ko',...
    'r*','g*','b*','c*','m*','y*','k*',...
    'rs','gs','bs','cs','ms','ys','ks',...
    'r+','g+','b+','c+','m+','y+','k+'};
figure;
for i=1:k1
    for j=1:k2        
        rgbMat = model.dataCluSquare.gtIllumSubSubset{i, j};
        rb=rbPlot(rgbMat,clrmark{nc});
        nc=nc+1;
        hold on;
        legendLabel{(i-1)*k2+j}=sprintf('region: i=%s, j=%s', num2str(i), num2str(j));
    end
end
legend(legendLabel);
title('r-g chromaticity scatters');
