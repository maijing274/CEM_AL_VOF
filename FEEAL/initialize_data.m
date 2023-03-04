function [example_data, example_target, instance_data, instance_target, bag_index]=initialize_data(dataset)
% example_data:   n*d  feature matrix in example level
% example_target:  n*c label matrix 
% instance_data:   nb*db  feature matrix in instance level
% instance_target:  nb*c label matrix 
% bag_index : nb*1 indicate the bag index of instances 
load (dataset)
instance_target=DD.YR;  %565个子样本*26类标签（1表示标注，0表示未标注）
bag_index=DD.XtB;       %
instance_data=DD.X;     %565个子样本*16维特征向量
example_target=DD.YB;   %144个样本*26类标签（1表示标注，-1表示未标注）
num_bag=size(example_target,1);
train_bags=cell(num_bag,1);%创建样本数量个cell数据
for i=1:num_bag
    example_index=find(bag_index==i);
    train_bags{i}=instance_data(example_index,:);
end                         %循环，生成：样本-子样本-子样本特征向量  结构的cell数据
example_data = bag_mapping(train_bags); % refer to the KiSar algorithm in [1].   输出样本数量*簇数量的bag_feature
% scale
example_data_scale = scaleForSVM(example_data,0,1);%归一化
instance_data_scale = scaleForSVM(instance_data,0,1);  %归一化
example_data =example_data_scale;
instance_data=instance_data_scale;


