function [nodes, new_node_activation] = update_node_activation_state(nodes, edges, prev_node_voltages, comp_params)
% updates node properties
% ----------------------------------------------------------------------
% INPUTS:
% nodes               ... (1,n) array of cicuit_node_type
% nodes               ... (1,n) array of cicuit_edge_type
% prev_node_voltages  ... (1,n) array of voltage values
% comp_params         ... computation parameters
% 
% OUTPUTS:
% nodes               ... array of cicuit_node_type
% new_node_activation ... true if new nodes have been activated
% ----------------------------------------------
prev_node_is_active = [nodes.is_active];
nodes               = deactivate_nodes(nodes, edges);
nodes               = activate_nodes(nodes, prev_node_voltages, comp_params);
new_node_activation = ([nodes.is_active] & ~prev_node_is_active);