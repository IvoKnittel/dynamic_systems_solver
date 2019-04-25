a =  1e-3; %inner cond radius 
b =  1e-2; %outer cond radius 
tau =2*pi;
R_per_m = 5e-3;%1/(tau*sigma*d_skin)*(1/a+1/b);  5e-3 Ohm/m
L_per_m = 0.2e-6;%;(mu/tau)*ln(a/b); = 0.2 muH
G_per_m =1e9;%tau*omega*imag(eps)/ln(b/a);
C_per_m = 80e-12;%tau*real(eps) /ln(b/a);   = 80pF

%Time delay 4 ns/m
%sigma
%d_skin= 1/sqrt(mu*sigma*omega/2)
%mu=mu0;
%eps=

%
%    ---- L  R  ----
%                |
% ...         C     G    ...   
%                |
%    ----------------