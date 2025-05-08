% plot_inlet_recovery_configs.m — Plot inlet recovery for Mach‑tailored inlets + η_d=0.95

clc; clear;
addpath('analysis','analysis/utils');

%% 1) Mach sweep
Mvec = linspace(4, 10, 31);   % start at Mach 4

%% 2) Fixed‐geometry configurations
theta4 = [2.485, 1.529, 0.986];   % optimized for Mach 4
theta6 = [2.694, 1.617, 0.689];   % optimized for Mach 6
theta8 = [3.000, 1.464, 0.536];   % optimized for Mach 8

rec4 = arrayfun(@(M) inlet_3shock(M,theta4).Pt2_P0, Mvec);
rec6 = arrayfun(@(M) inlet_3shock(M,theta6).Pt2_P0, Mvec);
rec8 = arrayfun(@(M) inlet_3shock(M,theta8).Pt2_P0, Mvec);

%% 3) Load η_d=0.95 reference
data         = load('analysis/utils/pressure_recovery_curve.mat','M_emp','eta95');
eta95_interp = interp1(data.M_emp, data.eta95, Mvec, 'pchip','extrap');

%% 4) Plot
figure('Color','w'); hold on;
plot(Mvec, rec4, '-','LineWidth',1.5, 'DisplayName','Opt @ M4   [2.485,1.529,0.986]°');
plot(Mvec, rec6, '--','LineWidth',1.5, 'DisplayName','Opt @ M6   [2.694,1.617,0.689]°');
plot(Mvec, rec8, ':','LineWidth',1.5, 'DisplayName','Opt @ M8   [3.000,1.464,0.536]°');
plot(Mvec, eta95_interp, '-.k','LineWidth',2,   'DisplayName','η_d=0.95 reference');

grid on;
xlim([4, max(Mvec)]);
xlabel('Freestream Mach Number, M_0');
ylabel('Total‑Pressure Recovery, P_{t2}/P_{t0}');
title('Three‑Shock Inlet Recovery: Mach‑Tailored vs η_d=0.95 Curve');
legend('Location','southwest','Interpreter','none');

%% 5) Save figure
figDir = fullfile(fileparts(mfilename('fullpath')),'..','figures');
if ~exist(figDir,'dir'), mkdir(figDir); end
outFile = fullfile(figDir,'inlet_recovery_configs.png');
saveas(gcf, outFile);
fprintf('Saved figure to:\n  %s\n', outFile);

