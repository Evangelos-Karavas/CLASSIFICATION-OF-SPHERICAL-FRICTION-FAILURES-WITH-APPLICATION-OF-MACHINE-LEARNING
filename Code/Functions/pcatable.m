function tbl = pcatable(data)
%Function to create the table containing the pca selected components
N = size(data,2);
PCA_Name = {};
for i=1:N
PCA_Name(i) = {['PCA',num2str(i)]}; %#ok<AGROW>
end
tbl = array2table(data,'VariableNames',PCA_Name);

end

