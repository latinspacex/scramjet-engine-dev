% test_oblique.m — Sanity check of obliqueShock total-pressure ratios
% SCRAMJET-ENGINE-DEV (MAE4321 Final)
%
% Verifies that obliqueShock returns 0 < Pt2/Pt1 ≤ 1 for selected Mach
% numbers and deflection angles.

clc; clear;
addpath('analysis', 'analysis/utils');

MachNumbers = [4, 6, 8];       % Freestream Mach numbers to test
DeflAngles  = [0.5, 1, 2, 5];   % Shock deflection angles [deg]

fprintf(' M   θ (deg)   Pt2/Pt1   Flag\n');
for M = MachNumbers
    for theta = DeflAngles
        [~, Pt_ratio] = obliqueShock(M, theta, 'weak');
        
        if isnan(Pt_ratio)
            flag = 'NaN';
        elseif Pt_ratio > 1
            flag = '>1';
        else
            flag = '';
        end
        
        fprintf('%4.0f     %4.1f     %6.3f   %s\n', ...
                M, theta, Pt_ratio, flag);
    end
end
