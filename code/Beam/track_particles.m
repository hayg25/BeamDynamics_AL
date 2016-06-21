function [particles,XCO] = track_particles(particles)
%TRACK_PARTICLES Summary of this function goes here
%   Detailed explanation goes here
global DYNAMIC LATTICE 

nelem=length(LATTICE);
np=length(particles(1,:));
XCO=ones(nelem,np)*0;
% Track from 1 to nelem
for i=1:nelem
    type=LATTICE(i).type;
    T   =LATTICE(i).matrix;
    L   =LATTICE(i).length;
    K   =LATTICE(i).strength;
    ksi =LATTICE(i).chro;
    Disp=LATTICE(i).disp;
    flag=LATTICE(i).flag;
    %
    if     strcmp(type,'RF')
        E =DYNAMIC.energy;
        RF=DYNAMIC.RF;           % Vrf,Frf,phi
        [particles]=pass_RF(particles,E,RF(1),RF(2),RF(3));
    elseif strcmp(type,'SD')
        [particles]=pass_drift(particles,L);
    elseif strcmp(type,'SX')
        [particles]=pass_SX(particles,K*L);
    elseif strcmp(type,'QFF')
        [particles]=pass_QFF(particles,K);
    elseif strcmp(type,'MULT')
        [particles]=pass_mult(particles,K);               
    elseif strcmp(type,'DI')
        % Case exact integration
        %[particles]=dipole_geom_pass(particles,L,K);
        %[particles]=dipole_test(particles,L,K);
        [particles]=pass_dipole(particles,L,K);
    elseif strcmp(type,'CO')
        % Case exact integration
        [particles]=pass_CO(particles,K,-flag);
    elseif strcmp(type,'QP')
        % Case exact integration
        [particles]=pass_QP(particles,K,L);
    else
        particles=T*particles;
%         [particles]=Chro_pass(particles,ksi);
%         [particles]=length_pass(particles,L);
    end
    %
    XCO(i,:)=particles(1,:);
end

return