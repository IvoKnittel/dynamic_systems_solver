function linear = make_linear_device_info(Rval, Lval , Cval , R_is_dummy, L_is_dummy, C_is_dummy)
% create info about linear devices on edges for edit table data 
% ----------------------------------------------------------------------
% INPUTS:
% Rval       ... (1,n) array
% Lval       ... (1,n) array
% Cval       ... (1,n) array
% R_is_dummy ... (1,n) array
% L_is_dummy ... (1,n) array
% C_is_dummy ... (1,n) array
%
% OUTPUTS:
% linear         ... linear_device_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

linear          = linear_device_info_type();
for j=1:length(Rval)
   nextR.val = Rval(j);
   nextL.val = Lval(j);
   nextC.val = Cval(j);
   nextR.is_dummy = R_is_dummy(j);
   nextL.is_dummy = L_is_dummy(j);
   nextC.is_dummy = C_is_dummy(j);
   linear.R = [linear.R nextR];
   linear.L = [linear.L nextL];
   linear.C = [linear.C nextC];
end