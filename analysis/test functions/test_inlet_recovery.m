% test_inlet_recovery.m — Verify 3-shock inlet total-pressure recovery
% SCRAMJET-ENGINE-DEV (MAE4321)
%
% Checks that Pt2/P0 from inlet_3shock at Mach 4, 6, and 8 lies in (0, 1].

clc; clear;
addpath('analysis', 'analysis/utils');

MachNumbers = [4, 6, 8];
fprintf(' Mach   Pt2/P0   Flag\n');

for M = MachNumbers
    res = inlet_3shock(M);
    rec = res.Pt2_P0;
    
    if isnan(rec)
        flag = 'NaN';
    elseif rec > 1
        flag = '>1';
    elseif rec <= 0
        flag = '<=0';
    else
        flag = '';
    end
    
    fprintf('%5.1f    %6.3f   %s\n', M, rec, flag);
end

