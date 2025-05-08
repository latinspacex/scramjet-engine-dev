clc; clear; addpath('analysis','analysis/utils');
target_q = 1200; M0=6;
alts = linspace(60000,90000,31);
errs=zeros(size(alts)); qs=zeros(size(alts));
for i=1:numel(alts)
  [P0,~,rho,~]=atmos_isa(alts(i));
  qPa = 0.5*rho*(295*M0)^2;
  qpsf = qPa*0.0208854;
  errs(i)=abs(qpsf-target_q); qs(i)=qpsf;
end
[~,idx]=min(errs);
fprintf('Best alt ≈ %.0f ft → q≈%.1f psf\n',alts(idx),qs(idx));
