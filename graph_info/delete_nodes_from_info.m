function node_info = delete_nodes_from_info(node_info, delete_idx)
node_info.names(delete_idx)      = [];
node_info.pos(:,delete_idx)      = [];
node_info.is_trans(delete_idx)   = [];
node_info.disp_only(delete_idx)  = [];
node_info.floating(delete_idx)   = [];
node_info.Cgrd(delete_idx)       = [];
node_info.id(delete_idx)         = [];