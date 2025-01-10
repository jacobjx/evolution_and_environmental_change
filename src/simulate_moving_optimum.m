% simulate_moving_optimum.m
%
% Core simulation function that initializes the population, calculates fitness, 
% and models evolutionary dynamics over time. Uses helper functions for offspring 
% generation, mutation, and fitness calculation. Generates runtime plots.
%
% See Johansson, J. 2008, Evolution 62: 421–435, for details.



function out=simulate_moving_optimum(p)


%structures and initial conditions
length_plotindex = floor(p.t_max/p.plot_interval)+1;
Kopt = p.Kopt0;

%pre-allocation of vectors for plotting features
out.mean_u =    NaN(length_plotindex, p.no_pop);
out.max_u =     NaN(length_plotindex, p.no_pop);
out.min_u =     NaN(length_plotindex, p.no_pop);
out.std_u =     NaN(length_plotindex, p.no_pop);
out.no_ind_v =  NaN(length_plotindex, p.no_pop);
out.Kopt_v =    NaN(length_plotindex, 1);
out.plottime =  NaN(length_plotindex, 1);
out.conf95hi =  NaN(length_plotindex, p.no_pop);
out.conf95low = NaN(length_plotindex, p.no_pop);


%initilize the population
if p.no_pop==1
        %%%%%%% One species case
          
        no_ind(1)=round(p.K0);
        uustar=0;
        
        UUadults{1}=zeros(2*p.no_loci,no_ind(1))+uustar/p.no_loci/2; % genome matrix with upper half belonging to mother, lower half father function zygot
        viable_v{1}=1:no_ind(1);
        out.mean_u(1,1)=0;

        out.max_u=out.mean_u;
        out.min_u=out.mean_u;

        uu_old=sum(UUadults{1})';
        
        
        

elseif p.no_pop==2
        
        %%%%%%% Two species case
        no_ind(1)=round(p.K0/2);
        no_ind(2)=round(p.K0/2);

        uustar=1/2*(-3*p.sigma_a^2+p.sigma_a*(3*p.sigma_a^2+8)^(1/2))^(1/2);

        UUadults{1}=zeros(2*p.no_loci,no_ind(1))+uustar/p.no_loci/2; % genome matrix with upper half belonging to mother, lower half father function zygot
        viable_v{1}=1:no_ind(1);
        
        UUadults{2}=zeros(2*p.no_loci,no_ind(2))-uustar/p.no_loci/2; % genome matrix with upper half belonging to mother, lower half father function zygot
        viable_v{2}=1:no_ind(2);

        UUadults{1}=UUadults{1};%+0.1*randn(size(UUadults{1}));
        UUadults{2}=UUadults{2};%+0.1*randn(size(UUadults{2}));
        
        out.mean_u(1,1)=uustar;
        out.mean_u(1,2)=-uustar;
        out.max_u=out.mean_u;
        out.min_u=out.mean_u;
        
        uu_old=[sum(UUadults{1})';sum(UUadults{2})'];
        
end        




%main loop
tic %
for t=1:p.t_max
    % if toc>tnext, t, tnext=tnext+10;end



    %update the position of the resource optimum Kopt
    if t>p.opt_start
        if p.autocorr_flag==0
          Kopt=p.h*(t-p.opt_start);
        else
          Kopt=p.autcorr*Kopt+p.std_autreg*randn; 
        end
    end

    %for each population take a generation step
    for k=1:p.no_pop
        
        if no_ind(k)>0
           
            %create offspring
            UUoffspring = zeros(2*p.no_loci,no_ind(k)*p.fecundity);
            UUoffspring = offspring_fcn(UUadults{k},no_ind(k),p);

            %mutate offspring
            UUoffspring=mutateoffspring_fcn(UUoffspring,no_ind(k),p);

            %calculate trait values of offspring
            uu_offsp = sum(UUoffspring)';

            %calculate fitness
            fitnessv = fitnessv_fcn(uu_offsp,uu_old,Kopt,p);
           
            %select by picking viable offspring to form new adult generation
            viable_v = fitnessv/p.fecundity-rand(no_ind(k)*p.fecundity,1)>0;

            %calculate new population size
            no_ind(k) = sum(viable_v);

            %pick new adult generation
            UUadults{k} = UUoffspring(:,viable_v);

            %pick their trait values and put them in a vector 
            %for all adults in the communtity
            uu_adults(sum(no_ind(1:k-1))+1 : sum(no_ind(1:k))) = uu_offsp(viable_v);
        end
    end

    %update trait values to next generation and clear them
    uu_old = uu_adults;
    uu_adults = [];

    %in case that all dies break the main loop
    
    if sum(no_ind)==0, disp('all dead'), break, end

    %output and plotting
    if rem(t,p.plot_interval)==0
        
        %gather data for plotting
        ti = floor(t/p.plot_interval)+1;
        out.plottime(ti) = t;
        out.Kopt_v(ti) = Kopt;
        [fitnessv, KTable, fitnessTable, ubins] = fitnessv_fcn(uu_old, uu_old, Kopt,p);
        out.fitnessTable = fitnessTable;
        out.KTable = KTable;
        out.ubins = ubins;
       

        for k=1:p.no_pop
            if no_ind(k)>0
                uu = sum(UUadults{k})';
                
                

                out.mean_u(ti,k) =  mean(uu);
                out.max_u(ti,k) =   max(uu);
                out.min_u(ti,k) =   min(uu);
                out.std_u(ti,k) =   std(uu);

                out.no_ind_v(ti,k)= no_ind(k);

                %calculating 95% interval
                c95uu=sort(uu);
                upind=round(no_ind(k)*0.975);
                lowind=round(no_ind(k)*0.025);
                if upind==0, upind=1;end
                if lowind==0, lowind=1;end
                chi=c95uu(upind);
                clow=c95uu(lowind);
                %end calculating 95% interval

                out.conf95hi(ti,k) = chi;
                out.conf95low(ti,k) = clow;
                
                out.uu_species{k}=sum(UUadults{k})';
              
            end
        end
        
        %full genome of adults
        out.UUadults=UUadults;
       
        
       
        %plot it (external function)
        if p.plot_runtime_flag == 1
          plot_simulation(out,p);
        end 
    end


    drawnow


end
toc













