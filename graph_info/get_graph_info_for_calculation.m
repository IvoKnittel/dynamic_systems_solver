function [nodes, edges, node_info, edge_info] = get_graph_info_for_calculation(node_info, edge_info, comp_params, supply_voltage)
% node info and edge info for pretty display of the circuit
% is converted into node info and edge info for computation
% 1. : Floating nodes are each connected to ground by a minuscule capacitance
% 2. : Same-potential nodes are removed.
% 3. : Transistors replaced by Ebers-Moll devices
% 4. : Multiple edges are merged.
% 5. : Add transistor Ebers-Moll parasitic capacitances.
% 6. : Voltage sources replaced by large charged capacitances.
% ----------------------------------------------------------------------
% INPUTS:
% node_info     ... node_info_type
% edge_info     ... edge_info_type
% supply_voltage
% OUTPUTS:
% node_info     ... node_info_type
% edge_info     ... edge_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

% 1. : Floating nodes are each connected to ground by a minuscule capacitance
% ------------------------------------------------------
[node_info, edge_info] =  add_capacitance_to_ground(node_info, edge_info, comp_params.time_epsilon, comp_params.C_to_ground);
[node_info, edge_info] = init_circuit_nodes(node_info, edge_info);

% 2. : Same-potential nodes are removed.
[node_info2, edge_info2] = remove_circuit_nodes(node_info, edge_info, find(node_info.disp_only~=0));


% 3. : Transistors replaced by Ebers-Moll devices.
% ------------------------------------------------
trans_idx = find(node_info2.is_trans~=0);
[node_info3, edge_info3] = remove_circuit_nodes(node_info2, edge_info2, trans_idx(1));
trans_idx = find(node_info3.is_trans~=0);
[node_info, edge_info] = remove_circuit_nodes(node_info3, edge_info3, trans_idx);

% 4. : Multiple edges are merged.
% -------------------------------
[edge_info, node_info] = merge_multiple_edges(edge_info, node_info);
[node_info, edge_info] = init_circuit_nodes(node_info, edge_info);
edge_info = reorder_edge_info(edge_info, node_info.names);

node_info.num_nodes = length(node_info.names);  

% 5. : Add transistor Ebers-Moll parasitic capacitances.
% ------------------------------------------------------
edge_info              = add_transistor_capacitances(edge_info);
[node_info, edge_info] = init_circuit_nodes(node_info, edge_info);
edge_info              =  reorder_edge_info(edge_info, node_info.names);
[node_info, edge_info] = init_circuit_nodes(node_info, edge_info);

% 6. : Voltage sources replaced by large charged capacitances.
% ------------------------------------------------------------
[node_info, edge_info] =  model_voltage_sources_as_capacitances(node_info, edge_info);
[node_info, edge_info] = init_circuit_nodes(node_info, edge_info);
edge_info              =  reorder_edge_info(edge_info, node_info.names);
[node_info, edge_info] = init_circuit_nodes(node_info, edge_info);
edge_info.devices      = convert_edge_info_to_edge_type_array(edge_info, comp_params); 

edges = edge_info.devices;
nodes = node_info_to_nodes_init(node_info, edges);
nodes(strcmp(node_info.names,'supply')).is_active = true;
nodes(strcmp(node_info.names,'supply')).var.potential = supply_voltage;
edges = init_nonlinear_device_voltage_ranges(nodes, edges);