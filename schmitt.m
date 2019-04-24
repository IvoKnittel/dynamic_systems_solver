function  [t, ut, u0, uvaridx, u_names, voltage_select, adja_mat, R_mat, cap_mat, L_mat, current_select_matrix, current_names, current_select] = schmitt()
% circuitdolver input modeling a Schmitt trigger
%                      15V=u0
%                       
%                       R1            R3
%
%                                     u5
%                       
%                       u2        trans2
%Ut=u6                    
%0 .. 3.3V  R2  u3    trans
%
%                               u4
%
%                               R4
%
%                            u7=0V
%
% Supply voltage
% --------------
U0=15;
% Signal input
% --------------
[ut, t]=generate_signal_input();

% The device matrix
% -----------------
%                               source node                          
%                 1           2              3        4       7        6    5
R_mat =       [[ NaN         NaN          NaN      NaN    NaN      NaN  NaN];  %1
               [  1e3        NaN          NaN      NaN    NaN      NaN  NaN];  %2
               [  Inf        Inf          NaN      NaN    NaN      NaN  NaN];  %3
               [  Inf        Inf          Inf      NaN    NaN      NaN  NaN];  %4sink node
               [  1e3        Inf          Inf      Inf    NaN      NaN  NaN]; %7
               [  Inf        Inf          1e3      Inf    Inf      NaN  NaN]; %6
               [  Inf        Inf          Inf      20     Inf      Inf NaN]]; %5     


R_mat = mat_symm(R_mat);


adja_mat =    {{ NaN         NaN            NaN      NaN      NaN      NaN  NaN};  %1
               {  0          NaN            NaN      NaN      NaN      NaN  NaN};  %2
               {  0          'bc'           NaN      NaN      NaN      NaN  NaN};  %3
               {  0     {'ec',3, 'eb2'}     'eb'     NaN      NaN      NaN  NaN};  %4sink node
               {  0         'bc2'            0     {'ec2',2}  NaN      NaN  NaN   }; %7
               {  0           0              0        0       0        NaN  NaN   }; %6
               {  0           0              0        0       0        0    NaN}}; %5       
% A constant voltage input we can regard as a charged capacitor connecting to ground
% with infinite capacity. Internal nodes have no capacity to ground.
node_to_ground_capacitance = ...
               [ Inf        0               0        0        0     Inf       Inf ];
% external voltage of node, or NaN if voltage is variable         
u0      =       [U0          NaN            NaN      NaN       NaN    ut(1)     0  ];
% index of the signal input
% -------------------------
uvaridx =        6;
% index of the ground input
% -------------------------
grd_idx =        7;  
% names of nodes for display
% -------------------------
u_names =      {'supply',  'upper',  'left base',  'lower'  ,'right coll','signal', 'out'};
voltage_select= [false      true          true       true       true        true     false ];   
num_nodes = size(adja_mat,1);
Ct=1e-11;
Cgrd = 1e-15;
% cap_mat = [[NaN          NaN            NaN      NaN       NaN    NaN      NaN ];
%            [0            NaN            NaN      NaN       NaN    NaN      NaN ];
%            [0            Ct             NaN      NaN       NaN    NaN      NaN ];
%            [0            Ct             Ct       NaN       NaN    NaN      NaN ];
%            [0            Ct             0        0         NaN    NaN      NaN ];
%            [0            0              0        0         0      NaN      NaN ];
%            [Inf          Cgrd           Cgrd     Cgrd      Cgrd   Inf      NaN ]];
cap_mat = [[Inf          0              0        0         0      0        Inf ];
           [0            0              Ct      Ct        Ct      0        Cgrd ];
           [0            Ct             0        Ct        0      0        Cgrd ];
           [0            Ct             Ct       0         0      0        Cgrd ];
           [0            Ct             0        0         0      0        Cgrd ];
           [0            0              0        0         0      Inf      Inf ];
           [Inf          Cgrd           Cgrd     Cgrd      Cgrd   Inf      Inf ]];
       
current_select_matrix=zeros(num_nodes, num_nodes);
current_select_matrix(2,1)=1; % left in
current_select_matrix(4,2)=2; % main up to main lo
current_select_matrix(4,3)=3; % left base
current_select_matrix(5,4)=4; % out
current_select_matrix(4,7)=5; % right ce
current_select_matrix(3,6)=6; % signal in
current_select_matrix(7,1)=7; % right in
current_names={'left in','main','left base', 'out', 'right ce' 'signal in', 'right in'};
current_select = logical([1 1 1 1 1 1 1]);

L_mat = zeros(size(cap_mat));

function mat = mat_symm(mat)
for j=1:size(mat,1)
     for k=1:size(mat,2)
        if isnan(mat(j,k))
           mat(j,k)=mat(k,j);
           if j==k
              mat(j,k)=0;
           end
        end
    end
end