function [probe_delta_u, nonlinearity] = try_device_nonlinearity(device_data, node_potentials, source_idx, sink_idx, probe_delta_u, comp_params)
% returns a new voltage range that is  either increased or decreased
% ------------------------------------------------------------------
% INPUTS:
% device_data               ... nonlinear device data type
% node_potentials           ... array of node potentials
% source_idx                ... source node index
% sink_idx                  ... sink node index
% probe_delta_u             ... voltage range struct  
% comp_params               ... computation parameters
%
% OUTPUTS:
% probe_delta_u             ... voltage range struct  
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved
nonlinearity = get_nonlinearity_intern(device_data, node_potentials, source_idx, sink_idx, probe_delta_u.val(end),  comp_params.voltage_tolerance);
if nonlinearity < comp_params.nonlinearity_threshold
    probe_delta_u.val = [probe_delta_u.val 2*probe_delta_u.val];
    probe_delta_u.sign_change = [probe_delta_u.sign_change 1];
else
    probe_delta_u.val = [probe_delta_u.val probe_delta_u.val/2];
    probe_delta_u.sign_change = [probe_delta_u.sign_change -1];
end

function nonlinearity = get_nonlinearity_intern(device_data, node_potentials, source_idx, sink_idx, probe_delta_u, voltage_tolerance)
% get nonlinearity measure between 0 (perfect linear) and 1 (nonlinearity equals the signal itself)
% -------------------------------------------------------------------------------------------------
% INPUTS:
% device_data               ... nonlinear device data type
% node_potentials           ... array of node potentials
% source_idx                ... source node index
% sink_idx                  ... sink node index
% probe_delta_u             ... voltage range struct  
% voltage_tolerance         ... a voltage too small to measure
%
% OUTPUTS:
% probe_delta_u             ... voltage range struct  
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

current_0   = get_current_of_transistor_device(device_data.class, node_potentials, source_idx, sink_idx, device_data.base_idx);
probed_node_idx =  [source_idx sink_idx];
probed_voltages =  node_potentials(probed_node_idx);
node_potentials(probed_node_idx) =  probed_voltages + [-1 1]*probe_delta_u/2;
current_neg   = get_current_of_transistor_device(device_data.class, node_potentials, source_idx, sink_idx, device_data.base_idx);
node_potentials(probed_node_idx) =  probed_voltages + [1 -1]*probe_delta_u/2;
current_pos   = get_current_of_transistor_device(device_data.class, node_potentials, source_idx, sink_idx, device_data.base_idx);

if abs(current_neg - current_pos) > voltage_tolerance
   nonlinearity = abs(1-(current_0 - current_neg)/(current_pos - current_0));
else
   nonlinearity = 0;
end