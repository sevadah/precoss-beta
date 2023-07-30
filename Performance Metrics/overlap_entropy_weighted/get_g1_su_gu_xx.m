function [gamma_xx, syll_xx, g1] = get_g1_su_gu_xx(sent_data, DEM)
    % getting syllable boundaries
    syllable_boundaries = sent_data.syllable_boundaries;
    Nsyl = length(syllable_boundaries)+1; % so does not include silent unit
    %         x(21 : 20 + Nsyl, 1);
    % get hidden states of level 2
    xx2 = full(DEM.qU.x{2})';

    % get dynamics of causal states of the syllable
    syllable_units = xx2(:, 21 : 20+Nsyl); % with the silent unit
    % dynamics of the causal states of the gamma units
    gammas = xx2(:, 9:16);

    % and there is at least 60ms before the next activated g1 unit
    g1 = gammas(:,1);
    [pks det_locs] = findpeaks(g1,'MinPeakDistance',60); 

    det_start = det_locs.*(pks>0.6);
    det_start(det_start < 0.5) = [];

    % with the Matlab's findpeaks function, from time to time
    % gamma unit at the beginning of the sentence was not detected (probably because of some boundary conditions)
    % although we know that it is the most active unit (in accordance with initial conditions)
    % thus we control for that occurrences.

    if isempty(det_start)
        det_start = [1];
    elseif det_start(1) > 25
        det_start = [1 det_start'];
    end

    g1 = det_start;
    gamma_xx = gammas;
    syll_xx = syllable_units;
end