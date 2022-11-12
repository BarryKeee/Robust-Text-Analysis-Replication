clear all
clc

%% NMF draw folder
NMF_draw_parent_folder = "D:\Robust_LDA_data\NMF_draws";

%% Baseline posterior
% percent difference
FOMC_sec = 1;
func = @HHI_percent_diff;
prior_posterior_spec = "posterior_alpha_1.25_beta_0.025";
prior_post_draw_name = NMF_draw_parent_folder + '\' + prior_posterior_spec ...
    + '\B_Theta_post_draws_sec1.mat'; 
NMF_draw_folder_name = NMF_draw_parent_folder + '\' + prior_posterior_spec ...
    + '\FOMC1\NMF_Theta';
x_lims = [15, 40];
y_lims = [0, 0.45];
x_label = '%';
density_type = "Posterior";
save_fig_name = prior_posterior_spec + '_percent_diff';
disp(save_fig_name)
empirical_application(FOMC_sec, func, save_fig_name, ...
    prior_post_draw_name, NMF_draw_folder_name, x_lims, y_lims, x_label, density_type)

% regression
func = @HHI_regression;
save_fig_name = prior_posterior_spec + '_regression';
x_label = 'Regression Coef on Transparency';
x_lims = [0.004, 0.016];
y_lims = [0, 1200];
disp(save_fig_name)
empirical_application(FOMC_sec, func, save_fig_name, ...
    prior_post_draw_name, NMF_draw_folder_name, x_lims, y_lims, x_label, density_type)

%% Baseline prior
% percent difference
FOMC_sec = 1;
func = @HHI_percent_diff;
prior_posterior_spec = "prior_alpha_1.25_beta_0.025";
prior_post_draw_name = NMF_draw_parent_folder + '\' + prior_posterior_spec ...
    + '\B_Theta_prior_draws_sec1.mat'; 
NMF_draw_folder_name = NMF_draw_parent_folder + '\' + prior_posterior_spec ...
    + '\FOMC1\NMF_Theta';
x_lims = [-5, 5];
y_lims = [0, 0.45];
x_label = '%';
density_type = "Prior";
save_fig_name = prior_posterior_spec + '_percent_diff';
disp(save_fig_name)
empirical_application(FOMC_sec, func, save_fig_name, ...
    prior_post_draw_name, NMF_draw_folder_name, x_lims, y_lims, x_label, density_type)

% regression
func = @HHI_regression;
save_fig_name = prior_posterior_spec + '_regression';
x_label = 'Regression Coef on Transparency';
x_lims = [-5*1e-3, 5*1e-3];
y_lims = [0, 600];
disp(save_fig_name)
empirical_application(FOMC_sec, func, save_fig_name, ...
    prior_post_draw_name, NMF_draw_folder_name, x_lims, y_lims, x_label, density_type)


%% Baseline posterior for FOMC2
% percent difference
FOMC_sec = 2;
func = @HHI_percent_diff;
prior_posterior_spec = "posterior_alpha_1.25_beta_0.025";
prior_post_draw_name = NMF_draw_parent_folder + '\' + prior_posterior_spec ...
    + '\B_Theta_post_draws_sec2.mat'; 
NMF_draw_folder_name = NMF_draw_parent_folder + '\' + prior_posterior_spec ...
    + '\FOMC2\NMF_Theta';
x_lims = [4, 25];
y_lims = [0, 0.5];
x_label = '%';
density_type = "Posterior";
save_fig_name = prior_posterior_spec + '_percent_diff_FOMC2';
disp(save_fig_name)
empirical_application(FOMC_sec, func, save_fig_name, ...
    prior_post_draw_name, NMF_draw_folder_name, x_lims, y_lims, x_label, density_type)

% regression
func = @HHI_regression;
save_fig_name = prior_posterior_spec + '_regression_FOMC2';
x_label = 'Regression Coef on Transparency';
x_lims = [-3*1e-3, 4*1e-3];
y_lims = [0, 1500];
disp(save_fig_name)
empirical_application(FOMC_sec, func, save_fig_name, ...
    prior_post_draw_name, NMF_draw_folder_name, x_lims, y_lims, x_label, density_type)


