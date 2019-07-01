function has_actual_value = impedance_has_actual_value(impedance_vector)
is_num = ~isnan(impedance_vector);
has_actual_value(is_num) = ~isinf(impedance_vector(is_num)) & ~impedance_vector(is_num)==0;