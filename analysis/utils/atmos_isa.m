function [P, T, rho, a] = atmos_isa(alt_ft)
    % atmos_isa  –  International Standard Atmosphere up to 84.852 km
    %
    %   [P, T, rho, a] = atmos_isa(alt_ft)
    %
    %   Inputs:
    %     alt_ft  — geometric altitude [ft]
    %   Outputs:
    %     P    — static pressure [Pa]
    %     T    — static temperature [K]
    %     rho  — density [kg/m^3]
    %     a    — speed of sound [m/s]
    %
    %   Layer definitions (geopotential altitude [m], base T [K], lapse rate [K/m]):
    %     0–11 000       : L = -0.0065
    %     11 000–20 000  : L = 0
    %     20 000–32 000  : L = +0.0010
    %     32 000–47 000  : L = +0.0028
    %     47 000–51 000  : L = 0
    %     51 000–71 000  : L = -0.0028
    %     71 000–84 852  : L = -0.0020
    
        %% 1. Convert altitude to meters
        alt = alt_ft * 0.3048;  % ft → m
    
        %% 2. Constants
        g0    = 9.80665;        % gravity [m/s^2]
        R     = 287.05287;      % specific gas constant [J/(kg·K)]
        gamma = 1.4;            % ratio of specific heats
    
        %% 3. Layer base data
        hb = [    0, 11000, 20000, 32000, 47000, 51000, 71000, 84852 ];
        Tb = [288.15,216.65,216.65,228.65,270.65,270.65,214.65,186.946];
        Lb = [-0.0065,0,    0.0010,0.0028,0,     -0.0028,-0.0020];
    
        %% 4. Identify layer
        for i = 1:length(hb)-1
            if alt >= hb(i) && alt < hb(i+1)
                H0 = hb(i);
                T0 = Tb(i);
                L  = Lb(i);
                break;
            end
        end
        if alt >= hb(end)
            H0 = hb(end);
            T0 = Tb(end);
            L  = Lb(end);
        end
    
        %% 5. Temperature profile
        if L == 0
            T = T0;
        else
            T = T0 + L * (alt - H0);
        end
    
        %% 6. Pressure calculation
        % Compute base pressure P0 by integrating lower layers
        P0 = 101325;  % sea-level standard
        for j = 1:i-1
            if Lb(j) == 0
                P0 = P0 * exp(-g0 * (hb(j+1)-hb(j)) / (R * Tb(j)));
            else
                P0 = P0 * (Tb(j+1)/Tb(j))^(-g0 / (Lb(j)*R));
            end
        end
    
        if L == 0
            % Isothermal layer
            P = P0 * exp(-g0 * (alt - H0) / (R * T0));
        else
            % Lapse-rate layer
            P = P0 * (T / T0)^(-g0 / (L * R));
        end
    
        %% 7. Density and speed of sound
        rho = P / (R * T);
        a   = sqrt(gamma * R * T);
    end
    