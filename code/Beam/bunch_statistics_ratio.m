function [b_mean q]=bunch_statistics_ratio(phasespace,qm,beta,x)
% Comput mean from phasespace over x percent of particles
% beta : longitudinal beta function (weak focusing : eps=beta*d^2 + s^2/beta)
% b_mean  : mean of the 6 variables

% Invariant A for each part


% Charge
q=length(phasespace(1,:))*qm;

% Mean
ms =mean(phasespace(5,:));
me =mean(phasespace(6,:));
b_mean=[mx ; mxp ; my ; myp ; ms ; me];

return