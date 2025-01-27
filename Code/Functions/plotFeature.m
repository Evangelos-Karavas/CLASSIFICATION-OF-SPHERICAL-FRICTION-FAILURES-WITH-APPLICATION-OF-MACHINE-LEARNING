function  plotFeature(shown_feature,ErrorMatrix,featureName,SavePlot)
%Feature Plot function
%Returns a scatter plot and a feature evolution plot for both problems
problem_NONE = 0; %Number used to show that the measurement is OK
problem_BPFO = 1; %Number used to show that the measurement is with BPFO
problem_BPFI = 2; %Number used to show that the measurement is with BPFI

if nargin<4
  SavePlot = 0;  
end

%Scatter Plot of the choosen feature
figure
clf
scatter(find(ErrorMatrix==problem_NONE),...
    shown_feature(ErrorMatrix==problem_NONE),'o',"blue",'LineWidth',0.7)
hold on
grid minor
scatter(find(ErrorMatrix==problem_BPFI),...
    shown_feature(ErrorMatrix==problem_BPFI),'x',"red",'LineWidth',0.7)
scatter(find(ErrorMatrix==problem_BPFO),...
    shown_feature(ErrorMatrix==problem_BPFO),'*',"green",'LineWidth',0.7)
%plot(1:length(ErrorMatrix),shown_feature',"--k",'LineWidth',0.1)
legend('No Problem','BPFI','BPFO')
ylabel('Feature Value')
xlabel('Measurement ID')
title(featureName,'interpreter','none')
if SavePlot
        filename = ['Plots\Features\Plot_',featureName,'_1.jpg'];
    saveas(gcf,filename)
end
%Plot of the choosen feature
figure
clf
subplot(2,1,1)
plot(1:63,shown_feature(1:63)',"--b",'LineWidth',0.3)
hold on
grid minor
scatter(find(ErrorMatrix==problem_BPFI),...
    shown_feature(ErrorMatrix==problem_BPFI),'x',"red",'LineWidth',0.7)
scatter(find(ErrorMatrix(1:63)==problem_NONE),...
    shown_feature(ErrorMatrix(1:63)==problem_NONE),'o',"blue",'LineWidth',0.7)
legend('No Problem','BPFI')
ylabel('Feature Value')
xlabel('Measurement ID')
subplot(2,1,2)
plot(64:123,shown_feature(64:end)',"--b",'LineWidth',0.3)
hold on
grid minor
scatter(find(ErrorMatrix==problem_BPFO),...
    shown_feature(ErrorMatrix==problem_BPFO),'x',"red",'LineWidth',0.7)
ind = ErrorMatrix==problem_NONE;
f = shown_feature(64:end);
scatter(63+find(ErrorMatrix(64:end)==problem_NONE),...
    f(ind(64:end)),'o',"blue",'LineWidth',0.7)
legend('No Problem','BPFO')
ylabel('Feature Value')
xlabel('Measurement ID')
sgtitle(featureName,'interpreter','none')
if SavePlot
        filename = ['Plots\Features\Plot_',featureName,'_2.jpg'];
    saveas(gcf,filename)
end
end

