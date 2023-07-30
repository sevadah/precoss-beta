load('perf_TM2a.mat')
perfA = perf; clear perf;
load('perf_TM2b.mat')
perfB = perf; clear perf;
load('perf_TM2c_antiphase.mat')
perfC = perf; clear perf;

alpha =0.05;
corr_alpha = 0.05/3;

% results for pairwise comaprisions are stored in the variables below
% e,g, for statAB, we compare variant A vs varian B, statCB -> C vs B, etc
% 1st column -> the p-value
% 2nd column -> h value (hypthesis rejected or not, if rejected->1, otherwise 0)
% 3rd column -> zval, A-B, C-B, C-A
% 4rd column -> srank
% statAB
% statCB
% statCA
for i = 1 : 8
    % A vs B
    [p, h, stats] = signrank(perfA(:,i), perfB(:,i), 'alpha', corr_alpha);
    statAB(i, 1) = p; clear p;
    statAB(i, 2) = h; clear h;
    statAB(i, 3) = stats.zval;
    statAB(i, 4) = stats.signedrank; clear stats
    
    % C vs B
    [p, h, stats] = signrank(perfC(:,i), perfB(:,i), 'alpha', corr_alpha);
    statCB(i, 1) = p; clear p;
    statCB(i, 2) = h; clear h;
    statCB(i, 3) = stats.zval;
    statCB(i, 4) = stats.signedrank; clear stats

    % C vs A
    [p, h, stats] = signrank(perfC(:,i), perfA(:,i), 'alpha', corr_alpha);
    statCA(i, 1) = p; clear p;
    statCA(i, 2) = h; clear h;
    statCA(i, 3) = stats.zval;
    statCA(i, 4) = stats.signedrank; clear stats

    
end