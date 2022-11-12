import os

cwd = os.getcwd()
PDF_PATH = os.path.join(cwd, 'FOMC_pdf')
CACHE_PATH = os.path.join(cwd, 'cache')
if not os.path.exists(CACHE_PATH):
    os.mkdir(CACHE_PATH)
MATRIX_PATH = os.path.join(cwd,'term-document matrix')
if not os.path.exists(MATRIX_PATH):
    os.mkdir(MATRIX_PATH)
UTILFILE_PATH = os.path.join(cwd, 'util_files')
PLOT_PATH = os.path.join(cwd, 'plots')
if not os.path.exists(PLOT_PATH):
    os.mkdir(PLOT_PATH)
NMF_draws_folder = r'D:\Robust_LDA_data'
if not os.path.exists(NMF_draws_folder):
    os.mkdir(NMF_draws_folder)