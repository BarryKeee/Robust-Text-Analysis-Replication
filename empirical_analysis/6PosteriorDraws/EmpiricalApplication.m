%% 1) Load structure containing posterior draws of B and Theta (200 x 2 cell)
% 200 posterior draws

draws ...
      = load('B_Theta_post_draws_sec1.mat');

%% 2) Load meeting dates

opts = detectImportOptions('covariates.xlsx');

opts.Sheet = 'Sheet 1';
  
opts.VariableTypes{1} ...
     = 'datetime';
  
dates_FOMC ...
     = readtable('covariates.xlsx',opts);
 
dummy_transp ...
     = dates_FOMC.Transparency;
 
dates_plots ...
     = [ datetime(dates_FOMC.Dates(1:99,1)++calyears(1900),'Format','MM-yyyy'); 
        datetime(dates_FOMC.Dates(100:end,1)+calyears(2000),'Format','MM-yyyy')];

%% 3) Posterior Mean Difference in H_index (pre-post)

H_diff ... 
    = zeros(size(draws.post_draws_B_Theta,1),1);

H_diff_percent ... 
    = zeros(size(draws.post_draws_B_Theta,1),1);

H_index ...
    = zeros(size(draws.post_draws_B_Theta,1),148); 

for i_draw = 1:size(draws.post_draws_B_Theta,1)

Theta_draw ...
    = draws.post_draws_B_Theta{i_draw,2};

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

%% 4) Robust Bayes

lambda_lower = zeros(size(draws.post_draws_B_Theta,1),1); 

lambda_upper = zeros(size(draws.post_draws_B_Theta,1),1);

lambda_lower_pre ...
             = zeros(size(draws.post_draws_B_Theta,1),1);
         
lambda_upper_pre ...        
             = zeros(size(draws.post_draws_B_Theta,1),1);
         
lambda_lower_post ...
             = zeros(size(draws.post_draws_B_Theta,1),1);
         
lambda_upper_post ...        
             = zeros(size(draws.post_draws_B_Theta,1),1);         

lambda_lower_percent ...
             = zeros(size(draws.post_draws_B_Theta,1),1); 

lambda_upper_percent ...
             = zeros(size(draws.post_draws_B_Theta,1),1);
         
lambda_lower_by_meeting ...
             = zeros(size(draws.post_draws_B_Theta,1),148);
         
lambda_upper_by_meeting ...
             = zeros(size(draws.post_draws_B_Theta,1),148); 
         
for i_draw = 1:size(draws.post_draws_B_Theta,1)

name_file ...
         = strcat('NMFs_FOMC1/Theta/NMF_sec1_Theta_draw',num2str(i_draw),'.mat');  
     
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

%aux                            = maxk(H_index_robust_percent, 1);

clear H_index_robust;

end

%% 5) Posterior Distribution for Difference in Herfindahl (Baseline Prior)


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

legend([g1,g2,g3],'Posterior density $\lambda(B,\Theta)$ (Baseline Prior)',...
                  'Posterior Density of $\underline{\lambda}^*(P),\overline{\lambda}^*(P)$',...
                '$95\%$ Robust Credible Set',...
                'Interpreter','latex',...
                'Location','northwest','FontSize',14)
            
legend('boxoff')            

xlim([15,40])

xlabel('%')

ylabel('Posterior Density')

print(gcf,'-depsc2','Figures/Posterior_Difference_Percent.eps')

%% 6) Plot Meeting-by-Meeting Posterior mean

post_mean_H_by_meeting ...
    = mean(H_index,1);

quantile_lower_pre ...
    = quantile(lambda_lower_pre,.025);

quantile_upper_pre ...
    = quantile(lambda_upper_pre,.975);

quantile_lower_post ...
    = quantile(lambda_lower_post,.025);

quantile_upper_post ...
    = quantile(lambda_upper_post,.975);

figure(3)

g1 = plot(dates_plots, post_mean_H_by_meeting,'b','LineWidth',1.5); hold on

xline(dates_plots(50),'-','LineWidth',2); hold on

g2 = stairs(dates_plots, [repmat(mean(post_mean_H_by_meeting(1,1:49)),[1,49]), ...
       repmat(mean(post_mean_H_by_meeting(1,50:end)),[1,148-49])],':b','LineWidth',2); hold on
   
g3 = stairs(dates_plots, [repmat(quantile_lower_pre,[1,49]), ...
       repmat(quantile_lower_post,[1,148-49])],'--r','LineWidth',2); hold on
   
stairs(dates_plots, [repmat(quantile_upper_pre,[1,49]), ...
       repmat(quantile_upper_post,[1,148-49])],'--r','LineWidth',2); hold off   

legend([g1,g2,g3],'Posterior Mean of HI (meeting by meeting)',...
               'Posterior Mean of Average Pre/Post HI',...
               'Robust 95% Credible Set',...
               'FontSize',14)   
           
legend('boxoff')            
   
ylim([.025,.14]);

print(gcf,'-depsc2','Figures/Posterior_meeting.eps')

%plot(dates_plots, quantile_lower,':r','LineWidth',1.5); hold on

%plot(dates_plots, quantile_upper,':r','LineWidth',1.5); hold off