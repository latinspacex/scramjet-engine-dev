% optimize_inlet.m  –  Optimize practical 3-shock inlet deflection angles for Mach 6–8

clc; clear;
addpath('analysis', 'analysis/utils');

% ------------------------------------------------------------------------------
% 1. Design guidance: total deflection
% ------------------------------------------------------------------------------
total_deflection = 3.5;              % [deg] practical constraint for Mach 6

% ------------------------------------------------------------------------------
% 2. Optimization setup
% ------------------------------------------------------------------------------
x0   = repmat(total_deflection / 3, 1, 3);   % initial guess
lb   = [0.1, 0.1, 0.1];                      % lower bounds on wedge angles [deg]
ub   = [3.0, 3.0, 3.0];                      % upper bounds on wedge angles [deg]
Aeq  = [1, 1, 1];                            % equality constraint: sum = total_deflection
beq  = total_deflection;

opts = optimoptions('fmincon', ...
    'Display', 'iter', ...
    'Algorithm', 'sqp');

% ------------------------------------------------------------------------------
% 3. Objective function – minimize worst-case recovery loss
% ------------------------------------------------------------------------------
obj = @(th) -min(arrayfun(@(M) inlet_3shock(M, th).Pt2_P0, [6, 7, 8]));

% ------------------------------------------------------------------------------
% 4. Solve
% ------------------------------------------------------------------------------
[thetas_opt, neg_recov] = fmincon(obj, x0, [], [], Aeq, beq, lb, ub, [], opts);
worst_recov = -neg_recov;

% ------------------------------------------------------------------------------
% 5. Report results
% ------------------------------------------------------------------------------
fprintf('Practical total deflection: %.1f°\n', total_deflection);
fprintf('Optimal angles: [%.3f, %.3f, %.3f]°\n', thetas_opt);
fprintf('Worst‑case recovery (Pt2/P0) = %.4f\n', worst_recov);
