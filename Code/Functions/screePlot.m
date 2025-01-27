function  screePlot(explained,latend,pca_thresh,name)
%Function to Create the Scree Plot of the PCA analysis
proportion_of_variance = cumsum(latend)./sum(latend);
figure
clf
bar(explained,'b')
hold on
plot(1:length(proportion_of_variance),proportion_of_variance*100,'*-')
yline(pca_thresh,'k--')
ylim([0,120])
ylabel('Percentage of Variance')
xlabel('Principal Components')
title('Scree Plot')
filename = ['Plots\FeatureSelection\',name];
saveas(gcf,filename)
end

