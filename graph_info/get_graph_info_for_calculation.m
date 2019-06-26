function [node_info, edge_info, matmem] = get_graph_info_for_calculation(node_info, edge_info, comp_params)

[node_info2, edge_info2] = remove_cicuit_nodes(node_info, edge_info, find(node_info.disp_only~=0));
trans_idx = find(node_info2.is_trans~=0);
[node_info3, edge_info3] = remove_cicuit_nodes(node_info2, edge_info2, trans_idx(1));
trans_idx = find(node_info3.is_trans~=0);
[node_info, edge_info] = remove_cicuit_nodes(node_info3, edge_info3, trans_idx);

last_s = 0;
multiple_idx_info=[];
unique_id = 1;
for j=1:length(edge_info.s)
    if edge_info.s(j) == last_s
        continue
    end
    same_s_value = edge_info.s == edge_info.s(j);
               
    t_values = unique(edge_info.t(same_s_value));
    for k=1:length(t_values)
        multiple_idx      =  find(same_s_value & edge_info.t == t_values(k));
        if length(multiple_idx)>1
            multiple_idx_info =[ multiple_idx_info [multiple_idx; unique_id*ones(1,length(multiple_idx))]];
            unique_id = unique_id + 1;
        end
    end
    last_s = edge_info.s(j);
end

if ~isempty(multiple_idx_info)
    last_s          = multiple_idx_info(2,1);
    start_merge_idx = 1;
    for end_merge_idx = 1:size(multiple_idx_info,2)
        if multiple_idx_info(2,end_merge_idx) == last_s && end_merge_idx<size(multiple_idx_info,2)  
            last_s = edge_info.s(end_merge_idx);
            continue
        end
        [edge_info, node_info] = merge_multiple_edges_in_info(edge_info, node_info, multiple_idx_info(1,start_merge_idx:end_merge_idx));     
        last_s = edge_info.s(end_merge_idx);
        start_merge_idx = end_merge_idx+1;
    end
end

[node_info, edge_info] = init_cicuit_nodes(node_info, edge_info);
edge_info = reorder_edge_info(edge_info, node_info.names);
node_info.num_nodes = length(node_info.names);  

matmem.R = get_adjamat(node_info, edge_info, 'R');

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

% index of the ground input
% -------------------------
grd_idx                     = find(strcmp(node_info.names,'sink'));  
matmem.C            = get_adjamat(node_info, edge_info, 'C');
matmem.C(grd_idx,:) = node_info.Cgrd;
matmem.C(:,grd_idx) = node_info.Cgrd';
matmem.L = get_adjamat(node_info, edge_info, 'L');

is_R = ~isnan(matmem.R);
is_C = ~isnan(matmem.C);
is_L = ~isnan(matmem.L);
is_connection = is_R | is_C | is_L | matmem.is_trans;
matmem.RInf = matmem.R;
matmem.RInf(~is_connection)=Inf;
matmem.Reps = matmem.R;
matmem.Reps(~is_connection) = comp_params.eps;
matmem.Reps(isnan(matmem.Reps)) = 0;

idx=1:node_info.num_nodes;
for j=1:node_info.num_nodes
   matmem.Reps(j,idx<j) = - matmem.Reps(j,idx<j);
end

matmem.LInf = matmem.L;
matmem.LInf(~is_connection)     = Inf;
matmem.LInf(isnan(matmem.LInf)) = 0;

matmem.maskabs_mat = matmem.LInf;
matmem.maskabs_mat(~matmem.maskabs_mat==Inf) = 0;