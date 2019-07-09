function [node_info, edge_info] = init_circuit_nodes2(node_info, edge_info)
% fills in blanks in node and edge info
% ----------------------------------------------
% INPUTS:
% node_info  ... node_info_type
% edge_info  ... edge_info_type 
% OUTPUTS:
% node_info  ... node_info_type
% edge_info  ... edge_info_type 
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved       

[node_info, edge_info]= circuit_display_assign_colors2(node_info, edge_info);

edge_info = edge_info';
node_info=node_info';