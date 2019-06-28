function [node_info, edge_info] = get_graph_info_for_calculation(node_info, edge_info)
% node info and edge info for pretty display of the circuit
% is converted into node info and edge info for computation
% same-potential nodes are removed, transistors replaced by Ebers-Moll
% devices.
% ----------------------------------------------------------------------
% INPUTS:
% node_info     ... node_info_type
% edge_info     ... edge_info_type
% OUTPUTS:
% node_info     ... node_info_type
% edge_info     ... edge_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

[node_info2, edge_info2] = remove_cicuit_nodes(node_info, edge_info, find(node_info.disp_only~=0));
trans_idx = find(node_info2.is_trans~=0);
[node_info3, edge_info3] = remove_cicuit_nodes(node_info2, edge_info2, trans_idx(1));
trans_idx = find(node_info3.is_trans~=0);
[node_info, edge_info] = remove_cicuit_nodes(node_info3, edge_info3, trans_idx);
[edge_info, node_info] = merge_multiple_edges(edge_info, node_info);

[node_info, edge_info] = init_cicuit_nodes(node_info, edge_info);
edge_info = reorder_edge_info(edge_info, node_info.names);
node_info.num_nodes = length(node_info.names);  