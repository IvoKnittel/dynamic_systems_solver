function  [device, current, time_constant, error] = current_single_device(device, node_voltages, source_idx, sink_idx, comp_params, max_time_constant)
% gets current from node voltages and constant impedance and device
% matrices
% ----------------------------------------------------------------------
% INPUTS:
% device         ... device_type
% node_voltages  ... potentials of all n nodes
% source_idx     ... node index
% sink_idx       ... node index
% base_idx       ... node index
% 
% OUTPUTS:
% current        ... current value
% ----------------------------------------------

% applied voltage and own voltage are different, set internal state
% an edge in general contains device, R, L, and C
% it is either nonlinear or RLC  (missing nl device is []) 
%      |              |
%      |          --------
%      |         |        |
%      |         L        C      either, or   
%      |                         missing L is L = 0 
%      |                         missing C is C = 0
%      |         |        |
%      |          -------- 
%      |              |
%      |              |
%   nl-device         R      missing R is R = Inf 
%      |              |        
%                     |
% R,L,C may be dummy, tiny for computation only.

current       = 0;
time_constant = NaN;
error         = false;
switch device.type
    case 'nonlinear'
         current       = get_current_of_transistor_device(device.data.class, node_voltages, source_idx, sink_idx, device.data.base_idx);
         time_constant = min(max_time_constant, comp_params.time_epsilon);
         error         = false;
    case 'linear'   
        voltage = node_voltages(source_idx) - node_voltages(sink_idx);
        if impedance_has_actual_value(device.data.L)
           assert(impedance_has_actual_value(device.data.C));

           % Use formula for inductance voltage
           % voltage = -device.data.L*(current - device.data.var.j)/time_constant -device.data.R*current;

           % flag error if current depends significantly on dummy impedance
           % --------------------------------------------------------------
           time_constant = min(max_time_constant, device.data.L/device.data.R); 
           error         = device.data.L_is_dummy && device.data.L/time_constant > device.data.R*comp_params.dummy_influence_threshold;
           current       = device.data.var.j - (voltage + device.data.R*current)*time_constant/device.data.L;
           device.var.j  = current;

        end
        if impedance_has_actual_value(device.data.C)
           assert(~impedance_has_actual_value(device.data.L));
           % flag error if capacitor is still charging
           % --------------------------------------------------------------
           time_constant = min(max_time_constant, device.data.R*device.data.C); 
           error         = device.data.C_is_dummy && abs(voltage - device.var.q/device.data.C) > abs(voltage)*comp_params.dummy_influence_threshold;
           current       = (voltage - device.var.q/device.data.C)/device.data.R;
           device.var.q  = current*time_constant;
        end
end