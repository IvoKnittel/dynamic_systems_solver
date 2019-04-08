function edge_currents = get_edge_currents(node_voltages, circuit_graph)
% gets current from node voltage and a circuit graph
% --------------------------------------------------
%
% the circuit graph is given as a matrix,
% each nonzero element is a cell array of (partial)devices 
% connecting respective nodes (symmetric relation)
% a device is given by 
%           a namestring                       , for a two-connector device,
% or        a namestring and an auxilliary node, for a three-connector device 

num_nodes=size(circuit_graph,1);

% the edge current matrix
% ------------------------
% element i j being the current from node j to node i
% the current matrix is antisymmentric
%
edge_currents=zeros(num_nodes,num_nodes);
%          sources
%          * * * *
%          a * * *
% sinks    b d * *
%          c e f *
% read:  device a connects node 1 with node 2, the current 1 to 2 is
% edge_current(1,2) 

for crt_source=1:num_nodes
    % for current source node, loop over all nodes it is feeding
    for crt_sink=1:num_nodes
        
        % a node doesnt feed itself. Also ignore node that have been
        % processed as sources before
        if crt_sink<=crt_source
            continue;
        end
        current = current_source_to_sink(circuit_graph{crt_sink}{crt_source}, node_voltages, crt_source, crt_sink );
        edge_currents(crt_sink,crt_source) =  current;
        edge_currents(crt_source,crt_sink) = -current;
    end
end

function total_current = current_source_to_sink(device_id_array, node_voltages, source_idx, sink_idx)
total_current = 0;
ubase=0;
if iscell(device_id_array)
    len = length(device_id_array);
else
    len =1;
end
j=1; 
while j<=len
    if iscell(device_id_array)
       device_id = device_id_array{j};
    else
       device_id = device_id_array;
    end
    if length(device_id)>=2 && strcmp(device_id(1:2),'ec')
       base_idx  = device_id_array{j+1};
       ubase     = node_voltages(base_idx);
       j=j+1;
    end    
    
    u_source = node_voltages(source_idx); 
    u_sink   = node_voltages(sink_idx);
    
    if strcmp(device_id(1),'R')
       du = u_source - u_sink; 
       eval(['total_current = du/' device_id(2:end) ';'])
       return
    end

    if device_id ==0
        return
    end

    switch device_id
        case 0
            current = 0;
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
    
    total_current = total_current + current;
    j=j+1;
end