[edges, node_info] = update_edge_states(edges, node_info, comp_params);
source_node_idx = edge_info.s(crt_edge_idx);
sink_node_idx   = edge_info.t(crt_edge_idx);

[devices, current, timestep, error] = get_edge_current(devices, node_voltages, source_node_idx, sink_node_idx, comp_params);


