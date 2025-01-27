function [Amax,Fmax,xf2,f2] = bandproc(xf,fs,BandCenter,harmonic,a)

N = size(xf,1);
assert(a<=1);
index_start = round(BandCenter*(1-a)*N/fs*harmonic);
index_end = round(BandCenter*(1+a)*N/fs*harmonic);
index = index_start:index_end;
xf2 = xf(index,:);
f2  = (index).*(fs/N);


%Find Max and Max frequency
Amax = max(xf);
Fmax = find(xf==Amax,1,'first');

end