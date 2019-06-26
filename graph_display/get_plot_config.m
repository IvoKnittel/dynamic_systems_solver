function plot_config = get_plot_config(node_info)
% names of nodes for display
% -------------------------
plot_config.voltage_select= [false      true          true       true       true        true     false ];   
plot_config.current.select_matrix=zeros(node_info.num_nodes, node_info.num_nodes);
plot_config.current.select_matrix(2,1)=1; % left in
plot_config.current.select_matrix(4,2)=2; % main up to main lo
plot_config.current.select_matrix(4,3)=3; % left base
plot_config.current.select_matrix(5,4)=4; % out
plot_config.current.select_matrix(4,7)=5; % right ce
plot_config.current.select_matrix(3,6)=6; % signal in
plot_config.current.select_matrix(7,1)=7; % right in
plot_config.current.names={'left in','main','left base', 'out', 'right ce' 'signal in', 'right in'};
plot_config.current.select = logical([1 1 1 1 1 1 1]);