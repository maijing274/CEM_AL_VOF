function     [query_label, models_instance, indicate_matrix_instance, num_query_instances, query_instance_index, query_Targets_instance]=...
    query_instance(idx_selected_example, idx_selected_label, train_example_index, instance_Data, instance_Targets, indicate_matrix_instance,...
    bag_index, bag_label, models_instance, query_instance_index, query_Targets_instance, options)
%[num_ins, num_label]=size(instance_Targets);
index1=find(bag_index==train_example_index(idx_selected_example));
instance_data1=instance_Data(index1,:);
instance_target1=instance_Targets(index1,idx_selected_label);
max_iter=length(index1);
niter=0;
more=true;
while(more)
    niter=niter+1;
    indicate_matrix=indicate_matrix_instance(index1,idx_selected_label);
    index2=find(indicate_matrix==0); %
    instance_data2=instance_data1(index2,:);
    instance_target2=instance_target1(index2);
    model=models_instance{idx_selected_label};
    [~, ~, decision_value]= mi_SVM_test(instance_data2,instance_target2,model);
    index3=find(decision_value==max(decision_value)); % find the most positive µÄinstance
    index3=index3(1);
    idx_selected_instance=index1(index2(index3));
    indicate_matrix_instance(idx_selected_instance,idx_selected_label)=1;
    query_Targets_instance(index1(index2(index3)),idx_selected_label)=instance_target2(index3);
    
    if (instance_target2(index3)==1)
        query_label=1;
        more=false;
    else %==-1
        if niter>=max_iter
            %         if niter>=max_iter/2 || sum(decision_value<=0)==length(decision_value)
            query_label=-1;
            more=false;
        end
    end
    %updata classification model on instance level
    temp=indicate_matrix_instance(:,idx_selected_label);
    indicate_instance=find(temp ==1); 
    train_data_instance=instance_Data(indicate_instance,:);
    train_target_instance=query_Targets_instance(indicate_instance,idx_selected_label);
    train_bag_index=bag_index(indicate_instance);
    [model, ~, ~]=mi_SVM_train(train_data_instance, train_target_instance, train_bag_index, bag_label, options);
    models_instance{idx_selected_label}=model;
end
num_query_instances=niter;