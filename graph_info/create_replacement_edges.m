function new_edges = create_replacement_edges(edge_info, node_ids, to_connect_idx, delete_node_idx, removed_node_type)
% Create replacement edges between all neighbors of a deleted node, with
% each replacement taking over all devices of the respective pair of deleted edges
% ----------------------------------------------------------------------
% INPUTS:
%  edge_info         ... array of edge info type 
%  node_ids          ... array of node ids
%  to_connect_idx    ... array of neighbor node indices
%  delete_node_idx   ... index of removed node
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
        crt_node_pair = [to_connect_idx(n) to_connect_idx(yet_unconnected(m))];
        switch removed_node_type
            case 'display_only'
                 new_edges = [new_edges merge_edge_pair_display_only(edge_info, node_ids, delete_node_idx, crt_node_pair, removed_node_type)];
            case 'transistor'
                 new_edges = [new_edges merge_edge_pair_transistor(edge_info, node_ids, delete_node_idx, crt_node_pair, removed_node_type)];
            otherwise
                error('unknown removed node type')
        end
    end
end