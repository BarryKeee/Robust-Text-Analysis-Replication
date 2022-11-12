function [B_list, Theta_list] = lda_gibbs(X, N_k, W, alpha, beta, ...
                                                         maxit, burn, thin)
    
    rng('default') % fix random seed

    N_d = length(X); % number of documents
    N_w = length(W); % number of words list

     % randomly assign words in each document a topic
     % todo: fix initialization
    Z = X;
    for d=1:N_d
        for v=1:length(X{d})
            Z{d}(v) = 1; % initially assign all words to be from topic 1
        end
    end

    % initialize lambda and gamma, parameter for B and Theta
    lambda = alpha*ones(1, N_k)';
    gamma = beta*ones(1, N_w)';
    
    % todo: fix initialization
    Theta = 1 / N_k * ones(N_d, N_k); % sample from Theta prior
    B = 1 / N_w * ones(N_k, N_w); % sample from B prior

    %% 
    % X is a cell of word lists
    B_all = zeros(N_w, N_k, maxit);
    Theta_all = zeros(N_k, N_d, maxit);
    
    for it=1:maxit
        for i=1:N_d
            for v=1:length(X{i})
                % conditional topic distribution for words in each document
                p_iv = exp(log(Theta(i,:))' + log(B(:, X{i}(v))));
                p_iv = p_iv / sum(p_iv);

                % resample word topic assignment
                [~, topic] = max(mnrnd(1, p_iv));
                Z{i}(v) = topic;
            end
        end

        % sample from full conditional of Theta
        m = zeros(N_k, N_d);
        for i=1:N_d
            for k=1:N_k
                m(k, i) = sum(Z{i} == k);
            end
        end
        post_lambda = lambda + m; % update lambda
        for i=1:N_d
            Theta(i, :) = sample_dirichlet(post_lambda(:,i)', 1)';
        end
        Theta_all(:, :, it) = Theta';
        % sample from full conditional of B
        n = zeros(N_w, N_k);
        for k=1:N_k
            for v=1:N_w
                for i=1:N_d
                    for l=1:length(X{i})
                        n(v, k)=n(v, k)+((X{i}(l) == v) & (Z{i}(l) == k));
                    end
                end
            end
        end
        post_gamma = gamma + n; % update gamma

        for k=1:N_k
            B(k, :) = sample_dirichlet(post_gamma(:,k)', 1)';
        end
        B_all(:, :, it) = B';
    end

    B_list = B_all(:, :, burn:thin:end);
    Theta_list = Theta_all(:, :, burn:thin:end);
end
