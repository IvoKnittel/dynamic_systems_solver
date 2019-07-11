function [mem, nodes_info, edges_info] = assign_unique_ids(mem, nodes_info, edges_info)
for j=1:length(nodes_info)
    nodes_info(j).id = mem.next_unique_id;
    mem.next_unique_id = mem.next_unique_id+1;
end
for j=1:length(edges_info)
    edges_info(j).id = mem.next_unique_id;
    mem.next_unique_id = mem.next_unique_id+1;
    edges_info(j).s_by_id = edges_info(j).s;
    edges_info(j).t_by_id = edges_info(j).t;    
end