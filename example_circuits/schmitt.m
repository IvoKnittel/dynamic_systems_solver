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
% -----------------------------------------------------------------------
% INPUTS:
% OUTPUTS:
% node_info  ... node_info_type
% edge_info  ... edge_info_type 
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved
Ct=1e-11;
Rt = 0;
node_info            = node_info_type();
node_info.names      = {'supply',  'supply_cpy', 'upper_left', 'left_trans', 'left base',  'lower'  ,'upper_right', 'right_trans' 'signal', 'sink', 'sink_cpy_l',  'sink_cpy_r'};
node_info.pos        = [   [-1;2]     [1;2]        [-1; 1.25]     [-1;1]       [-1.5;1]     [0; 0.5]      [1;1.5]        [1;1.25]       [-2;1]   [0;0]   [-1;0]        [1;0]];
node_info.is_trans   = [    0           0             0              1            0            0           0               1         0        0         0              0    ];
node_info.disp_only  = [    0           1             0              0            0            0           0               0         0        0         1              1    ];
node_info.floating   = [    0           0             1              1            1            1           1               1         2        0         0              0    ];
node_info.Cgrd       = [   Inf         NaN           NaN             NaN         NaN           NaN        NaN             NaN      Inf      Inf       NaN            NaN   ];
node_info.id         = 1:length(node_info.names);




%edge info: what edges exist, an for each edge the name and what device is
%residing on it
% ------------------------------------------------------------------------
edge_info             = edge_info_type();
edge_info.s_by_name   = {'supply',     'supply',     'supply_cpy',  'upper_left', 'upper_left', 'upper_right' , 'left_trans', 'left_trans', 'left base', 'right_trans', 'lower', 'sink',       'sink'};
edge_info.t_by_name   = {'upper_left', 'supply_cpy', 'upper_right', 'left_trans', 'right_trans', 'right_trans', 'left base',  'lower'     , 'signal'   , 'lower'      , 'sink'  , 'sink_cpy_l', 'sink_cpy_r'};
% R is in parallel to other devices on the same edge
       R              = [   1001          NaN            1003           NaN           NaN            NaN            NaN           NaN           1002       NaN           20       NaN            NaN    ];
       R_is_dummy     = [    0            0               0             1             1              1              1             1             0          1              0        0              0      ];
% L is in series with other devices on the same edge
       L     =          [    0            0               0             0             0              0              0             0             0          0              0        0              0      ];
% C is in parallel with other devices on the same edge
       C     =          [   NaN          NaN             NaN           NaN           NaN            NaN            NaN           NaN            NaN       NaN            NaN      NaN            NaN     ];
          is_base     = [    0            0               0             0             1              0              1             0             0          0              0        0              0      ];
          is_collector =[    0            0               0             1             0              1              0             0             0          0              0        0              0      ];
          is_emitter  = [    0            0               0             0             0              0              0             1             0          1              0        0              0      ];
edge_info.device_info = make_nonlinear_device_info(edge_info, is_base, is_collector, is_emitter, Ct,Rt);
edge_info.linear      = make_linear_device_info(R, L , C , R_is_dummy, false(1,length(L)), false(1,length(C)));