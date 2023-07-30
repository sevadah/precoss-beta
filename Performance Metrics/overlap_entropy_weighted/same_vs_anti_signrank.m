sing_sent = [64 70 131 32 77];
sing_sent = [];
load('perf_Precoss2_full_samephase.mat')
perf(sing_sent, :) = [];
perf_sm = perf; clear perf;

load('perf_Precoss2_full_antiphase')
perf(sing_sent, :) = [];
perf_af = perf; clear perf;
alpha = 0.05;
corr_alpha = alpha/size(perf_af,2); % Bonferroni corrected alpha value

for i = 1 : size(perf_af,2)
    [p(i,1), h(i,1), stats] = signrank(perf_sm(:, i), perf_af(:,i), 'alpha',corr_alpha);
    zval(i,1) = stats.zval;
    srank(i,1) = stats.signedrank;
end