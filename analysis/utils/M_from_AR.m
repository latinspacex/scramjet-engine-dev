function M = M_from_AR(AR, gamma)
    % M_from_AR  –  Solve for the supersonic Mach number given area ratio AR
    % Inputs:
    %   AR    — area ratio Ae/At
    %   gamma — specific heat ratio
    % Output:
    %   M     — supersonic Mach matching AR
    
        % Define the area‑Mach function for isentropic flow
        eq = @(M) (1./M) .* (2/(gamma+1)).^((gamma+1)/(2*(gamma-1))) ...
                  .* (1 + 0.5*(gamma-1).*M.^2).^((gamma+1)/(2*(gamma-1))) ...
                  - AR;
    
        opts = optimset('Display','off');
        
        % Initial guess: supersonic branch (≈ sqrt(AR) or at least 2)
        M0_guess = max(2, sqrt(AR));
        
        % Solve for supersonic root
        M = fzero(eq, M0_guess, opts);
    end
    