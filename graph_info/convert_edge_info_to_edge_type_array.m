function all_edges = convert_edge_info_to_edge_type_array(edge_info)
num_edges = length(edge_info.s);
all_edges = repmat(edge_type(),1,num_edges);
for idx=1:num_edges
    all_edges(idx).linear_device     = get_linear_device_by_idx(edge_info, idx);
    all_edges(idx).nonlinear_devices = get_nonlinear_devices_by_idx(edge_info, idx);
end

function linear_device = get_linear_device_by_idx(edge_info, idx)
linear_device = [];
assert(impedance_has_actual_value(edge_info.R(idx)));
if xor(impedance_has_actual_value(edge_info.C(idx)), impedance_has_actual_value(edge_info.L(idx)))
    assert(edge_info.L(idx) == 0 & edge_info.C(idx)==0);
end
if impedance_has_actual_value([edge_info.R(idx) edge_info.L(idx) edge_info.C(idx)])
    linear_device                   = device_type();
    linear_device.type              = 'linear';
    linear_device.data              = linear_device_data_type();
    linear_device.data.R            = edge_info.R(idx);
    linear_device.data.sigma        = 1/edge_info.R(idx);      
    linear_device.data.L            = edge_info.L(idx);
    linear_device.data.C            = edge_info.C(idx);
    linear_device.data.R_is_dummy   = edge_info.R_is_dummy(idx);
    linear_device.data.L_is_dummy   = edge_info.L_is_dummy(idx);
    linear_device.data.C_is_dummy   = edge_info.C_is_dummy(idx);
    linear_device.var.j             = 0;
    linear_device.var.q             = 0;
    linear_device.time_constant     = NaN;
    linear_device.var.error         = false;
end