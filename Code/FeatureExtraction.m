%**************************************************************************
%
%                          "Feature Extration"
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
features = []; %Struct to insert All the Used Features
fshaft = 33.33;
BPFO_theory = 236.4; 
BPFI_theory = 296.9;
BPFO_real = 231.4;
BPFI_real = 293.9;
BPFO = BPFO_real;
BPFI = BPFI_real;
unc = 0.12;
kyrtLevel = 5;
%**************************************************************************

%**************************************************************************

%**************************************************************************


%**************************************************************************
% Reading the used files
try
    Data = load('data.txt');
    ErrorMatrix = load('Errordata.txt');
catch
    
    %Goint to folder Data\Set01 (BPFI Problem)
    cd Data\Set01
    Files = dir;
    [Data1,ErrorMatrix1] = name2data(Files);
    
    %Goint to folder Data\Set02 (BPFO Problem)
    cd ..\Set02
    [Data2,ErrorMatrix2] = name2data(dir);
    
    % Total Data Used in Task
    Data = [Data1,Data2];
    ErrorMatrix = [ErrorMatrix1,ErrorMatrix2];
    
    %Returning to the original Directory
    cd ..\..
    
    %Saving the Read Measurements and Error Values
    writematrix(Data,'data.txt')
    writematrix([ErrorMatrix1,ErrorMatrix2],'Errordata.txt')
end
%**************************************************************************


%**************************************************************************
%Training and Testing Split
trainIndex_1 = [1:30,43,45,46,50,53,56,58,60];
trainIndex_2 =62 + [1:30,47,49,51,54,55,57];
trainIndex = [trainIndex_1,trainIndex_2];
trainData = Data(:,trainIndex);
trainErrorMatrix = ErrorMatrix(:,trainIndex);
testIndex = setdiff(1:size(Data,2),trainIndex);
testData = Data(:,testIndex);
testErrorMatrix = ErrorMatrix(:,testIndex);
%**************************************************************************

%% Basic Features and Hilbert

%**************************************************************************
%                         Processing: 
%At the end denoising techniques didn't work out so
%this part of pre-processing is commened out. However,
%we attempted Savitzky-Golay denoising, and wavelet filtering
%[Data_den] = pre_process(Data);
% Data_den_w = applyWindow(Data_den,@hamming);
%Data = Data_den;
%*************************************************************************

%**************************************************************************
%                       Feature Category: 
%               Time Features without signal processing
out = timeFeatures(Data);
features = addFeatures(features,out,'');
%**************************************************************************


%**************************************************************************
%                       Feature Category: 
%           Frequency Features without signal processing
[X_f,f] = FourierTransform(Data, fs);
outf = frequencyFeatures(X_f,f);
features = addFeatures(features,outf,'');

%**************************************************************************


%**************************************************************************
%                       Feature Category: 
%                      Kyrtogram Filtering
z = kyrtogramFiltering(Data,fs,kyrtLevel);
out1 = timeFeatures(z);
features = addFeatures(features,out1,'_kf');

[Z_f,f] = FourierTransform(z, fs);
out2 = frequencyFeatures(Z_f,f);
features = addFeatures(features,out2,'_kf');
%**************************************************************************


%**************************************************************************
%                       Feature Category: 
%                    Hilbert Transformation
h = hilbertTransform(z,fs);
hilbtfut = timeFeatures(h);
features = addFeatures(features,hilbtfut,'_h');


[H_f,f] = FourierTransform(h, fs);
hilbtfutf = frequencyFeatures(H_f,f);
features = addFeatures(features,hilbtfutf,'_h');

divfeature = Amax8(H_f,f,BPFI,BPFO);
features = addFeatures(features,divfeature,'_h');
%**************************************************************************


%**************************************************************************
%                       Feature Category: 
%             Frequency Band Selection (Hilbert Result)
[X_f_band,f_band] = BandSelecion(H_f,f, fshaft, 1, unc);
out_band = frequencyFeatures(X_f_band,f_band);
features = addFeatures(features,out_band,'_h_B1');

[X_f_band,f_band] = BandSelecion(H_f,f, BPFO, 1, unc);
out_band = frequencyFeatures(X_f_band,f_band);
features = addFeatures(features,out_band,'_h_B2');

