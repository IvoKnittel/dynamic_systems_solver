function [node_info, edge_info] =  model_voltage_sources_as_capacitances(node_info, edge_info)
% connect all fixed voltage nodes to ground with an infinite capacitance
% ----------------------------------------------------------------------
% INPUTS:
% node_info         ... node_info_type 
% edge_info         ... edge_info_type

% OUTPUTS:
% node_info         ... node_info_type 
% edge_info         ... edge_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

voltage_sources_node_idx = find(node_info.floating~=1 & ~strcmp(node_info.names,  'sink'));

for j=1:length(voltage_sources_node_idx)
    new_edge_info              =  edge_info_type();
    new_edge_info.s_by_name    =  node_info.names(voltage_sources_node_idx(j));
    new_edge_info.t_by_name    =  'sink';
    new_edge_info.R            =  0;       
    new_edge_info.R_is_dummy   =  true;
    new_edge_info.L_is_dummy   =  false;
    new_edge_info.C_is_dummy   =  true;
    new_edge_info.L            =  0;      
    new_edge_info.C            =  Inf; 
    new_edge_info.is_base      =  false;
    new_edge_info.is_collector =  false;   
    new_edge_info.is_emitter   =  false;
    new_edge_info.is_bc        =  false;
    new_edge_info.is_be        =  false;
    new_edge_info.is_ce        =  false;
    new_edge_info.id           = edge_info.next_unique_id;
    edge_info.next_unique_id   = edge_info.next_unique_id + 1;   
    new_edge_info.device_info  =  nonlinear_device_info_type();
    edge_info                  =  appped_edge_to_info(edge_info, new_edge_info);
end

[node_info, edge_info] =  init_circuit_nodes(node_info, edge_info);
edge_info              =  reorder_edge_info(edge_info, node_info.names);
[node_info, edge_info] =  init_circuit_nodes(node_info, edge_info);