function [phasespace,centre sigma emit]=track_bunch_LIN(phasespace,pelem,arg)
% test tracking bunch trought LATTICE; linear
global  LATTICE DYNAMIC
%
if nargin == 1 ; 
    nelem=length(LATTICE);
end

stat='yes'; % for cumulate out data  : centre sigma emit
if nargin == 3 ; 
    stat=arg;
end

%    
% at beginning
if strcmp(stat,'yes')
    disp= DYNAMIC.disp;
    [b_mean b_sig b_emit]=bunch_statistics(phasespace,0,disp);
    centre=b_mean;
    sigma =b_sig;
    emit  =b_emit;
end


%
nelem=length(LATTICE);
% get matrix
matrix=cat(3,LATTICE.matrix);
% track from 1 to nelem
for i=1:nelem
    T=matrix(:,:,i);
    phasespace=T*phasespace;
    
    % test for plot
    if strcmp(stat,'yes')   
        disp=LATTICE(i).disp;
        [b_mean b_sig b_emit]=bunch_statistics(phasespace,0,disp);
        centre=[centre b_mean];
        sigma= [sigma b_sig];
        emit = [emit b_emit]; 
    else
        if i==pelem     
            disp=LATTICE(i).disp;
            [b_mean b_sig b_emit]=bunch_statistics(phasespace,0,disp);
            centre=b_mean;
            sigma =b_sig;
            emit  =b_emit;
        end
    end
    
end


return