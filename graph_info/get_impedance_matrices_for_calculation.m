function matmem = get_impedance_matrices_for_calculation(matmem, node_info, edge_info, comp_params)
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

% index of the ground input
% -------------------------
grd_idx             = find(strcmp(node_info.names,'sink'));  
matmem.C            = get_adjamat(node_info, edge_info, 'C');
select_idx = isinf(node_info.Cgrd);
matmem.C(grd_idx,select_idx) = node_info.Cgrd(select_idx);
matmem.C(select_idx,grd_idx) = node_info.Cgrd(select_idx)';

% set diagonal capacitance to Inf for fixed volage nodes, to zero otherwise
% -------------------------------------------------------------------------
C_diag = node_info.Cgrd;
C_diag(~isinf(node_info.Cgrd)) = 0;
matmem.C = matmem.C + diag(C_diag);


comp_params.time_epsilon

matmem.L = get_adjamat(node_info, edge_info, 'L');

is_R = ~isnan(matmem.R);
is_C = ~isnan(matmem.C);
is_L = ~isnan(matmem.L);
is_connection = is_R | is_C | is_L | matmem.is_trans;
matmem.RInf = matmem.R;

matmem.RInf(~is_R)=Inf;
matmem.sigma = 1./matmem.RInf;
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

matmem.Inf_no_connect = matmem.LInf;
matmem.Inf_no_connect(~matmem.Inf_no_connect==Inf) = 0;