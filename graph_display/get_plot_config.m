function plot_config = get_plot_config(node_info)
% determines which node potentials and which
% edge currents are displays, including names and formats
% ----------------------------------------------
% INPUTS:
% node_info     ... constant non-matrix info about cicuit nodes
% comp_params   ...
% OUTPUTS:
% plot_config   ... plot_config struct
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved
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