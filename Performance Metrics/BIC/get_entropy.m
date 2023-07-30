function entr = get_entropy(syll_units)

    ss = softmax(syll_units')'; % to ensure that they are in (0 1) and sum to 1
    entr = -sum(ss.*log(ss),2); % per time point
    
end
