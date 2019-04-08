Vhi =  5;
Vlo = -0.5;
Vb  = -0.1:0.2:1.5;
vce = Vlo:0.02:Vhi;
figure(3);cla;
subplot(3,1,1); cla; hold on;
ib_mat=[];
ice_mat=[];
for j=1:length(Vb)
    vbe = Vb(j)*ones(1, length(vce));
    vbc = Vb(j)-vce;
    [ib,ice] = ebersmoll2(vbe,vbc);
    ib_mat=[ib_mat ib'];
    ice_mat=[ice_mat ice'];
    plot(vce,ice);
end
subplot(3,1,2);
plot(Vb, ib_mat(150,:));
subplot(3,1,3);
plot(ib_mat(150,:), ice_mat(150,:), ib_mat(50,:), ice_mat(50,:), ib_mat(250,:), ice_mat(250,:));
hallo=1;

