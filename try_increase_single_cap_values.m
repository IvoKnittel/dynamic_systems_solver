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
       
       
         function [u_is_oscillating2, improved, u_charge_rate] = try_with_new_cap_values(inv_node_capacitance, edge_current_mat, u_charge_rate, prev_u_charge_rate)
  u_charge_rate2      = sum(edge_current_mat,1).*inv_node_capacitance;
  u_is_oscillating2 = (sign(prev_u_charge_rate).*sign(u_charge_rate2)==-1);
  if sum(abs(u_charge_rate))> sum(abs(u_charge_rate2))
     improved=true;
     u_charge_rate = u_charge_rate2;
  else
     improved=false;
  end