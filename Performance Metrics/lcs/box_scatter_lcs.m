load('perf_Precoss.mat');

perf_fixed = perf_lcs_ratio(:,1); clear perf;

fname = 'perf_Precoss2_identity'; fig_title = 'Precoss2_identity';
% fname = 'perf_Precoss2_timing'; fig_title = 'Precoss2_timing';
% fname = 'perf_Precoss2_full_antiphase';  fig_title = 'Precoss2_full_antiphase';
% fname = 'perf_Precoss2_full_samephase';  fig_title = 'Precoss2_full_samephase';


load([fname '.mat'])

perf = [perf_fixed perf_lcs_ratio];

perf = 100*perf;

labels = {'Precoss', '2', '5', '10', '20', '30', '40', '50', '60'};
a = [1:size(perf,2)].*ones(1,length(perf))';



fg = figure('Position', [50 100 5.27*250 3*250]);
hold on

% % empty 
% for i = 1 : size(perf,2)
%     scatter(a(:,i),perf(:,i),'MarkerEdgeAlpha',0.4, 'MarkerEdgeColor', 'b', 'jitter','on','jitterAmount',0.2)
% end

% full
for i = 1 : size(perf,2)
    scatter(a(:,i),perf(:,i),'filled','MarkerFaceAlpha',0.2, 'MarkerFaceColor', 'b', 'jitter','on','jitterAmount',0.2)
end

boxplot(perf, 'Labels', labels, 'Widths',0.5)

aa = get(get(gca,'children'),'children'); % Get the handles of all the objects
t = get(aa{1},'tag'); % List the names of all the objects


idx=strcmpi(t,'box'); % Find Box objects
obj=aa{1}(idx); % Get the children you need
set(obj,'linewidth',1.2); % Set width

clear idx boxes obj

idx=strcmpi(t,'Median'); % Find Box objects
obj=aa{1}(idx); % Get the children you need
set(obj,'linewidth',1.2); % Set width

clear idx boxes obj

idx=strcmpi(t,'Lower Whisker'); % Find Box objects
obj=aa{1}(idx); % Get the children you need
set(obj,'linewidth',1.2); % Set width

clear idx boxes obj

idx=strcmpi(t,'Upper Whisker'); % Find Box objects
obj=aa{1}(idx); % Get the children you need
set(obj,'linewidth',1.2); % Set width

clear idx boxes obj

idx=strcmpi(t,'Lower Adjacent Value'); % Find Box objects
obj=aa{1}(idx); % Get the children you need
set(obj,'linewidth',1.2); % Set width

clear idx boxes obj

idx=strcmpi(t,'Upper Adjacent Value'); % Find Box objects
obj=aa{1}(idx); % Get the children you need
set(obj,'linewidth',1.2); % Set width

clear idx boxes obj

xlabel('Frequency of precision units (Hz)')
ylabel('Longest common (sub)sequence (%)')


title(fig_title)
% print(gcf,fname,'-svg');
% exportgraphics(gcf,'TM2c.pdf','ContentType','vector')
% saveas(fg, [[fname '_lcs'] '.svg'])