function Approximate_Range(N, I_sim)
%% Range of Posterior Means for Herfindhal 

n11 ...
    = (0:1:N);

n22 ...
    = N/2;
    %= (0:1:N);
    
%% Draws from the posterior


post_mean_h ...
   = size(N,N);

approx_post_mean_h ...
   = size(N,N); 

for n_1 = 1:N+1

    for n_2 = 1:size(n22,2)
    
    p1 = betarnd(n11(1,n_1)+1,N-n11(1,n_1)+1,[I_sim,1]);

    p2 = betarnd(N-n22(1,n_2)+1,n22(1,n_2)+1,[I_sim,1]);
    
    lambda ...
       = zeros(I_sim,1); 
   
    lambda_approx_min ...
       = zeros(I_sim,1); 
   
   lambda_approx_max ...
       = zeros(I_sim,1);

        for i_sim = 1:I_sim
   
        lambda(i_sim,1) ...
                  = lambda_example(p1(i_sim,1),p2(i_sim,1));
              
        aux_p     = [ p1(i_sim,1), p2(i_sim,1); 1-p1(i_sim,1), 1- p2(i_sim,1) ];      
        
        [lambda_approx_min(i_sim,1),lambda_approx_max(i_sim,1)] ...
                  = Approx_lambda_example_James(aux_p,120);
            
        end

    post_mean_h(n_1,n_2) = mean(lambda);
    
    approx_post_mean_h_min(n_1,n_2) = mean(lambda_approx_min);
    approx_post_mean_h_max(n_1,n_2) = mean(lambda_approx_max);

    clear lambda

    end

end

%% Plot

min_post_mean_h = min(post_mean_h,[],2)';

approx_min_post_mean_h = min(approx_post_mean_h_min,[],2)';

approx_max_post_mean_h = max(approx_post_mean_h_max,[],2)';

figure(1)

g1 = plot(n11./N,1,'linestyle','--','marker','^','color','red'); hold on

g2 = plot(n11./N,min_post_mean_h,'linestyle','-','marker','v','color','blue'); hold on

g3 = plot(n11./N,approx_min_post_mean_h,'linestyle',':','marker','*','color','blue'); hold on

g4 = plot(n11./N,approx_max_post_mean_h,'linestyle',':','marker','*','color','red'); hold off

hold off

xlim([0,1])

xticks(0:.1:1)

ylim([.5,1])

yticks(.5:.1:1)

xlabel('$n_{11}/N$','Interpreter','latex')

ylabel('$E[ \lambda(B,\Theta) \: | \: C]$','Interpreter','latex')

legend([g1(1) g2(1) g3(1) g4(1)],'Largest Posterior Mean','Smallest Posterior Mean','Approximation Lower Bound', ...
    'Approximation Upper Bound','location','north','FontSize',16);

legend('boxoff')

%% Save

name_plot = strcat('Approximation_Range_N',num2str(N));

print(gcf,'-depsc2',name_plot)
end