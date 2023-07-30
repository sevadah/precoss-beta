%% getting addressnce = 1;
currentFold = pwd;
P1_fold = fileparts(currentFold); % now we are on the folder corresponding model type
P2_fold = fileparts(P1_fold);
P3_fold = fileparts(P2_fold);
% P4_fold = fileparts(P3_fold);
% P5_fold = fileparts(P4_fold);
dataFold = fullfile(P2_fold, 'ModelData/Data');
full_sentence_list = importdata(fullfile(dataFold, 'full_sentence_list.mat'));

%%
% sentences from 1 to 80
iSentence = 45;
curr_sentence = char(full_sentence_list(iSentence));
DEM = importdata(['DEM_' curr_sentence '.mat']);
%%

vv2 = full(DEM.qU.v{2})';
xx2 = full(DEM.qU.x{2})';
syll_vv = vv2(:, 10 : end); % with the silent unit
syll_xx = xx2(:, 21 : end); % with the silent unit

fg = figure('Position', [50 100 1000 800]);
titletext = ['Precoss - log-precision of syllable causal states = 0.5, sentence ' num2str(iSentence)];
suptitle(titletext)

subplot(2, 1, 1);
plotSU_new(syll_xx);
title('syllable hidden states')



subplot(2, 1, 2);
plotSU_new(syll_vv);
title('syllable causal states')

% legend