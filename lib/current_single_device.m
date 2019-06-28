function  [device, current, time_constant, error] = current_single_device(device, node_voltages, source_idx, sink_idx, comp_params)
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

if ~isempty(device.nonlinear)
     current       = get_current_of_transistor_device(device.nonlinear.class, node_voltages, source_idx, sink_idx, device.nonlinear.base_idx);
     time_constant = comp_params.time_epsilon;
     error         = false;
     return
end

voltage = node_voltages(source_idx) - node_voltages(sink_idx);
if impedance_has_actual_value(device.L)
   assert(impedance_has_actual_value(device.C));

   % Use formula for inductance voltage
   % voltage = -device.L*(current - device.var.j)/time_constant -device.R*current;

   % flag error if current depends significantly on dummy impedance
   % --------------------------------------------------------------
   error = device.L_is_dummy && device.L/time_constant > device.R*comp_params.dummy_influence_threshold;

   current = device.var.j - (voltage+device.R*current)*time_constant/device.L;
   device.var.j = current;
   time_constant = device.L/device.R; 
end
if impedance_has_actual_value(device.C)
   assert(impedance_has_actual_value(device.L));
   % flag error if capacitor is still charging
   % --------------------------------------------------------------
   error = device.C_is_dummy && abs(voltage - device.var.q/device.C) > abs(voltage)*comp_params.dummy_influence_threshold;
   current = (voltage - device.var.q/device.C)/device.R;
   device.var.q = current*time_constant;
   time_constant = device.R*device.C; 
end