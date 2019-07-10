function mem =  model_voltage_sources_as_capacitances(mem, comp_params)
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
    new_edge_info                     =  edge_info_type();
    new_edge_info.s_by_id             =  [node_info(voltage_sources_node_idx(j)).id];
    new_edge_info.t_by_id             =  sink_id;
    new_edge_info.linear.R.val        =  comp_params.voltage_source_R;       
    new_edge_info.linear.R.is_dummy   =  true;
    new_edge_info.linear.L.is_dummy   =  false;
    new_edge_info.linear.C.is_dummy   =  false;
    new_edge_info.linear.L.val        =  0;      
    new_edge_info.linear.C.val        =  comp_params.voltage_source_C; 
    new_edge_info.device_info         =  nonlinear_device_info_type();
    new_edges = [new_edges new_edge_info];
end

mem = add_new_circuit_edges(mem, new_edges);
mem = circuit_display_assign_colors3(mem);