function acc = accuracy(y_actual,y_pred)
%Function to calculate the accuracy of the prediction model
y_actual = y_actual(:);
y_pred = y_pred(:);
assert(length(y_actual)==length(y_pred))

acc = sum(y_actual==y_pred)/length(y_actual);

end

