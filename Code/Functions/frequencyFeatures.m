function out = frequencyFeatures(X_f,f)
%Function to calculate the Frequency Dependent Features
out =[];

out.spectralCentroid = spectralCentroid(X_f,f);
out.spectralSpread = spectralSpread(X_f,f);
out.spectralSkewness = spectralSkewness(X_f,f);
out.spectralKurtosis = spectralKurtosis(X_f,f);
out.spectralRMS = rms(X_f)';
out.spectralEnergy = sum(X_f.^2)';

%Max A and Freq
[X_f_max,max_ind] = max(X_f);
out.spectralMaximum = X_f_max';
out.spectralFreqMax = f(max_ind)';

end

%HOW TO CALL ON MAIN SCRIPT
% [X_f,f] = FourierTransform(Data, fs)
% out = frequencyFeatures(X_f,f)
% feature.spectralCentroid = out.spectralCentroid ;
% feature.spectralSpread = out.spectralSpread;
% feature.spectralSkewness = out.spectralSkewness;
% feature.spectralKurtosis = out.spectralKurtosis;
% feature.spectralRMS = out.spectralRMS;
% feature.spectralEnergy = out.spectralEnergy;
