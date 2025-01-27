%**************************************************************************
%
%                      "Feature Selection"                       
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
SelectionThreshold = 0.6; %Threshold for CDET Method
pca_thresh_1 = 85; %Threshold for PCA Method
pca_thresh_2 = 95; %Threshold for PCA+CDET Method

%**************************************************************************


%**************************************************************************
% Reading the feature file
try
    tbl = readtable('ExtractedFeatures.csv');
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
trainData = tbl(trainIndex,:);
trainErrorMatrix = ErrorMatrix(trainIndex);
testIndex = setdiff(1:size(tbl,1),trainIndex);
testData = tbl(testIndex,:);
testErrorMatrix = ErrorMatrix(testIndex);
%**************************************************************************

%**************************************************************************
% Standarization based on the Training Data

[tbl_train_standarized,M,S] = normalization(trainData);

tbl_test_standarized = normalizeTestData(testData,M,S);
%**************************************************************************

%% Feature Selection
%**************************************************************************
% Finding the Best Features Based on the Training Data
[index,~,~] = CDET(trainData,trainErrorMatrix,SelectionThreshold);
%**************************************************************************

%% Feature Reduction using PCA + CDET

%**************************************************************************
% Reducing the Features Based on the Training Data

[coeff,score,latend,~,explained,mu] = pca(tbl_train_standarized(:,index).Variables);
idx = find(cumsum(explained)>pca_thresh_2,1);
scoreTrain = score(:,1:idx);
scoreTest = (tbl_test_standarized(:,index).Variables-mu)*coeff(:,1:idx);
scoreTotal = zeros(size(ErrorMatrix,2),idx);
scoreTotal(trainIndex,:) = scoreTrain;
scoreTotal(testIndex,:) = scoreTest;
%Creating the PCA Table
tbl_selected_pca = pcatable(scoreTotal);

%Scree plot
screePlot(explained,latend,pca_thresh_2,'Scree_1.jpg')
%**************************************************************************

%% Feature Reduction using PCA
%**************************************************************************
% Reducing the Features Based on the Training Data

[coeff,score,latend,~,explained,mu] = pca(tbl_train_standarized.Variables);
idx = find(cumsum(explained)>pca_thresh_1,1);
scoreTrain = score(:,1:idx);

scoreTest = (tbl_test_standarized.Variables-mu)*coeff(:,1:idx);

scoreTotal = zeros(size(ErrorMatrix,2),idx);
scoreTotal(trainIndex,:) = scoreTrain;
scoreTotal(testIndex,:) = scoreTest;
%Creating the PCA Table
tbl_pca = pcatable(scoreTotal);

%Scree plot
screePlot(explained,latend,pca_thresh_1,'Scree_2.jpg')
%**************************************************************************

%% File Creation
%**************************************************************************
fileSave(tbl(:,index), 'SelectedFeatures.csv')
fileSave(tbl_selected_pca, 'SelectedFeatures_PCA.csv')
fileSave(tbl_pca, 'ReducedFeatures.csv')
%**************************************************************************

%% Removing the Path added
%**************************************************************************
disp('Removing the Function Path from Matlab Path')
rmpath(FunctionDirectory)
%**************************************************************************
