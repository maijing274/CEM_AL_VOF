function MicroAvgF1=Micro_Avg_F1(Outputs,test_target)
%Computing the Micro Average F1
%Outputs: the predicted outputs of the classifier, the output of the ith instance for the jth class is stored in Outputs(j,i)
%test_target: the actual labels of the test instances, if the ith instance belong to the jth class, test_target(j,i)=1, otherwise test_target(j,i)=-1)
%   written by Guoxian Yu (guoxian85@gmail.com), School of Computer Science and Engineering,
%   South China University of Technology.
%   version 1.0 date:2011-11-15
Outputs=transform_one_zero(Outputs);
test_target=transform_one_zero(test_target);
C=size(test_target,1);
div1=0.000000;
div2=0.00000001;
div3=0.00000001;
for ii=1:C
    div1=div1+Outputs(ii,:)*(test_target(ii,:)');
    div2=div2+sum(Outputs(ii,:));
    div3=div3+sum(test_target(ii,:));
end
MicroAvgF1=2*div1/(div2+div3);