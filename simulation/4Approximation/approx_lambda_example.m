function [min_HHI,max_HHI] = approx_lambda_example(P_draw,num_NMF)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

NMF_max_it ...
    = 10000;

NMF_eps ...
    = 1e-12;

HHI ...
    = zeros(num_NMF, 1);

for num_NMF_draw=1:num_NMF

    B_init     ...
    = rand(size(P_draw)); 
            
    Theta_init ...
    = rand(size(P_draw));
         
    [~, Theta] ...
    = NMF(P_draw, NMF_eps, NMF_max_it, B_init, Theta_init);
           
    HHI(num_NMF_draw) ...
    = sum(Theta(:,1).^2, 1);

end
   
min_HHI = min(HHI,[],1);

max_HHI = max(HHI,[],1);

end

