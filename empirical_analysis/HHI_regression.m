function estimate = HHI_regression(H_index_NMF,dummy_transp, regressors)

LM = fitlm(regressors, H_index_NMF');
estimate = LM.Coefficients{'x1', 'Estimate'};
end

