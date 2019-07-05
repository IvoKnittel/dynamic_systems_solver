function edge_idx = get_egdes_by_node(edges, node_idx)
% gets indices of edges with endnodes in list of nodes 
% ----------------------------------------------------------------------
% INPUTS:
% edge_info      ... edge info type
% node_idx       ... array of node indices
% 
% OUTPUTS:
% edge_idx       ... array of edge indices
% ----------------------------------------------
edge_idx = [];
for j=1:length(node_idx)
   edge_idx = [edge_idx find([edges.s] == node_idx(j))];
   edge_idx = [edge_idx find([edges.t] == node_idx(j))];
end
edge_idx = unique(edge_idx);