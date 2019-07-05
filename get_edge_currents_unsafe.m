function [currents, tau, edges] = get_edge_currents_unsafe(edges, node_voltages, comp_params, tau_max)
% get currents for all edges from voltages, result may be out of voltage bounds
% ----------------------------------------------------------------------
% INPUTS:
% edges         ... array of circuit edge type
% voltages      ... array of node voltages
% comp_params   ... computation parameters
% tau_max       ... maximum time constant
%
% OUTPUTS:
% edges         ... array of circuit edge type
% currents      ... edge currents
% tau_chosen    ... chosen time step
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved
currents = zeros(1,length(edges));
tau      = zeros(1,length(edges));

for j= 1:length(edges)
[edges(j).devices, currents(j), tau(j)] = get_edge_current([edges(j).linear_device edges(j).nonlinear_devices], node_voltages, edges(j).s, edges(j).t, comp_params, tau_max);
end
