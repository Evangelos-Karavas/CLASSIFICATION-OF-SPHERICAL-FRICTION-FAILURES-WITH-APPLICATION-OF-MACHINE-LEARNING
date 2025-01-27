function [Dilation,Erosion,BeucherGrad,Closing,Opening] = morph_analysis(data,fs,f_d)
    % f_d = max(BPFO,BPFI)!
    X=fs/f_d;
    %for taking different Structure Element lengths
    Xk = (1:10).*0.1.*X;
    Xk = round(Xk);
    Xk = unique(sort(Xk));
   
    %Finding The Biggest Kyrtosis Structuring Elements for Each
    % morphological operation and demonstration
    k_Dilation = zeros(length(Xk),size(data,2));
    k_Erosion = zeros(length(Xk),size(data,2));
    k_BeucherGrad = zeros(length(Xk),size(data,2));
    k_Closing = zeros(length(Xk),size(data,2));
    k_Opening = zeros(length(Xk),size(data,2));
    se = cell(10,1);
    for i=1:length(Xk)
        se{i} = strel(ones(Xk(i),1));
        % calculating kurtosis value for selection of SE form 10 different SE used
        k_Dilation(i,:) = kurtosis(imdilate(data,se{i}));
        k_Erosion(i,:) = kurtosis(imerode(data,se{i}));
        k_BeucherGrad(i,:) = kurtosis(imdilate(data,se{i})-imerode(data,se{i}));
        k_Closing(i,:) = kurtosis(imclose(data,se{i}));
        k_Opening(i,:) = kurtosis(imopen(data,se{i}));
        
    end
    [~,ind_D] = max(k_Dilation);
    [~,ind_E] = max(k_Erosion);
    [~,ind_BG] = max(k_BeucherGrad);
    [~,ind_C] = max(k_Closing);
    [~,ind_O] = max(k_Opening);
    %Calculating The Morph analysis Signals for the Choosen SE
    Dilation = zeros(size(data));
    Erosion = zeros(size(data));
    BeucherGrad = zeros(size(data));
    Closing = zeros(size(data));
    Opening = zeros(size(data));
    for i=1:size(data,2)
        Dilation(:,i) = imdilate(data(:,i),se{ind_D(i)}); %Dilation
        Erosion(:,i) = imerode(data(:,i),se{ind_E(i)});  %Erosion
        BeucherGrad(:,i) = imdilate(data(:,i),se{ind_BG(i)})-...
            imerode(data(:,i),se{ind_BG(i)}); % Beucher Gradient
        Closing(:,i) = imclose(data(:,i),se{ind_C(i)}); %Closing
        Opening(:,i) = imopen(data(:,i),se{ind_O(i)});  %Opening
    end
    
end