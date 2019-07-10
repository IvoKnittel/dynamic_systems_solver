function mem = add_transistor_capacitances(mem)
% adds edges for Ebers-Moll transistor capacitances  
% ----------------------------------------------------------------------
% INPUTS:
% edge_info         ... edge_info_type
% OUTPUTS:
% edge_info         ... edge_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved
% find all Ebers-Moll transisitor replacement devices
edge_info = mem.G.Edges.info';
device_info = [edge_info.device_info];
trans_idx=[];
for j=1:length(device_info)
    if ~isempty(device_info(j).class)
        trans_idx=[trans_idx j];
    end
end
if isempty(trans_idx)
   return
end
[new_edges, edge_info(trans_idx)] = get_transistor_capacitances(edge_info(trans_idx));
mem.G.Edges.info = edge_info';
mem = add_new_circuit_edges(mem, new_edges);
mem = merge_multiple_edges(mem);
mem = circuit_display_assign_colors3(mem);
