function [new_edges, delete_idx] = get_multiple_edges_to_merge(node_info,edge_info)

last_s = 0;
multiple_idx_info=[];
unique_id = 1;
for j=1:length(edge_info)
    if edge_info(j).s == last_s
        continue
    end
    same_s_value = [edge_info.s] == edge_info(j).s;
               
    t_values = unique([edge_info(same_s_value).t]);
    for k=1:length(t_values)
        multiple_idx      =  find(same_s_value & [edge_info.t] == t_values(k));
        if length(multiple_idx)>1
            multiple_idx_info =[ multiple_idx_info [multiple_idx; unique_id*ones(1,length(multiple_idx))]];
            unique_id = unique_id + 1;
        end
    end
    last_s = edge_info(j).s;
end

unique_ids = unique(multiple_idx_info(2,:));
delete_idx = multiple_idx_info(1,:);
new_edges=[];
for j=1:length(unique_ids)
   to_merge = multiple_idx_info(2,:) == unique_ids(j);
   if all(~[edge_info(multiple_idx_info(1,to_merge)).reverse]) || all([edge_info(multiple_idx_info(1,to_merge)).reverse])
      new_edges=[new_edges merge_multiple_edges_in_info(edge_info, node_info, multiple_idx_info(1,to_merge))];
   else
      delete_idx(to_merge)=[];
      continue
   end
end