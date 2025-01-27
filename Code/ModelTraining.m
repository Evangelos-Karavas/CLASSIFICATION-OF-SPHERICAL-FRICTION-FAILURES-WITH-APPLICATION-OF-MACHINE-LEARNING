%**************************************************************************
%
%                      "Model Training & Validation"                       
%
% Author:
% Georgios Kassavetakis  AM02121203 (gkassavetakis@gmail.com)
% ADD YOUR NAME HERE
%
% Date: 18/02/2024
%**************************************************************************
%% Script Start

%**************************************************************************
clear
close all
clc

%**************************************************************************
%% Adding the Function Path

%**************************************************************************
FunctionDirectory = [pwd, '\Functions'];
pathCell = regexp(path, pathsep, 'split');
if any(strcmpi(FunctionDirectory, pathCell))
    disp('Function Path is Already to Matlab Path')
else
    disp('Adding the Function Path to Matlab Path')
    addpath(FunctionDirectory)
end
%**************************************************************************
%% Parameters Init and File Handle 
%**************************************************************************
% Parameters Used
fs=20000; % sampling rate (Hz)
problem_NONE = 0; %Number used to show that the measurement is OK
problem_BPFO = 1; %Number used to show that the measurement is with BPFO
problem_BPFI = 2; %Number used to show that the measurement is with BPFI
acc = zeros(6,1);
SVM = cell(6,2);
warning('off','all')
%**************************************************************************


%**************************************************************************
% Reading the ErrorMatrix file
try
    ErrorMatrix = load('Errordata.txt');
catch
    error('Missing Feature Data File');
end
%*************************************************************************


%**************************************************************************
%Training and Testing Split
trainIndex_1 = [1:30,43,45,46,50,53,56,58,60];
trainIndex_2 =62 + [1:30,47,49,51,54,55,57];
trainIndex = [trainIndex_1,trainIndex_2];
trainErrorMatrix = ErrorMatrix(trainIndex);
testIndex = setdiff(1:length(ErrorMatrix),trainIndex);
testErrorMatrix = ErrorMatrix(testIndex);
testResult = zeros(6,length(testErrorMatrix));
%**************************************************************************

%% Loading CDET Selected Features

disp('Model 1: Using CDET Features')
%Loading CDET created file
try
    tbl = readtable('SelectedFeatures.csv');
catch
    error('Missing CDET Selected Features File');
end

%Training Testing Data Split
trainData = tbl(trainIndex,:);
testData = tbl(testIndex,:);
%% SVM Model Based on CDET Selected Features
disp('SVM Classification')

%Finding Best CDET Model using Bayesian optimization
optimizer = 'bayesopt';
disp([9,'Finding Best Model using Bayesian optimization',...
    ' and 5-Fold Cross Validation'])
[svm_1,svm_2] = trainMultiSVM(trainData,trainErrorMatrix,optimizer);
SVM{1,1}=svm_1;
SVM{1,2}=svm_2;
disp('Training Phase')
[~,~] = testMultiSVM(svm_1,svm_2,trainData,trainErrorMatrix);
disp('Testing Phase')
[testResult(1,:),acc(1)] = testMultiSVM(svm_1,svm_2,testData,testErrorMatrix);

disp([9,'Best models Total Accuracy:',num2str(acc(1))])

%Finding Best CDET Model using Grid Search
disp([9,'Finding Best Model using Bayesian optimization',...
    ' and 5-Fold Cross Validation'])
optimizer = 'gridsearch';
[svm_1,svm_2] = trainMultiSVM(trainData,trainErrorMatrix,optimizer);
SVM{2,1}=svm_1;
SVM{2,2}=svm_2;
disp('Training Phase')
[~,~] = testMultiSVM(svm_1,svm_2,trainData,trainErrorMatrix);
disp('Testing Phase')
[testResult(2,:),acc(2)] = testMultiSVM(svm_1,svm_2,testData,testErrorMatrix);
disp([9,'Best models Total Accuracy:',num2str(acc(2))])
%% KMeans Model Based on CDET Selected Features
disp('kMeans Semi Supervised Classification')
% Standarization based on the Training Data:  
% [tbl_train_standarized,M,S] = normalization(trainData);
% tbl_test_standarized = normalizeTestData(testData,M,S);
% Results are the same

start_ind1 = find(trainErrorMatrix==0,1,'first');
start_ind2 = find(trainErrorMatrix==1,1,'last');
start_ind3 = find(trainErrorMatrix==2,1,'last');
start_matrix = [trainData(start_ind1,:).Variables;
                trainData(start_ind2,:).Variables;
                trainData(start_ind3,:).Variables];
