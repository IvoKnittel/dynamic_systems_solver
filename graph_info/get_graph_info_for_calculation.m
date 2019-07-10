function [G, nodes,edges] = get_graph_info_for_calculation(node_info_disp, edge_info_disp, comp_params, supply_voltage)
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
G.Edges.info   = convert_edge_info_to_edge_info_array(edge_info_disp)';
G.Nodes.info   = node_info_to_nodes_info_array(node_info_disp)';

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
% 3. : Floating nodes are each connected to ground by a minuscule capacitance
% ------------------------------------------------------
mem =  add_capacitance_to_ground(mem, comp_params.time_epsilon, comp_params.C_to_ground);

% 4. : Multiple edges are merged.
% -------------------------------
mem = merge_multiple_edges(mem);
mem = circuit_display_assign_colors3(mem);

% 5. : Add transistor Ebers-Moll parasitic capacitances.
% ------------------------------------------------------
mem = add_transistor_capacitances(mem);

% 6. : Voltage sources replaced by large charged capacitances.
% ------------------------------------------------------------
mem =  model_voltage_sources_as_capacitances(mem, comp_params);
edges = convert_edge_info_to_edge_type_array(mem.G.Edges.info', comp_params);
node_info = mem.G.Nodes.info';
nodes = node_info_to_nodes_init(node_info, edges);
nodes(strcmp([node_info.names],'supply')).is_active = true;
nodes(strcmp([node_info.names],'supply')).var.potential = supply_voltage;
edges = init_nonlinear_device_voltage_ranges(nodes, edges);
G = mem.G;