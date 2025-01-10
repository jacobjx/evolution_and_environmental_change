% fitness_fcn.m
%
% Calculates the fitness of individuals based on resource availability and 
% competition, using Lotka–Volterra equations. Uses linear interpolation 
% for efficiency.
%
% Refer to Johansson, J. 2008, Evolution 62: 421–435, for the theoretical basis.


function [fv, KTable, fitnessTable, ubins] = fitnessv_fcn(uu_offsp,uu_old,Kopt,p)
    fitnessTable = zeros(1,p.bins);
    Kv = zeros(1,p.bins);


    ubins = linspace(min(uu_offsp)-0.01,max(uu_offsp)+0.01,p.bins);

    for i=1:p.bins
        udiff=ubins(i)-uu_old;
        
        %competitive impact is modelled using a cauchy distribution
        %ensuring stable coexistence of two or more evolving species  
        alfa=1./(1+udiff.^2/2/p.sigma_a^2);
        
        %a more standard model is otherwise using
        %a guassian distribution, but this
        %does not allow a stable 2-species ESS
        %
        %example
        
        %{
        alfa=exp(-(udiff).^2/2/p.sigma_a^2); 
        %}
        
        KTable(i) = p.K0*exp(-(ubins(i)-Kopt).^2/2/p.sigma_K^2);
        fitnessTable(i) = 1 + p.r * (1 - sum(alfa)'/KTable(i));
    end

    fv = interp1(ubins',fitnessTable',uu_offsp);
  
    
end