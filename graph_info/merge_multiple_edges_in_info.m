function new_edge_info = merge_multiple_edges_in_info(edge_info, node_info, idx_multiple)
% Merges multiple edges connecting the same node pair
% into one edge with all devices in parallel
% ----------------------------------------------------------------------
% INPUTS:
% edge_info       ... edge_info_type
% node_info       ... node_info_type
% idx_multiple    ... indices of edges between the same node pair
% OUTPUTS:
% edge_info       ... edge_info_type
% node_info       ... node_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

% merges two edges beween the same startend nodes. 
% The result is one edge with the payloads (i.e.devices) of both edges on
% it in parallel
 all_idx=1:length(edge_info);
 to_merge = all_idx >= idx_multiple(1) & all_idx <= idx_multiple(end);
 
if ~isempty(idx_multiple)
    if ~isempty(idx_multiple)
        new_edge_info         = edge_info_type();
        new_edge_info.s       = edge_info(idx_multiple(1)).s;
        new_edge_info.t       = edge_info(idx_multiple(1)).t;
        new_edge_info.s_by_id = node_info(new_edge_info.s).id;
        new_edge_info.t_by_id = node_info(new_edge_info.t).id;        
        new_edge_info.linear  = merge_impedances(to_merge, [edge_info.linear]);           
    end
end

function linear = merge_impedances(to_merge, linear_vec)
linear = linear_device_info_type();
linear.R     = merge_impedance(to_merge, [linear_vec.R]); 
linear.L     = merge_impedance(to_merge, [linear_vec.L]); 
linear.C     = merge_impedance(to_merge, [linear_vec.C]); 

function out = merge_impedance(to_merge, imp_vec)

is_selected = to_merge & ~isnan([imp_vec.val]);
if any(is_selected) 
    if any(~[imp_vec(is_selected).is_dummy])
        is_selected = is_selected & ~[imp_vec.is_dummy];
        out.val       = 1/sum(1./[imp_vec(is_selected).val]);
        out.is_dummy  = false;
    else
        sel_idx = find(is_selected);
        out.val       = imp_vec(sel_idx(1)).val;
        out.dummy     = true;
    end
else
    out.is_dummy      = false; 
    out.val           = NaN;
end