fig_title = 'phase difference, overlap-hidden-states, entropy-weighted';
fname1 = 'phase_difference';

modelNames = {'Precoss2_full_antiphase', ...
            'Precoss2_full_samephase'};


fg = figure; hold on
sing_sent = [64 70 131 32 77];

jitter = [-0.1 0.1]
color = {'#55308d', '#ff0000'}


for i = 1 : length(modelNames)
    fname = ['perf_' modelNames{i}];
    load([fname '.mat']);
    
    perf = 100*perf; % convert to %
    perf(sing_sent, :) = [];
    %% get confidence intervals from boostrap and draw
    Nm = size(perf,2);

    [ci m]= bootci(10000,@mean,perf);

    yneg = ci(1,:) - mean(m);
    ypos = ci(2,:) - mean(m);
    % errorbar((1:Nm) + jitter(i-1), mean(m),yneg, ypos, 'o', 'MarkerEdgeColor',color{i-1}, 'MarkerFaceColor', color{i-1})
    e = errorbar((1:Nm) + jitter(i), mean(m),yneg, ypos, 'o');
    e.Color = color{i};
    % errorbar(1:Nm, mean(m),yneg, ypos, 'o')
    xlabel('frequency (Hz)')
    ylabel('performance (%)')


    xlim([0 Nm+1])
    xticks(0 : Nm+1)

end

thickLabels = {' ', '2', '5', '10', '20', '30', '40', '50', '60'};

xticklabels(thickLabels)


load('perf_Precoss.mat')

perf = 100*perf(:,1); % convert to %
%% get confidence intervals from boostrap and draw
Nm = size(perf,2);
[ci m]= bootci(10000,@mean,perf);
precoss_mean = ones(1,length(thickLabels))*mean(m);
ci_lower = ones(1,length(thickLabels))*ci(1,:);
ci_upper = ones(1,length(thickLabels))*ci(2,:);

plot(0.5 :length(thickLabels),precoss_mean, 'b')
plot(0.5 :length(thickLabels),ci_lower, '-b', 'LineWidth', 1.25)
plot(0.5 :length(thickLabels),ci_upper, '-b', 'LineWidth', 1.25)


% title(char(modelType(whichModel)))

title(fig_title)
legend('anti-phase', 'same phase')
% saveas(fg, [[fname1 '_bootstrap'] '.svg'])
% saveas(fg, [[fname1 '_bootstrap'] '.jpg'])
