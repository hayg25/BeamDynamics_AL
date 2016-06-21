function phasespace_code2genesis(filename,phasespace,E,Q)
%PHASESPACE_CODE2GENESIS Summary of this function goes here
% Export for Genesis
gamma=E/0.511;
np=length(phasespace);
% entete
l3=['? CHARGE = ' num2str(Q)];
l4=['? SIZE = ' num2str(np)];
%
beam=phasespace;
beam=beam';
beam(:,6)=gamma*(1+beam(:,6));
beam(:,5)=beam(:,5);
%
dlmwrite(filename, '# Input Distribution for LWFA', 'delimiter', '')
dlmwrite(filename, '? VERSION = 1.0', '-append','delimiter', '')
dlmwrite(filename, l3, '-append','delimiter', '')
dlmwrite(filename, l4, '-append','delimiter', '')
dlmwrite(filename, '? COLUMNS X XPRIME Y YPRIME Z GAMMA', '-append','delimiter', '')
dlmwrite(filename, beam, '-append', 'delimiter', ' ')

end

