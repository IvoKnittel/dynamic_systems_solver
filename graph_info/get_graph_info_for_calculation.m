function [nodes, edges, node_info, edge_info] = get_graph_info_for_calculation(node_info_disp, edge_info_disp, comp_params, supply_voltage)
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
G = digraph(edge_info_disp.s,edge_info_disp.t);
edge_info_arr   = convert_edge_info_to_edge_info_array(edge_info_disp);
edges           = convert_edge_info_to_edge_type_array(edge_info_disp, comp_params);
node_info_arr   = node_info_to_nodes_info_array(node_info_disp);
nodes           = node_info_to_nodes_init(node_info_disp, edges);
G.Edges.info    = edge_info_arr';
G.Nodes.info    = node_info_arr';
G.Edges.devices = edges';
G.Nodes.devices = nodes';

nodes_info  = G.Nodes.info';
edges_info = G.Edges.info';

mem.G=G;
mem.next_unique_id =1;

for j=1:length(nodes_info)
    nodes_info(j).id = mem.next_unique_id;
    mem.next_unique_id = mem.next_unique_id+1;
end
for j=1:length(edges_info)
    edges_info(j).id = mem.next_unique_id;
    mem.next_unique_id = mem.next_unique_id+1;
    edges_info(j).s_by_id = edges_info(j).s;
    edges_info(j).t_by_id = edges_info(j).t;    
end

[nodes_info, edges_info]= circuit_display_assign_colors2(nodes_info, edges_info);
% 1. : Same-potential nodes are removed.
mem.G.Nodes.info = nodes_info;
mem.G.Edges.info = edges_info;
mem = remove_circuit_nodes(mem, find([nodes_info.disp_only]~=0));

% 2. : Transistors replaced by Ebers-Moll devices.
% ------------------------------------------------
nodes_info = mem.G.Nodes.info';
trans_idx = find([nodes_info.is_trans]~=0);
mem = remove_circuit_nodes(mem, trans_idx(1));

nodes_info = mem.G.Nodes.info';
trans_idx = find([nodes_info.is_trans]~=0);
mem = remove_circuit_nodes(mem, trans_idx);

node_info = mem.G.Nodes.info';
edge_info = mem.G.Edges.info';

% 3. : Floating nodes are each connected to ground by a minuscule capacitance
% ------------------------------------------------------
G =  add_capacitance_to_ground(G, comp_params.time_epsilon, comp_params.C_to_ground);


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

% 4. : Multiple edges are merged.
% -------------------------------
[edge_info, node_info] = merge_multiple_edges(edge_info, node_info);
[node_info, edge_info] = init_circuit_nodes(node_info, edge_info);
edge_info = reorder_edge_info(edge_info, node_info.names);
[node_info, edge_info] = init_circuit_nodes(node_info, edge_info);

node_info.num_nodes = length(node_info.names);  

edge_info.devices      = convert_edge_info_to_edge_type_array(edge_info, comp_params);

edges = edge_info.devices;
nodes = node_info_to_nodes_init(node_info, edges);
nodes(strcmp(node_info.names,'supply')).is_active = true;
nodes(strcmp(node_info.names,'supply')).var.potential = supply_voltage;
edges = init_nonlinear_device_voltage_ranges(nodes, edges);