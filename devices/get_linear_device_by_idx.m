function linear_device = get_linear_device_by_idx(linear_info, dummy_resistor, dummy_inductance)
linear_device = [];
is_valid = impedance_has_actual_value([linear_info.R.val linear_info.L.val linear_info.C.val]);
if any(is_valid)
    linear_device                   = device_type();
    linear_device.type              = 'linear';
    linear_device.data              = linear_device_data_type();
    linear_device.data.sigma        = 1/linear_info.R.val;
    linear_device.data.R            = linear_info.R;
    linear_device.data.L            = linear_info.L;
    linear_device.data.C            = linear_info.C;
    linear_device.var.j             = 0;
    linear_device.var.q             = 0;
    linear_device.var.error         = false;
    
    if impedance_has_actual_value(linear_info.R.val) && ~any(impedance_has_actual_value([linear_info.L.val linear_info.C.val]))
        % resistor only, insert dummy inductance
        linear_device.data.L.val        = dummy_inductance;
        linear_device.data.L.is_dummy   = true;
    end
    
    if impedance_has_actual_value(linear_info.C.val) && impedance_has_actual_value(linear_info.L.val)
       error('linear device cannot be an oscillator');
    end
    
     if impedance_has_actual_value(linear_info.C.val) && ~impedance_has_actual_value(linear_info.R.val)
        % resistor only, insert dummy inductance
        linear_device.data.R.val        = dummy_resistor;
        linear_device.data.R.is_dummy   = true;
    end
    linear_device.time_constant     = set_device_default_time_constant(linear_device);
end
