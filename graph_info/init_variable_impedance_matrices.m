function matmem_var = init_variable_impedance_matrices(matmem_var, node_info, matmem_const)
% initializes variable impedance matrices 
% --------------------------------------------
% INPUTS:
% matmem_var    ... .var variable part of impedance matrix struct
% node_info     ...  node_info_type
% matmem_const  ... .const constant part of impedance matrix struct
% OUTPUTS:
% matmem_var    ... struct of impedance matrices
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved 

null_node_mat           = zeros(node_info.num_nodes,node_info.num_nodes);
matmem_var.currents  = null_node_mat;
matmem_var.dI        = null_node_mat;
matmem_var.dI(isinf(matmem_const.LInf))=1;
matmem_var.C = matmem_const.C;
