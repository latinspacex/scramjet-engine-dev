clc; clear; addpath('analysis','analysis/utils');
Mtests=[6,7,8]; Wreq=15000*9.81;
bands = struct('Isp',[900,1200],'Fmdot',[300,800],'f',[0.02,0.06]);
fprintf('M  Pt3/P0  Isp  F/mdot  f  Flags\n');
for M0=Mtests
  out = scram_cycle(M0,Wreq);
  flags = {};
  if out.Isp<bands.Isp(1)||out.Isp>bands.Isp(2), flags{end+1}='Isp_OOR'; end
  if out.F_mdot<bands.Fmdot(1)||out.F_mdot>bands.Fmdot(2), flags{end+1}='Fmdot_OOR'; end
  if out.f<bands.f(1)||out.f>bands.f(2), flags{end+1}='f_OOR'; end
  fprintf('%1.0f %7.3f %5.0f %8.0f %5.3f  %s\n', ...
    M0,out.Pt3_P0,out.Isp,out.F_mdot,out.f,strjoin(flags,' '));
end