[X_f_band,f_band] = BandSelecion(H_f,f, BPFO, 2, unc);
out_band = frequencyFeatures(X_f_band,f_band);
features = addFeatures(features,out_band,'_h_B3');

[X_f_band,f_band] = BandSelecion(H_f,f, BPFI, 1, unc);
out_band = frequencyFeatures(X_f_band,f_band);
features = addFeatures(features,out_band,'_h_B4');

[X_f_band,f_band] = BandSelecion(H_f,f, BPFI, 2, unc);
out_band = frequencyFeatures(X_f_band,f_band);
features = addFeatures(features,out_band,'_h_B5');
%**************************************************************************

%% Wavelet Transform
%**************************************************************************
%                       Processing: 
[Wavelet_Data, Wavelet_data_kurt] = Wavelet_trans(Data);
%**************************************************************************

%**************************************************************************
%                       Feature Category: 
%                       Wavelet Transform
out = timeFeatures(Wavelet_Data);
features = addFeatures(features,out,'_Wavelet');
[W_f,f] = FourierTransform(Wavelet_Data, fs);
out2 = frequencyFeatures(W_f,f);
features = addFeatures(features,out2,'_Wavelet');

out = timeFeatures(Wavelet_data_kurt);
features = addFeatures(features,out,'_Wavelet_kurt');
[W_f,f] = FourierTransform(Wavelet_data_kurt, fs);
out2 = frequencyFeatures(W_f,f);
features = addFeatures(features,out2,'_Wavelet_kurt');
% STON KYMATIDIAKO: Use Kyrtosis as a Selection Criterion
%**************************************************************************
%% Morphological Analysis
%**************************************************************************
%                         Processing: 
[Dilation,Erosion,BeucherGrad,Closing,Opening] = morph_analysis(Data,fs,max(BPFO,BPFI));

%**************************************************************************

%**************************************************************************
%                       Feature Category: 
%                Morphological Analysis Time Features

out = timeFeatures(Dilation);
features = addFeatures(features,out,'_morph_Dilation');
out = timeFeatures(Erosion);
features = addFeatures(features,out,'_morph_Erosion');
out = timeFeatures(BeucherGrad);
features = addFeatures(features,out,'_morph_BeucherGrad');
out = timeFeatures(Opening);
features = addFeatures(features,out,'_morph_Opening');
Closing_Thresh = morphPeakThreshold(Closing,mean(Closing));
out = timeFeatures(Closing_Thresh);
features = addFeatures(features,out,'_morph_Closing_threshold');
%**************************************************************************

%**************************************************************************
%                       Feature Category: 
%             Morphological Analysis Frequency Features

features = addMorphFreqFeatures(Dilation,features,'Dilation',fshaft,BPFO,BPFI,fs,unc);
features = addMorphFreqFeatures(Erosion,features,'Erosion',fshaft,BPFO,BPFI,fs,unc);
features = addMorphFreqFeatures(BeucherGrad,features,'BeucherGrad',fshaft,BPFO,BPFI,fs,unc);
features = addMorphFreqFeatures(Opening,features,'Opening',fshaft,BPFO,BPFI,fs,unc);
features = addMorphFreqFeatures(Opening,features,'Closing',fshaft,BPFO,BPFI,fs,unc);
%**************************************************************************
%% Autoregression Parameters
for i=1:size(Data,2)
    sys = ar(Data(:,i),8,'ls','now');
    p(:,i) = sys.Report.Parameters.ParVector;
end
out = [];
out.ArParameter1 = p(1,:)';
out.ArParameter2 = p(2,:)';
out.ArParameter3 = p(3,:)';
out.ArParameter4 = p(4,:)';
out.ArParameter5 = p(5,:)';
out.ArParameter6 = p(6,:)';
out.ArParameter7 = p(7,:)';
out.ArParameter8 = p(8,:)';
features = addFeatures(features,out,'');
%% File Creation

fileSave(struct2table(features), 'ExtractedFeatures.csv')

%To Read the Variables of a struct use: 
%struct2table(features).Properties.VariableNames
%To Read the Variables of a table use: 
%tbl.Properties.VariableNames

%% Removing the Path added

%**************************************************************************
disp('Removing the Function Path from Matlab Path')
rmpath(FunctionDirectory)
%**************************************************************************