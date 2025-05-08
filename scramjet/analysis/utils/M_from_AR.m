function M = M_from_AR(AR, gamma)
    % Returns the supersonic Mach matching Ae/At = AR
    
        f = @(M) (1./M)*(2/(gamma+1))^((gamma+1)/(2*(gamma-1))) ...
            .* (1+0.5*(gamma-1)*M.^2).^((gamma+1)/(2*(gamma-1))) - AR;
        M = fzero(f, max(1.1,sqrt(AR)));
    end
    