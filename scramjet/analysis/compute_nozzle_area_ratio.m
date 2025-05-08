% compute_nozzle_area_ratio.m  —  calculate Ae/At for given flight points

clc; clear;
addpath('scramjet/analysis','scramjet/analysis/utils');

%% 1) Flight points & constants
MachPoints = [4, 6, 8];
alt_ft     = 110000;
[P0,~,~,~] = atmos_isa(alt_ft);
gamma_in   = 1.4;

%% 2) Load digitized nozzle curve
load('scramjet/analysis/nozzle_data.mat','NPR_vec','AR_vec');

%% 3) Preallocate
N    = numel(MachPoints);
NPR  = zeros(1,N);
NPRc = zeros(1,N);
AeAt = zeros(1,N);

%% 4) Loop over Mach points
for i = 1:N
    M0 = MachPoints(i);

    % a) Inlet recovery
    recov = inlet_3shock(M0, [2.485,1.529,0.986]).Pt2_P0;

    % b) Freestream total pressure
    tau_r = 1 + 0.5*(gamma_in-1)*M0^2;
    Pt0   = P0 * tau_r^(gamma_in/(gamma_in-1));

    % c) Combustor‐face total pressure
    Pt4   = recov * Pt0;

    % d) NPR: ratio of P_t4 to static P0
    NPR(i) = Pt4 / P0;

    % e) Clamp this NPR(i) to the valid data range
    NPRc(i) = min( max(NPR_vec), max(min(NPR_vec), NPR(i)) );

    % f) Interpolate Ae/At without extrapolation
    AeAt(i) = interp1(NPR_vec, AR_vec, NPRc(i), 'pchip');
end

%% 5) Display
fprintf(' Mach |    NPR    | NPR_clamped |  A_e/A_t\n');
fprintf('-------------------------------------------\n');
for i=1:N
    fprintf('  %2.0f  | %8.1f |    %8.1f |   %6.3f\n', ...
            MachPoints(i), NPR(i), NPRc(i), AeAt(i));
end