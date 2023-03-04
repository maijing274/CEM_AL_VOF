function density = getDensity(Udata)
% This function is to estimate the density of each unlabeled sample.
% Input:
%   Udata - Nxd matrix, set of the unlabeled data
% 
% Output:
%   density - Nx1 vector, each entry is the density measure of
%   corresponding data point
% 
% Author:
%   Xin Li

[N, d] = size(Udata);

K = N-1; % Use all instances
metric = 'Cosine';

density = zeros(N,1);

for sample_i=1:N
    [~, sims] = KNN(Udata([1:sample_i-1,sample_i+1:end],:), Udata(sample_i,:), K, metric);
    sims = (sims-min(sims))/(max(sims)-min(sims)); % normalize to avoid negative values
    density(sample_i) = sum(sims)/K;
end