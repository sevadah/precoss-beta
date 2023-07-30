function LAP = DoLAPInference_theta(sent_data)

    N1 = 6; N2 = 8;


    I = sent_data.P_all; % load syllable parameters - stored spectrotemporal patterns
    E0 = sent_data.slow_amod; % load slow amplitude modulation
    Y0 = sent_data.aud_sptg; % load frequency channel dynamics
    syllable_boundaries = sent_data.syllable_boundaries; % syllable boundaries


    Y0(7, 1:end) = E0;
    Y = Y0(:, syllable_boundaries(1,1) : end);
    %     clear Y0 E0

    Nsyl = length(I);


    %% setting precisions

    % level 1
    % precision for the hidden states
    Wh1(1:N1, 1) = exp(15); % time-frequency decomp. / spectral content
    % causal states
    Vh1(1:N1,1) = exp(10);  % time-frequency decomp. / spectral content
    Vh1(N1+1,1) = exp(10);  % slow amplitude modulation / input
    % level 2
    % hidden states
    Wh2(1 : 2*N2, 1) = exp(5); % gamma units
    Wh2(2*N2 + 1,  1) = exp(5); % preferred gamma sequence duration/speed

    Wh2(2*N2 + 2,  1) = exp(7); % theta
    Wh2(2*N2 + 3,  1) = exp(7); % theta

    Wh2(2*N2 + 4,  1) = exp(15); % slow amplitude modulation / input

    Wh2(2*N2 + 5 : 2*N2+Nsyl+4,  1) = exp(3); % syllable unit
    Wh2(end,1) = exp(1); % silent unit has lower precision


    Wh2(2*N2 + Nsyl + 5, 1) = exp(7);
    Wh2(2*N2 + Nsyl + 6, 1) = exp(7);


    % causal states
    Vh2(1 : N2, 1) = exp(1.5); % gamma units
    Vh2(N2+1, 1) = exp(7); % slow amplitude modulation / input

    Vh2(N2+2 : N2+Nsyl+1,1) = exp(5); % syllable units


    %% initiating the model

    ilevel = 0;
    M(1).E.s = 1;
    M(1).E.K = exp(-3);
    M(1).E.dt = 1;
    M(1).E.methods.x = 1;
    M(1).nograph = 1;
    % M(ilevel).E.methods.v = 1;

    %% level 1
    ilevel = ilevel + 1;

    x1 = zeros(N1,1);

    M(ilevel).x = x1; % frequency channels
    M(ilevel).f = 'spm_F1_theta';
    M(ilevel).g = 'spm_G1_theta';

    M(ilevel).V = Vh1;
    M(ilevel).W = Wh1;

    M(ilevel).pE = I;

    %% level 2
    ilevel = ilevel + 1;
    % gamma units
    x2(1 : 8,1)= [2.9694 -0.9939 -3.7408 -4.2104 -4.2352 -4.3895 -5.6266 -1.4123]';
    x2(9 : 16,1)= [0.9669 0.0179 0.0012 0.0007 0.0007 0.0006 0.0002 0.0117]';

    x2(17,1) = 1; % gamma_speed

    x2(18,1) = -1; % theta
    x2(19,1) = 0; % theta

    x2(20,1) = 0; % input

    x2(21 : 20 + Nsyl,1) = -1; % syllable unit

    % precision units
    x2(21 + Nsyl, 1) = -1;
    x2(22 + Nsyl, 1) = 0;

    M(ilevel).x = x2;
    M(ilevel).f = 'spm_F2_v1';
    M(ilevel).g = 'spm_G2_theta';

    % M(ilevel).V = Vh2; % remove the fixed precisions for the causal states 
    M(ilevel).V = [];
    M(ilevel).W = Wh2;

    M(ilevel).ph = 'ph2'; % causal states precisions are state dependent (ph2 function)

    %% running DEM and LAP
    LAP.Y = Y;
    LAP.M = M;

    % spm_figure('GetWin','LAP');
    LAP = spm_LAP(LAP);

end