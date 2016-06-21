function file_genesis_Rin(filename,num,txt)
%FILE_GENESIS_RIN Summary of this function goes here
%   From Genesis command
%   num : ntail xlamds zsep nslice 
%   txt : filetype DISTFILE maginfile magoutfile outputfile

% Flash the file
fid = fopen([filename],'r');
C = textscan(fid,'%s','delimiter','\n');
fclose(fid);
C=(char(C{1}(:)));ll=size(C);
% Rewrite without the 10 last lines
dlmwrite(filename,C(1:(ll(1)-10),:),  'delimiter', '')
%
% Append the modified line
% To controle nslice & window (nslice*zsep*xlamb + ntail)
dlmwrite(filename,['ntail = ' num2str(num(1))] , '-append','delimiter', '')
dlmwrite(filename,['xlamds= ' num2str(num(2))] , '-append','delimiter', '')
dlmwrite(filename,['zsep  = ' num2str(num(3))] , '-append','delimiter', '')
dlmwrite(filename,['nslice= ' num2str(num(4))] , '-append','delimiter', '')
% To control in & out files
dlmwrite(filename,strcat('filetype  =''', txt(1),'''') , '-append','delimiter', '')
dlmwrite(filename,strcat('DISTFILE  =''', txt(2),'''') , '-append','delimiter', '')
dlmwrite(filename,strcat('maginfile =''', txt(3),'''') , '-append','delimiter', '')
dlmwrite(filename,strcat('magoutfile=''', txt(4),'''') , '-append','delimiter', '')
dlmwrite(filename,strcat('outputfile=''', txt(5),'''') , '-append','delimiter', '')
dlmwrite(filename,strcat('$end') , '-append','delimiter', '')
end

