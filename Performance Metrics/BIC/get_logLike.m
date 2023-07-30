function [logLike] = get_logLike(syllables, real_input)
 
    [Ns T] = size(syllables);
    
    p = syllables; % predictions
    y = real_input; % traget values
    A = y.*log(p)+(1-y).*log(1-p);
    logLikeSyll =  sum(A');
    syllDur = sum(y'>0);
    
    logLike = sum(logLikeSyll./syllDur);    

end
