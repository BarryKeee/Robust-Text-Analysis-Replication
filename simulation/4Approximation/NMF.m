function [B,Theta] = NMF(P, eps, max_it, B_init, Theta_init)
    W = P;
    
    B = B_init ./ sum(B_init, 1); 
    Theta = Theta_init ./ sum(Theta_init, 1);
    KL_div_prev = inf;
    for i=1:max_it
        Theta = (Theta ./ (B'*W)) .* (B'*(W.*P ./ (B*Theta)));
        B = (B ./ (W*Theta')) .* (((W.*P) ./ (B*Theta)) * Theta');
        KL_div = KL_weighted(W, P, B*Theta);
        if mod(i, 100) == 0
            %X = sprintf('Iteration %d. KL divergence %f.\n', i, KL_div);
            %disp(X)
        end
        
        if abs(KL_div_prev - KL_div) < eps
            %X = sprintf('Convergence after %d iterations\n', i);
            %disp(X)
            break
        end
        KL_div_prev = KL_div;
    end
    
    B = B ./ sum(B, 1);
    Theta = Theta ./ sum(Theta, 1);

end

