function [min_HHI,max_HHI] = Approx_lambda_example_James(P_draw,num_NMF)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

HHI ...
    = zeros(num_NMF, 1);

p1  = P_draw(1,1);

p2  = P_draw(1,2);

for num_NMF_draw=1:num_NMF

    b1 = unifrnd(0,min(p1,p2));
    
    b2 = unifrnd(max(p1,p2),1);
            
    B ...
       = [b1,b2;1-b1,1-b2];
   
    Theta ...
       = (B^(-1))*P_draw; 
                
    HHI(num_NMF_draw) ...
    = sum(Theta(:,1).^2, 1);

end
   
min_HHI = min(HHI,[],1);

max_HHI = max(HHI,[],1);

end

