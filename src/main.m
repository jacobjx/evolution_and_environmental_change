% main.m
% Sets parameters and runs an example simulation of a single species adapting 
% to a gradually moving resource maximum. Calls the core simulation function 
% simulate_moving_optimum.m.
%
% Based on J


%parameters values (default)

%ecological components
p.K0 = 1000; %height of resource distribution
p.r = 1;  %intrinsic growth rate
p.no_pop=1; %number of populations (choose between 1 or 2 for this script)
p.sigma_K = 1; %relative width of resource distribution
p.sigma_a = 1.1; %relative width of competition kernel (niche width)


%genetic components
p.mu = 0.02; % probability that a single offspring mutates
p.sigma_mu=0.005; %relative mutation size (set higher than in paper for speed)
p.fecundity=4; %maximal number of offspring per adult
p.no_loci=10; %number of loci


%parameters for the optimum
p.Kopt0=0; %optimal resource availability

%parameters used if the optimum follows an autoregressive model
p.autcorr=0.999; %autocorrelation (mu)
p.std_autreg=0.3*sqrt(1-p.autcorr^2); %deviation (epsilon)

%parameters used if the optimum increases gradually
p.h=0.0015;  %speed of moving optima per generation

%flag to control whether the optimum moves randomly (=1) or linearly(=0)
p.autocorr_flag = 0;


%scenario control
p.t_max = 600; %maximum number of generations
p.bins = 100;   %number of bins for interpolation of fitness
p.opt_start=200; %first timestep for moving optima ("burn-in" period)


%plot control
p.plot_interval = 20; %how many timesteps between plotting
p.fig_number = 1; %number of the figure showing the dynamics over time
p.plot_runtime_flag = 1; %flag for plotting (= 1) or not (= 0) during runtime



%example 1

%example of a single simulation
%using the default parameters 
%with a single species responding to a gradually moving optimum


%start the simulation
simulate_moving_optimum(p);

%example 2

%example of a single simulation
%with a single species being affected by 
%an optimum that moves randomly (following an autoregressive process)
 
%changed parameters (the others should remain as default)

%{

p.t_max = 1200;
p.autocorr_flag=1;
p.fig_number=2;
simulate_moving_optimum(p);

%}

%example 3

%example comparing how a single species and a coalition of 2 species
%responds to a gradually moving optimum

%changed parameters (the others should remain as default)

%{

p.t_max = 1000;
p.no_pop = 2;
p.autocorr_flag=0;
sigma_a = 0.25;
p.fig_number = 3;
simulate_moving_optimum(p);

%}
      


