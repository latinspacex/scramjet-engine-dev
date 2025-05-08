function out = scram_cycle(M0, Wreq, thetas)
    % scram_cycle  –  Ideal Farokhi‑style scramjet cycle
    % now uses realistic static‑pressure rise from inlet_3shock
    
    addpath('analysis/utils');
    alt_ft = 110000;
    [P0,T0,~,a0] = atmos_isa(alt_ft);

    gamma_noz = 1.3;
    R         = 287;
    cp        = 1005;
    Qr        = 42.8e6;
    eta_b     = 0.95;
    g0        = 9.81;

    % default inlet angles if none provided
    if nargin<3, thetas = [4,4,8]; end

    % 1) Inlet recovery (total & static)
    inlet = inlet_3shock(M0,thetas);
    Pt2_P0 = inlet.Pt2_P0;
    Ps2_P0 = inlet.P2_P0;

    Pt2 = Pt2_P0 * P0;     % total pressure into combustor
    P4  = Ps2_P0 * P0;     % static pressure into combustor

    % 2) Combustor (constant P4, T4s)
    T4s = 2220;            % static combustor exit T [K]
    f   = cp*(T4s - T0)/(eta_b*Qr);

    % total temp into nozzle (M4=1 choke)
    Tt4 = T4s * (1 + 0.5*(gamma_noz-1)*1^2);

    % 3) Nozzle expansion
    data   = load('analysis/nozzle_data.mat','NPR_vec','AR_vec');
    Ae_At  = interp1(data.NPR_vec,data.AR_vec,Pt2/P0,'pchip','extrap');
    M9     = M_from_AR(Ae_At,gamma_noz);

    T9s = Tt4 / (1 + 0.5*(gamma_noz-1)*M9^2);
    V9  = sqrt(gamma_noz*R*T9s)*M9;
    V0  = a0 * M0;

    % 4) Thrust & Isp
    thrust_per_kg = (1+f)*V9 - V0;
    mdot          = Wreq / thrust_per_kg;
    Fmdot         = thrust_per_kg + (P9 - P0)*( (mdot*Ae_At)/mdot );

    Isp = Fmdot / (f*g0);

    % 5) Package outputs
    out.Isp       = Isp;
    out.F_mdot    = Fmdot;
    out.f         = f;
    out.Pt4_P0    = Pt2_P0;
    out.P4_static = P4;
    out.mdot      = mdot;

    fprintf('scram_cycle @ M=%.1f, θ=[%.1f,%.1f,%.1f]: P4=%.1f Pa, Isp=%.1f s\n', ...
            M0, thetas, P4, Isp);
end
