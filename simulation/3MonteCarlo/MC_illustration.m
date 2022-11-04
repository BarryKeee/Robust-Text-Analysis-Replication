function MC_illustration(N, Btrue, Thetatrue, MC_draws, Posterior_draws)
% Monte Carlo Simulation (Robust Bayes LDA) 

%% True parameters
Ptrue ...
  = Btrue*Thetatrue;  

p1_true ...
  = Ptrue(1,1);

p2_true ...
  = Ptrue(1,2);

H_true ...
  = sum(Thetatrue(:,1).^2); 

%% Identified set for the Herfindahl Index

upper_bound_true = 1;

lower_bound_true = lambda_example(p1_true,p2_true);

%% Monte Carlo Draws 

rng('default');

n1 = binornd(N,p1_true,[MC_draws,1]);

n2 = N - binornd(N,p2_true,[MC_draws,1]);

frequentist_estimator ...
   = zeros(MC_draws,1);

robust_bayesian_estimator ...
   = zeros(MC_draws,1); 

for i_MC = 1: MC_draws
   
    frequentist_estimator(i_MC,1) = lambda_example(n1(i_MC,1)/N, 1-(n2(i_MC,1)/N));
    
    %Robust Bayesian Estimator
    
    p1post = betarnd(n1(i_MC,1)+1,N-n1(i_MC,1)+1,[Posterior_draws,1]);
                  
    p2post = betarnd(N-n2(i_MC,1)+1,n2(i_MC,1)+1,[Posterior_draws,1]);
    
    lambda_post ...
       = zeros(Posterior_draws,1); 

        for i_post = 1:Posterior_draws
   
        lambda_post(i_post,1)=lambda_example(p1post(i_post,1),p2post(i_post,1));
    
        end

    robust_bayesian_estimator(i_MC,1) = mean(lambda_post);
    
    clear lambda_post
    
end

%% SaveVariables 

mat_file_name = strcat('MC_N',num2str(N));
save(mat_file_name,'frequentist_estimator','robust_bayesian_estimator','N','lower_bound_true');
end
