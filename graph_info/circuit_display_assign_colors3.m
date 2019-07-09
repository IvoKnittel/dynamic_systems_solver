function mem= circuit_display_assign_colors3(mem)
node_info  = mem.G.Nodes.info;
edge_info  = mem.G.Edges.info;
[node_info, edge_info]= circuit_display_assign_colors2(node_info, edge_info);
mem.G.Nodes.info = node_info';
mem.G.Edges.info = edge_info';