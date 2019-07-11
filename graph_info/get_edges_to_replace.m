function edge_idx = get_edges_to_replace(edge_info, common_node_idx, trailing_pair_idx)
% gets connecting edge pair with one common node and specified pair of other end nodes
% ----------------------------------------------------------------------
% INPUTS:
% edge_info         ... edge_info_type
% common_node_idx   ... node index existing in edge_info.s or .t
% trailing_pair_idx ... pair of node indices
% OUTPUTS:
% edge_idx          ... pair of edge indices 
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

id_deleted = get_edge_to_delete(edge_info, common_node_idx, trailing_pair_idx(1));
id_other   = get_edge_to_delete(edge_info, common_node_idx, trailing_pair_idx(2));
edge_idx = [id_deleted id_other];
if length(edge_idx)~=2
   error('no edge pair found')
end

function id_deleted = get_edge_to_delete(edge_info, node1, node2)            
id_deleted = find([edge_info.s]==node1 & [edge_info.t] == node2);
if isempty(id_deleted)
   id_deleted = find([edge_info.t]==node1 & [edge_info.s] ==node2);                
end