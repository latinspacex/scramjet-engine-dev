%% run_sanity.m  –  one‑button smoke‑test for all SCRAM tasks
clc; clear;

addpath(fullfile(pwd, 'analysis'));
addpath(fullfile(pwd, 'analysis', 'utils'));

fprintf("------ SCRAMJET SMOKE‑TEST ------\n")

%% 2b  – M8 cycle
outM8 = scram_cycle_M8;   % <-- return a struct for easy access
disp(outM8)

%% 2c  – mass‑flow sizing (use cycle thrust)
W_takeoff = 1.0e6;        % N  (TEMP: replace w/ team value)
mdot_SJ   = massflow_sizing(outM8.F_mdot, W_takeoff);

fprintf("mdot needed @ TO :  %.1f  kg/s\n", mdot_SJ);

%% 2d  – 3‑shock inlet @ M4/6/8
for M = [4 6 8]
    res = inlet_3shock(M);
    fprintf("M%-2g  Pt2/P0 = %.3f  (η_d ~ %.2f%%)\n", ...
            M, res.Pt2_P0, res.eta_d*100 );
end

%% 2e‑f  – nozzle correlation (uses results from cycle)
noz   = nozzle_sizing(outM8.Pt4_P0, outM8.mdot); %#ok<*NASGU> 
