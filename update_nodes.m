function [node_info, new_node_activation] = update_nodes(node_info, comp_params)
source_voltage_change = inv_node_capacitances(source_node_idx)*current*timestep; 
if abs(source_voltage_change) > comp_params.voltage_tolerance
    node_info.var.voltages(source_node_idx) = node_info.var.voltages(source_node_idx) - source_voltage_change;
    new_node_activation = true;
    node_info.is_active(source_node_idx) = true; 
end
sink_voltage_change = inv_node_capacitances(sink_node_idx)*current*timestep; 
if abs(sink_voltage_change) > comp_params.voltage_tolerance
    node_info.var.voltages(sink_node_idx) = node_info.var.voltages(sink_node_idx) + sink_voltage_change;
    new_node_activation = true;
    node_info.is_active(sink_node_idx) = true; 
end