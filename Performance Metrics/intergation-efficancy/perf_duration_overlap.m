function r = perf_duration_overlap(syll_vv, g1, onsets, offsets)
    N_syl = length(onsets);

    % no softmax on syllable units

    inp_seq = zeros(length(syll_vv), N_syl); % no silent unit
    rec_seq = zeros(length(syll_vv), N_syl+1); % with silent unit

    % getting sequence of recognized syllables
    for iG = 1 : length(g1)-1
        st = g1(iG);
        en = g1(iG+1);
        temp_syl_dyn = syll_vv(st:en, :);

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

    perf_dot = inp_seq.*rec_seq(:, 1 : N_syl);

    r = sum(sum(perf_dot))/offsets(end);
end