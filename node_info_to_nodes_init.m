function nodes = node_info_to_nodes_init(node_info, edges)
nodes = rempmat(node_type(),1,length(node_info.names));
for crt_node=1:length(node_info.names)
  node_info.active     = node_info.active(crt_node);

  crt_edges         = [edges.s]== crt_node;
  crt_edges_reverse         = [edges.t]== crt_node;
    
  for idx =1:length(crt_edges)
     nodes(crt_nodes).C =   nodes(crt_nodes).C + edges(crt_edges(idx)).linear_device.data.C;
  end
  
  sigma=0;
  for idx =1:length(crt_edges_reverse)
     sigma = sigma +  edges(crt_edges_reverse(idx)).linear_device.data.sigma;
  end
  
  nodes(crt_nodes).timeconstant         = C/sigma;
  nodes(crt_nodes).invC                 = 1/C;
  nodes(crt_nodes).var.timeconstant     = NaN;  
  nodes(crt_nodes).var.potential        = NaN;
end