function features = addMorphFreqFeatures(data,features,name,fshaft,BPFO,BPFI,fs,unc)

[data_f,f] = FourierTransform(data, fs);
out = frequencyFeatures(data_f,f);
features = addFeatures(features,out,['_morph_',name,'_Frequency']);

[X_f_band,f_band] = BandSelecion(data_f,f, fshaft, 1, unc);
out_band = frequencyFeatures(X_f_band,f_band);
features = addFeatures(features,out_band,['_morph_',name,'_B1']);

[X_f_band,f_band] = BandSelecion(data_f,f, BPFO, 1, unc);
out_band = frequencyFeatures(X_f_band,f_band);
features = addFeatures(features,out_band,['_morph_',name,'_B2']);

[X_f_band,f_band] = BandSelecion(data_f,f, BPFO, 2, unc);
out_band = frequencyFeatures(X_f_band,f_band);
features = addFeatures(features,out_band,['_morph_',name,'_B3']);

[X_f_band,f_band] = BandSelecion(data_f,f, BPFI, 1, unc);
out_band = frequencyFeatures(X_f_band,f_band);
features = addFeatures(features,out_band,['_morph_',name,'_B4']);

[X_f_band,f_band] = BandSelecion(data_f,f, BPFI, 2, unc);
out_band = frequencyFeatures(X_f_band,f_band);
features = addFeatures(features,out_band,['_morph_',name,'_B5']);


end

