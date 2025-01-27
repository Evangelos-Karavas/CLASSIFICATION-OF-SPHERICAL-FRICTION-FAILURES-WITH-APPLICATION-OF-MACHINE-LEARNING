function h = hilbertTransform(z,fs)

h = hilbert(z);
h = abs(h);

end
