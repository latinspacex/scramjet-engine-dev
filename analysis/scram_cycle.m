function out = scram_cycle(M0, Wreq)
        % scram_cycle  —  Ideal Farokhi‐style scramjet cycle
        % Part of SCRAMJET-ENGINE-DEV (AE4321 Final)
        %
        %   out = scram_cycle(M0, Wreq)
        %
        % Inputs:
        %   M0   — Freestream Mach number
        %   Wreq — Required net thrust [N]
        %
        % Outputs (struct out):
        %   Isp       — Specific impulse [s]
        %   F_mdot    — Thrust per unit mass‐flow [m/s]
        %   f         — Fuel–air ratio
        %   Pt4_P0    — Total‐pressure ratio after inlet
        %   P4_static — Exit static pressure [Pa]
        %   mdot      — Mass‐flow [kg/s]
        
            %% 1. Paths & Flight Conditions
            addpath('analysis/utils');
            alt_ft = 110000;                      % Cruise altitude [ft]
            [P0, T0, ~, a0] = atmos_isa(alt_ft);  % P0 [Pa], T0 [K], a0 [m/s]
        
            %% 2. Constants & Gamma Split
            gamma_in  = 1.4;   % Inlet/diffuser
            gamma_noz = 1.3;   % Combustor/nozzle
            R         = 287;   % J/(kg·K)
            cp        = 1005;  % J/(kg·K)
            Qr        = 42.8e6;% J/kg (Jet‑A)
            eta_b     = 0.95;  % Combustor efficiency
            g0        = 9.81;  % m/s^2
        
            %% 3. Inlet Compression
            tau_r  = 1 + 0.5*(gamma_in - 1)*M0^2;
            Pt2_P0 = 0.95 * tau_r^(gamma_in/(gamma_in - 1));
            T2s    = T0;                  % Static T2 ≈ T0
            Tt2    = T0 * tau_r;          % Total T2
        
            %% 4. Combustor (Farokhi static-T model)
            M4   = 1.0;                    % Thermal choke Mach
            T4s  = 2220;                   % Static combustor exit T [K]
            f    = cp * (T4s - T2s) / (eta_b * Qr);  % Fuel–air ratio
            Tt4  = T4s * (1 + 0.5*(gamma_noz - 1)*M4^2);
            Pt4  = Pt2_P0 * P0;            % Total‐pressure constant
        
            %% 5. Nozzle Sizing & Exit Conditions
            % 5a) Interpolate Ae/At from NPR curve (γ=1.3)
            data  = load('analysis/nozzle_data.mat', 'NPR_vec', 'AR_vec');
            NPR   = Pt4 / P0;
            Ae_At = interp1(data.NPR_vec, data.AR_vec, NPR, 'pchip', 'extrap');
        
            % 5b) Solve exit Mach from area ratio
            M9 = M_from_AR(Ae_At, gamma_noz);
        
            % 5c) Compute exit static conditions
            T9s = Tt4 / (1 + 0.5*(gamma_noz - 1)*M9^2);
            P9  = Pt4 * (1 + 0.5*(gamma_noz - 1)*M9^2)^(-gamma_noz/(gamma_noz - 1));
        
            % 5d) Velocities
            V9 = sqrt(gamma_noz * R * T9s) * M9;
            V0 = a0 * M0;
        
            %% 6. Mass‐Flow & Thrust
            thrust_per_kg = (1 + f)*V9 - V0;
            mdot          = Wreq / thrust_per_kg;
            At            = mdot / (Pt4 * sqrt(gamma_noz/(R*Tt4)) ...
                             * (2/(gamma_noz + 1))^((gamma_noz + 1)/(2*(gamma_noz - 1))));
            Ae            = At * Ae_At;
            thrust_pt     = (P9 - P0) * (Ae / mdot);
            F_mdot        = thrust_per_kg + thrust_pt;
            Isp           = F_mdot / (f * g0);
        
            %% 7. Package Outputs
            out.Isp       = Isp;
            out.F_mdot    = F_mdot;
            out.f         = f;
            out.Pt4_P0    = Pt2_P0;
            out.P4_static = P9;
            out.mdot      = mdot;
        
        end
        