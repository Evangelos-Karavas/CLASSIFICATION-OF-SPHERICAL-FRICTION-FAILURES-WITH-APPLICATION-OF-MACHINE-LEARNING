function Data_window = applyWindow(Data,filter)
% Choose filter From:
%   a)@hamming
%   b)@hann
%   c)@flattopwin
%   d)@kaiser
%   e)@blackman
%   f)@rectwin

assert(isa(filter,'function_handle'))
N = size(Data,1);
F = filter(N);
Data_window = Data.*F;

end