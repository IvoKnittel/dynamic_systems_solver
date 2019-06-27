function [u, t, mem_var] = get_u_next_real_timepoint(time, u, mem, node_info, edge_info, comp_params)
% the function receives voltages for each node, a matrix of linear or nonlinear
% devices assigned to edges, and a matrix of capacitances residing
% on edges. Some of the capacitances are ficticious.
% the function returns updated voltages, a current for each edge
% and an update of the ficticious capacitances 
% updates an event with a new item
% ----------------------------------------------
% INPUTS:
% time          ... current time
% u             ... node potentials
% mem           ... matrix data of impedances and 
%                   current system state in .var
% node_info     ... constant non-matrix info about cicuit nodes
% comp_params   ...
% OUTPUTS:
% u             ... node potentials
% t             ... next time point
% mem.var    ... variable system state in .var
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

grd_idx = find(strcmp(node_info.names,'sink'));


mem.var.currents = mem.var.currents + mem.const.Reps; 
prev_current_into_node  = -sum(mem.var.currents,1);
t=0;
for j=1:1000
   inv_node_capacitance = 1./sum(mem.var.C,1); 
   R_mat = mem.const.R + mem.const.L.*(mem.var.dI + mem.const.maskabs_mat);

   prev_edge_current_mat = mem.var.currents;
   mem.var.currents = get_edge_currents(u, node_info, edge_info, R_mat);
   mem.var.currents = mem.var.currents + mem.Reps; 
   current_into_node  = -sum(mem.var.currents,1);
   %u_diff_mat = ones(num_nodes,1)*(u') - u*ones(1,num_nodes); 
   prev_u_charge_rate= prev_current_into_node.*inv_node_capacitance;
   u_charge_rate= current_into_node.*inv_node_capacitance;
   dtu                 = 0.01*max(abs(u))./max(abs(u_charge_rate));

   dI_mat = (mem.var.currents - prev_edge_current_mat);
   dtI = 0.01*max(max(dI_mat))*mem.const.L(2,1)/max(abs([0.2; u]));

   dt = min(dtu, dtI);
   if dt==0
      return
   end
   [u, cap_mat]=update_u_fictitous_caps(u, dt, prev_u_charge_rate, u_charge_rate, inv_node_capacitance, cap_mat, grd_idx, mem.var.currents);

   prev_current_into_node = current_into_node;
   t=t+dt;
   if t>time
      return
   end
end

mem_var = mem.var;