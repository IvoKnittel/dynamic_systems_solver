
%                      15V=u1
%                       
%                       R1            R3
%
%                                     u5
%                       
%                       u2        trans2
%U0=u6                    
%0 .. 3.3V  R2  u3    trans
%
%                               u4
%
%                               R4
%
%                            u7=0V
%
%
U0=15;
[ut, t]=generate_signal_input();

%                               source node                          
%             1           2              3        4       7        6    5
adja_mat ={{ NaN         NaN            NaN      NaN      NaN      NaN  NaN};  %1
           { 'R1e3'      NaN            NaN      NaN      NaN      NaN  NaN};  %2
           {  0          'bc'           NaN      NaN      NaN      NaN  NaN};  %3
           {  0     {'ec',3, 'eb2'}     'eb'     NaN      NaN      NaN  NaN};  %4sink node
           { 'R1e3'     'bc2'            0     {'ec2',2}  NaN      NaN  NaN   }; %7
           {  0           0            'R1e3'     0       0        NaN  NaN   }; %6
           {  0           0              0      'R20'     0        0    NaN}}; %5       
% external voltage of node, or NaN if voltage is variable       
node_to_ground_capacitance = ...
            [ Inf        0               0        0        0     Inf       Inf ];
u0      =   [U0          NaN            NaN      NaN       NaN    ut(1)     0  ];
uvaridx =   6;
grd_idx =   7;  
u_names = {'supply',  'upper',  'left base',  'lower'  ,'right coll','signal', 'out'};
tmp     = [  0             1              1        1       1           1        0 ];
voltage_select = logical(tmp);   
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