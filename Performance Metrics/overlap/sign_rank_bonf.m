
load('perf_Precoss.mat');

perf_fixed = 100*perf(:, 1); clear perf; % converted to %

fname = 'perf_Precoss2_identity'; fig_title = 'Precoss2_identity';
% fname = 'perf_Precoss2_timing'; fig_title = 'Precoss2_timing';
% fname = 'perf_Precoss2_full_antiphase';  fig_title = 'Precoss2_full_antiphase';
% fname = 'Precoss2_full_samephase';  fig_title = 'Precoss2_full_samephase';



load([fname '.mat'])
perf = 100*perf; % convert to %
alpha = 0.05;
corr_alpha = alpha/size(perf,2); % Bonferroni corrected alpha value

for i = 1 : size(perf,2)
    [p(i,1), h(i,1), stats] = signrank(perf_fixed, perf(:,i), 'alpha', corr_alpha);
    zval(i,1) = stats.zval;
    srank(i,1) = stats.signedrank;
end

table = [srank, zval, p];



round(table,4)