function device_info = make_nonlinear_device_info(edge_info, is_base, is_collector, is_emitter, Ct, Rt)
% every edges gets a struct containing info about their nonlinear devices
% so far, transistor capacitances
% ----------------------------------------------------------------------
% INPUTS:
% edge_info         ... edge_info_type
% Ct                ... common capacitance parallel to each Ebers-moll device  
% Rt                ... common resistance in series with Ct, this is to give
%                       this edge a finite (usually infinitesimal) time constant.  
% OUTPUTS:
% edge_info         ... edge_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

is_trans = is_base   | is_collector | is_emitter;
device_info = repmat(nonlinear_device_info_type(),1,length(is_collector));
[device_info(is_trans).Ct]=deal(Ct);
[device_info(is_trans).Rt]=deal(Rt);
for j=1:length(is_base)
    if is_base(j)
       device_info(j).class = 'b';
    end
    if is_collector(j)
       device_info(j).class = 'c';
    end
    if is_emitter(j)
       device_info(j).class = 'e';
    end
end