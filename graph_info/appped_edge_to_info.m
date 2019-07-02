function edge_info =  appped_edge_to_info(edge_info, new_edge_info)
% adds more edges to edge info   
% ----------------------------------------------------------------------
% INPUTS:
% edge_info         ... edge_info_type
% new_edge_info     ... edge_info_type
% OUTPUTS:
% edge_info         ... edge_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved
    edge_info.id          = [edge_info.id           length(new_edge_info.s_by_name)+(1:length(new_edge_info.s_by_name))];
    edge_info.labels      = [edge_info.labels       new_edge_info.labels];
    edge_info.colors      = [edge_info.colors       new_edge_info.colors];
    edge_info.s           = [edge_info.s            new_edge_info.s];
    edge_info.t           = [edge_info.t            new_edge_info.t];
    edge_info.s_by_name   = [edge_info.s_by_name    new_edge_info.s_by_name];
    edge_info.t_by_name   = [edge_info.t_by_name    new_edge_info.t_by_name];
    edge_info.R           = [edge_info.R            new_edge_info.R];        
    edge_info.L           = [edge_info.L            new_edge_info.L];     
    edge_info.C           = [edge_info.C            new_edge_info.C];
    edge_info.R_is_dummy  = [edge_info.R_is_dummy   new_edge_info.R_is_dummy];
    edge_info.L_is_dummy  = [edge_info.L_is_dummy   new_edge_info.L_is_dummy];
    edge_info.C_is_dummy  = [edge_info.C_is_dummy   new_edge_info.C_is_dummy];
    edge_info.is_base     = [edge_info.is_base      new_edge_info.is_base];   
    edge_info.is_collector= [edge_info.is_collector new_edge_info.is_collector];   
    edge_info.is_emitter  = [edge_info.is_emitter   new_edge_info.is_emitter];  
    edge_info.is_bc       = [edge_info.is_bc        new_edge_info.is_bc];   
    edge_info.is_be       = [edge_info.is_be        new_edge_info.is_be];   
    edge_info.is_ce       = [edge_info.is_ce        new_edge_info.is_ce];  
    edge_info.device_info = [edge_info.device_info  new_edge_info.device_info];