function matmem = get_device_matrix_for_calculation(matmem, node_info, edge_info)
% get cell array of device structs from graph info (yet only transistors) 
% ----------------------------------------------------------------------
% INPUTS:
% matmem             ... empty memory
% node_info          ... node_info_type
% edge_info          ... edge_info_type
% OUTPUTS:
% matmem.            ... stuff
% matmem.transistor  ... cell array of device_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved 

is_base_mat = get_adjamat(node_info, edge_info, 'is_base');
is_coll_mat = get_adjamat(node_info, edge_info, 'is_collector');
is_emm_mat  = get_adjamat(node_info, edge_info, 'is_emitter');

is_base_mat(isnan(is_base_mat))=false;
is_coll_mat(isnan(is_coll_mat))=false;
is_emm_mat(isnan(is_emm_mat))  =false;

matmem.is_ce = is_coll_mat & is_emm_mat;
matmem.is_be = is_base_mat & is_emm_mat;
matmem.is_bc = is_base_mat & is_coll_mat;
matmem.is_trans = matmem.is_ce | matmem.is_be | matmem.is_bc;

for crt_source=1:node_info.num_nodes
    for crt_sink=1:node_info.num_nodes
        matmem.transistor{crt_sink,crt_source} = get_device(edge_info, crt_source, crt_sink);
    end
end