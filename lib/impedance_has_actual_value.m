function has_actual_value = impedance_has_actual_value(impedance_vector)
% checks finiteness of impedances
% ----------------------------------------------------------------------
% INPUTS:
% impedance_vector  ... array of impedance values
% 
% OUTPUTS:
% has_actual_value  ... bool array, true if value is finite
% ---------------------------------------------
is_num = ~isnan(impedance_vector);
impedance_vector(~is_num) = 0;
has_actual_value = is_num & ~isinf(impedance_vector) & ~impedance_vector==0;