function voltages = set_node_voltages(nodes, voltages)
% set potentials of all nodes
% -----------------------------------------------------------
% INPUTS:
% voltages  ... array of voltage values
%
% OUTPUTS:
% nodes     ... array of circuit node type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved
for j=1:length(nodes)
    nodes(j).var.potential=voltages(j);
end
