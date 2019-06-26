function [node_info, edge_info] = init_cicuit_nodes(node_info, edge_info)
       

[node_info, edge_info]= circuit_display_assign_colors(node_info, edge_info);

edge_info.s=zeros(1,length(edge_info.s_by_name));
edge_info.t=zeros(1,length(edge_info.s_by_name));
for j=1:length(edge_info.s_by_name)
    edge_info.s(j) = find(strcmp(edge_info.s_by_name{j},node_info.names));      
    edge_info.t(j) = find(strcmp(edge_info.t_by_name{j},node_info.names));
end