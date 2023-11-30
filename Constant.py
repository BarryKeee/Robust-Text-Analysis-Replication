import os

cwd = os.getcwd()
PDF_PATH = os.path.join(cwd, 'FOMC_pdf')
CACHE_PATH = os.path.join(cwd, 'preprocessing/cache')
os.makedirs(CACHE_PATH, exist_ok=True)
MATRIX_PATH = os.path.join(cwd, 'preprocessing/term-document matrix')
os.makedirs(MATRIX_PATH, exist_ok=True)
UTILFILE_PATH = os.path.join(cwd, 'preprocessing/util_files')
PLOT_PATH = os.path.join(cwd, 'preprocessing/plots')
os.makedirs(PLOT_PATH, exist_ok=True)

NMF_draws_folder = r'D:\Robust_LDA_data\NMF_draws'
os.makedirs(NMF_draws_folder, exist_ok=True)
