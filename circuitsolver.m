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

% 1. Define circuit to be simulated
% -------------------------------
%[t, ut, u0, uvaridx, u_names, voltage_select, adja_mat, R_mat, cap_mat, L_mat, current_select_matrix, current_names, current_select]=coaxial();
% led
[node_info_disp, edge_info_disp] = schmitt();
[node_info_disp, edge_info_disp] = init_circuit_nodes(node_info_disp, edge_info_disp);
[edge_info_disp]                 = init_circuit_edges(node_info_disp, edge_info_disp);

% 2. Supply voltages and Signal
% --------------
supply_voltage = 15;
[signal.data, signal.time]=generate_signal_input();
signal.timestep = signal.time(2)-signal.time(1);

% 3. Set simulation parameters
% ----------------------------
comp_params.eps               = 1e-89;
comp_params.time_epsilon      = 1e-12;
comp_params.C_to_ground       = 1e-12;
comp_params.dummy_inductance  = 1e-5;
comp_params.dummy_resistor    = 1;
comp_params.voltage_tolerance = 1e-3;
comp_params.dummy_influence_threshold      = 1e-2;
comp_params.probe_delta_u                  = 1e-2;
comp_params.max_nonlinearity_voltage_range = 10;
comp_params.time_constant_factor           = 0.2;
comp_params.nonlinearity_threshold         = 0.15;

% 4. format output display
% ----------------------------
%plot_config = get_plot_config(node_info_disp);

% 5. Display circuit to be simulated
% -------------------------------
figure(1);
G               = graph(edge_info_disp.s,edge_info_disp.t,1, node_info_disp.names);
plot(G,'XData',node_info_disp.pos(1,:),'YData',node_info_disp.pos(2,:), 'EdgeLabel', edge_info_disp.labels, 'EdgeCData', edge_info_disp.colors, 'NodeCData', node_info_disp.colors);

% 6. Convert from dispplay to computation form
% ---------------------------------------------
G = get_graph_info_for_calculation(node_info_disp, edge_info_disp, comp_params, supply_voltage);

% 7. Display the circuit to be solved
% --------------------------------
figure(2);
G = digraph(edge_info.s,edge_info.t,1, node_info.names);
plot(G,'XData',node_info.pos(1,:),'YData',node_info.pos(2,:), 'EdgeLabel', edge_info.labels, 'EdgeCData', edge_info.colors);

% Set the supply voltage active because of initial switch-on
% ----------------------------------------------------------
ivec=[];
uvec=[];
signal.idx = strcmp(node_info_disp.names,'signal');

for j = 2:length(signal.time)-1
    [nodes, edges] = circuit_solver_step(nodes, edges, comp_params);
    
    % Set the signal voltage active because it is changing
    % ----------------------------------------------------
    nodes(strcmp(node_info.names,'signal')).is_active     = true;
    nodes(strcmp(node_info.names,'signal')).var.potential = signal.data(j);
    ivec = [ivec 1000*get_current_vector([edges.var.j],plot_config.current_select_matrix)'];
    uvec = [uvec node_info.var.voltages];
end
display_circuit_simulation_result(ivec, uvec, node_info, edge_info, plot_config)
