function [devices, total_current, time_constant, error] = get_edge_current(devices, node_voltages, sink_idx, source_idx, comp_params, max_time_constant)
% 
% ------------------------------------------------
% INPUTS:
% nodes               ... array of circuit_node_type
% edges               ... array of circuit_edge_type
% 
% OUTPUTS:
% nodes               ... array of circuit_node_type
% ----------------------------------------------
total_current = 0;
time_constant=Inf;
error = false;

if isempty(devices)
    return
end

for device_idx = 1:length(devices)
    [devices(device_idx), current, crt_time_constant, crt_error] = current_single_device(devices(device_idx), node_voltages, sink_idx, source_idx, comp_params, max_time_constant);
     total_current = total_current + current; 
    time_constant = min(crt_time_constant, time_constant*comp_params.time_constant_factor);
    error = error && crt_error;
end