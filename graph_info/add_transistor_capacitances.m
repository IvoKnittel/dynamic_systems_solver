function edge_info = add_transistor_capacitances(edge_info)
% adds edges for Ebers-Moll transistor capacitances  
% ----------------------------------------------------------------------
% INPUTS:
% edge_info         ... edge_info_type
% OUTPUTS:
% edge_info         ... edge_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

% find all Ebers-Moll trnsisitor replacement devices
trans_idx = find(edge_info.is_be | edge_info.is_bc | edge_info.is_ce);
for idx=1:length(trans_idx)
    % add a parasitic capacitance in parallel to each Ebers-Moll device
    % -----------------------------------------------------------------
    new_edge_info             = edge_info_type();
    new_edge_info.C           = sum(edge_info.device_info(trans_idx(idx)).Ct);
    new_edge_info.R           = sum(edge_info.device_info(trans_idx(idx)).Rt);   
    new_edge_info.L           = NaN;
    % same end nodes
    % --------------
    new_edge_info.s           = edge_info.s(trans_idx(idx));
    new_edge_info.t           = edge_info.t(trans_idx(idx));
    new_edge_info.s_by_name   = edge_info.s_by_name(trans_idx(idx));
    new_edge_info.t_by_name   = edge_info.t_by_name(trans_idx(idx));    
    
    % fill everything else with "nothing"
    new_edge_info.id              = edge_info.next_unique_id;
    edge_info.next_unique_id      = edge_info.next_unique_id + 1;   
    new_edge_info.labels          = [];
    new_edge_info.colors          = [];
    new_edge_info.R_is_dummy      = false;
    new_edge_info.L_is_dummy      = false;
    new_edge_info.C_is_dummy      = false;
    new_edge_info.is_base         = 0;
    new_edge_info.is_collector    = 0;
    new_edge_info.is_emitter      = 0;  
    new_edge_info.is_bc           = 0;   
    new_edge_info.is_be           = 0;   
    new_edge_info.is_ce           = 0;  
    new_edge_info.device_info     = nonlinear_device_info_type();
    edge_info =  appped_edge_to_info(edge_info, new_edge_info);
end