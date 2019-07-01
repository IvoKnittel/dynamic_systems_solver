function edge_info = edge_info_type()
%edge info: what edges exist, an for each edge the name and what device is
%residing on it
% ------------------------------------------------------------------------
edge_info.s            = [];
edge_info.t            = [];
edge_info.s_by_name    = {};
edge_info.t_by_name    = {};
edge_info.R            = [];
edge_info.L            = [];
edge_info.C            = [];
edge_info.is_base      = [];
edge_info.is_collector = [];
edge_info.is_emitter   = [];
edge_info.is_bc        = [];
edge_info.is_be        = [];
edge_info.is_ce        = [];
edge_info.device_info  = [];
edge_info.id           = [];
edge_info.labels       = [];
edge_info.colors       = [];
edge_info.R_is_dummy   = [];
edge_info.L_is_dummy   = [];
edge_info.C_is_dummy   = [];
edge_info.time_constant= NaN;
edge_info.var.j        = 0;
edge_info.var.q        = 0;
edge_info.var.error    = false;
