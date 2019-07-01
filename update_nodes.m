function [nodes, new_node_activation] = update_nodes(nodes, current, timestep, comp_params)
source_voltage_change = nodes(source_node_idx).invC*current*timestep; 
if abs(source_voltage_change) > comp_params.voltage_tolerance
    nodes(source_node_idx).var.potential = nodes(source_node_idx).var.voltages - source_voltage_change;
    new_node_activation = true;
    nodes(source_node_idx).var.is_active = true; 
end
sink_voltage_change = inv_node_capacitances(sink_node_idx)*current*timestep; 
if abs(sink_voltage_change) > comp_params.voltage_tolerance
    nodes(sink_node_idx).var.potential = nodes(sink_node_idx).var.potential + sink_voltage_change;
    new_node_activation = true;
    nodes(sink_node_idx).var.is_active = true; 
end