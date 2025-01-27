function [smoothedSignal] = pre_process(Data)
%  This function is pre-processing the signals before going for ML.
%  The signals go through Savitzky filtering and Wavelet denoising for
%  reducing high-frequency noise in a signal and in general removing the noise

processed_data = Data;
order = 4;
framelen = 11;
wname = 'sym4';
% Savitzky-Golay filter
%smoothedSignal = sgolayfilt(processed_data, order, framelen);
smoothedSignal = sgolayfilt(processed_data, 2, 5);
% smoothedSignal_1 = sgolayfilt(processed_data, 24, 123);

% Wavelet Denoising
% denoisedSignal = wdenoise(processed_data,10,'Wavelet',wname);
% smoothedDenoisedSignal = wdenoise(smoothedSignal, 3,'Wavelet',wname);
%Plot with specified colors
% figure;
% plot(processed_data, 'Color', 'blue', 'LineWidth', 1);
% title('normal data');

figure;
plot(smoothedSignal, 'Color', 'green', 'LineWidth', 1);
title('smoothed 1 data');
% 
% figure;
% plot(smoothedSignal_1, 'Color', 'red', 'LineWidth', 1);
% title('smoothed 2 data');



% OUTPUT NEEDS TO BE A 123x1 VECTOR!!!!!
assert(size(processed_data,2)==123)
end