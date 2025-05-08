function err = post_combustor_M4_error(M0, thetas, T4)
    M = M0;
    for k = 1:3
        [M, ~] = obliqueShock(M, thetas(k), 'weak');
    end
    [~, T0] = atmos_isa(110000);
    T2      = T0 * (1 + 0.5*(1.4-1)*M0^2);
    M4      = M * sqrt(T2 / T4);
    err     = abs(M4 - 1);
end
