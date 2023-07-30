fig_title = 'overlap hidden states, entropy weighted, no-silent';
fname1 = 'overlap-entropy-weighted';


modelNames = {'Precoss', ...
            'Precoss2_identity', ...
            'Precoss2_timing', ...
            'Precoss2_full_antiphase'};

fg = figure; hold on


jitter = [-0.25, 0, 0.25]
color = {'#ff860d', '#00a933', '#55308d'}


for i = 2 : length(modelNames)
    fname = ['perf_' modelNames{i}];
    load([fname '.mat']);
    
    perf = 100*perf; % convert to %
    perf(182, :) =[];
    %% get confidence intervals from boostrap and draw
    Nm = size(perf,2);

    [ci m]= bootci(10000,@mean,perf);

    yneg = ci(1,:) - mean(m);
    ypos = ci(2,:) - mean(m);
    % errorbar((1:Nm) + jitter(i-1), mean(m),yneg, ypos, 'o', 'MarkerEdgeColor',color{i-1}, 'MarkerFaceColor', color{i-1})
    e = errorbar((1:Nm) + jitter(i-1), mean(m),yneg, ypos, 'o');
    e.Color = color{i-1};
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
perf(182, :) =[];
%% get confidence intervals from boostrap and draw
Nm = size(perf,2);
[ci m]= bootci(10000,@mean,perf);
precoss_mean = ones(1,length(thickLabels))*mean(m);
ci_lower = ones(1,length(thickLabels))*ci(1,:);
ci_upper = ones(1,length(thickLabels))*ci(2,:);

plot(0.5 :length(thickLabels),precoss_mean, 'b', 'LineWidth', 1.25)
plot(0.5 :length(thickLabels),ci_lower, '-.b')
plot(0.5 :length(thickLabels),ci_upper, '-.b')


% title(char(modelType(whichModel)))

title(fig_title)

% saveas(fg, [[fname1] '.svg'])
% saveas(fg, [[fname1] '.jpg'])
