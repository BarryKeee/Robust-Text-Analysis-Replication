%% Sensitivity of Posterior Mean: Example

%% N = 10
N   = 10; 

n11 = (0:1:N);
aux = (n11 + 1)./(N+2);
post_mean_h = 1 - (2*aux.*(1-aux).*(1-(1/(N+3))));

figure(1)
g1 = plot(n11./N,1,'linestyle','--','marker','x','color','red'); hold on
g2 = plot(n11./N,post_mean_h,'linestyle',':','marker','*','color','blue'); hold off
xlim([0,1])
xticks(0:.1:1)
ylim([.5,1])
yticks(.5:.1:1)
xlabel('$n_{11}/N$','Interpreter','latex')
ylabel('$E[ \lambda(B,\Theta) \: | \: C]$','Interpreter','latex')
legend([g1(1) g2(1)],'\pi_1','\pi_2','location','north','FontSize',16);
legend('boxoff')
name_plot = strcat('Sensivitiy_N',num2str(N));
print(gcf,'-depsc2',name_plot)

%% N = 100
N   = 100; 

n11 = (0:1:N);
aux = (n11 + 1)./(N+2);
post_mean_h = 1 - (2*aux.*(1-aux).*(1-(1/(N+3))));

figure(2)
g1 = plot(n11./N,1,'linestyle','--','marker','x','color','red'); hold on
g2 = plot(n11./N,post_mean_h,'linestyle',':','marker','*','color','blue'); hold off
xlim([0,1])
xticks(0:.1:1)
ylim([.5,1])
yticks(.5:.1:1)
xlabel('$n_{11}/N$','Interpreter','latex')
ylabel('$E[ \lambda(B,\Theta) \: | \: C]$','Interpreter','latex')
legend([g1(1) g2(1)],'\pi_1','\pi_2','location','north','FontSize',16);
legend('boxoff')
name_plot = strcat('Sensivitiy_N',num2str(N));
print(gcf,'-depsc2',name_plot)
