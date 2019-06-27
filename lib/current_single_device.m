function  current = current_single_device(device_id, node_voltages, source_idx, sink_idx, base_idx)
% gets current from node voltages and constant impedance and device
% matrices
% ----------------------------------------------------------------------
% INPUTS:
% device_id      ... string identifier
% node_voltages  ... potentials of all n nodes
% source_idx     ... node index
% sink_idx       ... node index
% base_idx       ... node index
% 
% OUTPUTS:
% current        ... current value
% ----------------------------------------------

u_source = node_voltages(source_idx); 
u_sink = node_voltages(sink_idx); 
switch device_id
    case 'diode'
         % passes for positive voltage
         du = u_source - u_sink;
         %                           nVt, Isat
         current         = diode(du, 0.4, 1e-3);
    case 'bc' %current from collector to base
        %blocks for positive voltage
        [dummy,dummy2, current]           = ebersmoll(NaN,u_sink-u_source);
    case 'ec' %current from collector to emitter
         u_base = node_voltages(base_idx);
         ubase_emitter   = u_base-u_sink;   % transistor action if this is >0.7V
         ubase_collector = u_base-u_source; % this should be negative, blocking
        [dummy, current]                  = ebersmoll(ubase_emitter,ubase_collector);
    case 'ce' %current from collector to emitter
         u_base = node_voltages(base_idx);
         ubase_emitter   = u_base-u_sink;   % transistor action if this is >0.7V
         ubase_collector = u_base-u_source; % this should be negative, blocking
        [dummy, current]                  = ebersmoll(ubase_emitter,ubase_collector);
    case 'eb' %current from base to emitter
        [dummy, dummy2, dummy3, current]  = ebersmoll(u_source-u_sink,NaN);  
    case 'be' %current from base to emitter
        [dummy, dummy2, dummy3, current]  = ebersmoll(u_source-u_sink,NaN);  
    case 'bc2'
        [dummy,dummy2, current]           = ebersmoll(NaN,u_sink-u_source);
    case 'ec2'
        [dummy, current]                  = ebersmoll(ubase-u_sink,ubase-u_source);
    case 'eb2'
        [dummy, dummy2, dummy3, current]  = ebersmoll(u_source-u_sink,NaN);
end