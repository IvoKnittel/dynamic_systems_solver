function all_edges = convert_edge_info_to_edge_type_array(edge_info)
% converts edge_info to an edge_type array
% ----------------------------------------------
% INPUTS:
% edge_info         ... edge_info_type
% OUTPUTS:
% edges             ... array of edge_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved
num_edges = length(edge_info.s);
all_edges = repmat(edge_type(),1,num_edges);
for idx=1:num_edges
    all_edges(idx).s = edge_info.s(idx);
    all_edges(idx).t = edge_info.t(idx);
    all_edges(idx).linear_device     = get_linear_device_by_idx(edge_info, idx);
    all_edges(idx).nonlinear_devices = get_nonlinear_devices_by_idx(edge_info, idx);
end

function linear_device = get_linear_device_by_idx(edge_info, idx)
linear_device = [];
%assert(impedance_has_actual_value(edge_info.R(idx)));
if ~xor(impedance_has_actual_value(edge_info.C(idx)), impedance_has_actual_value(edge_info.L(idx)))
    k=1;%assert(edge_info.L(idx) == 0 & edge_info.C(idx)==0 | edge_info.L(idx) == 0 & isinf(edge_info.C(idx)));
end
is_valid = impedance_has_actual_value([edge_info.R(idx) edge_info.L(idx) edge_info.C(idx)]);
if any(is_valid)
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

if isinf(edge_info.C(idx))
    linear_device                   = device_type();
    linear_device.type              = 'linear';
    linear_device.data              = linear_device_data_type();
    linear_device.data.R            = 0;
    linear_device.data.sigma        = Inf;      
    linear_device.data.L            = 0;
    linear_device.data.C            = edge_info.C(idx);
    linear_device.data.R_is_dummy   = false;
    linear_device.data.L_is_dummy   = false;
    linear_device.data.C_is_dummy   = false;
    linear_device.var.j             = 0;
    linear_device.var.q             = 0;
    linear_device.time_constant     = NaN;
    linear_device.var.error         = false;
end
