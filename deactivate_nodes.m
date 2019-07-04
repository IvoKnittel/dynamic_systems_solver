function nodes = deactivate_nodes(nodes, edges)
% deactivate node if none of its edges is in error
% ----------------------------------------------------------------------
% INPUTS:
% nodes               ... array of circuit_node_type
% edges               ... array of circuit_edge_type
% 
% OUTPUTS:
% nodes               ... array of circuit_node_type
% ----------------------------------------------
for j=1:length(nodes)
   nodes(j).is_active = any(edges(get_from_edges(edges, 'edges_to_node', j)).error);
end