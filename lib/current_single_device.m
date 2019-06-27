function  current_single_device(device_id, u_source, u_sink, ubase)
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

             
             ubase_emitter   = ubase-u_sink;   % transistor action if this is >0.7V
             ubase_collector = ubase-u_source; % this should be negative, blocking
            [dummy, current]                  = ebersmoll(ubase_emitter,ubase_collector);
        case 'eb' %current from base to emitter
            [dummy, dummy2, dummy3, current]  = ebersmoll(u_source-u_sink,NaN);    
        case 'bc2'
            [dummy,dummy2, current]           = ebersmoll(NaN,u_sink-u_source);
        case 'ec2'
            [dummy, current]                  = ebersmoll(ubase-u_sink,ubase-u_source);
        case 'eb2'
            [dummy, dummy2, dummy3, current]  = ebersmoll(u_source-u_sink,NaN);
    end