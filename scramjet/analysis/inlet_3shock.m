function res = inlet_3shock(M0, thetas)
    % inlet_3shock – N‑stage oblique‑shock inlet recovery + M3
    %   res = inlet_3shock(M0, thetas)
    %   .Pt2_P0 = total‑pressure recovery
    %   .M3     = Mach after 3rd shock

    if nargin<2
        thetas = [0.5,0.5,0.5];
    end

    Pt_P0 = 1;
    M      = M0;
    for i = 1:3
        theta = thetas(i);
        [M, Pt_ratio] = obliqueShock(M, theta, 'weak');
        Pt_P0 = Pt_P0 * Pt_ratio;
    end

    res.Pt2_P0 = Pt_P0;
    res.M3     = M;
end
