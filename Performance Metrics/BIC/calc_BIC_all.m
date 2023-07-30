fig_title = 'Precoss2 - BIC';
fname1 = 'gamma_combined_ap';


modelNames = {'Precoss', 'Precoss2_identity', 'Precoss2_timing', ...
    'Precoss2_full_antiphase', 'Precoss2_full_samephase'};

N_sent = 220;
num_par = 19; % number of free-variables for Precoss-beta
num_par_precoss = 17; % number of free-variables for Precoss

% below are the sentences that did not converge and affect the BIC
% calculations
% not that typically sentences did not converge for 'samphase' and 'timing'
% but these sentences were removed from the calculation of all model
% variants
% also not converging affects only some of the metrics, such as BIC,
% entropy-weighted overlap, but not e.g. overlap (as we simply look at the 
% average acrross some boundaries)
sing_sent = [32 40 64 70 77 115 131 138 182 189 194 200 213]; 

N_sent = N_sent - length(sing_sent);

% load data for Precoss2
for i = 2 : length(modelNames)
    fname = ['perf_' modelNames{i}];
    load([fname '.mat']);
    perf(sing_sent,:) = []; 
    perf_BIC(:, i-1) = sum(perf) - 0.5*N_sent*log(num_par);
end

% load data for Precoss
load('perf_Precoss.mat')
perf = perf(:,1);
perf(sing_sent,:) = []; 
perf_BIC_precoss = sum(perf) - 0.5*N_sent*log(num_par_precoss);

