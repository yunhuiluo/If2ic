function [NMI] = nmi(A,B)
 
total = size(A,2);
A_i = unique(A);
A_c = length(A_i);
B_i = unique(B);
B_c = length(B_i);
idA =double(repmat(A,A_c,1) == repmat(A_i',1,total));
idB =double(repmat(B,B_c,1 ) == repmat(B_i',1,total));
idAB = idA * idB';
 
Sa = zeros(A_c,1);
Sb = zeros(B_c,1);
for i=1:A_c
     for j=1:total
        if idA(i,j)==1
            Sa(i,1) = Sa(i,1) + 1;
        end
    end
end
 
for i=1:B_c
    for j=1:total
        if idB(i,j) ==1
            Sb(i,1) = Sb(i,1) + 1;
        end
    end
end
 
Pa = zeros(A_c,1);
Pb = zeros(B_c,1);
 
for i=1:A_c
    Pa(i,1) = Sa(i,1) / total;
end
 
for i=1:B_c
    Pb(i,1) = Sa(i,1) / total;
end
 
Pab = idAB / total;
 
Ha = 0;
Hb = 0;
for i=1:A_c
    Ha = Ha + Pa(i,1) * log2(Pa(i,1));
end
 
for i=1:B_c
    Hb = Hb + Pb(i,1) * log2(Pb(i,1));
end
 
MI = 0;
for i=1:A_c
    for j=1:B_c
      MI = MI + Pab(i,j) * log2(Pab(i,j) / (Pa(i,1) * Pb(j,1)) + eps);
    end
end
 
NMI = MI / ((Ha * Hb).^(1/2));
fprintf('NMI = %d\n',NMI);