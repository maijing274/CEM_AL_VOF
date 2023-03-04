function [newLabels]=transform_one_zero(oldLabels)
%Transform the label  -1 1 1 -1 into 0 1 1 0  forms
%oldLabels: the output of the ith instance for the jth class is stored in oldLabels(j,i)
%newLabels: if the ith instance belong to the jth class, newLabels(j,i)=1, otherwise newLabels(j,i)=-1)
%   written by Guoxian Yu (guoxian85@gmail.com), School of Computer Science and Engineering,
%   South China University of Technology.
%   version 1.0 date:2011-11-15
newLabels=(abs(oldLabels)+oldLabels)/2;