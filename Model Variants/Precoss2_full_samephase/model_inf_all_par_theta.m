%% runs spm_LAP on sentence dataset

% add the path of the spm12 toolbox
path_of_toolbox = 'YOUR/PATH/TOOLBOX/spm12';
addpath(genpath(path_of_toolbox));

% address of data folder, where sentence data (spectrotemporal patterns,
% syllable timing, etc) is located

path_to_sentData = 'YOUR/PATH/SENTENCE/DATA'; 
dataFold = fullfile(path_to_sentData); 

full_sentence_list = importdata(fullfile(dataFold, 'full_sentence_list.mat'));
% N_sentence = length(full_sentence_list);

%% sentence and data


% N_sentence = 220;
whichSentences = 1 : 220;

% whichSentences = importdata('missing_sentences.mat');
N_sentence = length(whichSentences);

% parpool('local', 16) 
% one can skip this step and MATLAB will iniate default parpool

parfor i = 1 : N_sentence
    iSentence = whichSentences(i);
    curr_sentence = char(full_sentence_list(iSentence))
    sent_data = importdata(fullfile(dataFold, [curr_sentence '.mat']));

    LAP = DoLAPInference_theta(sent_data);
    
    fname = fullfile(['LAP_' curr_sentence]);
    parsave(fname, LAP)
end
