%% getting addressnce = 1;
currentFold = pwd;
P1_fold = fileparts(currentFold); % now we are on the folder corresponding model type
P2_fold = fileparts(P1_fold);
P3_fold = fileparts(P2_fold);

dataFold = fullfile(P3_fold, 'ModelData/Data');
full_sentence_list = importdata(fullfile(dataFold, 'full_sentence_list.mat'));

modelType = {'Precoss', ...
            'Precoss2_identity', ...
            'Precoss2_timing', ...
            'Precoss2_full_antiphase', ...
            'Precoss2_full_samephase'};

simFolders{1} = {'DEM', 'DEM_s05'}; % for Precoss
simFolders{2} = {'LAP2', 'LAP5', 'LAP10', 'LAP20', 'LAP30', 'LAP40', 'LAP50', 'LAP60'}; % for Precoss2 - A
simFolders{3} = {'LAP2', 'LAP5', 'LAP10', 'LAP20', 'LAP30', 'LAP40', 'LAP50', 'LAP60'}; % for Precoss2 - B
simFolders{4} = {'LAP2', 'LAP5', 'LAP10', 'LAP20', 'LAP30', 'LAP40', 'LAP50', 'LAP60'}; % for Precoss2 - C
simFolders{5} = {'LAP2', 'LAP5', 'LAP10', 'LAP20', 'LAP30', 'LAP40', 'LAP50', 'LAP60'}; % for Precoss2 - C -> samephase

%%%%%%%%%

modelsToEval = [1 2 3 4 5];
% modelsToEval = [4];

%%%%%%%%%


for i = 1 : length(modelsToEval)
    
    whichModel = modelsToEval(i);    
    runFold = fullfile([P2_fold '/' modelType{whichModel}], 'Data');
    whichFolder = simFolders{whichModel};
    
    sent_IDs = list_of_ext_sentences(runFold, whichFolder);
    N_sentences = length(sent_IDs);
    N_run = length(whichFolder);
    
    perf = zeros(N_sentences, N_run);
    
    for iRun = 1 : N_run
        
        fpath = fullfile(runFold, whichFolder{iRun});
        
        for iSentence = 1 : N_sentences
            curr_sentence = char(full_sentence_list(iSentence));
            sent_data = importdata(fullfile(dataFold, [curr_sentence '.mat']));
            N_syl = length(sent_data.P_all);
            
            % get DEM file (simulation results) for the current sentence and current model variant
            DEM = importdata(fullfile(fpath, char(sent_IDs(iSentence))));
            [syllables, real_input] = get_y_syllables_xx(DEM, sent_data);
            
            [logLike] = get_logLike(syllables, real_input);
                        
            perf(iSentence, iRun) = logLike;
            

        end
    end
    
    fname = ['perf_' modelType{whichModel}];
    save(fname, 'perf', 'sent_IDs', 'whichFolder', 'N_sentences');
    
    clear fname perf sent_IDs whichFolder N_sentences N_run
    
end
