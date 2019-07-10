function mem =  add_capacitance_to_ground(mem, time_epsilon, C_to_ground)
% connects all floating nodes to ground by an RC with infinitesimal time constant
% ----------------------------------------------------------------------
% INPUTS:
% mem           ... graph info memory
% time_epsilon  ... time constant  
% C_to_ground   ... ground capacitance
%
% OUTPUTS:
% mem           ... graph info memory
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

R = time_epsilon/C_to_ground;
% connect all floating nodes to ground that are not connected to ground
% anyway
edge_info = mem.G.Edges.info';

node_info = mem.G.Nodes.info;

floating_idx=find([node_info.floating]==1);
s_connected_to_sink_idx =  strcmp([node_info([edge_info.s]).names],  'sink');
node_connected_to_sink_idx =  [edge_info(s_connected_to_sink_idx).t];  
t_connected_to_sink_idx =  strcmp([node_info([edge_info.t]).names],  'sink');
node_connected_to_sink_idx = [node_connected_to_sink_idx [edge_info(t_connected_to_sink_idx).s]];
[~, delete_in_float_idx] = intersect(floating_idx, node_connected_to_sink_idx);
floating_idx(delete_in_float_idx)=[];

new_edge_info = edge_info_type();
new_edges = [];
for j=1:length(floating_idx)
    new_edge_info.s                   = floating_idx(j);
    new_edge_info.t                   = find(strcmp([node_info.names],  'sink'));
    new_edge_info.s_by_id             = node_info(new_edge_info.s).id;
    new_edge_info.t_by_id             = node_info(new_edge_info.t).id;    
    new_edge_info.linear.R.val        = R;       
    new_edge_info.linear.R.is_dummy   = true;
    new_edge_info.linear.L.val        = 0;   
    new_edge_info.linear.L.is_dummy   = false;   
    new_edge_info.linear.C.val        = C_to_ground;
    new_edge_info.linear.C.is_dummy   = true; 
    new_edges                         = [new_edges new_edge_info];
end
mem = add_new_circuit_edges(mem, new_edges);
