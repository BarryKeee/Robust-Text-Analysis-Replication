function PlotsMC(N10, N1000)
%% Plot 1: Overlay Frequentist Estimators for N and Nsmall <N

figure(1)

g0 = xline(N1000.lower_bound_true,':r','LineWidth',2); hold on

g1 = histogram(N10.frequentist_estimator,'Normalization','probability'); hold on

g2 = histogram(N1000.frequentist_estimator,'Normalization','probability'); hold off

xlim([.5 1])

ylim([0 .5])

xlabel('$\underline{\lambda}^*(\widehat{p}_1,\widehat{p}_2)$','Interpreter','latex')

legend([g1,g2,g0],'N=10','N=1000',...
                  '$\underline{\lambda}^*(p^0_1,p^0_2)$','location','northeast','FontSize',16,'Interpreter','latex');

legend('boxoff')

print(gcf,'-depsc2','Freq_MC')

%% Plot 2

figure(2) 

g0 = xline(N1000.lower_bound_true,':r','LineWidth',2); hold on

g1 = histogram(N10.robust_bayesian_estimator,'Normalization','probability'); hold on

g2 = histogram(N1000.robust_bayesian_estimator,'Normalization','probability'); hold off

xlim([.5 1])

ylim([0 .5])

xlabel('$E \left[ \: {\lambda}^*(p_1,p_2) \: | \: C \right]$','Interpreter','latex')

legend([g1,g2,g0],'N=10','N=1000',...
                  '$\underline{\lambda}^*(p^0_1,p^0_2)$','location','northeast','FontSize',16,'Interpreter','latex');

legend('boxoff')

print(gcf,'-depsc2','Robust_MC')

%% Plot 3 

figure(3)

diff_fb_10 = N10.frequentist_estimator-N10.robust_bayesian_estimator; 

diff_fb_1000 = N1000.frequentist_estimator-N1000.robust_bayesian_estimator; 

g0 = xline(0,':r','LineWidth',2); hold on

g1 = histogram(diff_fb_10,'Normalization','probability'); hold on

g2 = histogram(diff_fb_1000,'Normalization','probability'); hold off

xlim([-.2 .2])

xlabel('$\underline{\lambda}^*(\widehat{p}_1,\widehat{p}_2) - E \left[ \: {\lambda}^*(p_1,p_2) \: | \: C \right]$',...
       'Interpreter','latex')

legend([g1,g2,g0],'N=10','N=1000',...
                  '0','location','northeast','FontSize',16,'Interpreter','latex');   
              
legend('boxoff')              
   
print(gcf,'-depsc2','diff_MC')
end