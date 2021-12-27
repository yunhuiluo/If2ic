function checkIllest(ill)
% ill=est_ill_nowht;
% checkIllest(ill)
minVal=min(min(ill,[],2));
if minVal<=0 
    disp(['There is negative value: ' minVal]);
else
    disp('The values are positive.');
end
