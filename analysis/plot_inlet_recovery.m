% plot_inlet_recovery.m — Plot inlet total-pressure recovery vs. Mach
% SCRAMJET-ENGINE-DEV (MAE4321)
%
% Computes and plots Pt₂/P₀ versus freestream Mach for the default
% three-shock inlet geometry [2.480°, 0.506°, 0.514°].

clc; clear;

%% 1. Setup paths
thisFile    = mfilename('fullpath');
analysisDir = fileparts(thisFile);
utilsDir    = fullfile(analysisDir, 'utils');
addpath(analysisDir, utilsDir);

%% 2. Compute recovery over Mach sweep
Mvec     = linspace(2, 10, 41);
recovery = arrayfun(@(M) inlet_3shock(M).Pt2_P0, Mvec);

%% 3. Plot results
figure('Color', 'w');
plot(Mvec, recovery, 'LineWidth', 1.5);
grid on;
xlabel('Freestream Mach Number, M_0');
ylabel('Total-Pressure Recovery, P_{t2}/P_{t0}');
title('Inlet Total-Pressure Recovery vs. Mach');
xlim([min(Mvec), max(Mvec)]);
ylim([0, 1]);

%% 4. Save figure to figures/ directory
repoRoot = fileparts(analysisDir);       % project root
figDir   = fullfile(repoRoot, 'figures');
if ~exist(figDir, 'dir')
    mkdir(figDir);
end

outFile = fullfile(figDir, 'inlet_recovery_vs_Mach.png');
saveas(gcf, outFile);

fprintf('Inlet recovery plot saved to:\n  %s\n', outFile);
