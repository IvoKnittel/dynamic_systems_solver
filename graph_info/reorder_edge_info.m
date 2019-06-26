function edge_info = reorder_edge_info(edge_info, names)
% When nodes or edges were removed, edge infor must be reordered
% to comply with the matlab graph functions 
% ----------------------------------------------------------------------
% INPUTS:
% edge_info       ... edge_info_type
% names           ... cell array of names of all nodes
% OUTPUTS:
% edge_info     ... edge_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

% we happen to know that the names of edge startend nodes are assigned
% correctly
G = graph(edge_info.s, edge_info.t, 1, names);
ascend_idx  = 1:length(edge_info.s);
reorder_idx = 1:length(edge_info.s);
last_occur_idx = 0;
for edge_idx_in_graph=1:length(edge_info.s)
    pair_in_graph = G.Edges.EndNodes(edge_idx_in_graph,:);
    edge_idx_in_struct = find(ascend_idx >last_occur_idx & strcmp(pair_in_graph{1}, edge_info.s_by_name) & strcmp(pair_in_graph{2}, edge_info.t_by_name));
    if isempty(edge_idx_in_struct)
        edge_idx_in_struct = find(ascend_idx >last_occur_idx & strcmp(pair_in_graph{1}, edge_info.t_by_name) & strcmp(pair_in_graph{2}, edge_info.s_by_name));
    end
    if length(edge_idx_in_struct)==1
        reorder_idx(edge_idx_in_graph)=edge_idx_in_struct;
    else
        edge_idx_in_struct = sort(edge_idx_in_struct);
        reorder_idx(edge_idx_in_graph)=edge_idx_in_struct(1);
        last_occur_idx = edge_idx_in_struct(1);
    end
end
edge_info = reorder_edge_info_by_index(edge_info, reorder_idx);
