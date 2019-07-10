function out = node_info_to_nodes_info_array(node_info)
% 
% ----------------------------------------------------------------------
% INPUTS:
% node_info    ... node_info_type
% 
% OUTPUTS:
% out          ... array of node_info_type
% ----------------------------------------------
out =[];
next_node_info = node_info_type();
for crt_node=1:length(node_info.names)
    next_node_info.names      = node_info.names(crt_node);
    next_node_info.pos        = node_info.pos(:,crt_node);
    next_node_info.is_trans   = node_info.is_trans(crt_node);
    next_node_info.disp_only  = node_info.disp_only(crt_node);
    next_node_info.floating   = node_info.floating(crt_node);
    out=[out next_node_info];
end