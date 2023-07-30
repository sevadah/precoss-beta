function [syllables, real_input] = get_y_syllables_xx(DEM, sent_data)
% getting real input
syllable_boundaries = sent_data.syllable_boundaries;
startTime = syllable_boundaries(1,:);
endTime = syllable_boundaries(2,:);

% re align so the first syllable onset is the start of the sentence 
% (in TIMIT there is initial 0-padding)
startT = startTime - startTime(1) + 1;
endT = endTime - startTime(1) + 1;

N_syl = length(startT); % without silent


% get causal states of level 2
% vv2 = full(DEM.qU.v{2})';
xx2 = full(DEM.qU.x{2})';

syll_units = xx2(:, 21 : 20 + N_syl+1); % with the silent unit
ss = softmax(syll_units')';
% get dynamics of causal states of the syllable

syllables = ss(1 : endT(end), 1:end-1); % without the silent unit

real_input=zeros(N_syl, length(syllables)); 

for iSyl = 1 : length(startT)
    st = startT(iSyl);
    en = endT(iSyl);

    real_input(iSyl, st:en) = 1;
    clear st en temp_syl_dyn
end
syllables = syllables';

end
