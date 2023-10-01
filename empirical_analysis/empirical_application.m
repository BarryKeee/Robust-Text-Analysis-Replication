function empirical_application(FOMC_sec, func, save_fig_name, ...
    prior_post_draw_name, NMF_draw_folder_name, x_lims, y_lims, x_label, density_type)

%% 1) Load structure containing posterior draws of B and Theta (200 x 2 cell)
% 200 posterior draws

draws = load(prior_post_draw_name);
draws_B_Theta = draws.post_draws_B_Theta;

%if density_type == "Posterior"
%    draws_B_Theta = draws.post_draws_B_Theta;
%else
%    draws_B_Theta = draws.prior_draws_B_Theta;
%end
%% 2) Load meeting dates

opts = detectImportOptions('covariates.xlsx');

opts.Sheet = 'Sheet 1';
  
opts.VariableTypes{1} ...
     = 'datetime';
  
dates_FOMC ...
     = readtable('covariates.xlsx',opts);
 
dummy_transp ...
     = dates_FOMC.Transparency;

if FOMC_sec == 1
    regressors = table2array(removevars(dates_FOMC, {'Dates', 'Num_Stems_FOMC1'}));
else
    regressors = table2array(removevars(dates_FOMC, {'Dates', 'Num_Stems_FOMC2'}));
end

%% 3) Posterior Mean Difference in H_index (pre-post)

H_diff_percent = zeros(size(draws_B_Theta,1),1);

for i_draw = 1:size(draws_B_Theta,1)

Theta_draw = draws_B_Theta{i_draw,2};
HHI_draw = sum((Theta_draw.^2),1);

clear Theta_draw 

H_diff_percent(i_draw,1) = func(HHI_draw,dummy_transp, regressors);


clear H_index_pre H_index_post 

end

%% 4) Robust Bayes
      

lambda_lower_percent ...
             = zeros(size(draws_B_Theta,1),1); 

lambda_upper_percent ...
             = zeros(size(draws_B_Theta,1),1);
         
for i_draw = 1:size(draws_B_Theta,1)
if FOMC_sec == 1
    name_file = strcat(NMF_draw_folder_name + '/NMF_sec1_Theta_draw',num2str(i_draw),'.mat');  
else
    name_file = strcat(NMF_draw_folder_name + '/NMF_sec2_Theta_draw',num2str(i_draw),'.mat');  
end
     
ThetaNMF = load(name_file);

ThetaNMF = ThetaNMF.Theta_list;

sizeNMF  = min(120,size(ThetaNMF,1));     
     
H_index_robust_percent ...
         = zeros(sizeNMF,1);     

    for j_NMF = 1:sizeNMF
    
    Theta_draw ...
    = reshape(ThetaNMF(j_NMF,:,:),[40,148]);

    H_index_NMF ...
    = sum((Theta_draw.^2),1);

    clear Theta_draw 
        
    H_index_robust_percent(j_NMF,1) = func(H_index_NMF, dummy_transp, regressors);

    clear H_index_pre H_index_post H_index_NMF

    end                    

lambda_lower_percent(i_draw,1) = min(H_index_robust_percent);

lambda_upper_percent(i_draw,1) = max(H_index_robust_percent);

clear H_index_robust;

end

%% 5) Posterior distribution for the funcional


[Density_H_diff_percent,x_1] = ksdensity(H_diff_percent); 

[Density_lambda_lower_percent,x_2] ...
                             = ksdensity(lambda_lower_percent); 
                         
                         
[Density_lambda_upper_percent,x_3] ...
                             = ksdensity(lambda_upper_percent); 
                         
                  
figure(1)

g1 = plot(x_1,Density_H_diff_percent,'b','LineWidth',1); hold on

xline(mean(H_diff_percent),'--b'); hold on

g2 = plot(x_2,Density_lambda_lower_percent,'r','LineWidth',1); hold on

xline(mean(lambda_lower_percent),':r','LineWidth',.5); hold on

plot(x_3,Density_lambda_upper_percent,'r','LineWidth',1); hold on

xline(mean(lambda_upper_percent),':r','LineWidth',.5); hold on

g3 = plot(quantile(lambda_lower_percent,.025),0,'p',...
              'Color','red',  'MarkerFaceColor', 'red', ...
              'MarkerSize',15); hold on
          
plot(quantile(lambda_upper_percent,.975),0,'p',...
              'Color','red', 'MarkerFaceColor', 'red', ...
              'MarkerSize',15); hold off        

if density_type == "Posterior"
    legend([g1,g2,g3], density_type + ' density $\lambda(B,\Theta)$',...
                      density_type + ' density of $\underline{\lambda}^*(P),\overline{\lambda}^*(P)$',...
                    '$95\%$ robust credible Set',...
                    'Interpreter','latex',...
                    'Location','northwest','FontSize',14)
else
    legend([g1,g2,g3],'Prior density $\lambda(B,\Theta)$',...
                  'Alternative prior density for $\lambda(B,\Theta)$',...
                '$95\%$ credible set',...
                'Interpreter','latex',...
                'Location','northwest','FontSize',14)
end
legend('boxoff')            

xlim(x_lims)
ylim(y_lims)

xlabel(x_label)

ylabel(density_type + ' Density')

%% Save
print(gcf,'-depsc2','Figures/' + save_fig_name + '.eps')
end