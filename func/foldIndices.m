function [indices,N,L]=foldIndices(datasetFoldName)
k = str2double(datasetFoldName);
if isnan(k)
    indices=load_folds(datasetFoldName);
    N = max(unique(indices));
    L=size(indices,1);
else
    L=k;    % L=568; L=1707; L=2275
    N = 3; % N=10; N=5;
    indices = crossvalind('Kfold', L, N); % save gehlershi_folds indices;
    % indices=[zeros(568,1);indices]; save cubep_folds indices;
    % save gehlershi_and_cubep_folds indices;
end