fname = 'perf_Precoss2_identity'; fig_title = 'Precoss2_identity';
% fname = 'perf_Precoss2_timing'; fig_title = 'Precoss2_timing';
% fname = 'perf_Precoss2_full_antiphase';  fig_title = 'Precoss2_full_antiphase';
% fname = 'perf_Precoss2_full_samephase';  fig_title = 'Precoss2_full_samephase';

load([fname '.mat'])

% if whichModel == 5
%     perf([64, 77, 131,], :) = [];
% elseif whichModel == 4
%     perf([182], :) = [];
% end

% perf = 100*perf; % convert to %
perf = full_integ;
% perf(182,:)=[];
fgroups = {'2', '5', '10', '20', '30', '40', '50', '60'};

[p,tbl,stats] = friedman(perf);

figure;
thickLabels = {'60', '50', '40', '30', '20', '10', '5', '2'};

[c,m,h,gnames] = multcompare(stats,'Ctype', 'bonferroni');
yticklabels(thickLabels)
ylabel('frequency (Hz)')

