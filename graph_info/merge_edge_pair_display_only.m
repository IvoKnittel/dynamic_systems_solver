function new_edge_info =  merge_edge_pair_display_only(edge_info, node_ids, edge_idx, remove_node_idx)
% merges two edges with one node in common,
% assuming at least one of the edges being display only, i.e. without any
% devices.
% ----------------------------------------------------------------------
% INPUTS:
% edge_info         ... edge_info_type
% delete_node_idx   ... node index existing in edge_info.s or .t
% neigbor_node_pair ... pair of node indices
% names             ... cell array of names of all nodes
% OUTPUTS:
% edge_info         ... edge_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

if isempty(edge_idx)
    error('unexpected empty input');
end

% Find the at most one edge with devices on it
% --------------------------------------------
is_selected = get_idx_of_real_edge(edge_info(edge_idx));

% take over edge content
new_edge_info = edge_info(is_selected);

% get the endnodes right 
% ----------------------
other_end_node_id = get_surviving_node_id(edge_info(edge_idx(~is_selected)), node_ids(remove_node_idx));

if edge_info(edge_idx(is_selected)).s_by_id == node_ids(remove_node_idx)
    % make the surviving node of the other edge the new start node
    new_edge_info.s_by_id = other_end_node_id;
else
    % make the surviving node of the other edge the new end node
    new_edge_info.t_by_id = other_end_node_id;
end

function surviving_node_id = get_surviving_node_id(single_edge_info, remove_node_id)
    if single_edge_info.s_by_id  == remove_node_id
        surviving_node_id = single_edge_info.t_by_id;
    else
        surviving_node_id = single_edge_info.s_by_id;
    end

function is_selected = get_idx_of_real_edge(edge_pair_info)
% Find the at most one edge with devices on it
% ------------------------------------------------------
linear                         = [edge_pair_info.linear];

is_selected =               find_impedance([linear.R]);
is_selected = is_selected | find_impedance([linear.L]);
is_selected = is_selected | find_impedance([linear.C]);

% merge nonlinear devices asserting one edge with no device
% ---------------------------------------------------------
device_infos = [edge_pair_info.device_info];
is_selected = is_selected   | ~isempty([device_infos.class]);
if all(is_selected)
    error('Two real edges as input to display only function')
end

function  sel_idx = find_impedance(imp_vec)
% merge devices asserting one edge with no device
% -----------------------------------------------
sel_idx = impedance_has_actual_value([imp_vec.val]);
if all(sel_idx)
        error('Two real edges as input to display only function')
end
 



%     
%     new_edge_info.device_info  = merge_device_info([edge_info(edge_idx).device_info]);
%     % merging nonlinear devices, arranging them in parallel 
% 
% 
%     if ~isempty(device_infos)
%         return
%     end
%     
%     device_info.class      = {device_infos.class};
%     device_info.Ct         = [device_infos.Ct];
%     device_info.Rt         = [device_infos.Rt];    
% end