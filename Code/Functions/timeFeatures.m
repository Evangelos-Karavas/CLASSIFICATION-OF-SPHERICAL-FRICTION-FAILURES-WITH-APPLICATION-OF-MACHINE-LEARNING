function out = timeFeatures(Data)
%Function to calculate the Time Dependent Features
    out =[];
    out.Max = max(Data)';
    out.Mean = mean(Data)';
    out.Median = median(Data)';
    out.Peak2Peak = peak2peak(Data)';
    out.RMS = rms(Data)';
    out.Variance = var(Data)';
    out.Std = std(Data)';
    out.Skewness = skewness(Data)';
    out.Kurtosis = kurtosis(Data)';
    out.CrestFactor = max(Data)'./out.RMS;
    out.ShapeFactor = out.RMS./mean(abs(Data))';
    out.ImpulseFactor = (max(Data)./mean(abs(Data)))';
    out.MarginFactor = (max(Data)./mean(abs(Data)).^2)';
    out.Energy = sum(Data.^2)';
%     out.Entropy = ENTROPIA(h);
    
end

%HOW TO CALL ON MAIN SCRIPT
% out = timeFeatures(Data);
% out is a struct with values Mean,Kurtosis,etc
