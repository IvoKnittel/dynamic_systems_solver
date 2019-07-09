function nodes_quantity   =  additive_edges_to_nodes(nodes, edges, edge_quantity)
% returns the sum of some edge quantity of the edges connected to a node 
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
nodes_quantity = zeros(1,length(nodes));
for node_idx=1:length(nodes)
    % get edges connecting to this node
    % ---------------------------------
    crt_edge_idx = get_from_edges(edges, 'edges_to_node', node_idx);

    % take the minimum of the edge quantity for all connected edges
    % --------------------------------------------------------------
    for m=1:length(crt_edge_idx)     
        nodes_quantity(node_idx) = nodes_quantity(node_idx) + edge_quantity(crt_edge_idx(m));     
    end
end