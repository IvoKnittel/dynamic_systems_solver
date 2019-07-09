function mem = merge_multiple_edges(mem)
% All multiple edges in a cicuits are each merged into one edge
% carrying devices in parallel
% ----------------------------------------------------------------------
% INPUTS:
% edge_info       ... edge_info_type
% OUTPUTS:
% edge_info     ... edge_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved
 node_info = mem.G.Nodes.info';
[new_edges, delete_edge_idx] = get_multiple_edges_to_merge(node_info, mem.G.Edges.info'); 
mem.G = rmedge(mem.G, delete_edge_idx);
mem.G = reorder_edge_info(mem.G, [node_info.id]);
mem   = add_new_circuit_edges(mem, new_edges);