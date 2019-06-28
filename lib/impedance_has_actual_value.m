function has_actual_value = impedance_has_actual_value(impedance_vector)
has_actual_value = ~isnan(impedance_vector) & ~isinf(impedance_vector) & ~impedance_vector==0;