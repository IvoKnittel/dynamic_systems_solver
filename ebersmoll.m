function [ib,ice] = ebersmoll(vbe,vbc)

current_gain         = 100;
current_gain_reverse = 100;
nVt  = 1;
Isat = 1;
Icc  =  Isat*(exp(vbe/nVt)-1);
Iec  = -Isat*(exp(vbc/nVt)-1);

ice  = Icc + Iec;
ib   = Icc/current_gain + Iec/current_gain_reverse;

