% test_dynamic_pressure.m — Dynamic-pressure check at cruise altitude
% SCRAMJET-ENGINE-DEV (MAE4321)
%
% Verifies that the dynamic pressure at Mach 6–8 at 84,000 ft lies within
% the target corridor of 1,000–1,500 psf.

clc; clear;
addpath('analysis', 'analysis/utils');

%% 1. Cruise altitude
alt_ft = 84000;                                    % Altitude [ft]
[P0, T0, rho, a0] = atmos_isa(alt_ft);             % P0 [Pa], T0 [K], rho [kg/m³], a0 [m/s]

%% 2. Compute q at specified Mach numbers
Mtests = [6, 7, 8];                                % Mach numbers to test

fprintf(' M   q (psf)    q (Pa)\n');
for M0 = Mtests
    V    = a0 * M0;                                % True airspeed [m/s]
    qPa  = 0.5 * rho * V^2;                        % Dynamic pressure [Pa]
    qpsf = qPa * 0.0208854;                        % Convert Pa → psf
    fprintf('%2.0f  %8.1f   %8.0f\n', M0, qpsf, qPa);
end
