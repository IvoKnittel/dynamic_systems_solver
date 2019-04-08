Vhi=5;
Vlo=0;
Vb=Vlo:0.02:Vhi;
vbe = Vb;
vbc=Vhi-Vb;
[ib,ice] = ebersmoll(vbe,vbc);

figure(1);
plot(Vb,ice,Vb,ib);