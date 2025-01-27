function [y_pred,acc] = testMultiSVM(mdl_1,mdl_2,testData,testErrorMatrix)
%Implementation of a multi SVM classifier testing.
%Testing is first done for the 2 SVMs separately and secondly for the total model

% Using 0 for NOT problematic State and 1 for BPFO OR BPFI
testClass = double(testErrorMatrix>0);
y_pred_1 = predict(mdl_1,testData);
y_actual_1 = testClass';
disp([9,'Partial Accuracy 1: ',num2str(accuracy(y_actual_1,y_pred_1))])

% Classification between BPFO and BPFI
testClass_2 = testErrorMatrix(testErrorMatrix>0);
testData_2 = testData(testErrorMatrix>0,:);
y_pred_2 = predict(mdl_2,testData_2);
y_actual_2 = testClass_2';
disp([9,'Partial Accuracy 2: ',num2str(accuracy(y_actual_2,y_pred_2))])

%Total System Testing
y_problem =  predict(mdl_1,testData);
index_problem = find(y_problem==1);
y_problem_2 = predict(mdl_2,testData(index_problem,:));
y_pred = zeros(size(testErrorMatrix));
y_pred(index_problem) = y_problem_2;
acc = accuracy(testErrorMatrix,y_pred);
disp([9,'Complete System Accuracy: ',num2str(acc)])

end

