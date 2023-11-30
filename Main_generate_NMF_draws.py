from preprocessing.estimation_and_nmf import algo1_only_store_draws, vb_estimate
from Constant import NMF_draws_folder
import numpy as np
import os

K = 40
D = 148
V1 = 200
V2 = 150
eps = 1e-4
T = 120


def main():

    save_folder = os.path.join(NMF_draws_folder, 'posterior_alpha_1.25_beta_0.025')
    _, _, gamma1, lam1, _, _ = vb_estimate('FOMC1', onlyTF=True, K=K, alpha=1.25, eta=0.025)
    _, _, gamma2, lam2, _, _ = vb_estimate('FOMC2', onlyTF=True, K=K, alpha=1.25, eta=0.025)
    algo1_only_store_draws(gamma1, lam1, gamma2, lam2, eps, T, save_folder, post_draw_num=200, beta=0.5)

    save_folder = os.path.join(NMF_draws_folder, 'prior_alpha_1.25_beta_0.025')
    gamma1 = np.ones((D, K)) * 1
    lam1 = np.ones((K, V1)) * 0.025
    gamma2 = np.ones((D, K)) * 1.25
    lam2 = np.ones((K, V2)) * 0.025
    algo1_only_store_draws(gamma1, lam1, gamma2, lam2, eps, 200, save_folder, post_draw_num=200, beta=0.5)

    save_folder = os.path.join(NMF_draws_folder, 'posterior_alpha_1_beta_1')
    _, _, gamma1, lam1, _, _ = vb_estimate('FOMC1', onlyTF=True, K=K, alpha=1, eta=1)
    _, _, gamma2, lam2, _, _ = vb_estimate('FOMC2', onlyTF=True, K=K, alpha=1, eta=1)
    algo1_only_store_draws(gamma1, lam1, gamma2, lam2, eps, T, save_folder, post_draw_num=200, beta=0.5)

    save_folder = os.path.join(NMF_draws_folder, 'prior_alpha_1_beta_1')
    gamma1 = np.ones((D, K))
    lam1 = np.ones((K, V1))
    gamma2 = np.ones((D, K))
    lam2 = np.ones((K, V2))
    algo1_only_store_draws(gamma1, lam1, gamma2, lam2, eps, 200, save_folder, post_draw_num=200, beta=0.5)


if __name__ == '__main__':
    main()