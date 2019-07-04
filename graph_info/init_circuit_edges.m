function [edge_info] = init_circuit_edges(node_info, edge_info)
% gets edge info from circuit definition and fill blanks in edge info  
% ----------------------------------------------------------------------
% INPUTS:
% edge_info         ... edge_info_type
% node_info         ... node_info_type
% OUTPUTS:
% edge_info         ... edge_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

edge_info.id             = 1:length(edge_info.s_by_name);
edge_info.next_unique_id = edge_info.id(end) + 1;
edge_info.is_bc          = zeros(1,length(edge_info.s));
edge_info.is_be          = zeros(1,length(edge_info.s));
edge_info.is_ce          = zeros(1,length(edge_info.s));
edge_info.L_is_dummy     = false(1,length(edge_info.s));
edge_info.C_is_dummy     = false(1,length(edge_info.s));
edge_info                =  reorder_edge_info(edge_info, node_info.names);