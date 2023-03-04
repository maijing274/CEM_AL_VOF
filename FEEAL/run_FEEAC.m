function [query_example_index, num_query_instances, query_Targets_example]=...
    CMAL(train_Data_example, train_Targets_example, train_example_index, bag_labels, indicate_matrix_example, instance_Data, instance_Targets, bag_index, indicate_matrix_instance, n_pool, run, file_name)
% example_data:   n*d  feature matrix in example level
% example_target:  n*c label matrix 
% instance_data:   nb*db  feature matrix in instance level
% instance_target:  nb*c label matrix 
% bag_index : nb*1 indicate the bag index of instances 
% fprintf('\n =====%s begin CMAL time=%s\n',dataset,datestr(now));
file_name = ['results_logs',filesep,dataset,'_results.txt'];
fid=fopen(file_name,'w');
fprintf(fid,'开始时间：%s \n',datestr(now));
fclose(fid);
%% initialize data
[example_data, example_target, instance_data, instance_target, bag_Index]=initialize_data(dataset);
example_target(example_target==0)=-1;
instance_target(instance_target==0)=-1;
train_ratio=0.05;
test_ratio=0.5;
repeat=1; % repeat 
[num_example, num_label]=size(example_target);  
num_initial=ceil(num_example*train_ratio);
num_test=ceil(num_example*test_ratio);
num_pool=num_example-num_initial-num_test;

results_instance=cell(1,repeat);
rand_indexS=cell(1,repeat);
rand('seed',10);
for run=1:repeat
      rand_index=randperm(num_example);
      rand_indexS{run}=rand_index;
end

for run=1:repeat
    example_data1=example_data;
    example_target1=example_target;
    instance_Data=instance_data;
    instance_Targets=instance_target;
    bag_index=bag_Index;
    
    rand_index=rand_indexS{run};
    initial_example_index=rand_index(1:num_initial); 
    test_example_index=rand_index(num_initial+1:num_initial+num_test);
    pool_example_index=rand_index(num_initial+num_test+1:num_example);

    initial_Data_example=example_data1(initial_example_index,:);
    initial_Targets_example=example_target1(initial_example_index,:);
    test_Data_example=example_data1(test_example_index,:);
    test_Targets_example=example_target1(test_example_index,:);
    pool_Data_example=example_data1(pool_example_index,:);
    pool_Targets_example=example_target1(pool_example_index,:);

    train_Data_example=[initial_Data_example; pool_Data_example];
    train_Targets_example=[initial_Targets_example; pool_Targets_example];
    train_example_index=[initial_example_index pool_example_index];
    
    %
    for i=1:length(test_example_index)
        temp=test_example_index(i);
        instance_index=find(bag_index==temp);
        instance_Data(instance_index,:)=[];
        instance_Targets(instance_index,:)=[];
        bag_index(instance_index)=[];
    end
    
%construct the indicate matrix
    num_instance=size(instance_Data,1);
    indicate_matrix_instance=zeros(num_instance,num_label);
    indicate_matrix_example=[ones(num_initial, num_label); zeros(num_pool, num_label)];
    for i=1:length(initial_example_index)
        temp=initial_example_index(i);
        instance_index=find(bag_index==temp);
        indicate_matrix_instance(instance_index(:),:)=1;
    end
    
      [query_example_index,num_query_instances, query_Targets_example]=...
          CMAL(train_Data_example, train_Targets_example, train_example_index, example_target1, indicate_matrix_example,...
          instance_Data, instance_Targets, bag_index, indicate_matrix_instance, num_pool, run, file_name);
      indicate_matrix=[ones(num_initial,num_label); zeros(num_pool,num_label)];
      rand('seed',10);
      [result_instance]=CEAL_test(train_Data_example, query_Targets_example, query_example_index, test_Data_example, test_Targets_example, indicate_matrix, num_query_instances);
      results_instance{run}=result_instance;
end

evalstr=['save test',filesep,dataset,'_CM2AL.mat  results_instance'];
eval(evalstr);
fprintf('\n =====%s finish CM2AL time=%s\n',dataset,datestr(now));
end
   