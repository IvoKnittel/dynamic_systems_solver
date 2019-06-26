Vhi =  2;
Vlo = -0.5;
v = Vlo:0.02:Vhi;
figure(1);hold on;

Iout = diode(v,0.4 , 8e-3);
plot(v,Iout);

