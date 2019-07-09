function Iout = diode(v, nVt, Isat)

Iout  =  max(0, Isat*(exp(v/nVt)-1) );
%return
% Vlo = -0.5;
% Iout=[];
% for j=1:length(v)
%    vvec = Vlo:0.02:v(j);
%    Iout  =  [Iout sum(Isat*(1./(exp(-(vvec-0.7)/nVt)+1)))];
%end