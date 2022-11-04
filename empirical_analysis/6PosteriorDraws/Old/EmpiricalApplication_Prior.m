%% Load meeting dates

opts = detectImportOptions('covariates.xlsx');

opts.Sheet = 'Sheet 1';
  
opts.VariableTypes{1} ...
     = 'datetime';
  
dates_FOMC ...
     = readtable('covariates.xlsx',opts);
 
dummy_transp ...
     = dates_FOMC.Transparency;

%% Prior on Hindex

Prior_hyperparam ...
   = 1.25; 

Y = exprnd(Prior_hyperparam,[40,148,1000]); 

%% Hindex per meeting

Hindex_per_meeting = reshape(sum(Y.^2,1)./(sum(Y,1).^2),[148,1000]);

%% Pre-Post 

Hindex_pre         = mean(Hindex_per_meeting((dummy_transp==0)',:),1);

Hindex_post        = mean(Hindex_per_meeting((dummy_transp==1)',:),1);

H_index_percent    = 100*(Hindex_post-Hindex_pre)./ Hindex_pre;

clear Hindex_pre Hindex_post

%% 

[Density_H_diff_percent_prior,x_prior_1] = ksdensity(H_index_percent);

figure

g1 = plot(x_prior_1,Density_H_diff_percent_prior,'b','LineWidth',2); hold on

xline(mean(H_index_percent),'--b'); hold on

g2 = plot(quantile(H_index_percent,.025),0,'p',...
              'MarkerFaceColor','blue',...
              'LineStyle','none',...
              'MarkerSize',15); hold on

plot(quantile(H_index_percent,.975),0,'p',...
              'MarkerFaceColor','blue',...
              'MarkerSize',15); hold off
          
legend([g1,g2],'Baseline Prior on $\lambda(B,\Theta)$',...
                '$95\%$ Prior Credible Interval',...
                'Interpreter','latex',...
                'Location','northwest','FontSize',14)
            
legend('boxoff')            
                   
ylim([0,.45])

xlabel('%')

ylabel('Prior Density')

print(gcf,'-depsc2','Figures/Prior_Difference_Percent.eps')