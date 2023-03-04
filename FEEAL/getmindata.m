function [dis] = getmindata(data_feats,index)
[temp,d] = size(data_feats);
[idx, C] = k_means(data_feats,1);
K = size(C,1);
prototypes = zeros(K,d);%初始化一个集群数*特征维数的0矩阵
empty = [];
means = zeros(K,1);
cur_cluster = data_feats;%cur_cluster：存储第t个聚类的子样本特征向量信息
[n,m] = size(cur_cluster);
dis = zeros(n,1);
    % calculate the distances from each instance to the virtual center
for s = 1:m
    dis = dis + (cur_cluster(:,s)-C(1,s)).^2;
end
    
    % set the closest instance as the prototype
[temp, prototype_idx] = min(dis);%选择到簇中心最近的子样本作为prototype
prototype_idx