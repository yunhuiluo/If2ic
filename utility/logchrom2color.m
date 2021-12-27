function normalized = logchrom2color(rg_log)
% log2 chromaticity to rgb color
% normalized = logchrom2color([1,2;2 1])
N = size(rg_log,1);
rgb = zeros(N,3);
for i=1:N
    cr = rg_log(i,2);
    cg = rg_log(i,1);
    eta = sqrt((2^(-cr))^2 + (2^(-cg))^2 +1);
    rgb(i,1) = 2^(-cr)/eta;
    rgb(i,2) = 1/eta;
    rgb(i,3) = 2^(-cg)/eta;
end
normalized=normalizeChromaticity(rgb);