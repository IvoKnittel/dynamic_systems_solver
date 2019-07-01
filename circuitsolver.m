function circuitsolver2()
% reads a circuit description, displays it as a graph,
% simplifies the graph for computation, solves it for 
% some time-dependent signal input, and displays selected
% node potentials and currents
% ----------------------------------------------
% INPUTS:
% OUTPUTS:
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

%[t, ut, u0, uvaridx, u_names, voltage_select, adja_mat, R_mat, cap_mat, L_mat, current_select_matrix, current_names, current_select]=coaxial();
% led
[node_info_disp, edge_info_disp] = schmitt();

figure(1);
G = graph(edge_info_disp.s,edge_info_disp.t,1, node_info_disp.names);
plot(G,'XData',node_info_disp.pos(1,:),'YData',node_info_disp.pos(2,:), 'EdgeLabel', edge_info_disp.labels, 'EdgeCData', edge_info_disp.colors, 'NodeCData', node_info_disp.colors);

comp_params.eps               = 1e-89;
comp_params.time_epsilon      = 1e-15;
comp_params.C_to_ground       = 1e-15;
comp_params.voltage_tolerance = 1e-3;
comp_params.dummy_influence_threshold =1e-2;

[node_info, edge_info]         =  add_capacitance_to_ground(node_info_disp, edge_info_disp, comp_params.time_epsilon, comp_params.C_to_ground);


[node_info, edge_info] = get_graph_info_for_calculation(node_info, edge_info);

devices = convert_to_device_type(edge_info, 1:length(edge_info.s));

figure(2);
G = graph(edge_info.s,edge_info.t,1, node_info.names);
plot(G,'XData',node_info.pos(1,:),'YData',node_info.pos(2,:), 'EdgeLabel', edge_info.labels, 'EdgeCData', edge_info.colors);

% node_mats_empty = init_matmem(node_info.num_nodes, length(edge_info.s));
% node_mats.const = get_device_matrix_for_calculation(node_mats_empty.const, node_info, edge_info);
% node_mats.const = get_impedance_matrices_for_calculation(node_mats.const, node_info, edge_info, comp_params);
% node_mats.var   = init_variable_impedance_matrices(node_mats_empty.var, node_mats.const);

edges = convert_edge_info_to_edge_type_array(edge_info);

% plot_config = get_plot_config(node_info);

% Supply voltages and Signal
% --------------
[signal.data, signal.time]=generate_signal_input();
signal.idx = strcmp(node_info.names,'signal');
signal.timestep = signal.time(2)-signal.time(1);

% external voltage of node, or NaN if voltage is variable         
u0 = NaN(1,node_info.num_nodes);
u0(strcmp(node_info.names,'supply')) =  15;
u0(strcmp(node_info.names,'sink'))   =  0;
u0(signal.idx) =  signal.data(1);
%led

u = u0;
u(isnan(u0))=0;
uvec=u';
ivec=[];
active_node_idx = [];

% Set the supply voltage active because of initial switch-on
% ----------------------------------------------------------
node_info.is_active(strcmp(node_info.names,'supply')) = true;
for j = 2:length(signal.time)-1
    % Set the signal voltage active because it is changing
    % ----------------------------------------------------
    node_info.var.voltages(signal.idx,end)                = signal.data(j);
    [node_info, edges] = circuit_solver_step(node_info, edges);
    
    icrt = get_current_vector(crt_currents,current_select_matrix);
    [crt_voltages';icrt*1000];
    j/length(t);
    ivec=[ivec icrt'];
    uvec = [uvec node_info.var.voltages];
end

col_array={'k.','b.','g.','r.','c.','m.','y.'};
figure(2); subplot(2,1,1); cla; hold on
sel_idx = find(voltage_select);

for j=1:length(sel_idx)
   plot(t(2:end),uvec(sel_idx(j),:),col_array{sel_idx(j)});
end
legend(u_names(voltage_select));
subplot(2,1,2); cla;hold on;
t=t(2:end);
sel_idx = find(current_select);
for j=1:length(sel_idx)
   plot(t(2:end),ivec(sel_idx(j),:),col_array{sel_idx(j)});
end
legend(current_names(current_select));