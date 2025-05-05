function [M2, Pt2_Pt1] = obliqueShock(M1, theta_deg, branch)
    % obliqueShock  –  computes downstream Mach and total‐pressure ratio 
    %   [M2, Pt2_Pt1] = obliqueShock(M1, theta_deg, branch)
    %   Uses Theta‐Beta‐Mach with a weak‐shock assumption.
    
        gamma = 1.4;
        theta = theta_deg * pi/180;
    
        % Approximate beta ≈ theta for small angles (weak shock)
        beta = theta;  
    
        % Normal‐shock component
        Mn1 = M1 * sin(beta);
        % Total‐pressure ratio across normal shock
        Pt2_Pt1 = ((1 + (gamma-1)/2*Mn1^2)^(gamma/(gamma-1))) / ...
                  ((gamma*Mn1^2-(gamma-1)/2)^(1/(gamma-1)));
    
        % Downstream normal Mach
        Mn2 = sqrt((1 + (gamma-1)/2*Mn1^2) / (gamma*Mn1^2-(gamma-1)/2));
        % Convert back to flow Mach after the oblique turn
        M2 = Mn2 / sin(beta - theta);
    end
    