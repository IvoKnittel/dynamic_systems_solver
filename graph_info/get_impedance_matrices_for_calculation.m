function matmem = get_impedance_matrices_for_calculation(node_info, edge_info, comp_params)
% impedance matrices for computations are derived from graph info 
% ----------------------------------------------------------------------
% INPUTS:
% node_info     ... node_info_type
% edge_info     ... edge_info_type
% comp_params   ... computation parameters
% OUTPUTS:
% matmem        ... struct of impedance matrices
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved 

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

% set diagonal capacitance to Inf for fixed volage nodes, to zero otherwise
% -------------------------------------------------------------------------
C_diag = node_info.Cgrd;
C_diag(~isinf(node_info.Cgrd)) = 0;
matmem.C = matmem.C + diag(C_diag);

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

% get device matrix
matmem.transistor.type      = cell(node_info.num_nodes, node_info.num_nodes);
matmem.transistor.base_idx  = cell(node_info.num_nodes, node_info.num_nodes);

for crt_source=1:node_info.num_nodes
    % for current source node, loop over all nodes it is feeding
    for crt_sink=1:node_info.num_nodes
        [matmem.transistor.type{crt_sink,crt_source}, matmem.transistor.base_idx{crt_sink,crt_source}] = get_device(edge_info, crt_source, crt_sink);
    end
end


