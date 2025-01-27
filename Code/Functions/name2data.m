function [Data,ErrorMatrix,Problem,Date,time,C,Fault,Measurement] = name2data(directory)
%name2data Reads the file name and gives back the problem, the date and 
%time of recording, the position used, if there is a fault on the 
%maschine or not and the measurements based on the C read.

%Used variables init
NofFiles = size(directory,1)-2;
problem_NONE = 0; %Number used to show that the measurement is OK
problem_BPFO = 1; %Number used to show that the measurement is with BPFO
problem_BPFI = 2; %Number used to show that the measurement is with BPFI

% Init
Problem = cell(1,NofFiles);
Date = cell(1,NofFiles);
time = cell(1,NofFiles);
C = cell(1,NofFiles);
Fault = cell(1,NofFiles);
Measurement = cell(1,NofFiles);

for i=1:NofFiles
    try
        %Using i+2 because of the names . and .. found from the directory
        str = directory(i+2).name;
    catch
        error('Wrong Argument')
    end
    try
        Problem{i} = str(4:7);
        Date{i} = str(9:12);
        time{i} = str(14:17);
        C{i} = str(20);
        Fault{i} = str(22);
        temp = load(str);
        Measurement{i} = temp(:,str2num(C{i})); %#ok<ST2NM>
    catch
        error('Wrong File found in dir')
    end
end

% Data And ErrorMatric Creation
Data = zeros(size(Measurement{1},1),NofFiles);
ErrorMatrix = zeros(1,NofFiles);
for i=1:NofFiles
    
    %Data Matrix Creation
    Data(:,i)=Measurement{i};
    
    %Error Matrix Creation
    if strcmp(Problem{i},'BPFI')
        if strcmp(Fault{i},'F')
            %Faulty operation Detected
            ErrorMatrix(i)=problem_BPFI;
        else
            %Normal operation Detected
            ErrorMatrix(i)=problem_NONE;
        end
    elseif strcmp(Problem{i},'BPFO')
        if strcmp(Fault{i},'F')
            %Faulty operation Detected
            ErrorMatrix(i)=problem_BPFO;
        else
            %Normal operation Detected
            ErrorMatrix(i)=problem_NONE;
        end
    else
        error('Wrong Problem found')
    end
    
end

end