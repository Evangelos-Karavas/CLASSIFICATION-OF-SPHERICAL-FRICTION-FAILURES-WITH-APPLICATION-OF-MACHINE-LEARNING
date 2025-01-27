function [Wavelet_Data, Wavelet_data_kurt] = Wavelet_trans(Data)

kyrt = zeros(1,123);
kyrt2 = zeros(1,123);
new_data = zeros(size(Data));
new_data_2 = zeros(size(Data));

for i = 1:123
    x=Data(:,i); 
    [C,l] = wavedec(x,3,'db1'); 

    Wav_b=wrcoef('a',C,l,'db1',1);
    Wav_c=wrcoef('a',C,l,'db1',2);
    Wav_d=wrcoef('a',C,l,'db1',3);
    Wav_bdet=wrcoef('d',C,l,'db1',1);
    Wav_cdet=wrcoef('d',C,l,'db1',2);
    Wav_ddet=wrcoef('d',C,l,'db1',3);

    %We only need level 3 wavelet transformation
    first = Wav_d + Wav_bdet;
    efirst = sum(first.^2);
    k_first = kurtosis(first);
    second = Wav_d + Wav_cdet;
    esecond = sum(second.^2);
    k_second = kurtosis(second);
    third = Wav_d + Wav_ddet;
    ethird = sum(third.^2);
    k_third = kurtosis(third);
    fourth = Wav_d + Wav_bdet + Wav_cdet;
    efourth = sum(fourth.^2);
    k_fourth = kurtosis(fourth);
    fifth = Wav_d + Wav_bdet + Wav_ddet;
    efifth = sum(fifth.^2);
    k_fifth = kurtosis(fifth);
    sixth = Wav_d + Wav_cdet + Wav_ddet;
    esixth = sum(sixth.^2);
    k_sixth = kurtosis(sixth);
    kurt_array = [k_first, k_second, k_third, k_fourth, k_fifth, k_sixth];

    [max_kurt,k_ind] = maxk(kurt_array,2);
    [maxe, e_ind] = max([efirst, esecond, ethird, efourth, efifth, esixth]);

    if e_ind == k_ind(1)
       k_ind = k_ind(2);
    else
        k_ind = k_ind(1);
    end

    if e_ind == 1 
        new_data(:,i) = first;
    elseif e_ind == 2 
        new_data(:,i) = second;
    elseif e_ind == 3
        new_data(:,i) = third;
    elseif e_ind == 4 
        new_data(:,i) = fourth;
    elseif e_ind == 5 
        new_data(:,i) = fifth;
    elseif e_ind == 6
        new_data(:,i) = sixth;
    end

    if k_ind == 1 
        new_data_2(:,i) = first;
    elseif k_ind == 2 
        new_data_2(:,i) = second;
    elseif k_ind == 3
        new_data_2(:,i) = third;
    elseif k_ind == 4 
        new_data_2(:,i) = fourth;
    elseif k_ind == 5 
        new_data_2(:,i) = fifth;
    elseif k_ind == 6
        new_data_2(:,i) = sixth;
    end
end

% figure;
% plot(new_data(:,30), 'Color', 'blue', 'LineWidth', 1);
% title("Wavelet Transformation Data from Energy");
% figure;
% plot(new_data_2(:,30), 'Color', 'red', 'LineWidth', 1);
% title("Wavelet Transformation Data from Kurtosis");

Wavelet_Data = new_data;
Wavelet_data_kurt = new_data_2;
end