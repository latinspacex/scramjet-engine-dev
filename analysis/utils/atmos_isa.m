function [P, T, rho, a] = atmos_isa(alt_ft)
    % atmos_isa  International Standard Atmosphere model up to 86 km
    %
    %   [P, T, rho, a] = atmos_isa(alt_ft)
    %
    %   Inputs:
    %     alt_ft  — geometric altitude in feet
    %
    %   Outputs:
    %     P    — static pressure [Pa]
    %     T    — static temperature [K]
    %     rho  — density [kg/m^3]
    %     a    — speed of sound [m/s]
    %
    %   Uses piecewise ISA layers:
    %     0–11 km: lapse rate −6.5 K/km
    %    11–20 km: isothermal
    %    20–32 km: lapse rate +1.0 K/km
    %    32–47 km: lapse rate +2.8 K/km
    %    47–51 km: isothermal
    %    51–71 km: lapse rate −2.8 K/km
    %    71–84.852 km: lapse rate −2.0 K/km
    
    % Convert altitude to meters
    alt = alt_ft * 0.3048;
    
    % Constants
    g0   = 9.80665;      % gravity [m/s^2]
    R    = 287.05287;    % gas constant [J/kg·K]
    gamma= 1.4;          % ratio of specific heats
    
    % Define layer bases (geopotential) [m], temperature at base [K], lapse rate [K/m]
    hb   = [     0,  11000, 20000, 32000, 47000, 51000, 71000, 84852 ];
    Tb   = [ 288.15, 216.65, 216.65, 228.65, 270.65, 270.65, 214.65, 186.946 ];
    Lb   = [ -0.0065, 0,    0.0010, 0.0028, 0,     -0.0028, -0.0020 ];
    
    % Find layer
    for i = 1:length(hb)-1
        if alt >= hb(i) && alt < hb(i+1)
            H0 = hb(i);
            T0 = Tb(i);
            L  = Lb(i);
            break
        end
    end
    if alt >= hb(end)
        H0 = hb(end);
        T0 = Tb(end);
        L  = Lb(end);
    end
    
    % Compute temperature at alt
    if L == 0
        T = T0;
    else
        T = T0 + L*(alt - H0);
    end
    
    % Compute pressure
    if L == 0
        P = Tb(i) * 1000; % placeholder to initialize
        % Isothermal layer:
        P0 = Tb(i) * 1000; % will be overwritten
        % Find P0 at layer base by integrating previous layers
        P0 = 101325;
        for j = 1:i-1
            if Lb(j) == 0
                P0 = P0 * exp(-g0*(hb(j+1)-hb(j))/(R*Tb(j)));
            else
                P0 = P0 * (Tb(j+1)/Tb(j)).^(-g0/(Lb(j)*R));
            end
        end
        P = P0 * exp(-g0*(alt - H0)/(R*T0));
    else
        % Non‑isothermal layer:
        % Find P0 at layer base by integrating previous layers
        P0 = 101325;
        for j = 1:i-1
            if Lb(j) == 0
                P0 = P0 * exp(-g0*(hb(j+1)-hb(j))/(R*Tb(j)));
            else
                P0 = P0 * (Tb(j+1)/Tb(j)).^(-g0/(Lb(j)*R));
            end
        end
        P = P0 * (T/T0).^( -g0/(L*R) );
    end
    
    % Density from ideal gas law
    rho = P / (R * T);
    
    % Speed of sound
    a = sqrt(gamma * R * T);
    
    end
    