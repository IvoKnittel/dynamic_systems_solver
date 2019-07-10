function linear_device = get_linear_device_by_idx(edge_info, idx, dummy_resistor, dummy_inductance)
linear_device = [];
is_valid = impedance_has_actual_value([edge_info(idx).R.val edge_info(idx).L.val edge_info(idx).C.val]);
if any(is_valid)
    linear_device                   = device_type();
    linear_device.type              = 'linear';
    linear_device.data              = linear_device_data_type();
    linear_device.data.sigma        = 1/edge_info(idx).R.val;
    linear_device.data.R            = edge_info(idx).R;
    linear_device.data.L            = edge_info(idx).L;
    linear_device.data.C            = edge_info(idx).C;
    linear_device.var.j             = 0;
    linear_device.var.q             = 0;
    linear_device.var.error         = false;
    
    if impedance_has_actual_value(edge_info(idx).R.val) && ~any(impedance_has_actual_value([edge_info(idx).L.val edge_info(idx).C.val]))
        % resistor only, insert dummy inductance
        linear_device.data.L.val        = dummy_inductance;
        linear_device.data.L.is_dummy   = true;
    end
    
    if impedance_has_actual_value(edge_info(idx).C.val) && impedance_has_actual_value(edge_info(idx).L.val)
       error('linear device cannot be an oscillator');
    end
    
     if impedance_has_actual_value(edge_info(idx).C.val) && ~impedance_has_actual_value(edge_info(idx).R.val)
        % resistor only, insert dummy inductance
        linear_device.data.R.val        = dummy_resistor;
        linear_device.data.R.is_dummy   = true;
    end
    linear_device.time_constant     = set_device_default_time_constant(linear_device);
end
