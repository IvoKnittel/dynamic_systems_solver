function voltages = get_node_voltages(nodes)
% get potentials of all nodes
% -----------------------------------------------------------
% INPUTS:
% nodes     ... array of circuit node type
%
% OUTPUTS:
% voltages  ... array of voltage values
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved
nodes_var=[nodes.var];
voltages = [nodes_var.potential];
