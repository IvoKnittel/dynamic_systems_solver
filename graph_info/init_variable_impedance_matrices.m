function matmem_var = init_variable_impedance_matrices(matmem_var, matmem_const)
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

matmem_var.dI(isinf(matmem_const.LInf))=1;
matmem_var.dI(isnan(matmem_var.dI))=0;
matmem_var.C = matmem_const.C;
matmem_var.R = matmem_const.R;
