function z = kyrtogramFiltering(tbl,fs,kyrtLevel)

z = zeros(size(tbl));
for i=1:size(tbl,2)
    [~,~,~,fc,~,wb]=kurtogram(tbl(:,i),fs,kyrtLevel);
    FL = fc - wb;
    FH = fc + wb;
    if (FL <= 0)&&(FH >= fs/2)
        z(:,i) = tbl(:,i);
    else
        
        if (FL <= 0)
            [b,a]=butter(4, 2*FH/fs, 'low');
        elseif (2*FH/fs >= 1)
            [b,a]=butter(4, 2*FL/fs, 'high');
        else
            [b,a]=butter(4,[max(2*FL/fs,0) min(2*FH/fs,1)]);
        end
        
        z(:,i) = filter(b,a,tbl(:,i));
        
    end
end

% futkyrtogramakaifiltro = timeFeatures(z);
% futkyrtogramakaifiltro.fc = fc;
% futkyrtogramakaifiltro.wb = wb;
% [xf,f] =FourierTransform(z, fs);
% futkyrtogramakaifiltrof = frequencyFeatures(xf,f);
end
