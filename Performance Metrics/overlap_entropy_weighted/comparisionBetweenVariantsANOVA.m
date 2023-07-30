modelNames = {'Precoss2_identity', ...
            'Precoss2_timing', ...
            'Precoss2_full_antiphase', ...
            'Precoss2_full_samephase'};
shortNames = {'A', 'B', 'C', 'D'};
sing_sent = [64 70 131 32 77 182];

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

N_sent = 220 - length(sing_sent);
for iModel =  1 : length(modelNames)
    
    fname = modelNames{iModel};
    load([fname '.mat']);
    perf(sing_sent, :) = [];
    
    perf_jamovi = zeros(N_sent*8, 1);

    sents = sent_IDs';
%     sents(182) = [];
    Mtype = repmat(shortNames{iModel}, 8*N_sent,1);
    for i = 1 : 8

        perf_jamovi((i-1)*N_sent+1 : i*N_sent, 1) = perf(:, i);
        tag_freq((i-1)*N_sent+1 : i*N_sent, 1) = tagNames(i);
        tag_freq_cont((i-1)*N_sent+1 : i*N_sent, 1) = tagCont(i);
    end
    
    y = [y; perf_jamovi];
    g1 = [g1; tag_freq];
    g2 = [g2; Mtype];
%     g3 = [g3; sIDs];
    g4 = [g4; tag_freq_cont];
    
end

[~,~,stats] = anovan(y,{g2 g4},"Model","interaction", "Varnames",["g2","g4"], 'continuous',[2])

[results,~,~,gnames] = multcompare(stats,"Dimension",[1 1], 'Ctype', 'bonferroni')

results(:,3:end-1) = round(results(:,3:end-1), 4)

tbl = array2table(results,"VariableNames", ...
    ["M1","M2","lower bound","mean diff.","upper bound","p-value"]);
tbl.("M1") = longNames(results(:,1))';
tbl.("M2") = longNames(results(:,2))';