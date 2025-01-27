%**************************************************************************
%
%                          "Signal Plotting"
%
% Author:
% Georgios Kassavetakis  AM02121203 (gkassavetakis@gmail.com)
% ADD YOUR NAME HERE
%
% Date: 14/02/2024
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
% ADD NEW PARAMETERS YOU NEEDED HERE -> MODIFY HERE
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

%% Time and Frequency plots

for i=1:size(Data,2)
    X_t = Data(:,i);
    N = size(Data,1);
    if (ErrorMatrix(i) == problem_BPFO)
        name = ['Sample ',num2str(i),' with BPFO problem'];
    elseif (ErrorMatrix(i) == problem_BPFI)
        name = ['Sample ',num2str(i),' with BPFI problem'];
    else
        name = ['Sample ',num2str(i),' without problem'];
    end
    figure
    clf
    subplot(2,1,1)
    t = (0:1/fs:(N-1)/fs);
    plot(t,X_t)
    grid on
    xlim([min(t),max(t)]);
    xlabel('Time [s]');ylabel('Amp')
    subplot(2,1,2)
    X_f=abs(fft(X_t,N)/N); X_f(1)=0; %set DC=0
    f=(0:fs/N:fs/2);
    plot(f,X_f(1:N/2+1))
    grid on
    xlim([min(f),max(f)]);
    xlabel('Frequency [Hz]');ylabel('Amp')
    sgtitle(name)
    filename = ['Plots\TimeAndFrequency\Plot_',num2str(i),'.jpg'];
    saveas(gcf,filename)
end
%% Feature Plots

%**************************************************************************
% Reading the feature file
try
    tbl = readtable('ExtractedFeatures.csv');
    ErrorMatrix = load('Errordata.txt');
catch
    error('Missing Feature Data File');
end
%*************************************************************************
Names = tbl.Properties.VariableNames;

for i=1:length(Names)
    shown_feature = tbl(:,i);
    plotFeature(shown_feature.Variables,ErrorMatrix,Names{i},true)
end

%% Removing the Path added

%**************************************************************************
disp('Removing the Function Path to Matlab Path')
rmpath(FunctionDirectory)
%**************************************************************************
