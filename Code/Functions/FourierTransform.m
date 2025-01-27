function [X_f,f] = FourierTransform(Data, fs)
%Function to Return the Fourier Transformed Data
[N,S] = size(Data);
X_f = zeros(N/2+1,S);
f=(0:fs/N:fs/2);
for i=1:S
    X_t = Data(:,i);
    X=abs(fft(X_t,N)/N); 
    X(1)=0; %set DC=0
    X_f(:,i) = X(1:N/2+1);
end

end