[ind,C] = kmeans(trainData.Variables,3,'Distance','cityblock',...
                                        'Start',start_matrix);
% The Same Result is given by:
% [ind,C] = kmeans(trainData.Variables,3,'Distance','sqeuclidean',...
%     'Start',start_matrix);
                                                                
disp([9,'Training Accuracy: ',num2str(accuracy(trainErrorMatrix,ind-1))])

% Testing Data
ind_test = kmeans(testData.Variables,3,'MaxIter',1,'Start',C);
disp([9,'Testing Accuracy: ',num2str(accuracy(testErrorMatrix,ind_test-1))])

%% Loading PCA Selected Features

disp('Model 2: Using PCA Features')
%Loading CDET created file
try
    tbl = readtable('ReducedFeatures.csv');
catch
    error('Missing PCA Reduced Features File');
end

%Training Testing Data Split
trainData = tbl(trainIndex,:);
testData = tbl(testIndex,:);

%% SVM Model Based on PCA Selected Features
disp('SVM Classification')

%Finding Best PCA Model using Bayesian optimization
optimizer = 'bayesopt';
disp([9,'Finding Best Model using Bayesian optimization',...
    ' and 5-Fold Cross Validation'])
[svm_1,svm_2] = trainMultiSVM(trainData,trainErrorMatrix,optimizer);
SVM{3,1}=svm_1;
SVM{3,2}=svm_2;
disp('Training Phase')
[~,~] = testMultiSVM(svm_1,svm_2,trainData,trainErrorMatrix);
disp('Testing Phase')
[testResult(3,:),acc(3)] = testMultiSVM(svm_1,svm_2,testData,testErrorMatrix);

disp([9,'Best models Total Accuracy:',num2str(acc(3))])

%Finding Best PCA Model using Grid Search
disp([9,'Finding Best Model using Bayesian optimization',...
    ' and 5-Fold Cross Validation'])
optimizer = 'gridsearch';
[svm_1,svm_2] = trainMultiSVM(trainData,trainErrorMatrix,optimizer);
SVM{4,1}=svm_1;
SVM{4,2}=svm_2;
disp('Training Phase')
[~,~] = testMultiSVM(svm_1,svm_2,trainData,trainErrorMatrix);
disp('Testing Phase')
[testResult(4,:),acc(4)] = testMultiSVM(svm_1,svm_2,testData,testErrorMatrix);
disp([9,'Best models Total Accuracy:',num2str(acc(4))])

%% KMeans Model Based on PCA Selected Features
disp('kMeans Semi Supervised Classification')

start_ind1 = find(trainErrorMatrix==0,1,'first');
start_ind2 = find(trainErrorMatrix==1,1,'last');
start_ind3 = find(trainErrorMatrix==2,1,'last');
start_matrix = [trainData(start_ind1,:).Variables;
                trainData(start_ind2,:).Variables;
                trainData(start_ind3,:).Variables];
[ind,C] = kmeans(trainData.Variables,3,'Distance','cityblock',...
                                        'Start',start_matrix);
% The Same Result is given by:
% [ind,C] = kmeans(trainData.Variables,3,'Distance','sqeuclidean',...
%     'Start',start_matrix);
                                                     
disp([9,'Training Accuracy: ',num2str(accuracy(trainErrorMatrix,ind-1))])

% Testing Data
% ind_test = kmeans(testData.Variables,3,'MaxIter',1,'Start',C);
% disp([9,'Testing Accuracy: ',num2str(accuracy(testErrorMatrix,ind_test-1))])

%% Loading PCA+CDET Selected Features
disp('Model 3: Using PCA Features Extracted from CDET')
%Loading CDET created file
try
    tbl = readtable('SelectedFeatures_PCA.csv');
catch
    error('Missing CDET + PCA Reduced Features File');
end

%Training Testing Data Split
trainData = tbl(trainIndex,:);
testData = tbl(testIndex,:);
%% SVM Model Based on CDET & PCA Selected Features
disp('SVM Classification')
%Finding Best CDET+PCA Model using Bayesian optimization
optimizer = 'bayesopt';
disp(['Finding Best Model using Bayesian optimization',...
    ' and 5-Fold Cross Validation'])
[svm_1,svm_2] = trainMultiSVM(trainData,trainErrorMatrix,optimizer);
SVM{5,1}=svm_1;
SVM{5,2}=svm_2;
disp('Training Phase')
[~,~] = testMultiSVM(svm_1,svm_2,trainData,trainErrorMatrix);
disp('Testing Phase')
[testResult(5,:),acc(5)] = testMultiSVM(svm_1,svm_2,testData,testErrorMatrix);

