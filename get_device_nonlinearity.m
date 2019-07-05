function linear_voltage_range = get_device_nonlinearity(device_data, node_potentials, source_idx, sink_idx, comp_params)
% get linear voltage range of a  nonlinear device
% 1. get nonlinearity of a trial voltage range
% 2. decrease range if nonlinearity is above threshold
% 3. increase range if nonlinearity is below threshold
% 4. stop decreasing range at the first 'increase' result
% 5. stop increasing range at the first 'decrease' result
% -----------------------------------------------------------
% INPUTS:
% device_data         ... nonlinear device data type
% node_potentials     ... array of node potentials
% source_idx          ... source node index
% sink_idx            ... sink node index
% comp_params         ... computation parameters
%
% OUTPUTS:
% linear_voltage_range... [min;max] voltage range relative to
%                         node potential
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

probe_delta_u.val         = comp_params.probe_delta_u;
probe_delta_u.sign_change = NaN;
done = false;
linear_voltage_range_abs = NaN;

while ~done && probe_delta_u.val(end) < comp_params.max_nonlinearity_voltage_range
    
    % returns a new voltage range that is  either increased or decreased
    % ------------------------------------------------------------------
    probe_delta_u = try_device_nonlinearity(device_data, node_potentials, source_idx, sink_idx, probe_delta_u, comp_params);
    
    % break at the first sign change i.e. at the first range decrease after a sequence of increases, or vice versa.
    % -------------------------------------------------------------------------------------------------------------
    if length(probe_delta_u.sign_change) > 1 && probe_delta_u.sign_change(end) ~= probe_delta_u.sign_change(2)
        linear_voltage_range_abs = probe_delta_u.val(end-1);
        done = true;
    end
end
linear_voltage_range = [linear_voltage_range_abs; linear_voltage_range_abs];