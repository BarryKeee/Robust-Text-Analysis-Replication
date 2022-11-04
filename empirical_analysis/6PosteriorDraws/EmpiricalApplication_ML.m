%% Load Prior Draws

draws ...
      = load('B_Theta_draws_of_phat_sec1');
  
%% Number of words per meeting

opts = detectImportOptions('../0Data/FOMC1_meeting_matrix_onlyTF.xlsx');

opts.Sheet = 'Sheet1';

opts.DataRange ...
           = 'B2';

FOMC1 ...
     = readtable('../0Data/FOMC1_meeting_matrix_onlyTF.xlsx',opts);
 
FOMC1array ...
     = table2array(FOMC1);
 
FOMC1array ...
     = FOMC1array(:,1:end-1);

N    = sum(FOMC1array); 

Phat ...
     = FOMC1array./N;
 
%% Load meeting dates

opts = detectImportOptions('covariates.xlsx');

opts.Sheet = 'Sheet 1';
  
opts.VariableTypes{1} ...
     = 'datetime';
  
dates_FOMC ...
     = readtable('covariates.xlsx',opts);
 
dummy_transp ...
     = dates_FOMC.Transparency;
 
%% Maximize the likelihood 

loglikelihood ...
     = zeros(size(draws.ML_draws_B_Theta,1),1);

for i_draw ...
     = 1:size(draws.ML_draws_B_Theta,1)

Theta_draw ...
     = draws.ML_draws_B_Theta{i_draw,2};

Beta_draw ...
     = draws.ML_draws_B_Theta{i_draw,1}; 

loglikelihood(i_draw,1)...
     = sum(sum(FOMC1array.*log(Beta_draw*Theta_draw)));

end

[~,index_max] ...
     = max(loglikelihood);

%% lower lambda ML
         
i_draw = index_max;

name_file ...
         = strcat('NMFs_ML/Theta/NMF_sec1_Theta_draw',num2str(i_draw),'.mat');  
     
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
    
lambda_lower_by_meeting ...
                       = min(H_index_robust_bymeeting,[],1);
                   
lambda_upper_by_meeting ...
                       = max(H_index_robust_bymeeting,[],1);  
                   
lambda_lower_pre...
                       = min(H_index_robust_pre);
                   
lambda_upper_pre...
                       = max(H_index_robust_pre);   
                   
lambda_lower_post...
                       = min(H_index_robust_post);
                   
lambda_upper_post...
                       = max(H_index_robust_post);                      
    
lambda_lower           = min(H_index_robust);

lambda_upper           = max(H_index_robust);

lambda_lower_percent   = min(H_index_robust_percent);

lambda_upper_percent   = max(H_index_robust_percent);

clear H_index_robust;