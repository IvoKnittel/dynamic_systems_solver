function edge_currents = get_edge_currents(node_voltages, mem_const, sigma)
% gets current from node voltages and constant impedance and device
% matrices
% ----------------------------------------------------------------------
% INPUTS:
% node_voltages  ... potentials of all n nodes
% mem_const      ... impedance matrices
% OUTPUTS:
% edge_currents  ... (n,n) current matrix
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved 

% the edge current matrix
% ------------------------
% element i j being the current from node j to node i
% the current matrix is antisymmentric
%
%          sources
%          * * * *
%          a * * *
% sinks    b d * *
%          c e f *
% read:  device a connects node 1 with node 2, the current 1 to 2 is
% edge_current(1,2) 

num_nodes=mem_const.num_nodes;
edge_currents=zeros(num_nodes,num_nodes);
for crt_source=1:num_nodes
    % for current source node, loop over all nodes it is feeding
    for crt_sink=1:num_nodes
        
        % a node doesnt feed itself. Also ignore nodes that have been
        % processed as sources before
        if crt_sink<=crt_source
            continue;
        end
        
        current = sigma(crt_source, crt_sink)*(node_voltages(crt_source) - node_voltages(crt_sink));
        current = current + current_source_to_sink(mem_const.transistor, node_voltages, crt_source, crt_sink);
        edge_currents(crt_sink,crt_source) =  current;
        edge_currents(crt_source,crt_sink) = -current;
    end
end

function total_current = current_source_to_sink(mem_transistor, node_voltages, source_idx, sink_idx)
devices  = mem_transistor{sink_idx,source_idx};

total_current = 0;

if isempty(devices)
    return
end

for device_idx = 1:length(devices)
    crt_device = devices{device_idx};
    total_current = total_current + current_single_device(crt_device.class, node_voltages, source_idx, sink_idx, crt_device.base_idx);
end