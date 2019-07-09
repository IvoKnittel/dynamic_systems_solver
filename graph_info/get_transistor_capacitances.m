function new_edges = get_transistor_capacitances(edge_info)
new_edges =[];
% find all Ebers-Moll transisitor replacement devices
trans_idx = find([edge_info.is_be] | [edge_info.is_bc] | [edge_info.is_ce]);
for j   = 1:length(trans_idx)
    idx = trans_idx(j);
    % add a parasitic capacitance in parallel to each Ebers-Moll device
    % -----------------------------------------------------------------
    new_edge_info             = edge_info_type();
    new_edge_info.L           = NaN;
    % same end nodes
    % --------------
    new_edge_info.s           = edge_info(idx).s;
    new_edge_info.t           = edge_info(idx).t;
    new_edge_info.s_by_id     = edge_info(idx).s_by_id;
    new_edge_info.t_by_id     = edge_info(idx).t_by_id;    
    
    % fill everything else with "nothing"
%     new_edge_info.labels          = [];
%     new_edge_info.colors          = [];
%     new_edge_info.R_is_dummy      = false;
%     new_edge_info.L_is_dummy      = false;
%     new_edge_info.C_is_dummy      = false;
%     new_edge_info.is_base         = 0;
%     new_edge_info.is_collector    = 0;
%     new_edge_info.is_emitter      = 0;  
%     new_edge_info.is_bc           = 0;   
%     new_edge_info.is_be           = 0;   
%     new_edge_info.is_ce           = 0;  
%     new_edge_info.device_info     = nonlinear_device_info_type();
    
    device_info                   = edge_info(idx).device_info;
    for k = 1:length(device_info.Ct)
        new_edge_info.C               = [device_info.Ct(k)];
        new_edge_info.R               = [device_info.Rt(k)];   
        new_edges =[new_edges new_edge_info];
    end
end