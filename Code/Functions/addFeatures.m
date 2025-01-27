function features_new = addFeatures(features,newFeatures,name)
%Function Returns a Struct with the previous and the new Features

if isempty(features)
    tbl = table();
else
    tbl = struct2table(features);
end
tbl_new = struct2table(newFeatures);
newNames = tbl_new.Properties.VariableNames;

for i=1:length(newNames)
    tbl = addvars(tbl,tbl_new(:,i).Variables,'NewVariableNames',[newNames{i},name]);
end

features_new = table2struct(tbl,"ToScalar",true);

end

