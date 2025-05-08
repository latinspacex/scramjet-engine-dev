% test_requirement_2b_true_static.m – corrected freestream total‑pressure

clc; clear;
addpath('analysis','analysis/utils');

%% 1) Freestream & gas constants
M0     = 8.0;
alt_ft = 110000;
[P0,T0,~,a0] = atmos_isa(alt_ft);

gamma = 1.4;
R     = 287;
cp    = 1005;
Qr    = 42.8e6;
eta_b = 0.95;
g0    = 9.81;

%% 2) Freestream stagnation pressure
tau_r = 1 + 0.5*(gamma-1)*M0^2;
Pt0   = P0 * tau_r^(gamma/(gamma-1));

%% 3) Inlet recovery with optimized wedges @ Mach 8
thetas = [3.000, 1.464, 0.536];          % optimized for M8
inlet   = inlet_3shock(M0, thetas);     % returns .Pt2_P0 and .M3
Pt2_P0  = inlet.Pt2_P0;                 % total‑pressure recovery
M3      = inlet.M3;                     % Mach after 3rd shock

% static‐pressure recovery via isentropic
P2_P0   = Pt2_P0 / (tau_r^(gamma/(gamma-1)));

Pt2 = Pt2_P0 * Pt0;                     % P_t2 [Pa]
P4  = P2_P0  * P0;                      % P2 static = combustor static P4

%% 4) Combustor & nozzle → Isp
T4s = 2220;                             % combustor static temp [K]
f   = cp*(T4s - T0)/(eta_b*Qr);         % fuel–air ratio

% analytic expansion Mach from Pt2/P0
ratio = Pt2 / P0;
if ratio <= 1
    M9 = NaN;
else
    M9 = sqrt(2/(gamma-1)*(ratio^((gamma-1)/gamma)-1));
end

if ~isnan(M9)
    Tt4  = T4s * (1 + 0.5*(gamma-1)*1^2);   % total T at combustor exit
    T9s  = Tt4 / (1 + 0.5*(gamma-1)*M9^2);
    V9   = sqrt(gamma*R*T9s) * M9;
    V0   = a0 * M0;
    Isp  = ((1+f)*V9 - V0)/(f*g0);
else
    V9  = NaN;
    Isp = NaN;
end

%% 5) Report
fprintf('\nReq 2b) corrected total‑P usage @ M=8:\n');
fprintf('  Ambient P0            = %.1f Pa\n', P0);
fprintf('  Stag P0 (Pt0)         = %.1f Pa\n', Pt0);
fprintf('  Inlet Pt2             = %.1f Pa\n', Pt2);
fprintf('  Combustor static P4   = %.1f Pa\n', P4);
fprintf('  Mach after shocks M3  = %.3f\n', M3);
fprintf('  Fuel–air ratio f      = %.4f\n', f);
if isnan(M9)
    fprintf('  Exit Mach M9          = NaN (no supersonic expansion)\n');
else
    fprintf('  Exit Mach M9          = %.3f\n', M9);
    fprintf('  Exit vel V9           = %.1f m/s\n', V9);
    fprintf('  Specific impulse Isp  = %.1f s\n', Isp);
end
fprintf('\n');
