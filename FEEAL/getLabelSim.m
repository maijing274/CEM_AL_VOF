function Lsim = getLabelSim(labels,Udata, W, option)
% This function is to measure the label dimension similarity
% Input:
%   labels - NxL matrix, N is the number of training instances and L is the
%   number of labels
%   Udata - Unlabeld data points
%   W - current model
%   option: 'L2' - L2 distance
%           'Ratio' - max(card/pred, pred/card)
% Output:
%   Lsim - similarity of label level between the estimated label
%   cardinality and predicted number of labels
% 
% Author:
% Xin Li

%% calculate estimated cardinality
card = mean(sum(labels,2));
[~,~,predY] = mlabelTest_SVM(W,Udata);
predY = sum(predY,2);

if strcmp(option,'L2')
    Lsim = (predY-card).^2;
elseif strcmp(option, 'Ratio')
    Lsim = max([predY/card,card./predY],[],2);
else
    error('The value of option variable is not valid!\n')
end