%                      15V
%                  
%
%                       D0
%                       
%                       u1
%                       
%                       R1
%                       
%                       u2
%U0                    
%0 .. 3.3V  R2  u3 trans
%
%                   
%
%
%                        0V
%
%
%          device         edge       voltage drop      node
%         15V power       1          u(1) - u(4)       15V
%          diode          2          u(1) - u(2)       - 
%          R1             3          u(2) - u(3)       -
%          transistor     4          u(3) - u(4)       -
%          ground         -          -                 0
%
%      node  1    2    3    4   5

adja_mat ={{ NaN    'diode'      0      0        0        0 };
           { NaN    NaN          'R660'   0        0        0 };
           { NaN    NaN          NaN    'bc'   {'ec',4}       0 };
           { NaN    NaN          NaN    NaN      0     'R1500'};
           { NaN    NaN          NaN    NaN      NaN      0};
           { NaN    NaN          NaN    NaN      NaN     NaN}};
       
M = size(adja_mat,2);
inv_node_capacitance = 1e15*ones(1,M);
errbest = Inf;

errvec = [];
ivec   = zeros(M,1);
iout   = [];

U0=15;
U1=2.5;
u0      = [U0 0 0  0 0 U1];
uvar    = [0  1 1  1 0 0];
u = u0;
%load u
uvec=u';
t=0;

for j=1:300
   edge_current_mat = get_edge_currents(u, adja_mat);
   u_charge_rate    = inv_node_capacitance.*(sum(edge_current_mat,2)');
   dt               = 0.01*max(u)/max(u_charge_rate),
   u                = u + u_charge_rate*dt.*uvar;
   u,
   uvec=[uvec u'];
   
   t =[t t(end)+dt];
end
figure(1);hold on; plot(t,uvec(2,:),'b.',t,uvec(3,:),'g.');
iout,
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

