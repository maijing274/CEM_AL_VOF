function [neighborIds, neighborDistances] = KNN(dataMatrix, queryMatrix, k, metric)
%--------------------------------------------------------------------------
% Program to find the k - nearest neighbors (kNN) within a set of points. 
% Distance metric used: Euclidean distance or Cosine distance
% 
% Usage:
% [neighbors distances] = kNearestNeighbors(dataMatrix, queryMatrix, k);
% dataMatrix  (N x D) - N vectors with dimensionality D (within which we search for the nearest neighbors)
% queryMatrix (M x D) - M query vectors with dimensionality D
% k           (1 x 1) - Number of nearest neighbors desired
% metric - 'Euclidean': Euclidean Distance
%        - 'Cosine': Cosine Distance
% 
% Example:
% a = [1 1; 2 2; 3 2; 4 4; 5 6];
% b = [1 1; 2 1; 6 2];
% [neighbors distances] = KNN(a,b,2);
% 
% Output:
% neighbors =
%      1     2
%      1     2
%      4     3
% 
% distances =
%          0    1.4142
%     1.0000    1.0000
%     2.8284    3.0000
%--------------------------------------------------------------------------

neighborIds = zeros(size(queryMatrix,1),k);
neighborDistances = neighborIds;

numDataVectors = size(dataMatrix,1);
numQueryVectors = size(queryMatrix,1);

for i=1:numQueryVectors
    if strcmp(metric,'Euclidean')
        dist = sum((repmat(queryMatrix(i,:),numDataVectors,1)-dataMatrix).^2,2); % Nx1 vector
    elseif strcmp(metric,'Cosine')
        dist = (dataMatrix*queryMatrix(i,:)')./(arrayfun(@(idx) norm(dataMatrix(idx,:)), 1:size(dataMatrix,1))'*norm(queryMatrix(i,:)));
    else
        error('Metric is NOT recognized');
    end
    [sortval, sortpos] = sort(full(dist),'ascend');
    neighborIds(i,:) = sortpos(1:k);
    if strcmp(metric,'Euclidean')
        neighborDistances(i,:) = sqrt(sortval(1:k));
    else % cosine similarity
        neighborDistances(i,:) = sortval(end-k+1:end);
    end
end