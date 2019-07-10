function  time_constant = set_device_default_time_constant(device)
time_constant = NaN;
switch device.type
    case 'nonlinear'
         time_constant = Inf;
    case 'linear'   
        if impedance_has_actual_value(device.data.L.val)
           time_constant = device.data.L.val/device.data.R.val; 
        end
        if impedance_has_actual_value(device.data.C.val)
           time_constant = device.data.R.val*device.data.C.val; 
        end
end