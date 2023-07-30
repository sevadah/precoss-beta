load('perf_Precoss.mat');

perf_fixed = perf(:,1); clear perf;

fname = 'perf_Precoss2_identity'; fig_title = 'Precoss2_identity';
% fname = 'perf_Precoss2_timing'; fig_title = 'Precoss2_timing';
% fname = 'perf_Precoss2_full_antiphase';  fig_title = 'Precoss2_full_antiphase';
% fname = 'perf_Precoss2_full_samephase';  fig_title = 'Precoss2_full_samephase';

load([fname '.mat'])

perf = [perf_fixed perf];

% if whichModel == 5
%     perf([64, 77, 131,], :) = [];
% elseif whichModel == 4
%     perf([182], :) = [];
% end

perf = 100*perf; % convert to %

%% get confidence intervals from boostrap and draw
Nm = size(perf,2);

[ci m]= bootci(10000,@mean,perf);

yneg = ci(1,:) - mean(m);
ypos = ci(2,:) - mean(m);

fg = figure; errorbar(1:Nm, mean(m),yneg, ypos, 'o')
% errorbar(1:Nm, mean(m),yneg, ypos, 'o')
xlabel('frequency (Hz)')
ylabel('performance (%)')


xlim([0 Nm+1])
xticks(0 : Nm+1)
% ylim([0 70])
% xticklabels(whichFolder)

hold on

thickLabels = {' ', 'Precoss', '2', '5', '10', '20', '30', '40', '50', '60'};

xticklabels(thickLabels)
% title(char(modelType(whichModel)))

%% permuttation test

for i = 1 : Nm
    for j = i+1 : Nm
        [p, observeddifference, effectsize] = permutationTest(perf(:,i), perf(:,j), 10000, 'plotresult', 0);
        pp(i,j) = p
        clear p
    end
end

alpha = 0.05;
pp > 0.05

pp_out = round(pp,5);
mean(m)

% title(fig_title)
% saveas(fg, [[fname '_lcs_bootstrap'] '.svg'])

% save([fname '_lcs_bootstrap_permut'], 'm', 'ci', 'yneg', 'ypos', 'pp', 'pp_out');