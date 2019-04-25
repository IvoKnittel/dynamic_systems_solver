function [u, edge_current_mat, dI_mat] = get_u_next_real_timepoint(time, u, edge_current_mat, dI_mat, adja_mat, R0_mat, cap_mat, L_mat)
% the function receives voltages for each node, a linare or nonlinear
% devices assigned to edges, and a matrix of capacitances residing
% on edges. Some of the capacitances are ficticious
% the function returns updated voltages, a current for each edge
% and an update of the ficticious capacitances 

prev_current_into_node=[];
num_nodes=length(u);
grd_idx=num_nodes;
cap_mat_finite = cap_mat;
cap_mat_finite(cap_mat==Inf)=0;
t  = time;
dt = Inf;
eps=1e-12;
for j=1:1000
    inv_node_capacitance = 1./sum(cap_mat,1); 
    R_mat = R0_mat + L_mat.*dI_mat;

    prev_edge_current_mat = edge_current_mat;
    edge_current_mat = get_edge_currents(u, adja_mat, R_mat);
    edge_current_mat(edge_current_mat==0) = eps; 
   current_into_node  = -sum(edge_current_mat,1);
   u_charge_rate      = (current_into_node.*inv_node_capacitance)';
   u_diff_mat = ones(num_nodes,1)*(u') - u*ones(1,num_nodes);
   prev_charges = cap_mat_finite.*u_diff_mat;
   
   if ~isempty(prev_current_into_node)
       prev_u_charge_rate= prev_current_into_node.*inv_node_capacitance;
       u_charge_rate= current_into_node.*inv_node_capacitance;
       dt                 = 0.01*max(abs(u))./max(abs(u_charge_rate));
       if dt==0
          return
       end
       u_is_oscillating = (sign(prev_u_charge_rate).*sign(u_charge_rate)==-1);
       if any(u_is_oscillating)
            % get rid of oscillation by increasing capacitance of oscillationg nodes
            % one by one
            if any(u_is_oscillating)
               [inv_node_capacitance, u_is_oscillating] = try_increase_single_cap_values(inv_node_capacitance, u_is_oscillating, edge_current_mat, prev_u_charge_rate);
               cap_mat(:,grd_idx) = 1./(inv_node_capacitance');
               cap_mat(grd_idx,:) = 1./inv_node_capacitance;
               cap_mat_finite(:,grd_idx) = cap_mat(:,grd_idx);
               cap_mat_finite(grd_idx,:) = cap_mat(grd_idx,:);
               cap_mat_finite(cap_mat==Inf)=0;
            end
       end
       
       if ~any(u_is_oscillating)
           u                = u + (u_charge_rate')*dt;
           t=t+dt;
%            icrt = get_current_vector(edge_current_mat,current_select_matrix);
%            subplot(3,1,1);hold on;
%            for crt_u = u
%                plot(t,crt_u, '.');
%            end
%            subplot(3,1,2);hold on;
%            for crt_C = node_capacitance
%                plot(t,crt_C, '.');
%            end
%            subplot(3,1,3);hold on;
%            for crt_i = icrt
%                plot(t,crt_i, '.');
%            end
       end
   end
   dI_mat = (edge_current_mat - prev_edge_current_mat)/dt;
   dI_mat(dI_mat==0)=eps;
   prev_current_into_node = current_into_node;
%   t=[t (t(end)+dt/damp)];   
   %u                = u + u_charge_rate*dt.*isvar/damp;
end
hallo=1;
%t=t(2:end);
%figure(1);cla; plot(t,uwatch,t,iwatch*1000,'b.');
%hallo=1;
  function [u_is_oscillating2, improved, u_charge_rate] = try_with_new_cap_values(inv_node_capacitance, edge_current_mat, u_charge_rate, prev_u_charge_rate)
  u_charge_rate2      = sum(edge_current_mat,1).*inv_node_capacitance;
  u_is_oscillating2 = (sign(prev_u_charge_rate).*sign(u_charge_rate2)==-1);
  if sum(abs(u_charge_rate))> sum(abs(u_charge_rate2))
     improved=true;
     u_charge_rate = u_charge_rate2;
  else
     improved=false;
  end
  
  function [inv_node_capacitance, u_is_oscillating] = try_increase_single_cap_values(inv_node_capacitance, u_is_oscillating, edge_current_mat, prev_u_charge_rate)
  oscillating_idx=find(u_is_oscillating);
  for crt_idx=oscillating_idx
     [inv_node_capacitance, u_is_oscillating] = try_increase_single_cap_value(crt_idx, inv_node_capacitance, u_is_oscillating, edge_current_mat, prev_u_charge_rate);
  end
  
  function [inv_node_capacitance, u_is_oscillating] = try_increase_single_cap_value(crt_idx, inv_node_capacitance, u_is_oscillating, edge_current_mat, prev_u_charge_rate)
       inv_node_capacitance2 = inv_node_capacitance;
       for j=1:10  
          inv_node_capacitance2(crt_idx) = inv_node_capacitance2(crt_idx).*(1-0.1); 
          u_is_oscillating2 = try_with_new_cap_values(inv_node_capacitance2, edge_current_mat, prev_u_charge_rate, prev_u_charge_rate);
          if ~u_is_oscillating2(crt_idx)
             u_is_oscillating= u_is_oscillating2;
             inv_node_capacitance = inv_node_capacitance2;
             break
          end
       end