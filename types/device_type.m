function device = device_type()
device.R            = [];
device.L            = [];
device.C            = [];
device.nonlinear    = [];
device.R_is_dummy   = [];
device.L_is_dummy   = [];
device.C_is_dummy   = [];

device.var.j        = 0;
device.var.q        = 0;

device.time_constant= NaN;
device.var.error    = false;
