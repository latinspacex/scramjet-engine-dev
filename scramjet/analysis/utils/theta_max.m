function Theta_max = theta_max(M0, gamma)
    % theta_max  —  max total deflection for weak‑shock chain to M3=1
    % Uses closed‑form chain or pre‑tabulated data; here we use a fit.
    
        % approximate Θ_max(M) fit (deg):
        % piecewise: rises from ≈10° at M=2 to ≈60° at M=8
        Theta_max = 5 + 10*(M0-2)./(6);  
        Theta_max = max(0, Theta_max);
    end
    