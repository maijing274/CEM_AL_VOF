function [diss] =test(Sdata, Slabels, Udata,index,indicate_matrixs)
feats = double(Sdata);
X = feats;
indicate_example=find(indicate_matrixs == 0); 
[~,m] = size(Slabels);
data_feats = [];
labels = double(Slabels);
for index = 1:m
    Y= labels(:,index);
    indice=SVM_RFE(Y,X);
    [~,n]= size(indice);
    n =n/2;
    data_feats = [];
    for k = 1:n    
        data_feats = [Udata(:,indice(k)) data_feats];
    end
    [dataf_size,datal_size] = size(data_feats);
    if dataf_size == 0
        data_feats = Udata;
    end
    disp(data_feats);
    dis = getmindata(data_feats);
    if index ==1
    diss = dis;
    else
    diss = [diss,dis];
    end
end

