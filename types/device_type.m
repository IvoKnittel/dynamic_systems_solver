function device = device_type()
% the device type is either linear or nonlinear
device.type          = [];
device.data          = [];
device.var.j         = 0;
device.var.q         = 0;
device.time_constant = NaN;
device.var.error     = false;