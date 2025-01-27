function tbl_test_standarized = normalizeTestData(testData,M,S)
assert(isa(testData,'table'))
tbl_test_standarized = testData;
for i=1:size(testData,2)
    tbl_test_standarized(:,i).Variables = (testData(:,i).Variables-M(i))/S(i);
end

end

