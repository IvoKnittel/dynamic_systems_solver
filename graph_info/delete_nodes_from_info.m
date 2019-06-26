function node_info = delete_nodes_from_info(node_info, delete_idx)
% Deletes nodes from node_info
% ----------------------------------------------------------------------
% INPUTS:
% node_info         ... node_info_type
% delete_node_idx   ... array of node indices in node_info
% OUTPUTS:
% node_info         ... node_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

node_info.names(delete_idx)      = [];
node_info.pos(:,delete_idx)      = [];
node_info.is_trans(delete_idx)   = [];
node_info.disp_only(delete_idx)  = [];
node_info.floating(delete_idx)   = [];
node_info.Cgrd(delete_idx)       = [];
node_info.id(delete_idx)         = [];