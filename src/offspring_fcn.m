% offspring_fcn.m
%
% Helper function to generate a new generation of individuals from the parent 
% generation via random mating and genetic crossover.
%
% Part of the model described in Johansson, J. 2008, Evolution 62: 421–435.

function UUoffspring = offspring_fcn(UUadults,no_indiv,p)

    %retrieving the 2 strands (mUU1 and mUU2) of the mother genome
    mUU1 = UUadults(1:p.no_loci,:);
    mUU2 = UUadults(p.no_loci+1:end,:);

    %pre-allocation for speed
    mgametes = zeros(p.no_loci,no_indiv);
    pgametes = zeros(p.no_loci,no_indiv);

    UUoffspring = zeros(p.no_loci*2,no_indiv*p.fecundity);
    for i=1:p.fecundity

        %partner
        partner_v=ceil(no_indiv*rand(no_indiv,1));

        %retrieving the 2 strands (pUU1 and pUU2) of the partner genome
        pUU1 = UUadults(1:p.no_loci,partner_v);
        pUU2 = UUadults(1:p.no_loci,partner_v);

        %offspring index vector
        offsp=(i-1)*no_indiv+1:i*no_indiv;

        %obtain zygot gene position matrix for mother 
        binzyg = rand(p.no_loci,no_indiv) < 0.5;
        
        %offspring genome from mother function zygots
        mgametes(binzyg) = mUU1(binzyg);
        mgametes(~binzyg) = mUU2(~binzyg);

        %zygot gene position matrix for partner function
        binzyg = rand(p.no_loci,no_indiv) < 0.5;

        %offspring genome partner function 
        pgametes(binzyg) = pUU1(binzyg);
        pgametes(~binzyg) = pUU2(~binzyg);

        %put together mother and parent gametes
        UUoffspring(1:p.no_loci,offsp) = mgametes;
        UUoffspring(p.no_loci+1:end,offsp) = pgametes;

    end

end