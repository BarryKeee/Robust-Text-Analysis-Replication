import numpy as np
import os
import timeit
import scipy
import pandas as pd
from preprocessing.Constant import MATRIX_PATH
import pickle
import onlineldavb


def _sample_dirichlet(alpha):
    """
    Sample from dirichlet distribution. Alpha is a matrix whose rows are params (resulting sample sum = 1 across axis 1
    """
    res = []
    for i in range(alpha.shape[0]):
        res.append(np.random.dirichlet(alpha[i,:]))

    return np.array(res)


def vb_estimate(section, onlyTF=True, K=40, alpha=0.025, eta=0.025, tau=1024, kappa=0.7,
                docs_idx_list=None):
    print('VB Estimation for {}'.format(section))
    vocab_1 = pd.read_excel(os.path.join(MATRIX_PATH, section + '_dictionary_meeting{}.xlsx'.format('_onlyTF' if onlyTF else '')), index_col=0, engine='openpyxl').index
    vocab_1 = list(vocab_1)

    with open(os.path.join(MATRIX_PATH, section + '_text{}.pkl'.format('_onlyTF' if onlyTF else '')), 'rb') as f:
        text1 = pickle.load(f)

    text1 = [' '.join(x) for x in text1]
    if docs_idx_list is not None:
        text1 = [text1[x] for x in range(len(text1)) if x in docs_idx_list]
    D = len(text1) # the number of documents

    # initialize online LDA algorithm
    olda = onlineldavb.OnlineLDA(vocab_1, K, D, alpha, eta, tau, kappa)
    (gamma, bound) = olda.update_lambda(text1)

    # Normalize gamma column-wise (sum across rows for each column)
    posterior_mean = gamma / gamma.sum(axis=0)
    # compute herfindehl of the posterior mean
    return (posterior_mean**2).sum(axis=0),posterior_mean, gamma, olda._lambda, olda, text1


def find_NMF_given_solution(B_init, Theta_init, beta, T, eps, maxit=100000, verbose=False):

    def A(i, j, lam, K):
        A = np.diag(np.ones(K))
        A[i, i] = 1 - lam
        A[j, i] = lam
        return A

    K = B_init.shape[1]
    B = B_init
    Theta = Theta_init

    B_store = np.array([B_init])
    Theta_store = np.array([Theta_init])

    for s in range(maxit):
        B = B_store[s]
        Theta = Theta_store[s]
        for i in range(K):
            j = np.random.choice(np.delete(np.array(range(K)), i), size=1)[0]
            lambda_max = np.min((Theta[j] / (Theta[i] + Theta[j])) * np.where((Theta[i] + Theta[j]) > 0, 1, np.inf))
            lambda_min = np.max((B[:, i] / (B[:, i] - B[:, j])) * np.where(B[:, j] > B[:, i], 1, -np.inf))

            x = np.random.beta(beta, beta)
            lam = x * lambda_max + (1 - x) * lambda_min
            B = B @ A(i, j, lam, K)
            Theta = A(i, j, -lam / (1 - lam), K) @ Theta

        B_store = np.append(B_store, np.array([B]), axis=0)
        Theta_store = np.append(Theta_store, np.array([Theta]), axis=0)

        if s > T:
            avg_B_chg_S = (B_store.max(axis=0) - B_store.min(axis=0)).mean()
            avg_B_chg_T = (B_store[:-T].max(axis=0) - B_store[:-T].min(axis=0)).mean()
            if verbose:
                print(f'{s}: {avg_B_chg_S - avg_B_chg_T}')
            if avg_B_chg_S - avg_B_chg_T < eps:
                break
    return B_store, Theta_store


def algo1_only_store_draws(gamma1, lam1, gamma2, lam2, eps, T, save_folder, post_draw_num=200, beta=0.5):
    np.random.seed(0)
    B_Theta_sec1_post_draw_store = []
    B_Theta_sec2_post_draw_store = []

    os.makedirs(save_folder, exist_ok=True)
    os.makedirs(os.path.join(save_folder, 'FOMC1'), exist_ok=True)
    os.makedirs(os.path.join(save_folder, 'FOMC2'), exist_ok=True)
    os.makedirs(os.path.join(save_folder, 'FOMC1', 'NMF_B'), exist_ok=True)
    os.makedirs(os.path.join(save_folder, 'FOMC1', 'NMF_Theta'), exist_ok=True)
    os.makedirs(os.path.join(save_folder, 'FOMC2', 'NMF_B'), exist_ok=True)
    os.makedirs(os.path.join(save_folder, 'FOMC2', 'NMF_Theta'), exist_ok=True)

    for i in range(post_draw_num):
        print('Drawing posterior number {}'.format(i+1))
        start = timeit.default_timer()

        # sample from dirichlet distribution given lambda and gamma
        B1 = _sample_dirichlet(lam1).T
        B2 = _sample_dirichlet(lam2).T
        Theta1 = _sample_dirichlet(gamma1).T
        Theta2 = _sample_dirichlet(gamma2).T

        B_list_1, Theta_list_1 = find_NMF_given_solution(B1, Theta1, beta, T, eps)
        B_list_2, Theta_list_2 = find_NMF_given_solution(B2, Theta2, beta, T, eps)

        B_Theta_sec1_post_draw_store.append([B1, Theta1])
        B_Theta_sec2_post_draw_store.append([B2, Theta2])

        scipy.io.savemat(os.path.join(save_folder, 'FOMC1', 'NMF_B', f'NMF_sec1_B_draw{i+1}.mat'),
                         {'B_list': B_list_1})
        scipy.io.savemat(os.path.join(save_folder, 'FOMC2', 'NMF_B', f'NMF_sec2_B_draw{i+1}.mat'),
                         {'B_list': B_list_2})
        scipy.io.savemat(os.path.join(save_folder, 'FOMC1', 'NMF_Theta', f'NMF_sec1_Theta_draw{i+1}.mat'),
                         {'Theta_list': Theta_list_1})
        scipy.io.savemat(os.path.join(save_folder, 'FOMC2', 'NMF_Theta', f'NMF_sec2_Theta_draw{i+1}.mat'),
                         {'Theta_list': Theta_list_2})
        end = timeit.default_timer()
        print('Finished posterior draw {}. Time: {}'.format(i + 1, end - start))

    scipy.io.savemat(os.path.join(save_folder, 'B_Theta_post_draws_sec1.mat'),
                     {'post_draws_B_Theta': np.array(B_Theta_sec1_post_draw_store)})
    scipy.io.savemat(os.path.join(save_folder, 'B_Theta_post_draws_sec2.mat'),
                     {'post_draws_B_Theta': np.array(B_Theta_sec2_post_draw_store)})


def store_posterior_draws(gamma, lam, post_draw_num, save_folder, cache_name):
    np.random.seed(0)
    B_Theta_post_draw_store = []
    os.makedirs(save_folder, exist_ok=True)

    for i in range(post_draw_num):
        print('Drawing posterior number {}'.format(i+1))

        # sample from dirichlet distribution given lambda and gamma
        B = _sample_dirichlet(lam).T
        Theta = _sample_dirichlet(gamma).T

        B_Theta_post_draw_store.append([B, Theta])

    scipy.io.savemat(os.path.join(save_folder, f'{cache_name}.mat'),
                     {'post_draws_B_Theta': np.array(B_Theta_post_draw_store)})