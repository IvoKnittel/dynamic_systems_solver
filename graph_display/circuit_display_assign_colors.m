function [node_info,edge_info] = circuit_display_assign_colors(node_info, edge_info)
% a transistor node is displayed yellow
% fixed voltage nodes are displayed
% -------------------------------------

edge_info.labels      = cell(1,length(edge_info.s_by_name));
edge_info.colors      = zeros(1,length(edge_info.s_by_name));

node_info.colors=zeros(1,length(node_info.names));
for j=1:length(node_info.names)
    if node_info.is_trans(j)
        node_info.colors(j)=150;
    elseif node_info.floating
        node_info.colors(j)=1;
    else  
        node_info.colors(j)=200;
    end
    switch  node_info.floating(j)
        case 1
            if node_info.is_trans(j)
                node_info.colors(j)=150; % transistor if yellow
            else
                node_info.colors(j)=1;   % other flaoting is blue
            end
        case 2
            node_info.colors(j)=200;     % color of signal input
        case 0
            node_info.colors(j)=80;     % color of supply node
    end
end

for idx=1:length(edge_info.id)   
    if edge_info.R(idx) > 0
        edge_info.labels{idx} =['R' num2str(edge_info.R(idx))];
        edge_info.colors(idx) =50;
    else
        edge_info.labels{idx} ='';
        edge_info.colors(idx) =1;
    end
end