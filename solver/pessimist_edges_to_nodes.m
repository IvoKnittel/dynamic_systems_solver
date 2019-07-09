function nodes_quantity   =  pessimist_edges_to_nodes(nodes, edges, edge_quantity)
% gets a node quantity by taking the minimum of the edges connected to a node of some edge quantity
% -----------------------------------------------------------
% INPUTS:
% nodes           ... (1,n) array of circuit node type
% edges           ... (1,m) array of edges
% edge_quantity   ... (1,m) array
%
% OUTPUTS:
% nodes_quantity  ... (1,n) array 
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

% init output

nodes_quantity = Inf(1,length(nodes));
for node_idx=1:length(nodes)
    % get edges connecting to this node
    % ---------------------------------
    crt_edge_idx = find(get_from_edges(edges, 'edges_to_node', node_idx));

    % take the minimum of the edge quantity for all connected edges
    % --------------------------------------------------------------
    for m=1:length(crt_edge_idx)     
        nodes_quantity(node_idx) = min(nodes_quantity(node_idx), edge_quantity(crt_edge_idx(m)));     
    end
end