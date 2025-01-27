function [mdl_1,mdl_2] = trainMultiSVM(trainData,trainErrorMatrix,optimizer)
%Implementation of a multi SVM classifier training phase

% Using 0 for NOT problematic State and 1 for BPFO OR BPFI
trainClass = double(trainErrorMatrix>0);
k = 5;
AcquisitionFun = 'expected-improvement-per-second-plus';
%If we want Reproduction of Bayesian Optimizer uncommend:
%AcquisitionFun = 'expected-improvement-plus'; 
OptimizeHyperparametersOpt = struct('Optimizer',optimizer,...
    'AcquisitionFunctionName',AcquisitionFun,...
    'NumGridDivisions',3,'Kfold',k);
mdl_1 = fitcsvm(trainData,trainClass,...
    'OptimizeHyperparameters',{'BoxConstraint','KernelFunction',...
    'KernelScale','PolynomialOrder','Standardize'},...
    'HyperparameterOptimizationOptions',OptimizeHyperparametersOpt);



% Classification between BPFO and BPFI
trainClass_2 = trainErrorMatrix(trainErrorMatrix>0);
trainData_2 = trainData(trainErrorMatrix>0,:);
mdl_2 = fitcsvm(trainData_2,trainClass_2,...
    'OptimizeHyperparameters',{'BoxConstraint','KernelFunction',...
    'KernelScale','PolynomialOrder','Standardize'},...
    'HyperparameterOptimizationOptions',OptimizeHyperparametersOpt);
 
% mdl_1 = fitcsvm(trainData,trainClass);
% mdl_2 = fitcsvm(trainData_2,trainClass_2);
end

