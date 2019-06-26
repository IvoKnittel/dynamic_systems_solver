function [node_info, edge_info] = init_cicuit_nodes(node_info, edge_info)
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

[node_info, edge_info]= circuit_display_assign_colors(node_info, edge_info);

edge_info.s=zeros(1,length(edge_info.s_by_name));
edge_info.t=zeros(1,length(edge_info.s_by_name));
for j=1:length(edge_info.s_by_name)
    edge_info.s(j) = find(strcmp(edge_info.s_by_name{j},node_info.names));      
    edge_info.t(j) = find(strcmp(edge_info.t_by_name{j},node_info.names));
end