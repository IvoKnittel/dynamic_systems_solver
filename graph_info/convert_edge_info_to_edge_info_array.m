function out = convert_edge_info_to_edge_info_array(edge_info)
% 
% ----------------------------------------------
% INPUTS:
% edge_info         ... edge_info_type
% OUTPUTS:
% out               ... array of edge_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved
num_edges = length(edge_info.s);
out=[];
for idx=1:num_edges
    next_edge_info.s            = edge_info.s(idx);
    next_edge_info.t            = edge_info.t(idx);
    next_edge_info.R.val        = edge_info.R.val(idx);
    next_edge_info.L.val        = edge_info.L.val(idx);
    next_edge_info.C.val        = edge_info.C.val(idx);
    next_edge_info.device_info  = edge_info.device_info(idx);
    next_edge_info.labels       = edge_info.labels{idx};
    next_edge_info.colors       = edge_info.colors(idx);
    next_edge_info.R.is_dummy   = edge_info.R.is_dummy(idx);
    next_edge_info.L.is_dummy   = edge_info.L.is_dummy(idx);
    next_edge_info.C.is_dummy   = edge_info.C.is_dummy(idx);
    out =[out next_edge_info];
end