function edge_info =  add_capacitance_to_ground(node_info, edge_info, time_epsilon, C_to_ground)
% connects all floating nodes to ground by an RC with infinitesimal time constant
% ----------------------------------------------------------------------
% INPUTS:
% edge_info         ... edge_info_type
% delete_node_idx   ... node index existing in edge_info.s or .t
% neigbor_node_pair ... pair of node indices
% names             ... cell array of names of all nodes
% OUTPUTS:
% edge_info         ... edge_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

R = time_epsilon/C_to_ground;
% connect all floating nodes to ground that are not connected to ground
% anyway
floating_idx=find(node_info.floating==1);
s_connected_to_sink_idx =  strcmp(edge_info.s_by_name,  'sink');
node_connected_to_sink_idx =  edge_info.t(s_connected_to_sink_idx);  
t_connected_to_sink_idx =  strcmp(edge_info.t_by_name,  'sink');
node_connected_to_sink_idx = [node_connected_to_sink_idx edge_info.s(t_connected_to_sink_idx)];
[~, delete_in_float_idx] = intersect(floating_idx, node_connected_to_sink_idx);
floating_idx(delete_in_float_idx)=[];

for j=1:length(floating_idx)
    new_edge_info              =  edge_info_type();
    new_edge_info.s_by_name    =  node_info.names(floating_idx(j));
    new_edge_info.t_by_name    =  'sink';
    new_edge_info.R            =  R;        
    new_edge_info.L            =  0;      
    new_edge_info.C            =  C_to_ground; 
    new_edge_info.is_base      = false;
    new_edge_info.is_collector = false;   
    new_edge_info.is_emitter   = false;
    new_edge_info.is_bc        =  false;
    new_edge_info.is_be        =  false;
    new_edge_info.is_ce        =  false;
    new_edge_info.id           =  0;
    edge_info                  =  appped_edge_to_info(edge_info, new_edge_info);
end