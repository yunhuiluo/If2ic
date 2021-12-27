function noModels=findNoModels(fileNo,result)
%% find which model for a specific image
noModels=0;
num=size(result.Models,2);
for i=1:num
    aaa=find(result.Models(i).data_test_fileno==fileNo, 1);
    if ~isempty(aaa)
        noModels=i;
    end
end