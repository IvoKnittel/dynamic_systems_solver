function edges = convert_to_device_type(edge_info, crt_edge_idx)
edges =[];
edge = edge_type();
device = device_type();
for j=1:length(crt_edge_idx)
   for k=1:length()
        device.R            = edge_info.R(crt_edge_idx(j));
        device.L            = edge_info.L(crt_edge_idx(j));
        device.C            = edge_info.C(crt_edge_idx(j));
        device.nonlinear    = get_device(edge_info, crt_edge_idx(j));

        device.R_is_dummy   = edge_info.R_is_dummy(crt_edge_idx(j));
        device.L_is_dummy   = edge_info.L_is_dummy(crt_edge_idx(j));
        device.C_is_dummy   = edge_info.C_is_dummy(crt_edge_idx(j));

        device.var.j        = 0;
        device.var.q        = 0;

        device.time_constant= NaN;
        device.var.error    = false;
        edge.devices =[edge.devices device];
    end
    edges=[edges edge];
end
