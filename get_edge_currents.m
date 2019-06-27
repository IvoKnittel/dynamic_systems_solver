function edge_currents = get_edge_currents(node_voltages, circuit_graph, edge_info, R_mat)
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
        
        % a node doesnt feed itself. Also ignore nodes that have been
        % processed as sources before
        if crt_sink<=crt_source
            continue;
        end
        if ~isnan(R_mat(crt_source, crt_sink))
            du = u_source - u_sink; 
            current = sigma*du/R_mat(crt_source, crt_sink);
        end
        current = current + current_source_to_sink([matmem_transistor, node_voltages, crt_source, crt_sink);
        edge_currents(crt_sink,crt_source) =  current;
        edge_currents(crt_source,crt_sink) = -current;
    end
end

function total_current = current_source_to_sink(matmem_transistor, node_voltages, source_idx, sink_idx)
devices  = matmem_transistor.type{crt_sink,crt_source};
base_idx = matmem_transistor.base_idx{crt_sink,crt_source};
total_current = 0;

if isempty(devices)
    return
end
for device_idx = 1:length(devices)
    total_current = total_current + current_single_device(devices{k}, node_voltages(source_idx), node_voltages(sink_idx), node_voltages(base_idx(k)));
end