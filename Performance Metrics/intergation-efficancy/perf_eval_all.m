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


for i = 1 : length(modelsToEval)
    
    whichModel = modelsToEval(i);
    runFold = fullfile([P2_fold '/' modelType{whichModel}], 'Data');
    whichFolder = simFolders{whichModel};

    sent_IDs = list_of_ext_sentences(runFold, whichFolder); 
    N_sentences = length(sent_IDs);
    N_run = length(whichFolder); 

    full_integ = zeros(N_sentences, N_run);
    
    for iRun = 1 : N_run

        fpath = fullfile(runFold, whichFolder{iRun});

        for iSentence = 1 : N_sentences
            curr_sentence = char(full_sentence_list(iSentence));
            sent_data = importdata(fullfile(dataFold, [curr_sentence '.mat']));
            
            % getting syllable boundaries
            syllable_boundaries = sent_data.syllable_boundaries;
            startTime = syllable_boundaries(1,:);
            endTime = syllable_boundaries(2,:);
            
            % re align so the first syllable onset is the start of the sentence
            % (in TIMIT there is initial 0-padding)
            onsets = startTime - startTime(1) + 1;
            offsets = endTime - startTime(1) + 1;
            
            % get DEM file (simulation results) for the current sentence and current model variant
            DEM = importdata(fullfile(fpath, char(sent_IDs(iSentence))));
            
            [gamma_xx, syll_xx, ~, pe_syll_xx] = get_pe_su_gu_xx(sent_data, DEM);
            
            ds = diff(syll_xx(1:offsets(end), 1:end-1)); % remove tail and silent unit - syllable hidden states
            ds_soft = diff(syll_xx(1:offsets(end), 1:end-1)); % remove tail and silent unit - derivative of syllable hidden states
            
            g8 = gamma_xx(1:offsets(end)-1,8); % the last gamma unit used to reset syllable hidden states
            
            [~, syll_vv, pe_gamma_vv, pe_syll_vv] = get_pe_su_gu(sent_data, DEM);
            
            
            % bottom-up prediction errors
            pe_syll_vv(:, end) = []; % remove for silent unit 
            pe_syll_vv = pe_syll_vv(1:offsets(end)-1, :); 
          
            
            % remove reset points
            ds(g8>0.5,:) = [];
            ds_soft(g8>0.5,:) = [];
            pe_syll_vv(g8>0.5,:) = [];
            
           
            % how well prediction errors were integrated
           
            % getting positive and negative bottom-up prediction errors
            pos_pe_syll_vv = pe_syll_vv.*(pe_syll_vv>0); % positive PE
            neg_pe_syll_vv = pe_syll_vv.*(pe_syll_vv<0); % negative PE
            
            % getting positive and negative changes in syllable hidden
            % states
            pos_ds = ds.*(ds>0); % postive derivative of syllable hidden state      
            neg_ds = ds.*(ds<0); % negative derivative of syllable hidden state

            % for each syllable hidden states, if the corresponding
            % component of bottom-up prediction error is postive(negative)
            % and model was able to intagrate into the hidden states, then
            % the derivative of syllable hidden states would also be
            % postive(negative)
            
            full_integ(iSentence, iRun) = mean(mean(pos_pe_syll_vv.*pos_ds + neg_pe_syll_vv.*neg_ds));
            

            clear curr_sentence syllable_boundaries DEM
            clear gamma_xx syll_xx pe_gamma_vv pe_syll_vv 

        end
    end

    fname = ['perf' modelType{whichModel}];
    save(fname, 'full_integ', 'sent_IDs', 'whichFolder', 'N_sentences');

    
end
