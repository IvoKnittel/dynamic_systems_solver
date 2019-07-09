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
        new_edge_info              =  edge_info_type();
        [new_edge_info.R, new_edge_info.R_is_dummy]= merge_impedance(to_merge, [edge_info.R], [edge_info.R_is_dummy]);        
        [new_edge_info.L, new_edge_info.L_is_dummy]= merge_impedance(to_merge, [edge_info.L], [edge_info.L_is_dummy]);    
        [new_edge_info.C, new_edge_info.C_is_dummy]= merge_impedance(to_merge, [edge_info.C], [edge_info.C_is_dummy]);    
        new_edge_info.is_base        =  NaN;
        new_edge_info.is_collector   =  NaN;
        new_edge_info.is_emitter     =  NaN;
        new_edge_info.is_bc          =  sum(edge_info(idx_multiple).is_bc);
        new_edge_info.is_be          =  sum(edge_info(idx_multiple).is_be);
        new_edge_info.is_ce          =  sum(edge_info(idx_multiple).is_ce);
        new_edge_info.device_info    = nonlinear_device_info_type();
        new_edge_info.device_info.Ct = [edge_info(idx_multiple).device_info.Ct];
        new_edge_info.device_info.Rt = [edge_info(idx_multiple).device_info.Rt];
    end
end

function [imp_vec_out, imp_vec_is_dummy_out] = merge_impedance(to_merge, imp_vec, imp_is_dummy_vec)
      
is_selected = to_merge & ~isnan(imp_vec);
if any(is_selected) 
    if any(~imp_is_dummy_vec(is_selected))
        is_selected = is_selected & ~imp_is_dummy_vec;
        imp_vec_out            =  1/sum(1./imp_vec(is_selected));
        imp_vec_is_dummy_out   =  0;
    else
        sel_idx = find(is_selected);
        imp_vec_out            =  imp_vec(sel_idx(1));
        imp_vec_is_dummy_out   =  1;
    end
else
    imp_vec_is_dummy_out   =  0; 
    imp_vec_out  = NaN;
end