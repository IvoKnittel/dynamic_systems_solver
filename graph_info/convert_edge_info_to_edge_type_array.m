function all_edges = convert_edge_info_to_edge_type_array(edge_info)
num_edges = length(edge_info.s);
all_edges = rempmat(edge_type(),1,num_edges);
for idx=1:num_edges
    devices = edge_info_to_device(edge_info, idx);
    all_edges(idx).devices = devices;
end

function devices = edge_info_to_device(edge_info, idx)
device = [];
assert(impedance_has_actual_value(edge_info.R(idx)));
assert(xor(impedance_has_actual_value(edge_info.C(idx)), impedance_has_actual_value(edge_info.L(idx))));
if impedance_has_actual_value([edge_info.R(idx) edge_info.L(idx) edge_info.C(idx)])
    device                   = device_type();
    device.type              = 'linear';
    device.data              = linear_device_data_type();
    device.data.R            = edge_info.R(idx);
    device.data.L            = edge_info.L(idx);
    device.data.C            = edge_info.C(idx);
    device.data.R_is_dummy   = edge_info.R_is_dummy(idx);
    device.data.L_is_dummy   = edge_info.L_is_dummy(idx);
    device.data.C_is_dummy   = edge_info.C_is_dummy(idx);
    device.var.j             = 0;
    device.var.q             = 0;
    device.time_constant     = NaN;
    device.var.error         = false;
end

devices = [device get_nonlinear_devices_by_idx(edge_info, idx)];