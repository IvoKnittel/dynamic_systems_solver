function [nodes, edges] = circuit_solver_step(nodes, edges, comp_params)
% circuit simulation taking one external signal timestep
% ----------------------------------------------------------------------
% INPUTS:
% nodes               ... array of circuit node type
% edges               ... array of circuit edge type
% node_info           ... node info type
% comp_params         ... computation parameters
% 
% OUTPUTS:
% nodes               ... array of circuit node type
% edges               ... array of circuit edge type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

prev_active_node_idx = [];
active_node_idx      = [];
active_edge_idx      = [];
prev_node_voltages = get_node_voltages(nodes);
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
        % get a short enough super-safe global timestep (TODO:Do this non-global)
        % -----------------------------------------------------------------------
        timestep = get_global_time_constant(edges, nodes, comp_params);
        
        % get the current through devices
        % ----------------------------------------------------------------------
        node_voltages = get_node_voltages(nodes);
        currents = get_edge_currents_unsafe(edges, node_voltages, comp_params, timestep);
        
        % update node voltages
        % --------------------
        node_charge_change_rate = get_node_charge_change_rate(nodes, currents);
        nodes = set_node_voltages(nodes, timestep.*[nodes.invC].*node_charge_change_rate);
        
        % update internal states of the
        % devices (capacitor charges, inductive current, nonlinear device range)
        % ----------------------------------------------------------------------
        edges                        = update_edges(edges, currents, voltages, tau, comp_params);

        [nodes, new_node_activation] = update_node_activation_state(nodes, [edges.error], prev_node_voltages, comp_params);
        
    end
    prev_active_node_idx = active_node_idx;
end
