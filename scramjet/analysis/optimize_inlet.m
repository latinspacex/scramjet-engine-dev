% optimize_inlet_constrained.m
clc; clear;
addpath('scramjet/analysis','scramjet/analysis/utils');

total_deflection = 5.0;       % your chosen total turn
MachPoints      = [4,6,8];

lb  = [0.1,0.1,0.1];
ub  = [3.0,3.0,3.0];
Aeq = [1,1,1];
beq = total_deflection;

opts = optimoptions('fmincon',...
    'Display','off','Algorithm','sqp', ...
    'OptimalityTolerance',1e-6,'StepTolerance',1e-8);

fprintf('\nConstrained inlet optimization (M3≥1)  total_defl=%.1f°\n', total_deflection);
fprintf(' Mach |   θ₁   |   θ₂   |   θ₃   | Pt₂/P₀  |  M₃\n');
fprintf('-----------------------------------------------\n');

for M0 = MachPoints
    % Objective: maximize Pt2/P0  → minimize negative
    obj = @(th) -inlet_3shock(M0,th).Pt2_P0;

    % Nonlinear constraint: 1 - M3(th) ≤ 0  ⇒  M3 ≥ 1
    nonlcon = @(th) deal(1 - inlet_3shock(M0,th).M3, []);

    % Initial guess
    x0 = repmat(total_deflection/3,1,3);

    % Run fmincon
    [th_opt, negRec] = fmincon(obj, x0, [],[], Aeq,beq, lb,ub, nonlcon, opts);
    recov = -negRec;
    M3    = inlet_3shock(M0,th_opt).M3;

    fprintf('  %1.0f   | %5.3f | %5.3f | %5.3f |  %6.3f | %5.3f\n', ...
        M0, th_opt(1), th_opt(2), th_opt(3), recov, M3);
end
fprintf('\n');
