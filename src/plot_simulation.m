% plot_simulation.m
%
% Produces runtime of final plots showing population size, trait dynamics, 
% and snapshots of fitness, resource availability, and trait distributions.
% Visualizes results described in Johansson, J. 2008, Evolution 62: 421–435.


function plot_simulation(out,p)


plotcols='bg';

%figure showing population size and trait values over time
figure(p.fig_number)
set(gcf,'position',[200   750   800   300])

subplot(2,1,1)
cla

handles = []; 
labels = {};  


for k=1:p.no_pop
 
    handles(k)=plot(out.plottime,out.no_ind_v(:,k),plotcols(k)); 
    hold on
    labels{k}=sprintf('species %d', k);

end
legend(handles, labels,'location','northeastoutside');

ylabel('population size, N')

set(gca,'ylim',[0 p.K0*1.5])
set(gca,'xlim',[0 p.t_max])


subplot(2,1,2)
cla
handles = [];  
labels = {};   

step=1;

handles(1)=plot(out.plottime(1:step:end),out.Kopt_v(1:step:end),'r','linewidth',1);
labels{1}='resource optimum';


for k=1:p.no_pop

    hold on
    handles(k+1)=plot(out.plottime(1:step:end),out.mean_u(1:step:end,k),plotcols(k),'linewidth',2);
    
    labels{k+1}=sprintf('species %d', k);
    
    handles(p.no_pop+2)=plot(out.plottime(1:step:end),out.conf95hi(1:step:end,k),[plotcols(k),'-'],'markersize',1);
    plot(out.plottime(1:step:end),out.conf95low(1:step:end,k),[plotcols(k),'-'],'markersize',1)
    labels{p.no_pop + 2}='95% interval';
end

set(gca,'xlim',[0 p.t_max])
xlimits_snapshot = ylim;

legend(handles, labels,'location','northeastoutside');
xlabel('time')
ylabel('ecological trait, u')



%figure showing a snapshot of fitness, resource optimum and trait values
figure(p.fig_number + 100)
set(gcf,'position',[200   150   400   400])


subplot(3,1,1)
plot(out.ubins,out.fitnessTable,'k')
ylabel('fitness, W')


subplot(3,1,2)
plot(out.ubins,out.KTable,'r')
ylabel('carrying capacity, K')

set(gca,'xlim',[out.ubins(1),out.ubins(end)])


subplot(3,1,3)
cla
hold on
for k=1:p.no_pop
  hist(out.uu_species{k},15,plotcols(k))
end
box on

for k=1:3
  set(gca,'xlim',[out.ubins(1),out.ubins(end)])
end

ylabel('number of individuals, N')
xlabel('ecological trait, u')


drawnow