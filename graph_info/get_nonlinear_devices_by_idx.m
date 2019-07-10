function next_devices = get_nonlinear_devices_by_idx(edge_info, edge_idx)
% returns array of nonlinear devices from edge_info
% ----------------------------------------------
% INPUTS:
% edge_info         ... edge_info_type
% edge_idx          ... edge index
% OUTPUTS:
% devices           ... array of device_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved
next_devices = [];
if isempty(edge_info(edge_idx).device_info)
    return
end
crt_class = edge_info(edge_idx).device_info.class;
next_device               = device_type();
next_device.type          = 'nonlinear';
next_device.data          = nonlinear_device_data_type();
next_device.time_constant = Inf;
for j=1:length(crt_class)
    next_device.data.class    = crt_class{j};
    if strcmp(crt_class{j}, 'ce')
        next_device.data.base_idx =  get_base_idx(device_info, edge_idx);
    end
    next_devices = [next_devices next_device];
end

function base_idx = get_base_idx(edge_info, edge_idx)
%   a bc egde must be connected to a be on one end and a bc on the other
%   end
%
%    u                  l                 Case 1: bc is here
%      .              .                   Case 2: be is here
%        .          .                      
%           l     u                    
%              u
%              . bc this is the bc edge
%              .
%              l
%            u   l                        Case1 : be is here 
%          .       .                      Case2 : bc is here
%        .           .
%       l              u

upper_node_bc_idx = get_base_idx_intern([edge_info.s], [edge_info.t], edge_info(edge_idx).s, edge_idx, [edge_info.is_bc]);
lower_node_be_idx = get_base_idx_intern([edge_info.s], [edge_info.t], edge_info(edge_idx).t, edge_idx, [edge_info.is_be]);

tmp              = [edge_info(upper_node_bc_idx).s;edge_info(upper_node_bc_idx).t];
cand_base_nodes  = tmp(tmp~=edge_info.s(edge_idx));

tmp              = [edge_info(lower_node_be_idx).s;edge_info(lower_node_be_idx).t];
cand_base_nodes2 = tmp(tmp~=edge_info(edge_idx).s);

base_idx = intersect(cand_base_nodes, cand_base_nodes2);
if length(base_idx)>1
    error('unexpected transistor connection')
end
    
if isempty(base_idx)
    upper_node_bc_idx = get_base_idx_intern([edge_info.s], [edge_info.t], edge_info(edge_idx).s, edge_idx, [edge_info.is_be]);
    lower_node_be_idx = get_base_idx_intern([edge_info.s], [edge_info.t], edge_info(edge_idx).t, edge_idx, [edge_info.is_bc]);
    
    tmp              = [edge_info(upper_node_bc_idx).s;edge_info(upper_node_bc_idx).t];
    cand_base_nodes  = tmp(tmp~=edge_info(edge_idx).s);
    
    tmp              = [edge_info(lower_node_be_idx).s;edge_info(lower_node_be_idx).t];
    cand_base_nodes2 = tmp(tmp~=edge_info(edge_idx).s);
    
    base_idx = intersect(cand_base_nodes, cand_base_nodes2);
    if length(base_idx)>1
        error('unexpected transistor connection')
    end
    
end
if isempty(base_idx)
   error('transistor base not found')
end
    
function base_idx = get_base_idx_intern(s_vec, t_vec, chosen_node_id, edge_idx, is_right_type)
%   For a chosen end node of a bc egde, all edges are found that are
%   connected to it with a certain type (either be or bc)
%   s-t orientation of edges is disregarded. 
%
%    u                  l                 
%      .              .                   
%        .          .                      
%           l     u                    
%              c
%              . bc this is the bc edge
%              .
s_vec(edge_idx)=NaN;
t_vec(edge_idx)=NaN;

base_idx = [find(s_vec==chosen_node_id & is_right_type) find(t_vec==chosen_node_id & is_right_type)];