function edge_info = edge_info_type()
%edge info: what edges exist, an for each edge the name and what device is
%residing on it
% ------------------------------------------------------------------------
edge_info.id           = 0;
edge_info.s            = 0;
edge_info.t            = 0;
edge_info.s_by_id      = 0;
edge_info.t_by_id      = 0;
edge_info.linear       = linear_device_info_type();
edge_info.device_info  = {};
edge_info.labels       = [];
edge_info.colors       = [];