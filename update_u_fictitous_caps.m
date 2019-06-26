function [u, cap_mat]=update_u_fictitous_caps(u, dt, prev_u_charge_rate, u_charge_rate, inv_node_capacitance, cap_mat, grd_idx, edge_current_mat)
   u_is_oscillating = (sign(prev_u_charge_rate).*sign(u_charge_rate)==-1);
   if any(u_is_oscillating)
        % get rid of oscillation by increasing capacitance of oscillationg nodes
        % one by one
        if any(u_is_oscillating)
           [inv_node_capacitance, u_is_oscillating] = try_increase_single_cap_values(inv_node_capacitance, u_is_oscillating, edge_current_mat, prev_u_charge_rate);
           cap_mat(:,grd_idx) = 1./(inv_node_capacitance');
           cap_mat(grd_idx,:) = 1./inv_node_capacitance;
%            cap_mat_finite(:,grd_idx) = cap_mat(:,grd_idx);
%            cap_mat_finite(grd_idx,:) = cap_mat(grd_idx,:);
%            cap_mat_finite(cap_mat==Inf)=0;
        end
   end

   if ~any(u_is_oscillating)
       u                = u + (u_charge_rate')*dt;
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