function G = reorder_edge_info(G, node_ids)
% order edge info such that it matches the edge numbering in graph
% ----------------------------------------------------------------------
% INPUTS:
% mem        ... graph info memory
% OUTPUTS:
% mem        ... graph info memory
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved
edge_info      = G.Edges.info;
endnodes       = G.Edges{:,1};

for j=1:length(edge_info)
   crt_endnode_ids    = [edge_info(j).s_by_id; edge_info(j).t_by_id];
   crt_endnode_idx    = [find(crt_endnode_ids(1)==node_ids); find(crt_endnode_ids(2)==node_ids)]; 
   reordered_edge_idx = endnodes(:,1)==crt_endnode_idx(1) & endnodes(:,2)==crt_endnode_idx(2); 
   G.Edges.info(reordered_edge_idx)  = edge_info(j);
end