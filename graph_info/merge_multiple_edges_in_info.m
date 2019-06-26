function [edge_info, node_info] = merge_multiple_edges_in_info(edge_info, node_info, idx_multiple)
% merges two edges beween the same startend nodes. 
% The result is one edge with the payloads (i.e.devices) of both edges on
% it in parallel 
if ~isempty(idx_multiple)
    if ~isempty(idx_multiple)
        new_edge_info              =  edge_info_type();
        new_edge_info.s_by_name    =  node_info.names(edge_info.s(idx_multiple(1)));
        new_edge_info.t_by_name    =  node_info.names(edge_info.t(idx_multiple(1)));
        new_edge_info.R            =  1/sum(1./edge_info.R(idx_multiple));        
        new_edge_info.L            =  1/sum(1./edge_info.L(idx_multiple));      
        new_edge_info.C            =  1/sum(1./edge_info.C(idx_multiple)); 
        new_edge_info.is_base      =  NaN(1,length(idx_multiple));
        new_edge_info.is_collector =  NaN(1,length(idx_multiple));
        new_edge_info.is_emitter   =  NaN(1,length(idx_multiple));
        new_edge_info.is_bc        =  sum(edge_info.is_bc(idx_multiple));
        new_edge_info.is_be        =  sum(edge_info.is_be(idx_multiple));
        new_edge_info.is_ce        =  sum(edge_info.is_ce(idx_multiple));
        [edge_info, node_info] = delete_edges_from_info(edge_info, node_info, idx_multiple);
        edge_info =  appped_edge_to_info(edge_info, new_edge_info);
    end
end
