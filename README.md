# Classification-of-Spherical-Friction-Failures-with-Application-of-Machine-Learning  

Development of an ‘automated detection system’ of the operational state of the
machine based on the scenario. The main stages of the development process are the following:
1. Pre-processing or not of the historical data with time windows,
denoising using wavelet transform (Wavelet denoising),
isolation of frequency ranges using filters, time series smoothing
(smoothing) by applying Savitzki-Golay filter, etc. If the historical data under
fault conditions are not sufficient for the ‘system’ to have satisfactory performance, then
simulated data with OR (outer race bearing
fault) and IR (inner race bearing fault) faults can also be used.

2. Extraction of common features from the transformed ones (Frequency domain analysis using the Fourier transform, Morphological analysis, Envelope analysis using the Hilbert transform, Wavelet transform analysis, etc.) or no (Time domain analysis) time signals of (a) good
operation of the machine, (b) with OR failure and (c) with IR failure.  

3. Selection or restriction or none of these of the extracted features (CDET, PCA,
etc.).

4. Input final features from (a) good operation of the machine, (b) OR failure of the bearings and (c) IR failure of the bearings into multiple classification algorithms
(Kmeans, SVM, ANN, etc.) to train the system and create boundaries separating the operational state of the machine into (a) good, (b) OR failure and (c) IR failure.

5. Measurement of the performance of the ‘system’ using the control signals.


![Screenshot 2025-01-27 145544](https://github.com/user-attachments/assets/789fb1b0-2222-4cc7-9e88-df51c0fcb0da)

For more information read:
[Classification-of-Spherical-Friction-Failures-with-Application-of-Machine-Learning.pdf](https://github.com/user-attachments/files/18558234/Classification-of-Spherical-Friction-Failures-with-Application-of-Machine-Learning.pdf)
