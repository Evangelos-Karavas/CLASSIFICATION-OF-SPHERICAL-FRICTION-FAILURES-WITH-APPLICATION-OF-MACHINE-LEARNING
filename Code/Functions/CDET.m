function [selectedIndexes,selectedFeatures,a_norm] = CDET(features,Class,threshold)
%Function to Implement the CDET feature Selection Algorithm
% This is a, N class implementation using 0,1,2,..,N-1 as the classes Variables


    %Features need to be a table Variable to continue
    assert(isa(features,'table'))
    disp('CDET Feature Selection Algorithm')
    NofFeatures = size(features,2);
    NofClasses = length(unique(Class));
    % Calculating the average distance of the same condition samples
    disp('Step 1: Calculating Average Distance of Same Class Observations')
    d = zeros(NofClasses,NofFeatures);
    for c=0:(NofClasses-1) %For Each Class
        ClassSamples = features(Class == c,:);
        NofClassObservations = size(ClassSamples,1);
        for i=1:NofFeatures
            for j=1:NofClassObservations
                temp = 0;
                for k=1:NofClassObservations
                    temp = temp+abs(ClassSamples{j,i}-ClassSamples{k,i});
                end
                d(c+1,i)=d(c+1,i)+temp;
            end
        end
        d(c+1,:) = d(c+1,:)/(NofClassObservations*(NofClassObservations-1));
    end
    
    % Getting the average distance of classes
    disp('Step 2: Calculating Average Distance of Classes')
    dw = (1/NofClasses)*(d(1,:)+d(2,:)+d(3,:));
    
    % Calculating the variance factor of dw
    disp('Step 2b: Calculating Variance of Average Distance of Classes')
    V = max(d)./min(d);
    V(~isfinite(V) | isnan(V))=0; %Calculation Error Handling
    s = V;

    % Calculating the average feature value of all samples under the same condition
    disp('Step 3: Calculating Average Feature value for each Class')
    F_Mean = zeros(NofClasses,NofFeatures);
    for c=0:(NofClasses-1) %For Each Class
        ClassSamples = features(Class == c,:);
        F_Mean(c+1,:) = mean(ClassSamples.Variables);
    end
    
    
    
    % Obtaining the average distance between different condition samples
    disp('Step 4a: Calculating Average distance between different Class Samples')
    U = zeros(NofClasses^2,NofFeatures);
    k=0;
    for i=1:NofClasses
        for j=1:NofClasses
            k=k+1;
            U(k,:) = abs(F_Mean(j,:)-F_Mean(i,:));
        end
    end
    U(min(U == 0,[],2),:) = [];
    
    d_Mean = mean(U);

    % Definining and calculating the Variance factor of d_Mean 
    disp('Step 4b: Calculating Variance of Average Distance between different Class Samples')
    Variance_Factor = max(U)./min(U);
    Variance_Factor(~isfinite(Variance_Factor) | isnan(Variance_Factor))= 0;
    
    % Calculating the compensation factor
    disp('Step 5: Calculating Compensation factor')
    L=1./((s/max(s))+(Variance_Factor/max(Variance_Factor)));
    L(~isfinite(L) | isnan(L)) = 0;
    
    % Calculating distance evaluation factor
    disp('Step 6: Calculating Distance Evaluation factor')
    a = L.*(d_Mean./dw);
    a(~isfinite(a) | isnan(a))=0;
    % Normalization of ai
    a_norm=a/max(a);
    a_norm(~isfinite(a_norm) | isnan(a_norm))=0;
    
    % Best Feature Identification 
    selectedIndexes = find(a_norm>=threshold); 
    selectedFeatures = features(:,selectedIndexes);
    
    %Plot of Feature Selection Metric
    set(0,'DefaultAxesColorOrder',[0 0 0],...
    'DefaultAxesLineStyleOrder','-|-.|--|:')

    figure
    clf
    plot(1:NofFeatures,threshold*ones(1,NofFeatures),...
        1:NofFeatures,a_norm,':ks','LineWidth',2,...
         'MarkerEdgeColor','k',...
        'MarkerFaceColor','r',...
        'MarkerSize',10);
    xlabel('Features')
    ylabel('Evaluation Factor')
    title('FEATURE EVALUATION')
    filename = 'Plots\FeatureSelection\CDET.jpg';
    saveas(gcf,filename)
end

