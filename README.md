# Robust-Text-Analysis-Replication
Replication code for "Robust Machine Learning Algorithms for Text Analysis". If you use this code, please cite Ke, Montiel Olea, Nesbit. *Quantitiative Economics* Forthcoming. 

The paper has two modules of programming exercises. One is a simulation exercise that illustrates the main results with stylized examples with V = K = D = 2. The other is an empirical exercise that runs our algorithm on FOMC transcripts.  

Compile language: Matlab, Python

Python dependencies: 

## Simulation

The replication codes for simulation (Section 6.1 of main text and Section E of online appendix) are in \simulation folder. They are self-contained scripts that could be run individually. Below describes each folder and which plot the script replicates:

* 1Sensitivity: Run Sensitivity.m for Figure 3 in main text

* 2Range: Run Range_main.m for Figure 4, 5 and 6 in main text

* 3MonteCarlo: Run Main_MonteCarlo.m for Figure 7 in main text and Figure 4 in online appendix

* 4Approximation: Run Main_approx.m for Figure 3 in online appendix

* 5AnchorWord: Run Main_AnchorWord.m for Figure 5 and 6 in online appendix

  

## Empirical Exercise

The rest of the codebase is for replicating the empirical exercise on FOMC transcript (Section 6.2 of main and Section F of online appendix). 

The raw data used are in folder 

* FOMC_pdf: raw PDF files for FOMC transcripts from Aug-1987 to Jan-2006
* util_files: covariates and separation rules for FOMC 1 and 2

The replication consists of following steps:

1. run preprocessing.MAIN_preprocess.py, which parses raw pdf files, clean up corpus, and generate term-document frequency matrices. The final term-document frequency matrices are stored in \term-document matrix folder

2. run preprocessing.MAIN_generate_NMF_draws.py, which generates NMF draws of prior and posterior estimates of P_hat with different prior values used in the paper. The final outputs are .mat files stored in "NMF_draws_folder" defined in preprocessing.Constant.py

   **Note: for full replication of all graphs, this step will probably take a long time (6-8 hours) and the output data takes significant storage space. It is highly recommended to change the NMF_draws_folder to point to a directory with >150G spare space. Alternatively, user can run single block in Main_generate_NMF_draws.py to replicate individual plot**

3. In empirical_analysis, run Main_empirical.m to generate all graphs in the empirical section. Change NMF_draw_parent_folder in Main_empirical.m to point to NMF_draws_folder as specified in preprocessing.Constant.py.

    Running the full script will also take some time. User can also run single block to generate individual graph. The plots are stored in empirical_analysis/Figures. The file names for figures in the paper can be found in figure_names.md.

   

