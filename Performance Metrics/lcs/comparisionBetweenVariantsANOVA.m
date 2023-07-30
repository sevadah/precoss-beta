modelNames = {'Precoss2_identity', ...
            'Precoss2_timing', ...
            'Precoss2_full_antiphase', ...
            'Precoss2_full_samephase'};
shortNames = {'A', 'B', 'C', 'D'};
longNames = {'Precoss-b-identity', 'Precoss-b-timing', 'Precoss-b-full-anti-phase', 'Precoss-b-full-same-phase'};

tagNames = {'2 Hz', ...
    '5 Hz', ...
    '10 Hz', ...
    '20 Hz', ...
    '30 Hz', ...
    '40 Hz', ...
    '50 Hz', ...
    '60 Hz'};
tagCont = [2 5 10 20 30 40 50 60];

y = [];
g1 = [];
g2 = [];
g3 = [];
g4 = [];

for iModel =  1 : length(modelNames)
    
    fname = modelNames{iModel};
    load(['perf_' fname '.mat']);
    perf = perf_lcs_ratio;
    perf_jamovi = zeros(220*8, 1);

    sents = sent_IDs';
    Mtype = repmat(shortNames{iModel}, 8*220,1);
    for i = 1 : 8
        sIDs((i-1)*220+1 : i*220, 1) = sents;
        perf_jamovi((i-1)*220+1 : i*220, 1) = perf(:, i);
        tag_freq((i-1)*220+1 : i*220, 1) = tagNames(i);
        tag_freq_cont((i-1)*220+1 : i*220, 1) = tagCont(i);
    end
    
    y = [y; perf_jamovi];
    g1 = [g1; tag_freq];
    g2 = [g2; Mtype];
    g3 = [g3; sIDs];
    g4 = [g4; tag_freq_cont];
    
end

[~,~,stats] = anovan(y,{g2 g4},"Model","interaction", "Varnames",["g2","g4"], 'continuous',[2])
% [~,~,stats] = anovan(y,{g2 g4},"Model","interaction", "Varnames",["g2","g4"])

[results,~,~,gnames] = multcompare(stats,"Dimension",[1 1], 'Ctype', 'bonferroni')

results(:,3:end-1) = round(results(:,3:end-1), 4)

tbl = array2table(results,"VariableNames", ...
    ["M1","M2","lower bound","mean diff.","upper bound","p-value"]);
tbl.("M1") = longNames(results(:,1))';
tbl.("M2") = longNames(results(:,2))';