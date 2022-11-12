function functional = HHI_percent_diff(H_index_NMF,dummy_transp, regressors)
    H_index_pre = mean(H_index_NMF(1,dummy_transp==0),2);
    H_index_post = mean(H_index_NMF(1,dummy_transp==1),2);
    functional = 100*(H_index_post - H_index_pre) ./ H_index_pre;
end

