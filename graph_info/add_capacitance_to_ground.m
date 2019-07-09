function G =  add_capacitance_to_ground(G, time_epsilon, C_to_ground)
% connects all floating nodes to ground by an RC with infinitesimal time constant
% ----------------------------------------------------------------------
% INPUTS:
% node_info         ... node_info_type
% edge_info         ... edge_info_type
% time_epsilon      ... time constant  
% C_to_ground       ... ground capacitance
%
% OUTPUTS:
% node_info         ... node_info_type
% edge_info         ... edge_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

R = time_epsilon/C_to_ground;
% connect all floating nodes to ground that are not connected to ground
% anyway
edges=G.Edges.devices;

edge_info = G.Edges.info';

node_info = G.Nodes.info;

floating_idx=find([node_info.floating]==1);
s_connected_to_sink_idx =  strcmp([node_info([edges.s]).names],  'sink');
node_connected_to_sink_idx =  [edges(s_connected_to_sink_idx).t];  
t_connected_to_sink_idx =  strcmp([node_info([edges.t]).names],  'sink');
node_connected_to_sink_idx = [node_connected_to_sink_idx [edges(t_connected_to_sink_idx).s]];
[~, delete_in_float_idx] = intersect(floating_idx, node_connected_to_sink_idx);
floating_idx(delete_in_float_idx)=[];

new_edge_info = edge_info_type();
for j=1:length(floating_idx)
    s    =  floating_idx(j);
    t    = find(strcmp([node_info.names],  'sink'));
    G = addedge(G,s,t,1);
    new_edge_info.R            =  R;       
    new_edge_info.R_is_dummy   =  true;
    new_edge_info.L_is_dummy   =  false;
    new_edge_info.C_is_dummy   =  true;
    new_edge_info.L            =  0;      
    new_edge_info.C            =  C_to_ground; 
    new_edge_info.is_base      =  false;
    new_edge_info.is_collector =  false;   
    new_edge_info.is_emitter   =  false;
    new_edge_info.is_bc        =  false;
    new_edge_info.is_be        =  false;
    new_edge_info.is_ce        =  false;
    edge_info =[edge_info new_edge_info];
end
G.Edges.info = edge_info';

% % another link to make capacitance of the sink node nonzero
% %  --------------------------------------------------------
% new_edge_info              =  edge_info_type();
% new_edge_info.s_by_name    =  'sink';
% new_edge_info.t_by_name    =  'supply';
% new_edge_info.R            =  R;       
% new_edge_info.R_is_dummy   =  true;
% new_edge_info.L_is_dummy   =  false;
% new_edge_info.C_is_dummy   =  true;
% new_edge_info.L            =  0;      
% new_edge_info.C            =  C_to_ground; 
% new_edge_info.is_base      =  false;
% new_edge_info.is_collector =  false;   
% new_edge_info.is_emitter   =  false;
% new_edge_info.is_bc        =  false;
% new_edge_info.is_be        =  false;
% new_edge_info.is_ce        =  false;
% new_edge_info.id           =  0;
% new_edge_info.id           =  edge_info.next_unique_id;
% edge_info.next_unique_id   = edge_info.next_unique_id +1;
% new_edge_info.device_info  =  nonlinear_device_info_type();
% edge_info                  =  appped_edge_to_info(edge_info, new_edge_info);
% 
% [node_info, edge_info] =  init_circuit_nodes(node_info, edge_info);
% edge_info              =  reorder_edge_info(edge_info, node_info.names);
% [node_info, edge_info] =  init_circuit_nodes(node_info, edge_info);