% test_cycle_performance.m — Sanity check of scramjet cycle at Mach 6–8
% SCRAMJET-ENGINE-DEV (MAE4321)
%
% Runs the scram_cycle function at Mach 6, 7, and 8, and verifies that
% the design point (Mach 6) lies within the ideal-analysis bands for
% Isp, thrust-per-mass-flow, and fuel–air ratio.

clc; clear;
addpath('analysis', 'analysis/utils');

%% 1. Test setup
Mtests = [6, 7, 8];            % Mach numbers to test
Wreq   = 15000 * 9.81;         % Required thrust [N] (15,000 kg × g)

% Ideal-analysis target bands
Isp_band   = [900, 1200];      % Specific impulse [s]
Fmdot_band = [300,  800];      % Thrust per unit mass-flow [m/s]
f_band     = [0.02, 0.06];     % Fuel–air ratio

fprintf(' M   Pt4/P0   Isp (s)   F/mdot (m/s)   f (–)   Flag\n');

%% 2. Loop over Mach numbers
for M0 = Mtests
    out    = scram_cycle(M0, Wreq);
    Isp    = out.Isp;
    Fmdot  = out.F_mdot;
    f      = out.f;
    Pt4P0  = out.Pt4_P0;
    flags  = '';

    % Enforce target bands at Mach 6 only
    if M0 == 6
        if Isp < Isp_band(1) || Isp > Isp_band(2)
            flags = [flags ' Isp_OOR'];
        end
        if Fmdot < Fmdot_band(1) || Fmdot > Fmdot_band(2)
            flags = [flags ' Fmdot_OOR'];
        end
        if f < f_band(1) || f > f_band(2)
            flags = [flags ' f_OOR'];
        end
    end

    fprintf('%2.0f  %8.3f   %8.1f   %12.1f   %6.3f   %s\n', ...
            M0, Pt4P0, Isp, Fmdot, f, strtrim(flags));
end
