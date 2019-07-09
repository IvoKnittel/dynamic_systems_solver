function linear_device = get_linear_device_by_idx(edge_info, idx, dummy_resistor, dummy_inductance)
linear_device = [];
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
    linear_device.var.error         = false;
    
    if impedance_has_actual_value(edge_info.R(idx)) && ~any(impedance_has_actual_value([edge_info.L(idx) edge_info.C(idx)]))
        % resistor only, insert dummy inductance
        linear_device.data.L            = dummy_inductance;
        linear_device.data.L_is_dummy   = true;
    end
    
    if impedance_has_actual_value(edge_info.C(idx)) && impedance_has_actual_value(edge_info.L(idx))
       error('linear device cannot be an oscillator');
    end
    
     if impedance_has_actual_value(edge_info.C(idx)) && ~impedance_has_actual_value(edge_info.R(idx))
        % resistor only, insert dummy inductance
        linear_device.data.R            = dummy_resistor;
        linear_device.data.R_is_dummy   = true;
    end
    linear_device.time_constant     = set_device_default_time_constant(linear_device);
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
