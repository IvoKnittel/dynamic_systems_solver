function mem = remove_circuit_nodes(mem, delete_node_idx, removed_node_type)
% Nodes are removed either because they are same-potential, or transistors replaced by Ebers-Moll
% devices
% ----------------------------------------------------------------------
% INPUTS:
% mem               ... graph info memory
% delete_node_idx   ... array of indices in node_info
% removed_node_type ... either 'display_only' or 'transistor'
% OUTPUTS:
% mem               ... graph info memory
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

new_edges = get_remove_nodes_info(mem.G, delete_node_idx, removed_node_type);
mem.G     = rmnodes(mem.G, delete_node_idx);
mem       = add_new_circuit_edges(mem, new_edges);
