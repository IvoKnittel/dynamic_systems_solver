function devices = get_device(edge_info, s, t)
% ------------------------------------------------------------------------
devices ={};
edge_idx = find(edge_info.s==s & edge_info.t == t);
if isempty(edge_idx)
    return
end
devices = get_device(edge_info, edge_idx);