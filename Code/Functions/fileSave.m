function  fileSave(tbl, filename)
%Table Save function using a given name

assert(isa(filename,'string')|isa(filename,'char'))

disp(['Saving ',num2str(size(tbl,1)),' Observations',...
    ' with ', num2str(size(tbl,2)),' features onto the file ',...
    filename])
writetable(tbl,filename,'WriteRowNames',true);

end

