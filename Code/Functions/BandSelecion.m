function [xf2,f2] = BandSelecion(xf,f,BandCenter,harmonic,a)

assert(a<=1);
index_start = find(f <= BandCenter*(1-a)*harmonic,1,'last');
index_end = find(f >= BandCenter*(1+a)*harmonic,1,'first');
index = index_start:index_end;
xf2 = xf(index,:);
f2  = f(index);


end
