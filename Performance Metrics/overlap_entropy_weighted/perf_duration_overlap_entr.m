function r = perf_duration_overlap_entr(syll_xx, g1, onsets, offsets, entr)
    N_syl = length(onsets);

    % no softmax on syllable units

    inp_seq = zeros(length(syll_xx), N_syl); % no silent unit
    rec_seq = zeros(length(syll_xx), N_syl+1); % with silent unit

    % getting sequence of recognized syllables
    for iG = 1 : length(g1)-1
        st = g1(iG);
        en = g1(iG+1);
        temp_syl_dyn = syll_xx(st:en, :);

        [val idx] = max(mean(temp_syl_dyn));
        rec_seq(st:en, idx) = 1;
        clear st en temp_syl_dyn
    end

    % getting sequence of syllable units
    for iSyl = 1 : N_syl
        st = onsets(iSyl);
        en = offsets(iSyl);

        inp_seq(st:en, iSyl) = 1;
    end

    perf_dot = inp_seq(1 : offsets(end), :).*rec_seq( 1 : offsets(end), 1 : N_syl);
    
    r = sum(sum(perf_dot').*(1-entr(1:offsets(end)))')/offsets(end);
end