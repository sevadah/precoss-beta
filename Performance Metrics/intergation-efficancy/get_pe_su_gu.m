function [gamma_vv, syll_vv, pe_gamma_vv, pe_syll_vv] = get_pe_su_gu(sent_data, DEM)
    % getting syllable boundaries
    syllable_boundaries = sent_data.syllable_boundaries;
%     N_syl = length(syllable_boundaries) + 1; % so does not include silent unit

    % get causal states of level 2
    vv2 = full(DEM.qU.v{2})';
    % getting prediction errors of the level 2
    pEvv2 = full(DEM.qU.z{2})';
    
    
    % get dynamics of causal states of the syllable
    syll_vv = vv2(:, 10 : end); % with the silent unit
    pe_syll_vv = pEvv2(:, 10 : end); % with the silent unit
    
    % dynamics of the causal states of the gamma units
    gamma_vv = vv2(:, 1:8);
    pe_gamma_vv = pEvv2(:, 1:8);
    
end