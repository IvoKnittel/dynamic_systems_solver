function circuitsolver()
% reads a circuit description, displays it as a graph,
% simplifies the graph for computation, solves it for 
% some time-dependent signal input, and displays selected
% node potentials and currents
% ----------------------------------------------
% INPUTS:
% OUTPUTS:
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

% Define circuit to be simulated
% -------------------------------
%[t, ut, u0, uvaridx, u_names, voltage_select, adja_mat, R_mat, cap_mat, L_mat, current_select_matrix, current_names, current_select]=coaxial();
% led
[node_info_disp, edge_info_disp] = schmitt();

[node_info_disp, edge_info_disp] = init_circuit_nodes(node_info_disp, edge_info_disp);
[edge_info_disp]                 = init_circuit_edges(node_info_disp, edge_info_disp);

% Display circuit to be simulated
% -------------------------------
figure(1);
G = graph(edge_info_disp.s,edge_info_disp.t,1, node_info_disp.names);
plot(G,'XData',node_info_disp.pos(1,:),'YData',node_info_disp.pos(2,:), 'EdgeLabel', edge_info_disp.labels, 'EdgeCData', edge_info_disp.colors, 'NodeCData', node_info_disp.colors);

% Supply voltages and Signal
% --------------
supply_voltage = 15;
[signal.data, signal.time]=generate_signal_input();
signal.timestep = signal.time(2)-signal.time(1);

% Set simulation parameters
% ----------------------------
comp_params.eps               = 1e-89;
comp_params.time_epsilon      = 1e-15;
comp_params.C_to_ground       = 1e-15;
comp_params.voltage_tolerance = 1e-3;
comp_params.dummy_influence_threshold =1e-2;
%plot_config = get_plot_config(node_info_disp);

% convert from network to display to network to solve
% ---------------------------------------------------
[node_info, edge_info] =  add_capacitance_to_ground(node_info_disp, edge_info_disp, comp_params.time_epsilon, comp_params.C_to_ground);

[node_info, edge_info] = get_graph_info_for_calculation(node_info, edge_info);

edge_info              = add_transistor_capacitances(edge_info);
[node_info, edge_info] = init_circuit_nodes(node_info, edge_info);
edge_info              =  reorder_edge_info(edge_info, node_info.names);
[node_info, edge_info] = init_circuit_nodes(node_info, edge_info);

[node_info, edge_info] =  model_voltage_sources_as_capacitances(node_info, edge_info);
[node_info, edge_info] = init_circuit_nodes(node_info, edge_info);
edge_info              =  reorder_edge_info(edge_info, node_info.names);
[node_info, edge_info] = init_circuit_nodes(node_info, edge_info);
edge_info.devices      = convert_edge_info_to_edge_type_array(edge_info); 

% display the curcuit ot be solved
% --------------------------------
figure(2);
G = graph(edge_info.s,edge_info.t,1, node_info.names);
plot(G,'XData',node_info.pos(1,:),'YData',node_info.pos(2,:), 'EdgeLabel', edge_info.labels, 'EdgeCData', edge_info.colors);

% Set the supply voltage active because of initial switch-on
% ----------------------------------------------------------

%ivec=[];
%uvec=[];
signal.idx = strcmp(node_info_disp.names,'signal');
edges = edge_info.devices;
nodes = node_info_to_nodes_init(node_info, edges);
nodes(strcmp(node_info.names,'supply')).is_active = true;
nodes(strcmp(node_info.names,'supply')).var.potential = supply_voltage;
edges = init_nonlinear_device_voltage_ranges(nodes, edges);

for j = 2:length(signal.time)-1
    [nodes, edges] = circuit_solver_step(nodes, edges, comp_params);
    
    % Set the signal voltage active because it is changing
    % ----------------------------------------------------
    nodes(strcmp(node_info.names,'signal')).is_active     = true;
    nodes(strcmp(node_info.names,'signal')).var.potential = signal.data(j);
%    ivec = [ivec 1000*get_current_vector([edges.var.j],plot_config.current_select_matrix)'];
%    uvec = [uvec node_info.var.voltages];
end
%display_circuit_simulation_result(ivec, uvec, node_info, edge_info, plot_config)
