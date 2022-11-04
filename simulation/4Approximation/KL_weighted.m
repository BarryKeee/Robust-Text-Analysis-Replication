function KL = KL_weighted(W, P, P_hat)
    KL = sum(((P.*log(P ./ P_hat) - P + P_hat).*W), 'all');
end

