%                      15V
%
%
%                       D0
%                       (i3)
%                       u3
%                       
%                       R2
%                       (i2)
%                       u2
%U0                    (ice)
%0 .. 3.3V  R1  u1 (ib) trans
%
%                   
%
%
%                        0V
%
%
%               G uvec 
errbest=Inf;
R1=10000;
R2 =330;
U0=2;
errvec=[];
for j=1:3000000
   u = 15*rand(1,2);
   i1       = R1*(U0-u(1));
   [ib,ice] = ebersmoll2(u(1)-u(2),u(2));
   %i3       = diode(15-u(3));
   i2       = R2*(15-u(2));

   err1=abs(i1 - ib);
   %err2=abs(i2 - i3); 
   err2=abs(i2-ice);

   err = err1+err2;
   if err<errbest
       errbest=err;
       ubest=u;
       errvec=[errvec errbest];
   end
   
end
figure(1);plot(log(errvec));
errbest,
u,
%    i1       = R1*(U0-u(1));
%    [ib,ice] = ebersmoll2(u(1)-u(2),u(2));
%    i3       = diode(15-u(3));
%    i2       = R2*(u(3)-u(2));
% 
%    err1=abs(i1 - ib);
%    err2=abs(i2 - i3); 
%    err3=abs(i3-ice);
% 
%    err = err1+err2+err3;

