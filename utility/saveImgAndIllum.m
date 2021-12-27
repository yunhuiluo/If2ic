function saveImgAndIllum(A_sRGB,illuminant,imgFullfile,gt,bShowInfo)
%%
% illuminant=QualityResults.GehlerShi.gtIllum(i,:);
% imgFullfile=fullfile('resultImg','Gehlershi',['Gehlershi',num2str(i),'_gt','.jpg']);
strLabel={'a) input','b) gt','c) ours: ','d) GW: ','e) WP: ','f) SoG: ','g) GE1: ','h) GE2: ','i)PCA: ','j) GGW: ','k) LSR: '};
figure,
imshow(A_sRGB);
if bShowInfo>2
    colormap(illuminant);colorbar; set(colorbar,'Ticks',[]);
    title(['\fontsize{32}', strLabel{bShowInfo}, '\gamma = ',num2str(colorangle(illuminant,gt)),'\circ']);
else
    colormap(gt);colorbar; set(colorbar,'Ticks',[]);
    
    title(['\fontsize{32}',strLabel{bShowInfo}]);
end
savefigure2img(imgFullfile);
close