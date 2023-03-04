function r = SVMRFE(label, data)
% SVM-RFE
% SVM Recursive Feature Elimination (SVM RFE)
% by liyang @BNU Math
% Email:patrick.lee@foxmail.com
% last modified 2010.09.18
%%
n = size(data,2);
s = 1:n;
r = [];
iter = 1;
while ~isempty(s)
%     if mod(iter, 10) == 0
%         str = ['===',num2str(iter),'==='];
%         disp(str);
%         disp('processing .....');
%     end
    X = data(:,s);
    
%     v = 3;
%     [bestCVaccuracy,bestc,bestg] = SVMcgForClass(label, X, ...
%         -8,8,-8,8,v,0.8,0.8,4.5);
%     cmd = ['-c ',num2str(bestc),' -g ',num2str(bestg)];
%     model = svmtrain(label, X, cmd);
    
    model = svmtrain(label, X);
    
    w = model.SVs' * model.sv_coef;
    c = w.^2;
    [c_minvalue, f] = min(c);
    r = [s(f),r];
    ind = [1:f-1, f+1:length(s)];
    s = s(ind);
    
    iter = iter + 1;
end