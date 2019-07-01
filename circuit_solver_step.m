function [node_info, nodes, edges] = circuit_solver_step(node_info, nodes, edges)
prev_active_node_idx=[];

while any([egdes.var.error])
    new_node_activation = false;
    % get newly activated nodes
    % --------------------------------------------
    active_node_idx      = unique([active_node_idx find(nodes.var.is_active)]);
    new_active_node_idx  = setdiff(active_node_idx, prev_active_node_idx);
    all_edges_active_idx = unique([active_edge_idx get_egdes_by_node(edge_info, new_active_node_idx)]);
    
    % set all edges of newly activated nodes to error
    % -----------------------------------------------
    edge_info.var.error(all_edges_active_idx) = true;
    [edges(active_edge_idx).var.error]        = deal(true);
    
    % loop over all edges in error until they are gone
    % ------------------------------------------------ 
    while any(any([egdes.var.error])) && ~new_node_activation
          [edges, node_info]               = update_edge_states(edges, node_info, comp_params);
          [node_info, new_node_activation] = update_nodes(node_info, comp_params);
    end
    prev_active_node_idx = active_node_idx;
end