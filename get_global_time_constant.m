function tau_chosen = get_global_time_constant(edges, nodes, comp_params)
% get time constant for elementary simulator computation step
% -----------------------------------------------------------
% INPUTS:
% edges               ... array of circuit edge type
% nodes               ... array of circuit node type
% comp_params         ... computation parameters
%
% OUTPUTS:
% tau_chosen    ... chosen time step
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

nodes_var = [nodes.var];

% get for each edge 
% 1. a current as it simply would result from the potential difference and
% device properties
% 2. a time constant, if there is one.
% --------------------------------------------------------
[edge_currents, edge_time_constants, edge_voltage_ranges] = get_edge_currents_unsafe(edges, [nodes_var.potential], comp_params, Inf);
node_time_constants                                       = pessimist_edges_to_nodes(nodes, edges, edge_time_constants);

% get for each node the charge rate that would result from those currents
% -----------------------------------------------------------------------
node_charge_change_rate      = additive_edges_to_nodes(nodes, edges, edge_currents);

% get for each node the charge that would result from those currents
% and the  time constants
% -----------------------------------------------------------------------
node_charge_change_unlimited = node_charge_change_rate.*node_time_constants;

% get voltage ranges for each active node such that there will be
% no surprises from nonlinear devices
max_charge_change            =  pessimist_edges_to_nodes(nodes, edges, edge_voltage_ranges).*[nodes.invC];
node_charge_change_limited   =  min(max_charge_change, node_charge_change_unlimited);
node_charge_change_limited   =  max(-max_charge_change, node_charge_change_limited);

tau_limited                  = node_time_constants*node_charge_change_limited./node_charge_change_unlimited;
tau_chosen                   = min(tau_limited);