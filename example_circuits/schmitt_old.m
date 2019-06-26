function  [t, ut, u0, uvaridx, u_names, voltage_select, adja_mat, R_mat, cap_mat, L_mat, current_select_matrix, current_names, current_select] = schmitt()
% circuitsolver input modeling a Schmitt trigger
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

% node info: name, whether node is a transistor, whether node exists only
% for nice display, whether node voltage is floating
% -----------------------------------------------------------------------
node_info.names       = {'supply',  'supply_cpy', 'upper_left', 'left_trans', 'left base',  'lower'  ,'upper_right', 'right_trans' 'signal', 'out', 'out_cpy_l',  'out_cpy_r'};
node_info.pos       = [   [-1;2]     [1;2]        [-1; 1.25]     [-1;1]       [-1.5;1]     [0; 0.5]      [1;1.5]        [1;1.25]       [-2;1]   [0;0]   [-1;0]        [1;0]];
node_info.is_trans   = [    0           0             0              1            0            0           0               1         0        0         0              0    ];
node_info.disp_only  = [    0           1             0              0            0            0           0               0         0        0         1              1    ];
node_info.floating   = [    0           0             1              1            1            1           1               1         2        0         0              0    ];
node_info.id         = 1:length(node_info.floating);

%edge info: what edges exist, an for each edge the name and what device is
%residing on it
% ------------------------------------------------------------------------
edge_info.s_by_name   = {'supply',     'supply',     'supply_cpy',  'upper_left', 'upper_left', 'upper_right' , 'left_trans', 'left_trans', 'left base', 'right_trans', 'lower', 'out',       'out'};
edge_info.t_by_name   = {'upper_left', 'supply_cpy', 'upper_right', 'left_trans', 'right_trans', 'right_trans', 'left base',  'lower'     , 'signal'   , 'lower'      , 'out'  , 'out_cpy_l', 'out_cpy_r'};
edge_info.R =           [   1001          0              1003           0             0              0              0             0            1002        0              20       0              0      ];
edge_info.L =           [    0            0               0             0             0              0              0             0             0          0              0        0              0      ];
edge_info.C =           [    0            0               0             0             0              0              0             0             0          0              0        0              0      ];
edge_info.is_base     = [    0            0               0             0             1              0              1             0             0          0              0        0              0      ];
edge_info.is_collector =[    0            0               0             1             0              1              0             0             0          0              0        0              0      ];
edge_info.is_emitter  = [    0            0               0             0             0              0              0             1             0          1              0        0              0      ];
edge_info.id          = 1:length(edge_info.s_by_name);
[node_info, edge_info] = remove_cicuit_nodes(node_info, edge_info, []);

figure(1);subplot(2,1,1);
G = graph(edge_info.s,edge_info.t,1, node_info.names);
plot(G,'XData',node_info.pos(1,:),'YData',node_info.pos(2,:), 'EdgeLabel', edge_info.labels, 'EdgeCData', edge_info.colors, 'NodeCData', node_info.colors);


[node_info2, edge_info2] = remove_cicuit_nodes(node_info, edge_info, find(node_info.disp_only~=0));

% subplot(3,1,2);
% G2 = graph(edge_info2.s,edge_info2.t,1, node_info2.names);
% plot(G2,'XData',node_info2.pos(1,:),'YData',node_info2.pos(2,:), 'EdgeLabel', edge_info2.labels, 'EdgeCData', edge_info2.colors);

trans_idx = find(node_info2.is_trans~=0);
[node_info3, edge_info3] = remove_cicuit_nodes(node_info2, edge_info2, trans_idx(1));
G3 = graph(edge_info3.s,edge_info3.t,1, node_info3.names);
figure(6);
plot(G3,'XData',node_info3.pos(1,:),'YData',node_info3.pos(2,:), 'EdgeLabel', edge_info3.labels, 'EdgeCData', edge_info3.colors);
trans_idx = find(node_info3.is_trans~=0);
[node_info4, edge_info4] = remove_cicuit_nodes(node_info3, edge_info3, trans_idx);
% figure(7);
% G4 = graph(edge_info4.s,edge_info4.t,1, node_info4.names);
% plot(G4,'XData',node_info4.pos(1,:),'YData',node_info4.pos(2,:), 'EdgeLabel', edge_info4.labels, 'EdgeCData', edge_info4.colors);
figure(1);
subplot(2,1,2);
G4 = graph(edge_info4.s,edge_info4.t,1, node_info4.names);
plot(G4,'XData',node_info4.pos(1,:),'YData',node_info4.pos(2,:), 'EdgeLabel', edge_info4.labels, 'EdgeCData', edge_info4.colors);
u_names = node_info4.names;


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

circuit_adja = [[ NaN      NaN        NaN    NaN    NaN      NaN  NaN];  %1
               [  1        NaN        NaN    NaN    NaN      NaN  NaN];  %2
               [  0        1          NaN    NaN    NaN      NaN  NaN];  %3
               [  0        1          1      NaN    NaN      NaN  NaN];  %4sink node
               [  1        1          0      1      NaN      NaN  NaN]; %7
               [  0        0          1      0        0      NaN  NaN]; %6
               [  0        0          0      1        0        0 NaN]]; %5  


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
uvaridx =        find(strcmp(u_names,'signal'));  
% index of the ground input
% -------------------------
grd_idx =        find(strcmp(u_names,'out'));  
% names of nodes for display
% -------------------------
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