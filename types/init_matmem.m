function matmem = init_matmem(num_nodes, num_edges)
% initialized the memory for circuit computation 
% ----------------------------------------------------------------------
% INPUTS:
% num_nodes          ... number of nodes
% OUTPUTS:
% matmem             ... empty memory struct
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved 

%init constant part
% ----------
matmem.const.num_nodes = num_nodes;
matmem.const.transistor   = cell(num_nodes, num_nodes);
matmem.const.is_ce        = false(1,num_edges);
matmem.const.is_be        = false(1,num_edges);
matmem.const.is_bc        = false(1,num_edges);
matmem.const.is_trans     = false(1,num_edges);

matmem.const.R            = NaN(num_nodes, num_nodes);
matmem.const.C            = NaN(num_nodes, num_nodes);
matmem.const.L            = NaN(num_nodes, num_nodes);

matmem.const.RInf         = NaN(num_nodes, num_nodes);
matmem.const.sigma        = NaN(num_nodes, num_nodes);
matmem.const.Reps         = NaN(num_nodes, num_nodes);
matmem.const.LInf         = NaN(num_nodes, num_nodes);
matmem.const.maskabs_mat  = NaN(num_nodes, num_nodes);

matmem.var.num_nodes      = NaN(num_nodes, num_nodes);
matmem.var.currents       = NaN(num_nodes, num_nodes);
matmem.var.dI             = NaN(num_nodes, num_nodes);
matmem.var.C              = NaN(num_nodes, num_nodes);
matmem.var.R              = NaN(num_nodes, num_nodes);
matmem.var.sigma          = NaN(num_nodes, num_nodes);