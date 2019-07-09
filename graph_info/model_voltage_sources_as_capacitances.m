function mem =  model_voltage_sources_as_capacitances(mem)
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

node_info = mem.G.Nodes.info';
sink_id   = node_info(strcmp([node_info.names],'sink')).id;

voltage_sources_node_idx = find([node_info.floating]~=1 & ~strcmp([node_info.names],  'sink'));
new_edges = [];
for j=1:length(voltage_sources_node_idx)
    new_edge_info              =  edge_info_type();
    new_edge_info.s_by_id      =  [node_info(voltage_sources_node_idx(j)).id];
    new_edge_info.t_by_id      =  sink_id;
    new_edge_info.R            =  1e-12;       
    new_edge_info.R_is_dummy   =  true;
    new_edge_info.L_is_dummy   =  false;
    new_edge_info.C_is_dummy   =  false;
    new_edge_info.L            =  0;      
    new_edge_info.C            =  1e4; 
    new_edge_info.is_base      =  false;
    new_edge_info.is_collector =  false;   
    new_edge_info.is_emitter   =  false;
    new_edge_info.is_bc        =  false;
    new_edge_info.is_be        =  false;
    new_edge_info.is_ce        =  false;  
    new_edge_info.device_info  =  nonlinear_device_info_type();
    new_edges = [new_edges new_edge_info];
end

mem = add_new_circuit_edges(mem, new_edges);
mem = circuit_display_assign_colors3(mem);