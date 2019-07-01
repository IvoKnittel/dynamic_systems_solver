function [node_info, edges] = circuit_solver_step(node_info, edges)
node_info.is_active(strcmp(node_info.names,'signal')) = true;
while any(egde_info.error)
    % activate all edges of the newly activated nodes
    % -----------------------------------------------
    prev_active_node_idx = active_node_idx;
    active_node_idx = unique([active_node_idx find(node_info.is_active)]);
    new_active_node_idx = setdiff(active_node_idx, prev_active_node_idx);
    active_edge_idx = unique([active_edge_idx get_egdes_by_node(edge_info, new_active_node_idx)]);
    edge_info.var.error(active_edge_idx)=true;
    [edges(active_edge_idx).error] =deal(true);
    % loop over all edges in error until they are gone
    % ------------------------------------------------ 
    new_node_activation = [];
    while any(any(egde_info.error)) && ~new_node_activation


    end
end