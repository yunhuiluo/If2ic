function ca = getEstAdjacentAE(estIll,dataTrain)
% estAdjAE = getEstAdjacentAE(result.est_ill_sort,dataTrain); size(estAdjAE)
%%
ca=zeros(2275,36);
for num=1:2275
    e=zeros(9,3);
    e(1,:)=estIll(num,:);
    for i=1:8
        e(i+1,:)=dataTrain.illSet8Tr_nor{num,1}(i,:);
    end
    ca_row=[];
    for i=1:8
        for j=i+1:9
            ca_row=[ca_row colorangle(e(i,:),e(j,:))];
        end
    end
    ca(num,:)=ca_row;
end

