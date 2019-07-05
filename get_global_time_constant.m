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
[currents, tau] = get_edge_currents_unsafe(edges, [nodes_var.potential], comp_params, Inf);
% get voltage ranges for each active node such that there will be
% no surprises from nonlinear devices
max_charge_change   = get_node_voltage_ranges(nodes, edges, comp_params).*[nodes.invC];
       
node_charge_change_rate = get_node_charge_change_rate(nodes, currents);
node_charge_change_unlimited = node_charge_change_rate*tau;
node_charge_change_limited =  min(max_charge_change, node_charge_change_unlimited);
node_charge_change_limited =  max(-max_charge_change, node_charge_change_limited);
tau_limited = tau*node_charge_change_limited./node_charge_change_unlimited;
tau_chosen = min(tau_limited);