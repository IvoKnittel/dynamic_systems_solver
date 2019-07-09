function edges = init_nonlinear_device_voltage_ranges(nodes, edges)
% initializes the last voltage value for nonlinear devices
% ---------------------------------------------------
% INPUTS:
% nodes               ... array of circuit node type
% edges               ... array of circuit edge type
% 
% OUTPUTS:
% edges               ... array of circuit edge type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

for j=1:length(edges)
    for m=1:length(edges(j).nonlinear_devices)
        edges(j).nonlinear_devices(m).data.var.last_voltage_value =  nodes(edges(j).s).var.potential - nodes(edges(j).t).var.potential;
    end
end

