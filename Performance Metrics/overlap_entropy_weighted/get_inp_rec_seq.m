function [inp_seq, nrec_seq, rec_seq] = get_inp_rec_seq(syll_vv, g1, onsets, offsets)

    N_syl = length(onsets); 
    
    % getting sequenc of syllable units, where we set 1 to the max, and 0
    % to the rest for each time point
    su = syll_vv; % excluding silent unit
    [val idx] = max(su');
    clear su;
    for i = 1 : length(onsets)+1
        su(abs(idx-i)<1,i) = 1; 
    end
    
    nrec_seq = su;
    
    inp_seq = zeros(length(syll_vv), N_syl);
    rec_seq = zeros(length(syll_vv), N_syl+1);
    
    % getting sequence of recognized syllables
    for iG = 1 : length(g1)-1
		st = g1(iG);
		en = g1(iG+1);
		temp_syl_dyn = su(st:en, :);

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
end