%% Baseline prior for FOMC2
% percent difference
FOMC_sec = 1;
func = @HHI_percent_diff;
prior_posterior_spec = "prior_alpha_1.25_beta_0.025";
prior_post_draw_name = NMF_draw_parent_folder + '\' + prior_posterior_spec ...
    + '\B_Theta_prior_draws_sec1.mat'; 
NMF_draw_folder_name = NMF_draw_parent_folder + '\' + prior_posterior_spec ...
    + '\FOMC1\NMF_Theta';
x_lims = [-8, 8];
y_lims = [0, 0.5];
x_label = '%';
density_type = "Prior";
save_fig_name = prior_posterior_spec + '_percent_diff_FOMC2';
disp(save_fig_name)
empirical_application(FOMC_sec, func, save_fig_name, ...
    prior_post_draw_name, NMF_draw_folder_name, x_lims, y_lims, x_label, density_type)

% regression
func = @HHI_regression;
save_fig_name = prior_posterior_spec + '_regression_FOMC2';
x_label = 'Regression Coef on Transparency';
x_lims = [-5*1e-3, 5*1e-3];
y_lims = [0, 600];
disp(save_fig_name)
empirical_application(FOMC_sec, func, save_fig_name, ...
    prior_post_draw_name, NMF_draw_folder_name, x_lims, y_lims, x_label, density_type)


%% Alternative posterior: alpha=beta=1
% percent difference
FOMC_sec = 1;
func = @HHI_percent_diff;
prior_posterior_spec = "posterior_alpha_1_beta_1";
prior_post_draw_name = NMF_draw_parent_folder + '\' + prior_posterior_spec ...
    + '\B_Theta_post_draws_sec1.mat'; 
NMF_draw_folder_name = NMF_draw_parent_folder + '\' + prior_posterior_spec ...
    + '\FOMC1\NMF_Theta';
x_lims = [20, 60];
y_lims = [0, 0.45];
x_label = '%';
density_type = "Posterior";
save_fig_name = prior_posterior_spec + '_percent_diff';
disp(save_fig_name)
empirical_application(FOMC_sec, func, save_fig_name, ...
    prior_post_draw_name, NMF_draw_folder_name, x_lims, y_lims, x_label, density_type)

% regression
func = @HHI_regression;
save_fig_name = prior_posterior_spec + '_regression';
x_label = 'Regression Coef on Transparency';
x_lims = [0.004, 0.022];
y_lims = [0, 800];
disp(save_fig_name)
empirical_application(FOMC_sec, func, save_fig_name, ...
    prior_post_draw_name, NMF_draw_folder_name, x_lims, y_lims, x_label, density_type)

%% Alternative prior: alpha=beta=1
% percent difference
FOMC_sec = 1;
func = @HHI_percent_diff;
prior_posterior_spec = "prior_alpha_1_beta_1";
prior_post_draw_name = NMF_draw_parent_folder + '\' + prior_posterior_spec ...
    + '\B_Theta_post_draws_sec1.mat'; 
NMF_draw_folder_name = NMF_draw_parent_folder + '\' + prior_posterior_spec ...
    + '\FOMC1\NMF_Theta';
x_lims = [-6, 6];
y_lims = [0, 0.45];
x_label = '%';
density_type = "Posterior";
save_fig_name = prior_posterior_spec + '_percent_diff';
disp(save_fig_name)
empirical_application(FOMC_sec, func, save_fig_name, ...
    prior_post_draw_name, NMF_draw_folder_name, x_lims, y_lims, x_label, density_type)

% regression
func = @HHI_regression;
save_fig_name = prior_posterior_spec + '_regression';
x_label = 'Regression Coef on Transparency';
x_lims = [-5*1e-3, 5*1e-3];
y_lims = [0, 800];
disp(save_fig_name)
empirical_application(FOMC_sec, func, save_fig_name, ...
    prior_post_draw_name, NMF_draw_folder_name, x_lims, y_lims, x_label, density_type)




