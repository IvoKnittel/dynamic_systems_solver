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

edge_info_disp         =  add_capacitance_to_ground(node_info_disp, edge_info_disp, comp_params.time_epsilon, comp_params.C_to_ground);
[node_info, edge_info] =  init_cicuit_nodes(node_info_disp, edge_info_disp);
edge_info              =  reorder_edge_info(edge_info, node_info.names);
[node_info, edge_info] =  init_cicuit_nodes(node_info, edge_info);

[node_info, edge_info] = get_graph_info_for_calculation(node_info, edge_info);
figure(2);
G = graph(edge_info.s,edge_info.t,1, node_info.names);
plot(G,'XData',node_info.pos(1,:),'YData',node_info.pos(2,:), 'EdgeLabel', edge_info.labels, 'EdgeCData', edge_info.colors);

node_mats_empty = init_matmem(node_info.num_nodes, length(edge_info.s));
node_mats.const = get_device_matrix_for_calculation(node_mats_empty.const, node_info, edge_info);
node_mats.const = get_impedance_matrices_for_calculation(node_mats.const, node_info, edge_info, comp_params);
node_mats.var   = init_variable_impedance_matrices(node_mats_empty.var, node_mats.const);

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

node_info.active        = false(1,length(node_info.names));
node_info.C             = zeros(1,length(node_info.names));
node_info.var.voltages  = u';
node_info.timeconstant  = zeros(1,length(node_info.names));
node_info.var.charges           = zeros(1,length(node_info.names));
node_info.inv_node_capacitances = zeros(1,length(node_info.names));
edge_info.var.error     = false(1,length(edge_info.s));
edge_info.time_constant = comp_params.time_epsilon*ones(1,length(edge_info.s));
edge_info.var.j         = zeros(1,length(edge_info.s));
edge_info.var.q         = zeros(1,length(edge_info.s));
active_node_idx = [];

% Set the supply voltage active because of initial switch-on
% ----------------------------------------------------------
node_info.is_active(strcmp(node_info.names,'supply'))=true;
devices = convert_to_device_type(edge_info, 1:length(edge_info.s));
for j = 2:length(signal.time)-1
    % Set the signal voltage active because it is changing
    % ----------------------------------------------------
    node_info.var.voltages(signal.idx,end)             = signal.data(j);
    node_info.is_active(strcmp(node_info.names,'signal'))=true;
    while any(egde_info.error)
        % activate all edges of the newly activated nodes
        % -----------------------------------------------
        prev_active_node_idx =active_node_idx;
        active_node_idx = unique([active_node_idx find(node_info.is_active)]);
        new_active_node_idx = setdiff(active_node_idx, prev_active_node_idx);
        active_edge_idx = unique([active_edge_idx get_egdes_by_node(edge_info, new_active_node_idx)]);
        edge_info.var.error(active_edge_idx)=true;

        % loop over all edges in error until they are gone
        % ------------------------------------------------ 
        new_node_activation = [];
        while any(any(egde_info.error)) && ~new_node_activation

            source_node_idx = edge_info.s(crt_edge_idx);
            sink_node_idx   = edge_info.t(crt_edge_idx);

            [devices, current, timestep, error] = get_edge_current(devices, node_voltages, source_node_idx, sink_node_idx, comp_params);
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
            edge_info
            current = get_edge_current(devices, node_voltages, comp_params);
            active_node_idx = find(node_info.is_active);
            % set error flag: error means that output depends on dummy devices

            % If the output from edge device update changes the voltage
            % level of a node, activate it

            % new_node_activation = true
        end
    end
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