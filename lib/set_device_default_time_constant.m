function  time_constant = set_device_default_time_constant(device)
time_constant = NaN;
switch device.type
    case 'nonlinear'
         time_constant = Inf;
    case 'linear'   
        if impedance_has_actual_value(device.data.L)
           time_constant = device.data.L/device.data.R; 
        end
        if impedance_has_actual_value(device.data.C)
           time_constant = device.data.R*device.data.C; 
        end
end