function edge_info =  merge_edge_pair(edge_info, deleted_node, neigbor_node_pair, names)
% merges two edges with one node in common, which will disappear. 
% The result is one edge with the payloads (i.e.devices) of both edges on
% it in series. If the deleted node is a transistor, it is replaced
% by its Ebers-Moll components 
id_deleted = get_edge_to_delete(edge_info, deleted_node, neigbor_node_pair(1));
id_other   = get_edge_to_delete(edge_info, deleted_node, neigbor_node_pair(2));

if ~isempty(id_deleted)
    new_edge_info              = edge_info_type();
    new_edge_info.s_by_name    =  names(neigbor_node_pair(1));
    new_edge_info.t_by_name    =  names(neigbor_node_pair(2));
    new_edge_info.R            =  edge_info.R(id_deleted) + edge_info.R(id_other);        
    new_edge_info.L            =  edge_info.L(id_deleted) + edge_info.L(id_other);      
    new_edge_info.C            =  edge_info.C(id_deleted) + edge_info.C(id_other); 
    is_base      =  edge_info.is_base(id_deleted)     | edge_info.is_base(id_other);
    is_collector =  edge_info.is_collector(id_deleted)| edge_info.is_collector(id_other);
    is_emitter   =  edge_info.is_emitter(id_deleted)  | edge_info.is_emitter(id_other);
    new_edge_info.is_base      = NaN;
    new_edge_info.is_collector = NaN;   
    new_edge_info.is_emitter   = NaN;
    new_edge_info.is_bc        =  double(is_base     &  is_collector);
    new_edge_info.is_be        =  double(is_base     &  is_emitter);
    new_edge_info.is_ce        =  double(is_emitter  &  is_collector);
    new_edge_info.id           = 0;
    edge_info                  =  appped_edge_to_info(edge_info, new_edge_info);
end

function id_deleted = get_edge_to_delete(edge_info, node1, node2)            
id_deleted = find(edge_info.s==node1 & edge_info.t == node2);
if isempty(id_deleted)
   id_deleted = find(edge_info.t==node1 & edge_info.s ==node2);                
end