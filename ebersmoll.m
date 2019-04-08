function [ib,ice,ibc,ibe] = ebersmoll(vbe,vbc)
% for 2N3904 Transistor
%               nVt, Isat
%Icc =  diode(vbe,0.4 , 8e-3);
Icc = diode(vbe,0.4 , 8e-3);
%               nVt, Isat
%Iec = -diode(vbc,0.4 , 8e-3);
Iec = -diode(vbc,0.4 , 8e-3);
ice  = Icc + Iec;

current_gain         = 200;
current_gain_reverse = 100;
ibe  = Icc/current_gain;
ibc  = Iec/current_gain_reverse;

ib  =ibe +ibc;