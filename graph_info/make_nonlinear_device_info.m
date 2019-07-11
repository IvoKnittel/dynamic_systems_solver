function device_info = make_nonlinear_device_info(edge_info, node_info, is_base, is_collector, is_emitter, Ct, Rt)
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

device_info = repmat(nonlinear_device_info_type(),1,length(is_collector));

trans_node_idx = find(node_info.is_trans);
for crt_trans_node = 1:length(trans_node_idx)
    s_is_crt_transistor = strcmp(node_info.names(trans_node_idx), edge_info.s_by_name{trans_node_idx(crt_trans_node)});
    t_is_crt_transistor = strcmp(node_info.names(trans_node_idx), edge_info.t_by_name{trans_node_idx(crt_trans_node)});
    edge_linked_to_crt_transistor = s_is_crt_transistor | t_is_crt_transistor;
    triode_node_ids.b = find(is_base(trans_node_idx)      & edge_linked_to_crt_transistor);
    triode_node_ids.c = find(is_collector(trans_node_idx) & edge_linked_to_crt_transistor);
    triode_node_ids.e = find(is_emitter(trans_node_idx)   & edge_linked_to_crt_transistor);
    device_info(trans_node_idx(crt_trans_node)).triode_node_ids = triode_node_ids;
end

is_trans = is_base   | is_collector | is_emitter;
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
