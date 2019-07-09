function [nodes, new_node_activation] = activate_nodes(nodes, prev_node_voltages, comp_params)
% updates node properties
% ----------------------------------------------------------------------
% INPUTS:
% nodes               ... (1,n) array of cicuit_node_type
% prev_node_voltages  ... (1,n) array of voltage values
% comp_params         ... computation parameters
% 
% OUTPUTS:
% nodes               ... array of cicuit_node_type
% new_node_activation ... true if new nodes have been activated
% ----------------------------------------------
voltage_change                = get_node_voltages(nodes) - prev_node_voltages; 
voltage_change_is_significant = abs(voltage_change) > comp_params.voltage_tolerance;

if any(voltage_change_is_significant) 
    new_node_activation                              = true;
    [nodes(voltage_change_is_significant).is_active] = deal(true); 
end