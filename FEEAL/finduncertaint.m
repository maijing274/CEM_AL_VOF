function  [n,m,uncertainty]=finduncertaint(Data, Targets, models)
[~,c] = size(Targets);
for i=1:c
    pool_Data=Data
    pool_Target=Targets(:,i);
    
    model=models(i);
    [~, ~, decision_value]= libsvmpredict(pool_Target,pool_Data,model);%libpredict函数用于对测试集的数据进行测试，还能对未知样本进行预测
    decision_values(:,i)=decision_value;                 %每次运行会进行预测
end
uncertainty=1./max(abs(decision_values),0.0001);%计算不确定性得分
[n,m] = find(uncertainty==max(max(uncertainty)));
1;