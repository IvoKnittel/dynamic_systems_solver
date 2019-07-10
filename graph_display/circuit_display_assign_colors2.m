function [node_info,edge_info] = circuit_display_assign_colors2(node_info, edge_info)
% update display labels, node and edge colors 
% ----------------------------------------------------
% INPUTS:
% node_info       ... node_info_type
% edge_info       ... edge_info_type
% OUTPUTS:
% node_info     ... node_info_type
% edge_info     ... edge_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

% a transistor node is displayed yellow
% fixed voltage nodes are displayed
% -------------------------------------

for j=1:length(node_info)
    if node_info(j).is_trans
        node_info(j).colors=150;
    elseif node_info(j).floating
        node_info(j).colors=1;
    else  
        node_info(j).colors=200;
    end
    switch  node_info(j).floating
        case 1
            if node_info(j).is_trans
                node_info(j).colors=150; % transistor if yellow
            else
                node_info(j).colors=1;   % other flaoting is blue
            end
        case 2
            node_info(j).colors=200;     % color of signal input
        case 0
            node_info(j).colors=80;     % color of supply node
    end
end

for idx=1:length(edge_info)   
    if edge_info(idx).linear.R.val > 0
        edge_info(idx).labels =['R' num2str(edge_info(idx).linear.R.val)];
        edge_info(idx).colors =50;
    else
        edge_info(idx).labels ='';
        edge_info(idx).colors =1;
    end
end
node_info= node_info';
edge_info= edge_info';