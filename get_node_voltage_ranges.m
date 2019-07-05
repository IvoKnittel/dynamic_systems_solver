function voltage_ranges   = get_node_voltage_ranges(nodes, edges, comp_params)
% get linear voltage range for nonlinear devices
% -----------------------------------------------------------
% INPUTS:
% nodes           ... (1,n) array of circuit node type
% edges           ... array of circuit edge type
% comp_params     ... computation parameters
%
% OUTPUTS:
% voltage_ranges  ... (1,n) array of [min;max] voltage ranges
%                      each relative to the potential of its respective node
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

% init output
voltage_ranges = repmat([-Inf;Inf],1,length(nodes));

nodes_var = [nodes.var];
for node_idx=1:length(nodes)
    % get edges connecting to this node
    % ---------------------------------
    crt_edges = edges(get_from_edges(edges, 'edges_to_node', node_idx));
    
    % get all devices connecting to this node
    % ---------------------------------
    crt_nonlinear_devices = [crt_edges.nonlinear_devices];
    
    % get startend nodes of each device
    % ---------------------------------    
    st_vec = [];
    for idx=1:length(crt_edges)
        st_vec = [st_vec [crt_edges(idx).s;crt_edges(idx).t]*ones(1,length(crt_edges(idx).nonlinear_devices))];
    end
    
    for m=1:length(crt_nonlinear_devices)
        % get voltage range for each device 
        % ---------------------------------  
        
        % start/end nodes are interchangable, nonlinearity is symmetric
        crt_device_voltage_range = get_device_nonlinearity(crt_nonlinear_devices(m).data, [nodes_var.potential], st_vec(1,m), st_vec(2,m), comp_params);
        
        % get voltage range of the node of the overlap of device voltage ranges 
        % ---------------------------------------------------------------------  
        voltage_ranges(1,node_idx) = min(voltage_ranges(1,node_idx), crt_device_voltage_range(1));     
        voltage_ranges(2,node_idx) = min(voltage_ranges(2,node_idx), crt_device_voltage_range(2));
    end
end