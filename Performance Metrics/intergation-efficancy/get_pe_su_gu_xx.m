function [gamma_xx, syll_xx, pe_gamma_xx, pe_syll_xx] = get_pe_su_gu_xx(sent_data, DEM)
    % getting syllable boundaries
    syllable_boundaries = sent_data.syllable_boundaries;
    N_syl = length(syllable_boundaries) + 1; 
    % get causal states of level 2
    xx2 = full(DEM.qU.x{2})';
    % getting prediction errors of the level 2
    pExx2 = full(DEM.qU.w{2})';
    
    
    % get dynamics of causal states of the syllable
    syll_xx = xx2(:, 21 : 20 + N_syl); % with the silent unit
    pe_syll_xx = pExx2(:, 21 : 20 + N_syl); % with the silent unit
    
    % dynamics of the causal states of the gamma units
    gamma_xx = xx2(:, 9:16);
    pe_gamma_xx = pExx2(:, 9:16);
    
end