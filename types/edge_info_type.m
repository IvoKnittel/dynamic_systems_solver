function edge_info = edge_info_type()
%edge info: what edges exist, an for each edge the name and what device is
%residing on it
% ------------------------------------------------------------------------
edge_info.id           = 0;
edge_info.s            = 0;
edge_info.t            = 0;
edge_info.s_by_id      = 0;
edge_info.t_by_id      = 0;
edge_info.R            = 0;
edge_info.L            = 0;
edge_info.C            = 0;
edge_info.is_base      = false;
edge_info.is_collector = false;
edge_info.is_emitter   = false;
edge_info.is_bc        = false;
edge_info.is_be        = false;
edge_info.is_ce        = false;
edge_info.device_info  = {};
edge_info.labels       = [];
edge_info.colors       = [];
edge_info.R_is_dummy   = 0;
edge_info.L_is_dummy   = 0;
edge_info.C_is_dummy   = 0;
edge_info.reverse      = false;