function nodes = node_info_to_nodes_init(node_info, edges, C_to_ground)
% gets nodes from node_info struct, calculates the capacitance and default
% time constant of each circuit node
% ----------------------------------------------------------------------
% INPUTS:
% node_info           ... node_info_type
% edges               ... array of edge type
% 
% OUTPUTS:
% nodes               ... array of cicuit_node_type
% ----------------------------------------------
nodes = repmat(circuit_node_type(),1,length([node_info.names]));
for crt_node = 1:length(node_info)
  crt_edges  = find([edges.s]== crt_node);
  for idx =1:length(crt_edges)
     if ~isempty(edges(crt_edges(idx)).linear_device) 
        nodes(crt_node).C = nodes(crt_node).C + edges(crt_edges(idx)).linear_device.data.C.val;
     end
  end
end

sink_idx = find(strcmp([node_info.names],'sink'));
nodes(sink_idx).C = max(nodes(sink_idx).C, C_to_ground);

for crt_node=1:length(node_info)
  nodes(crt_node).timeconstant         = NaN;
  nodes(crt_node).invC                 = 1/nodes(crt_node).C;
  nodes(crt_node).var.timeconstant     = NaN;  
  nodes(crt_node).var.potential        = 0;  
end

