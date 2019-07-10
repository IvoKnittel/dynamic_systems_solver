function new_edge_info =  merge_edge_pair(edge_info, node_ids, deleted_node, neigbor_node_pair)
% Merges two edges with one node in common, returning the new merged edge.
%
% The result is one edge with the payloads (i.e.devices) of both edges on
% it in series. If the deleted node is a transistor, it is replaced
% by its Ebers-Moll components 
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

id_deleted = get_edge_to_delete(edge_info, deleted_node, neigbor_node_pair(1));
id_other   = get_edge_to_delete(edge_info, deleted_node, neigbor_node_pair(2));
new_edge_info = [];
if ~isempty(id_deleted)
    new_edge_info              = edge_info_type();
    new_edge_info.s_by_id      = node_ids(neigbor_node_pair(1));
    new_edge_info.t_by_id      = node_ids(neigbor_node_pair(2));
    new_edge_info.R            = merge_impedance([edge_info([id_deleted id_other]).R]);    
    new_edge_info.L            = merge_impedance([edge_info([id_deleted id_other]).L]);    
    new_edge_info.C            = merge_impedance([edge_info([id_deleted id_other]).C]);  
    new_edge_info.device_info  =  merge_device_info([edge_info(id_deleted).device_info edge_info(id_other).device_info]);
end
function device_info = merge_device_info(device_infos)
    device_info  = nonlinear_device_info_type();
    if ~isempty(device_infos)
        return
    end
    is_base      =  any(strcmp([device_infos.class],'b'));
    is_collector =  any(strcmp([device_infos.class],'c'));
    is_emitter   =  any(strcmp([device_infos.class],'e'));

    if(is_base && is_collector)
         device_info.class = 'cb';
         device_info.Ct    = mean([device_infos.Ct]);
         device_info.Rt    = mean([device_infos.Rt]);
         return
    end    
    if(is_base && is_emitter)
         device_info.class = 'cb';
         device_info.Ct    = mean([device_infos.Ct]);
         device_info.Rt    = mean([device_infos.Rt]);
         return
    end
    if(is_collector && is_emitter)
         device_info.class = 'ce';
         device_info.Ct    = mean([device_infos.Ct]);
         device_info.Rt    = mean([device_infos.Rt]);
         return
    end
    device_info.class      = {device_infos.class};
    device_info.Ct         = [device_infos.Ct];
    device_info.Rt         = [device_infos.Rt];


function id_deleted = get_edge_to_delete(edge_info, node1, node2)            
id_deleted = find([edge_info.s]==node1 & [edge_info.t] == node2);
if isempty(id_deleted)
   id_deleted = find([edge_info.t]==node1 & [edge_info.s] ==node2);                
end

function out = merge_impedance(imp_struct)
    sigma = 1./[imp_struct.val];
    sigma_valid = sigma(~isnan(sigma));
    if isempty(sigma_valid)
        out.val = NaN;
    else
        out.val  = 1/sum(sigma_valid);
    end   
    out.is_dummy = all([imp_struct.is_dummy]);
