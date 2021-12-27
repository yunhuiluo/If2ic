function saveImgAndAeNoabc(A_sRGB,illuminant,imgFullfile,gt,bShowInfo)
%%
% illuminant=QualityResults.GehlerShi.gtIllum(i,:);
% imgFullfile=fullfile('resultImg','Gehlershi',['Gehlershi',num2str(i),'_gt','.jpg']);
[ae,rpe]=evaluate(illuminant,gt);
strLabel={'Input','Ground truth','Luo: ','GW: ','WP: ','SoG: ','GE1: ','GE2: ','PCA: ','GGW: ','LSR: ','Proposed: '};
figure,
imshow(A_sRGB);
if bShowInfo>2
    %colormap(illuminant);colorbar; set(colorbar,'Ticks',[]);
    %title(['\fontsize{20}', strLabel{bShowInfo}, 'AE = ',num2str(roundn(ae,-2)),'\circ',...
    %    ', RPE = ',num2str(roundn(rpe,-2)),'\circ']);
    txtCont = [strLabel{bShowInfo}, 'AE = ',num2str(ae,'%0.2f'),'\circ, RPE = ',num2str(rpe,'%0.2f'),'\circ'];
else
    %colormap(gt);colorbar; set(colorbar,'Ticks',[]);
    %title(['\fontsize{20}',strLabel{bShowInfo}]);
    txtCont = ['\colorbox{black}',strLabel{bShowInfo}];
end
text(100,100,txtCont,'Color','black','BackgroundColor','white','FontSize',32)
savefigure2img(imgFullfile);
% disp(imgFullfile);
print(gcf,'-r300','-depsc2',[imgFullfile '.eps']);
disp([imgFullfile '.eps']);
close