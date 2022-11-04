%% Load Prior Draws

draws ...
      = load('B_Theta_prior_draws_sec1.mat');

%% Load meeting dates

opts = detectImportOptions('covariates.xlsx');

opts.Sheet = 'Sheet 1';
  
opts.VariableTypes{1} ...
     = 'datetime';
  
dates_FOMC ...
     = readtable('covariates.xlsx',opts);
 
dummy_transp ...
     = dates_FOMC.Transparency;
 
%% Prior Mean Difference in H_index (pre-post)

H_diff ... 
    = zeros(size(draws.prior_draws_B_Theta,1),1);

H_diff_percent ... 
    = zeros(size(draws.prior_draws_B_Theta,1),1);

H_index ...
    = zeros(size(draws.prior_draws_B_Theta,1),148); 

for i_draw = 1:size(draws.prior_draws_B_Theta,1)

Theta_draw ...
    = draws.prior_draws_B_Theta{i_draw,2};

H_index(i_draw,:) ...
    = sum((Theta_draw.^2),1);

H_index_pre ...
    = mean(H_index(i_draw,dummy_transp==0));

H_index_post ...
    = mean(H_index(i_draw,dummy_transp==1));

clear Theta_draw 

H_diff(i_draw,1) = H_index_post - H_index_pre;

H_diff_percent(i_draw,1) ...
                 = 100*(H_index_post - H_index_pre)./H_index_pre;


clear H_index_pre H_index_post 

end

%% Prior based on min/max NMF

lambda_lower = zeros(size(draws.prior_draws_B_Theta,1),1); 

lambda_upper = zeros(size(draws.prior_draws_B_Theta,1),1);

lambda_lower_pre ...
             = zeros(size(draws.prior_draws_B_Theta,1),1);
         
lambda_upper_pre ...        
             = zeros(size(draws.prior_draws_B_Theta,1),1);
         
lambda_lower_post ...
             = zeros(size(draws.prior_draws_B_Theta,1),1);
         
lambda_upper_post ...        
             = zeros(size(draws.prior_draws_B_Theta,1),1);         

lambda_lower_percent ...
             = zeros(size(draws.prior_draws_B_Theta,1),1); 

lambda_upper_percent ...
             = zeros(size(draws.prior_draws_B_Theta,1),1);
         
lambda_lower_by_meeting ...
             = zeros(size(draws.prior_draws_B_Theta,1),148);
         
lambda_upper_by_meeting ...
             = zeros(size(draws.prior_draws_B_Theta,1),148); 
         
for i_draw = 1:size(draws.prior_draws_B_Theta,1)

name_file ...
         = strcat('NMFs_FOMC1_prior/Theta/NMF_sec1_Theta_draw',num2str(i_draw),'.mat');  
     
ThetaNMF = load(name_file);

ThetaNMF = ThetaNMF.Theta_list;

sizeNMF  = min(120,size(ThetaNMF,1));

H_index_robust_bymeeting ...
         = zeros(sizeNMF,148);
     
H_index_robust_pre...     
         = zeros(sizeNMF,1);
         
H_index_robust_post...     
         = zeros(sizeNMF,1);         
         
H_index_robust ...
         = zeros(sizeNMF,1); 
     
H_index_robust_percent ...
         = zeros(sizeNMF,1);     

    for j_NMF = 1:sizeNMF
    
    Theta_draw ...
    = reshape(ThetaNMF(j_NMF,:,:),[40,148]);

    H_index_NMF ...
    = sum((Theta_draw.^2),1);

    H_index_pre ...
    = mean(H_index_NMF(1,dummy_transp==0),2);

    H_index_post ...
    = mean(H_index_NMF(1,dummy_transp==1),2);

    clear Theta_draw 

    H_index_robust_bymeeting(j_NMF,:) ...
                            = H_index_NMF; 
                        
    H_index_robust_pre(j_NMF,1) ...
                            = H_index_pre;
                        
    H_index_robust_post(j_NMF,1) ...
                            = H_index_post;
    
    H_index_robust(j_NMF,1) = H_index_post - H_index_pre;
    
    H_index_robust_percent(j_NMF,1) = 100*(H_index_post - H_index_pre)./H_index_pre;

    clear H_index_pre H_index_post H_index_NMF

    end
    
lambda_lower_by_meeting(i_draw,:) ...
                       = min(H_index_robust_bymeeting,[],1);
                   
lambda_upper_by_meeting(i_draw,:) ...
                       = max(H_index_robust_bymeeting,[],1);  
                   
lambda_lower_pre(i_draw,1)...
                       = min(H_index_robust_pre);
                   
lambda_upper_pre(i_draw,1)...
                       = max(H_index_robust_pre);   
                   
lambda_lower_post(i_draw,1)...
                       = min(H_index_robust_post);
                   
lambda_upper_post(i_draw,1)...
                       = max(H_index_robust_post);                      
    
lambda_lower(i_draw,1) = min(H_index_robust);

lambda_upper(i_draw,1) = max(H_index_robust);

lambda_lower_percent(i_draw,1) = min(H_index_robust_percent);

lambda_upper_percent(i_draw,1) = max(H_index_robust_percent);

clear H_index_robust;

end

%% Prior Distribution for Difference in Herfindahl (Baseline Prior)


[Density_H_diff_percent,x_1] = ksdensity(H_diff_percent); 

[Density_lambda_lower_percent,x_2] ...
                             = ksdensity(lambda_lower_percent); 
                         
                         
[Density_lambda_upper_percent,x_3] ...
                             = ksdensity(lambda_upper_percent); 
                         
                  
figure(1)

g1 = plot(x_1,Density_H_diff_percent,'b','LineWidth',1); hold on

%xline(mean(H_diff_percent),'--b'); hold on

g2 = plot(x_2,Density_lambda_lower_percent,'r','LineWidth',.25); hold on

%xline(mean(lambda_lower_percent),':r','LineWidth',1.5); hold on

plot(x_3,Density_lambda_upper_percent,'r','LineWidth',.25); hold on

%xline(mean(lambda_upper_percent),':r','LineWidth',1.5); hold on

g3 = plot(quantile(H_diff_percent,.025),0,'p',...
              'Color', 'red', 'MarkerFaceColor','red',...
              'LineStyle','none',...
              'MarkerSize',15); hold on
          
plot(quantile(H_diff_percent,.975),0,'p',...
              'Color', 'red', 'MarkerFaceColor','red', ...
              'MarkerSize',15); hold off       

legend([g1,g2,g3],'Prior density $\lambda(B,\Theta)$ (Baseline Prior)',...
                  'Alternative prior density for $\lambda(B,\Theta)$',...
                '$95\%$ Credible Set',...
                'Interpreter','latex',...
                'Location','northwest','FontSize',14)
            
legend('boxoff')  

ylim([0,.45])

xlim([-5,5])

xlabel('%')

ylabel('Prior Density')

print(gcf,'-depsc2','Figures/Prior_Difference_Percent.eps')