function [edge_info, node_info] = merge_multiple_edges(edge_info, node_info)
% All multiple edges in a cicuits are each merged into one edge
% carrying devices in parallel
% ----------------------------------------------------------------------
% INPUTS:
% edge_info       ... edge_info_type
% OUTPUTS:
% edge_info     ... edge_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

last_s = 0;
multiple_idx_info=[];
unique_id = 1;
for j=1:length(edge_info.s)
    if edge_info.s(j) == last_s
        continue
    end
    same_s_value = edge_info.s == edge_info.s(j);
               
    t_values = unique(edge_info.t(same_s_value));
    for k=1:length(t_values)
        multiple_idx      =  find(same_s_value & edge_info.t == t_values(k));
        if length(multiple_idx)>1
            multiple_idx_info =[ multiple_idx_info [multiple_idx; unique_id*ones(1,length(multiple_idx))]];
            unique_id = unique_id + 1;
        end
    end
    last_s = edge_info.s(j);
end

if ~isempty(multiple_idx_info)
    last_s          = multiple_idx_info(2,1);
    start_merge_idx = 1;
    for end_merge_idx = 1:size(multiple_idx_info,2)
        if multiple_idx_info(2,end_merge_idx) == last_s && end_merge_idx<size(multiple_idx_info,2)  
            last_s = edge_info.s(end_merge_idx);
            continue
        end
        [edge_info, node_info] = merge_multiple_edges_in_info(edge_info, node_info, multiple_idx_info(1,start_merge_idx:end_merge_idx));     
        last_s = edge_info.s(end_merge_idx);
        start_merge_idx = end_merge_idx+1;
    end
end