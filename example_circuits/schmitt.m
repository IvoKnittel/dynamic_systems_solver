function  [node_info, edge_info] = schmitt()
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
Ct=1e-11;
Cgrd = 1e-15;
node_info            = node_info_type();
node_info.names      = {'supply',  'supply_cpy', 'upper_left', 'left_trans', 'left base',  'lower'  ,'upper_right', 'right_trans' 'signal', 'sink', 'sink_cpy_l',  'sink_cpy_r'};
node_info.pos        = [   [-1;2]     [1;2]        [-1; 1.25]     [-1;1]       [-1.5;1]     [0; 0.5]      [1;1.5]        [1;1.25]       [-2;1]   [0;0]   [-1;0]        [1;0]];
node_info.is_trans   = [    0           0             0              1            0            0           0               1         0        0         0              0    ];
node_info.disp_only  = [    0           1             0              0            0            0           0               0         0        0         1              1    ];
node_info.floating   = [    0           0             1              1            1            1           1               1         2        0         0              0    ];
node_info.Cgrd       = [   Inf         NaN           Cgrd           Cgrd         Cgrd         Cgrd       Cgrd             Cgrd      Inf      Inf       NaN            NaN   ];
node_info.id         = 1:length(node_info.names);

%edge info: what edges exist, an for each edge the name and what device is
%residing on it
% ------------------------------------------------------------------------
edge_info             = edge_info_type();
edge_info.s_by_name   = {'supply',     'supply',     'supply_cpy',  'upper_left', 'upper_left', 'upper_right' , 'left_trans', 'left_trans', 'left base', 'right_trans', 'lower', 'sink',       'sink'};
edge_info.t_by_name   = {'upper_left', 'supply_cpy', 'upper_right', 'left_trans', 'right_trans', 'right_trans', 'left base',  'lower'     , 'signal'   , 'lower'      , 'sink'  , 'sink_cpy_l', 'sink_cpy_r'};
edge_info.R =           [   1001          0              1003           0             0              0              0             0            1002        0              20       0              0      ];
edge_info.L =           [    0            0               0             0             0              0              0             0             0          0              0        0              0      ];
edge_info.C =           [    0            0               0             Ct/2          Ct/2           Ct/2           Ct/2          Ct/2          0          Ct/2           0        0              0      ];
edge_info.is_base     = [    0            0               0             0             1              0              1             0             0          0              0        0              0      ];
edge_info.is_collector =[    0            0               0             1             0              1              0             0             0          0              0        0              0      ];
edge_info.is_emitter  = [    0            0               0             0             0              0              0             1             0          1              0        0              0      ];
edge_info.id          = 1:length(edge_info.s_by_name);

[node_info, edge_info] = init_cicuit_nodes(node_info, edge_info);
edge_info.is_bc = zeros(1,length(edge_info.s));
edge_info.is_be = zeros(1,length(edge_info.s));
edge_info.is_ce = zeros(1,length(edge_info.s));