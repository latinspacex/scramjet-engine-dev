function [M2, Pt2_Pt1] = obliqueShock(M1, theta_deg, branch)
    % obliqueShock  –  Θ–β–M law + normal‑shock recovery
    
        gamma = 1.4;
        theta = theta_deg*pi/180;
    
        % Solve for beta
        func = @(beta) tan(theta) - 2*cot(beta).*(M1^2.*sin(beta).^2-1)./(M1^2*(gamma+cos(2*beta))+2);
        opts = optimset('Display','off');
        beta = fsolve(func, theta+0.2, opts);
    
        % Normal component
        Mn1 = M1*sin(beta);
        Pt2_Pt1_n = ((1+(gamma-1)/2*Mn1^2)^(gamma/(gamma-1))) / ...
                    ((gamma*Mn1^2-(gamma-1)/2)^(1/(gamma-1)));
        % downstream Mach
        Mn2 = sqrt((1+(gamma-1)/2*Mn1^2)/(gamma*Mn1^2-(gamma-1)/2));
        M2  = Mn2/sin(beta-theta);
    
        Pt2_Pt1 = min(Pt2_Pt1_n,1);
    end
    