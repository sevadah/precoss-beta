# precoss-beta

The repository contains the custom Matlab script for the manuscript titled "Rhythmic modulation of prediction errors: a top-down gating role for the beta-range in speech processing".

contact: Sevada Hovsepyan (sevada.hovsepyan@gmail.com)

There are two main folders in the repository that contain Matlab Scripts to run model simulations and perform statistical analysis reported in the manuscript.

Below one can find a detailed description of the contents of these folders.


## Model Variants

### Precoss-beta (oscillating precisions)

This folder contains the Matlab scripts for each model variant discussed in the Manuscript put in a separate folder (with the same name as the model). Additionally, each model variant folder (e.g. 'Precoss-beta-identity') contains the 'Data' folder. For each Precoss-beta variant, the `Data`folder contains subfolders named with the following convention: `LAP_{NUMBER}` where the `NUMBER` corresponds to the frequency of oscillatory prediction error precisions (PEP) and has one of the following values `NUMBER = {2, 5, 10, 20, 30, 40, 50, 60}`. Each `LAP_{NUMBER}` folder contains an example from a model simulation (Matlab `.mat`file) for a sentence from the TIMIT database. The filename of the `.mat` file indicates the inversion scheme from `spm12` the toolbox (`spm_LAP`) and the sentence ID from the TIMIT dataset. 

> For more details on how the raw data for each sentence was constructed can be found in the `data_constraction`folder of the original Precoss model Github repository (please start with the corresponding [ReadMe file](https://github.com/sevadah/precoss/blob/master/data_construction/Readme.md))

The frequency of oscillating PEP precisions is set in `spm_F2_v1.m` file, line 92.

`model_inf_all_par_theta.m` script runs the inference process.

### Precoss (fixed precisions)

We have also re-uploaded the code for the original Precoss model (`Model variants/Precoss`) with an addition for Precoss with very low precision for syllable causal states (`Data/DEM_s05`). Here as well, the contents of the `Data`folder corresponds to simulations with different parameters (in the case, of Precoss with fixed precisions, we varied the precision of syllable causal states). There is an example sentence with the simulation, that now use the `spm_DEM` inversion scheme.


High/low fixed precisions for syllable causal states are set in `DoInference_theta.m` file, line 42/43.



Otherwise, for more details about how scripts are organized, please see the [description](https://github.com/sevadah/precoss/blob/master/full_simulations/Readme.md) from the Precoss repository.


## Performance Metrics

This folder contains Matlab scripts for the performance metrics that were used to analyze the models (each in a separate subfolder with the metric name, e.g. for the overlap metric - `Performance Metrics/overlap`).



`perf_eval_all.m` evaluates all models based on the given metric (depending on which subfolder it is located) and as an output it gives `.mat` files with model names (e.g. `perf_Precoss.mat` or `perf_Precoss2_identity.mat`) that contain model performance for the corresponding metric.

> Precoss2 <=> Precoss-beta

for `Precoss` columns correspond to different values of precisions of syllable causal states, where the first column corresponds to the original Precoss (fixed log-precision of syllable causal states - exp(5)) and the second column corresponds to the Precoss with low precisions (fixed log-precision of syllable causal states - exp(0.5)).


for `Precoss-beta` columns correspond for tested PEP frequencies in the following order `[2Hz, 5 Hz, 10Hz, 20Hz, 30Hz, 40Hz, 50Hz, 60Hz]`.


Rows for each case correspond to the number of testes sentences (220).


These `mat` files were used to generate the figures reporting model performance (for each metric) as well as to perform the statistical analysis.



The scripts to perform the statistical analysis are also included in each performance-metric folder:



e.g. script names `box_scatter.m` is used to generate box+scatter plots for each model variant reported in the supplementary materials.



`calc_draw_m_ci_bootstrap.m` calculates and draws mean ( `m`) and a 95% confidence interval ( `ci`) for all model variants (Precoss and Precoss-beta). e.g. reported in Figure 2 for the overlap metric.


`friedman_test.m` performs the Friedman test for a given Precoss-beta variant (to see whether oscillatory PEP frequency affects model performance), followed by multiple comparisons with Bonferroni correction. 


`comparisionBetweenVariantsANOVA.m` performs 2-way ANOVA within Precoss-beta variants to see whether a model type has an effect on model performance. In this case, the model type is considered a discrete factor, whereas the PEP frequency is a continuous prediction. 
