% find_cruise_altitude.m — Determine altitude for q ≈ 1200 psf at Mach 6
% SCRAMJET-ENGINE-DEV (MAE4321)
%
% Scans altitudes between 60 000–90 000 ft to find which yields 
% dynamic pressure ≈ 1200 psf at Mach 6.

clc; clear;
addpath('analysis', 'analysis/utils');

%% 1. Parameters
target_qpsf = 1200;                 % Desired dynamic pressure [psf]
M0          = 6;                    % Mach number for sizing
alts_ft     = linspace(60000, 90000, 31);  % Altitude sweep [ft]

qerrs     = zeros(size(alts_ft));   % Error from target at each altitude
qpsf_vals = zeros(size(alts_ft));   % Computed q [psf] at each altitude

%% 2. Sweep altitudes
for i = 1:length(alts_ft)
    alt = alts_ft(i);
    [~, ~, rho, a0] = atmos_isa(alt);   % rho [kg/m³], a0 [m/s]
    V    = a0 * M0;                     % True airspeed [m/s]
    qPa  = 0.5 * rho * V^2;             % Dynamic pressure [Pa]
    qpsf = qPa * 0.0208854;             % Convert Pa → psf
    
    qerrs(i)     = abs(qpsf - target_qpsf);
    qpsf_vals(i) = qpsf;
end

%% 3. Find best altitude
[~, idx]  = min(qerrs);
best_alt  = alts_ft(idx);
best_qpsf = qpsf_vals(idx);

fprintf('Best cruise altitude ≈ %.0f ft → q₆ ≈ %.1f psf\n', ...
        best_alt, best_qpsf);
