function new_edges = create_replacement_edges(edge_info, node_ids, to_connect_idx, deleted_node, removed_node_type)
% Create replacement edges between all neighbors of a deleted node, with
% each replacement taking over all devices of the respective pair of deleted edges
% ----------------------------------------------------------------------
% INPUTS:
%  edge_info         ... array of edge info type 
%  node_ids          ... array of node ids
%  to_connect_idx    ... array of neighbor node indices
%  delete_node       ... index of removed node
%  removed_node_type ... either 'display_only', or 'transistor'; type of removed node
% OUTPUT:
% new_edges  ... array of edge info type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved
new_edges = [];
rel_idx = 1:length(to_connect_idx);
for n=1:length(to_connect_idx)
    yet_unconnected = find(rel_idx > n);
    for m=1:length(yet_unconnected)
        neigbor_node_pair        = [to_connect_idx(n) to_connect_idx(yet_unconnected(m))];
        edge_pair_to_remove_idx  = get_edges_to_replace(edge_info, deleted_node, neigbor_node_pair);
        switch removed_node_type
            case 'display_only'
                 new_edges = [new_edges merge_edge_pair_display_only(edge_info, node_ids, edge_pair_to_remove_idx, deleted_node)];
            case 'transistor'
                 new_edges = [new_edges merge_edge_pair_transistor(edge_info, node_ids, edge_pair_to_remove_idx, deleted_node)];
            otherwise
                error('unknown removed node type')
        end
    end
end