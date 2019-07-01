function devices = get_nonlinear_devices_by_idx(edge_info, edge_idx)
devices=[];
for j=1:edge_info.is_bc(edge_idx)
    next_device=device_type();
    next_device.type = 'nonlinear';
    next_device.data = nonlinear_device_data_type(); 
    next_device.data.class          = 'bc';
    next_device.data.info = [];%edge_info.is_bc(edge_idx).info;
    devices = [devices next_device];
end
for j=1:edge_info.is_be(edge_idx)   
    next_device=device_type();
    next_device.type = 'nonlinear';
    next_device.data = nonlinear_device_data_type(); 
    next_device.data.class          = 'be';
    next_device.data.info = [];%edge_info.is_bc(edge_idx).info;
    devices = [devices next_device];
    
end
for j=1:edge_info.is_ce(edge_idx)
    next_device=device_type();
    next_device.type = 'nonlinear';
    next_device.data = nonlinear_device_data_type(); 
    next_device.data.class          = 'bc';
    next_device.base_idx        =  get_base_idx(edge_info, edge_idx);
    next_device.data.info = [];%edge_info.is_bc(edge_idx).info;
    devices = [devices next_device];
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

upper_node_bc_idx = get_base_idx_intern(edge_info.s, edge_info.t, edge_info.s(edge_idx), edge_idx, edge_info.is_bc);
lower_node_be_idx = get_base_idx_intern(edge_info.s, edge_info.t, edge_info.t(edge_idx), edge_idx, edge_info.is_be);

tmp              = [edge_info.s(upper_node_bc_idx);edge_info.t(upper_node_bc_idx)];
cand_base_nodes  = tmp(tmp~=edge_info.s(edge_idx));

tmp              = [edge_info.s(lower_node_be_idx);edge_info.t(lower_node_be_idx)];
cand_base_nodes2 = tmp(tmp~=edge_info.s(edge_idx));

base_idx = intersect(cand_base_nodes, cand_base_nodes2);
if length(base_idx)>1
    error('unexpected transistor connection')
end
    
if isempty(base_idx)
    upper_node_bc_idx = get_base_idx_intern(edge_info.s, edge_info.t, edge_info.s(edge_idx), edge_idx, edge_info.is_be);
    lower_node_be_idx = get_base_idx_intern(edge_info.s, edge_info.t, edge_info.t(edge_idx), edge_idx, edge_info.is_bc);
    
    tmp              = [edge_info.s(upper_node_bc_idx);edge_info.t(upper_node_bc_idx)];
    cand_base_nodes  = tmp(tmp~=edge_info.s(edge_idx));
    
    tmp              = [edge_info.s(lower_node_be_idx);edge_info.t(lower_node_be_idx)];
    cand_base_nodes2 = tmp(tmp~=edge_info.s(edge_idx));
    
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