function mdot = massflow_sizing(F_mdot, W_required)
    % massflow_sizing  –  compute mdot given thrust‑per‑kg‑flow and required thrust
    %   Inputs:
    %     F_mdot    = thrust per unit mass‑flow [N·s/kg]
    %     W_required = required thrust (or weight) [N]
    %   Output:
    %     mdot      = mass‑flow [kg/s]
    
        mdot = W_required / F_mdot;
    end
    