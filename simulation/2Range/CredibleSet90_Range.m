function CredibleSet90_Range(N, I_sim)
% Range of Posterior Means for Herfindhal (with quantiles)

%% Parameters
n11 ...
    = (0:1:N);     %Term 1 in document 1 (grid from 0 to N)

n22 ...
    = N/2;         %Term 2 in document 2 (fixed at N/2)

alpha ...
    = .05;
    
%% Draws from the posterior

post_mean_h ...    
   = size(N,1); 

quantile_alpha ...    
   = size(N,1); 


for n_1 = 1:N+1
       
    p1 = betarnd(n11(1,n_1)+1,N-n11(1,n_1)+1,[I_sim,1]);
                  %When p1,p2 are i.i.d unif (0,1), the posterior for p1
                  %is beta, independent of p2. 

    p2 = betarnd(N-n22+1,n22+1,[I_sim,1]);
    
    lambda ...
       = zeros(I_sim,1); 

        for i_sim = 1:I_sim
   
        lambda(i_sim,1)=lambda_example(p1(i_sim,1),p2(i_sim,1));
    
        end

    post_mean_h(n_1,1) = mean(lambda);
    
    quantile_alpha(n_1,1) ...
                       = quantile(lambda,alpha);
    
    clear lambda

end

%% Plot

aux = (n11 + 1)./(N+2);

figure(1)

g0 = plot(n11./N,quantile_alpha,'linestyle','--','marker','none','color','blue'); hold on

g1 = plot(n11./N,1,'linestyle','--','marker','^','color','red'); hold on

g2 = plot(n11./N,post_mean_h','linestyle','-','marker','v','color','blue'); hold off

xlim([0,1])

xticks(0:.1:1)

ylim([.48,1])

yticks(.5:.1:1)

xlabel('$n_{11}/N$','Interpreter','latex')

ylabel('$E[ \lambda(B,\Theta) \: | \: C]$','Interpreter','latex')

legend([g1(1) g2(1) g0(1)],'Largest Posterior Mean','Smallest Posterior Mean',...
       'Lower Bound of 90% Robust Credible Set','location','north','FontSize',16);

legend('boxoff')

%% Save
name_plot = strcat('CredibleSet90_Range_N',num2str(N));
print(gcf,'-depsc2',name_plot)
end