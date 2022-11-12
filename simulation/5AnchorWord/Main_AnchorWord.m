clear all
clc

%% Define true B and Theta, where B has anchor word
Btrue = eye(2); 
Thetatrue = [.2,.8;.8,.2]; 
Ptrue = Btrue * Thetatrue;
K = 2;
W = [1,2]; % two words

N = 1000;
doc1 = [repelem(1, floor(Ptrue(1,1)*N)), repelem(2, floor(Ptrue(1,2)*N))];
doc2 = [repelem(1, floor(Ptrue(2,1)*N)), repelem(2, floor(Ptrue(2,2)*N))]; 
X = {doc1, doc2}; 

% hyperparameters for lda
gibbs_alpha = 1;
gibbs_beta = 1;

gibbs_burn = 5000;
gibbs_thin = 10;
num_P = 100; % make 100 posterior draws B and Theta
gibbs_max_it = gibbs_burn + gibbs_thin*num_P;

[B_list, Theta_list] = lda_gibbs(X, K, ...
    W, gibbs_alpha, gibbs_beta, gibbs_max_it, gibbs_burn, gibbs_thin);

B11 = reshape(B_list(1, 1, :), length(B_list), 1);
figure(1)
g1 = histogram(B11,'Normalization','probability'); hold on
xlim([0 1.05])
g0 = xline(Btrue(1,1),':r','LineWidth',2); hold off
xlabel('\beta_{1,1}')
ylabel('Density')
legend([g1 g0], 'Posterior distribution', 'True value')
legend('boxoff')              
print(gcf,'-depsc2','AnchorWord_vs_posterior')
