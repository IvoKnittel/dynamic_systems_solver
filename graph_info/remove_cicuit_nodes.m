function [node_info, edge_info] = remove_cicuit_nodes(node_info, edge_info, delete_node_idx)
% Nodes are removed either because they are same-potential, or transistors replaced by Ebers-Moll
% devices
% ----------------------------------------------------------------------
% INPUTS:
% node_info       ... node_info_type
% edge_info       ... edge_info_type
% delete_node_idx ... array of indices in node_info
% OUTPUTS:
% node_info     ... node_info_type
% edge_info     ... edge_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

[node_info, edge_info]= circuit_display_assign_colors(node_info, edge_info);
edge_info.s=zeros(1,length(edge_info.s_by_name));
edge_info.t=zeros(1,length(edge_info.s_by_name));
for j=1:length(edge_info.s_by_name)
    edge_info.s(j) = find(strcmp(edge_info.s_by_name{j},node_info.names));      
    edge_info.t(j) = find(strcmp(edge_info.t_by_name{j},node_info.names)); 
end

delete_edge_idx = [];
G = graph(edge_info.s, edge_info.t, 1, node_info.names);
for j=1:length(delete_node_idx)
    delete_edge_idx = [delete_edge_idx find(edge_info.s == delete_node_idx(j) | edge_info.t == delete_node_idx(j))];
    neighbor_nodes = G.neighbors(delete_node_idx(j));
    neighbor_node_idx = 1:length(neighbor_nodes);
    for n=1:length(neighbor_nodes)
        yet_unconnected = find(neighbor_node_idx > n);
        for m=1:length(yet_unconnected)
            neigbor_node_pair = [neighbor_nodes(n) neighbor_nodes(yet_unconnected(m))];
            edge_info = merge_edge_pair(edge_info, delete_node_idx(j), neigbor_node_pair, node_info.names);
        end
    end
end
[node_info, edge_info] = init_cicuit_nodes(node_info, edge_info);
delete_edge_idx = unique(delete_edge_idx);
node_info = delete_nodes_from_info(node_info, delete_node_idx);
[edge_info, node_info] = delete_edges_from_info(edge_info, node_info, delete_edge_idx);
[node_info, edge_info] = init_cicuit_nodes(node_info, edge_info);
edge_info = reorder_edge_info(edge_info, node_info.names);
[node_info, edge_info] = init_cicuit_nodes(node_info, edge_info);

