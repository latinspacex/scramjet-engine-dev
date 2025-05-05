function res = inlet_3shock(M0, thetas)
    % inlet_3shock  –  N‑stage oblique‑shock inlet recovery
    %   res = inlet_3shock(M0, thetas)
    %   Inputs:
    %     M0      Freestream Mach
    %     thetas  Vector of shock‐turn angles [deg], e.g. [4 4 8]
    %   Outputs:
    %     res.Pt2_P0  Total‑pressure recovery
    %     res.eta_d    Same as Pt2_P0 (for our purposes)
    
        if nargin < 2
            % default three‑shock geometry
            thetas = [0.5, 0.5, 0.5];
        end
    
        Pt_P0 = 1;
        M     = M0;
        for i = 1:numel(thetas)
            theta = thetas(i);
            [M, Pt_ratio] = obliqueShock(M, theta, 'weak');
            Pt_P0 = Pt_P0 * Pt_ratio;
        end
    
        res.Pt2_P0 = Pt_P0;
        res.eta_d   = Pt_P0;
    end
    