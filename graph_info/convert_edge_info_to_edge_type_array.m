function all_edges = convert_edge_info_to_edge_type_array(edge_info, comp_params)
% converts edge_info to an edge_type array
% ----------------------------------------------
% INPUTS:
% edge_info         ... edge_info_type
% comp_params       ... 
% OUTPUTS:
% edges             ... array of edge_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved
num_edges = length(edge_info.s);
all_edges = repmat(edge_type(),1,num_edges);
for idx=1:num_edges
    all_edges(idx).s = edge_info.s(idx);
    all_edges(idx).t = edge_info.t(idx);
    all_edges(idx).linear_device     = get_linear_device_by_idx(edge_info, idx, comp_params.dummy_resistor, comp_params.dummy_inductance);
    all_edges(idx).nonlinear_devices = get_nonlinear_devices_by_idx(edge_info, idx);
end