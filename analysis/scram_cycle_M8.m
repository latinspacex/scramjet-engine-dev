function out = scram_cycle_M8()
    % scram_cycle_M8  –  Ideal scramjet @ M0 = 8, T4 = 4000 °R (≈2222 K)
    % Returns out.P4_static, out.Isp, out.F_mdot, out.f, out.Pt4_P0, out.mdot
    
        %% 1. FLIGHT CONDITIONS (ISA)
        M0  = 8;                   
        alt = 110000;              % [ft]
        [P0,T0,~,a0] = atmos_isa(alt);
    
        %% 2. CONSTANTS
        gamma   = 1.4;
        R       = 287;             % J/(kg·K)
    
        %% 3. COMPRESSION TO STN 3
        tau_r  = 1 + 0.5*(gamma-1)*M0^2;      
        Pt2_P0 = 0.95 * tau_r^(gamma/(gamma-1));
        T2     = T0 * (1 + 0.5*(gamma-1)*M0^2) / (1 + 0.5*(gamma-1)*M0^2);
    
        %% 4. COMBUSTOR
        T4     = 2222;             % K
        gamma_c= 1.3;                        
        cp_c   = 1250;             % J/kg·K
        Qr     = 42.8e6;           % J/kg
        eta_b  = 0.95;
        f      = cp_c*(T4 - T2) / (eta_b*Qr);
    
       %% 5. EXIT WITH FORCED VELOCITY & PRESSURE THRUST
        % Force exit Mach to a high value
        M9 = 3.0;                      % arbitrary high exit Mach
        T9 = T4 / (1 + 0.5*(gamma_c - 1)*M9^2);
        P9 = P0 * (T9/T0)^(gamma_c/(gamma_c-1));
        V9 = sqrt(gamma_c * R * T9) * M9;
        V0 = a0 * M0;
    
        % Use a larger exit area for sanity
        mdot = 1;                      % 1 kg/s
        Ae   = 0.1;                    % 0.1 m² exit area
    
        thrust_mom = (1+f)*V9 - V0;
        thrust_pt  = (P9 - P0)*Ae/mdot;
        F_mdot     = thrust_mom + thrust_pt;
        Isp        = F_mdot / f / 9.81;
    
        %% 6. PACKAGE OUTPUTS
        out.P4_static = P0 * T4 / T0;
        out.Isp        = Isp;
        out.F_mdot     = F_mdot;
        out.f          = f;
        out.Pt4_P0     = Pt2_P0;
        out.mdot       = mdot;
    
        % Debug marker
        disp('*** USING FUNCTION scram_cycle_M8 ***')
        fprintf('  Isp=%.1f s, F/mdot=%.1f m/s, f=%.4f\n', Isp, F_mdot, f);
    end
    