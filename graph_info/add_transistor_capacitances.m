function mem = add_transistor_capacitances(mem)
% adds edges for Ebers-Moll transistor capacitances  
% ----------------------------------------------------------------------
% INPUTS:
% edge_info         ... edge_info_type
% OUTPUTS:
% edge_info         ... edge_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

new_edges = get_transistor_capacitances(mem.G.Edges.info');
mem = add_new_circuit_edges(mem, new_edges);
mem = merge_multiple_edges(mem);
mem = circuit_display_assign_colors3(mem);
