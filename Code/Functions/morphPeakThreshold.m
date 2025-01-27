function peak_data = morphPeakThreshold(data,A)
%function that makes zeros all the Values below the threshold A
assert(length(A)==size(data,2))
peak_data = data - repmat(A(:)',size(data,1),1);
peak_data(peak_data<0) = 0;

end