disp([9,'Best models Total Accuracy:',num2str(acc(5))])

%Finding Best CDET+PCA Model using Grid Search
disp([9,'Finding Best Model using Bayesian optimization',...
    ' and 5-Fold Cross Validation'])
optimizer = 'gridsearch';
[svm_1,svm_2] = trainMultiSVM(trainData,trainErrorMatrix,optimizer);
SVM{6,1}=svm_1;
SVM{6,2}=svm_2;
disp('Training Phase')
[~,~] = testMultiSVM(svm_1,svm_2,trainData,trainErrorMatrix);
disp('Testing Phase')
[testResult(6,:),acc(6)] = testMultiSVM(svm_1,svm_2,testData,testErrorMatrix);
disp([9,'Best models Total Accuracy:',num2str(acc(6))])

%% KMeans Model Based on PCA+CDET Selected Features
disp('kMeans Semi Supervised Classification')

start_ind1 = find(trainErrorMatrix==0,1,'first');
start_ind2 = find(trainErrorMatrix==1,1,'last');
start_ind3 = find(trainErrorMatrix==2,1,'last');
start_matrix = [trainData(start_ind1,:).Variables;
                trainData(start_ind2,:).Variables;
                trainData(start_ind3,:).Variables];
[ind,C] = kmeans(trainData.Variables,3,'Distance','cityblock',...
                                        'Start',start_matrix);
% The Same Result is given by:
% [ind,C] = kmeans(trainData.Variables,3,'Distance','sqeuclidean',...
%     'Start',start_matrix);
                                                                
disp([9,'Training Accuracy: ',num2str(accuracy(trainErrorMatrix,ind-1))])

% Testing Data
ind_test = kmeans(testData.Variables,3,'MaxIter',1,'Start',C);
disp([9,'Testing Accuracy: ',num2str(accuracy(testErrorMatrix,ind_test-1))])

%% Best Model based on CrossValidation Loss
KFLoss = ones(6,2);
for i=1:6
    for j=1:2
        KFLoss(i,j)=kfoldLoss(SVM{i,j}.crossval,'Folds',5);
    end
end
KFLoss = sum(KFLoss,2);
ind = find(KFLoss==min(KFLoss));
disp('Calculation using the KFold Loss:')
for i=1:length(ind)
    switch ind(i)
        case 1
            disp([9,'Best Model found with Bayesian Optimization',...
                ' and CDET features with kfoldLoss:',num2str(KFLoss(1))])
        case 2
            disp([9,'Best Model found with Grid Search',...
                ' and CDET features with kfoldLoss:',num2str(KFLoss(2))])
        case 3
            disp([9,'Best Model found with Bayesian Optimization',...
                ' and PCA features with kfoldLoss:',num2str(KFLoss(3))])
        case 4
            disp([9,'Best Model found with Grid Search',...
                ' and PCA features with kfoldLoss:',num2str(KFLoss(4))])  
        case 5
            disp([9,'Best Model found with Bayesian Optimization',...
                ' and CDET+PCA features with kfoldLoss:',num2str(KFLoss(5))])
        case 6
            disp([9,'Best Model found with Grid Search',...
                ' and CDET+PCA features with kfoldLoss:',num2str(KFLoss(6))]) 
    end
end
%% Best Overall Model

best_ind = find(acc==max(acc));
disp('Calculation using test Accuracy:')
for i=1:length(best_ind)
    switch best_ind(i)
        case 1
            disp([9,'Best Model found with Bayesian Optimization',...
                ' and CDET features with accuracy:',num2str(acc(1))])
        case 2
            disp([9,'Best Model found with Grid Search',...
                ' and CDET features with accuracy:',num2str(acc(2))])
        case 3
            disp([9,'Best Model found with Bayesian Optimization',...
                ' and PCA features with accuracy:',num2str(acc(3))])
        case 4
            disp([9,'Best Model found with Grid Search',...
                ' and PCA features with accuracy:',num2str(acc(4))])  
        case 5
            disp([9,'Best Model found with Bayesian Optimization',...
                ' and CDET+PCA features with accuracy:',num2str(acc(5))])
        case 6
            disp([9,'Best Model found with Grid Search',...
                ' and CDET+PCA features with accuracy:',num2str(acc(6))])  
    end
end
%% Removing the Path added

%**************************************************************************
disp('Removing the Function Path from Matlab Path')
rmpath(FunctionDirectory)
%**************************************************************************