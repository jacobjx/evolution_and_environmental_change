% offspring_fcn.m
% Helper function to generate a new generation of individuals from the parent 
% generation via random mating and genetic crossover.
%
% Refer to Johansson, J. 2008, Evolution 62: 421–435, for details.



function UUoffspring=mutateoffspring_fcn(UUoffspring,no_indiv,p)

    %vector of mutated individuals
    mut_ind = find(rand(no_indiv*4,1)<p.mu);

    %vector of mutated genes
    mut_gen=ceil(2*p.no_loci*rand(size(mut_ind)));

    %mutate the genomes
    UUoffspring(mut_gen,mut_ind)=UUoffspring(mut_gen,mut_ind)+p.sigma_mu*randn(length(mut_gen),length(mut_ind));



end