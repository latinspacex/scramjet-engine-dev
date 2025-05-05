function [M2, Pt2_Pt1] = obliqueShock(M1, theta_deg, branch)
    % obliqueShock  –  Computes downstream Mach and total-pressure ratio
    % for an oblique shock followed by flow turning.
    %
    %   [M2, Pt2_Pt1] = obliqueShock(M1, theta_deg, branch)
    %
    % Inputs:
    %   M1        — Freestream Mach number
    %   theta_deg — Deflection angle [deg]
    %   branch    — 'weak' or 'strong' solution branch (currently only weak)
    %
    % Outputs:
    %   M2         — Downstream Mach number
    %   Pt2_Pt1    — Total-pressure ratio through oblique + normal shock
    
        %% 1. Setup
        gamma = 1.4;
        theta = deg2rad(theta_deg);
    
        %% 2. Solve Θ–β–M relation for shock angle β
        eq = @(beta) tan(theta) ...
            - 2*cot(beta) .* (M1.^2 .* sin(beta).^2 - 1) ...
              ./ (M1.^2*(gamma + cos(2*beta)) + 2);
    
        beta0 = theta + (pi/2 - theta)/2;  % initial guess between θ and π/2
        opts  = optimset('Display','off');
        beta  = fsolve(eq, beta0, opts);
    
        %% 3. Normal-shock component
        Mn1 = M1 * sin(beta);
        Pt2_Pt1_n = (1 + (gamma-1)/2*Mn1^2)^(gamma/(gamma-1)) ...
                   / (gamma*Mn1^2 - (gamma-1)/2)^(1/(gamma-1));
        Mn2 = sqrt((1 + (gamma-1)/2*Mn1^2) ...
                 / (gamma*Mn1^2 - (gamma-1)/2));
    
        %% 4. Downstream Mach after turning
        M2 = Mn2 / sin(beta - theta);
    
        %% 5. Total-pressure recovery (clamp ≤1)
        Pt2_Pt1 = min(Pt2_Pt1_n, 1.0);
    end
    