function idx_g1 = perf_duration_overlap_idx(syll_xx, g1, onsets, offsets)
    N_syl = length(onsets);

    % no softmax on syllable units

%     inp_seq = zeros(length(syll_vv), N_syl); % no silent unit
    rec_seq = zeros(length(syll_xx), N_syl+1); % with silent unit

    % getting sequence of recognized syllables
    
    iG_idx = []; % to store the sequence of recognized syllables
    
    for iG = 1 : length(g1)-1
        st = g1(iG);
        en = g1(iG+1);
        temp_syl_dyn = syll_xx(st:en, :);

        [val idx] = max(mean(temp_syl_dyn));
        if st < offsets(end)
            iG_idx = [iG_idx idx];
        end
        rec_seq(st:en, idx) = 1;
        clear st en temp_syl_dyn
    end
    
    idx_g1 = iG_idx; % sequence of recognized syllables 

end