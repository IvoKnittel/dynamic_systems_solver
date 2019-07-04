function [node_info, nodes, edges] = circuit_solver_step(node_info, nodes, edges, comp_params)
% cicuit simulation taking one external signal timestep
% ----------------------------------------------------------------------
% INPUTS:
% node_info           ... node info type
% nodes               ... array of circuit node type
% edges               ... array of circuit edge type
% comp_params         ... computation parameters
% 
% OUTPUTS:
% node_info           ... node info type
% nodes               ... array of circuit node type
% edges               ... array of circuit edge type
% ----------------------------------------------
prev_active_node_idx = [];
active_node_idx      = [];
active_edge_idx      = [];
while any([nodes.is_active]) || any([edges.error])
    new_node_activation = false;
    % get newly activated nodes
    % --------------------------------------------
    active_node_idx      = unique([active_node_idx find([nodes.is_active])]);
    new_active_node_idx  = setdiff(active_node_idx, prev_active_node_idx);
    all_edges_active_idx = unique([active_edge_idx get_egdes_by_node(edges, new_active_node_idx)]);
    
    % set all edges of newly activated nodes to error
    % -----------------------------------------------
    [edges(all_edges_active_idx).error]        = deal(true);
    
    % loop over all edges in error until they are gone
    % ------------------------------------------------ 
    while any([edges.error]) && ~new_node_activation
          [edges, node_info]               = update_edge_states(edges, nodes, node_info, comp_params);
          [node_info, new_node_activation] = update_nodes(node_info, comp_params);
    end
    prev_active_node_idx = active_node_idx;
end