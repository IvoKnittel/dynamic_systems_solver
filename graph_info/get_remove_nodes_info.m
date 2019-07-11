function new_edges = get_remove_nodes_info(G, delete_node_idx, removed_node_type)
% Create new circuit edges between all neighbors of a removed circuit node
% ----------------------------------------------------------------------
% INPUTS:
% G                 ... graph circuit graph
% delete_node_idx   ... array of node indices
% removed_node_type ... either 'display_only' or 'transistor'
% OUTPUT:
% new_edges         ... array of edge info type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

edge_info = G.Edges.info';
node_info = G.Nodes.info';

new_edges=[];
for j=1:length(delete_node_idx)
    neighbor_nodes = [G.predecessors(delete_node_idx(j))' G.successors(delete_node_idx(j))'];
    new_edges = [new_edges create_replacement_edges(edge_info, [node_info.id], neighbor_nodes, delete_node_idx(j), removed_node_type)];
end