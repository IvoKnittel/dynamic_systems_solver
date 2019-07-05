function [devices, total_current, time_constant, voltage_range, error] = get_edge_current(devices, node_voltages, sink_idx, source_idx, comp_params, max_time_constant)
% get current through an edge,
% the edge time constant
% the error state of the edge,
% and the updated internal states of the devices on the edge  
% ------------------------------------------------
% INPUTS:
% nodes               ... array of circuit_node_type
% edges               ... array of circuit_edge_type
% 
% OUTPUTS:
% nodes               ... array of circuit_node_type
% ----------------------------------------------
total_current = 0;
time_constant = Inf;
error         = false;
voltage_range = Inf;
if isempty(devices)
    return
end

for device_idx = 1:length(devices)
    [devices(device_idx), current, crt_time_constant, crt_voltage_range, crt_error] = current_single_device(devices(device_idx), node_voltages, sink_idx, source_idx, comp_params, max_time_constant);
    % the edge current is the sum of device currents
    % ----------------------------------------------
    total_current = total_current + current;
     
    % the edge time constant is the shortest device time constant
    % -----------------------------------------------------------
    time_constant = min(crt_time_constant, time_constant*comp_params.time_constant_factor);
    
    % get voltage range of the node of the overlap of device voltage ranges 
    % ---------------------------------------------------------------------  
    voltage_range = min(voltage_range, crt_voltage_range);     
    
    % the edge is in error if any of its devices is in error
    % ------------------------------------------------------
    error = error && crt_error;
end