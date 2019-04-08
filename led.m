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
U0=15;
U1=0;
% external voltage of node, or NaN if voltage is variable   
u0         = [U0        NaN       NaN     NaN     0    U1];
%                               source node                          
%             1           2       3        4        5    6    
adja_mat ={{  NaN       NaN       NaN     NaN    NaN  NaN};
           { 'diode'    NaN       NaN     NaN    NaN  NaN};
           {  0        'R660'     NaN     NaN    NaN  NaN};
           {  0           0       'bc'    NaN    NaN  NaN};
           {  0           0     {'ec',4}  0      NaN  NaN};
           {  0           0        0    'R1500'  0    NaN}};    
       
uvaridx=6;
dt=0.02;
times = 0:dt:0.5;
Umax=4;
period=1;
dUdt=2*Umax*dt/period;
ut = zeros(length(times), 1);
ut(1) =u(uvaridx);
t=0;
for j = 2:length(times)
    ut(j)             = ut(j-1)+sawtooth(times(j),dUdt,period);
end   

M = size(adja_mat,1);
current_select_matrix=zeros(M,M);
current_select_matrix(2,1)=1;
current_select_matrix(3,2)=2;
current_select_matrix(4,3)=3;
current_select_matrix(6,4)=4;
current_select_matrix(5,3)=5;


