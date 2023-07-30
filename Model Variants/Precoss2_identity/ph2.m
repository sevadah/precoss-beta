function pi_v = ph2(x,v,h,M)

    Nsyl = length(x) - 22;

    % getting normalized (amplitude) oscillatory precision units
    b1 = x(21+Nsyl,1);
    b2 = x(22+Nsyl,1);
    %   b1s = b1./sqrt(b1*b1 + b2*b2);
    b2s = b2./sqrt(b1*b1 + b2*b2);
    
    pi_v(1:8,1) = 1.5; % precision of gamma causal states
    pi_v(9,1) = 7;  % precision of slow amplitude modulation
    pi_v(10 : 9 + Nsyl,1) = 2.5 + 2*b2s; % oscillatory precisions of syllable causal states
    
end
