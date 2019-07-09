function mem = remove_circuit_nodes(mem, delete_node_idx)
% Nodes are removed either because they are same-potential, or transistors replaced by Ebers-Moll
% devices
% ----------------------------------------------------------------------
% INPUTS:
% node_info       ... node_info_type
% edge_info       ... edge_info_type
% delete_node_idx ... array of indices in node_info
% OUTPUTS:
% node_info     ... node_info_type
% edge_info     ... edge_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

edge_info = mem.G.Edges.info';

node_info = mem.G.Nodes.info';

delete_edge_idx = [];
new_edges=[];
for j=1:length(delete_node_idx)
    delete_edge_idx = [delete_edge_idx find([edge_info.s] == delete_node_idx(j) | [edge_info.t] == delete_node_idx(j))];
    neighbor_nodes = [mem.G.predecessors(delete_node_idx(j))' mem.G.successors(delete_node_idx(j))'];
    neighbor_node_idx = 1:length(neighbor_nodes);
    for n=1:length(neighbor_nodes)
        yet_unconnected = find(neighbor_node_idx > n);
        for m=1:length(yet_unconnected)
            neigbor_node_pair = [neighbor_nodes(n) neighbor_nodes(yet_unconnected(m))];            
            new_edges = [new_edges merge_edge_pair(edge_info, [node_info.id], delete_node_idx(j), neigbor_node_pair)];
            new_edges(end).id = mem.next_unique_id;
            mem.next_unique_id = mem.next_unique_id + 1;
        end
    end
end
mem.G = rmnodes(mem.G, delete_node_idx);

% get new order of nodes, which is fixed from now on
% --------------------------------------------------
node_info = mem.G.Nodes.info';

% add new edges
% -------------
for j=1:length(new_edges)
   endnodes_new_edge = [find([node_info.id] == new_edges(j).s_by_id); find([node_info.id] == new_edges(j).t_by_id)]; 
   mem.G        = addedge(mem.G, endnodes_new_edge(1),endnodes_new_edge(2));
   endnodes     = mem.G.Edges{:,1};
   mem.G.Edges.info(endnodes(:,1) == endnodes_new_edge(1) & endnodes(:,2) == endnodes_new_edge(2)) = new_edges(j);  
end


% update edge endnodes
% --------------------
node_info = mem.G.Nodes.info';
for j=1:size(mem.G.Edges.info)
    mem.G.Edges.info(j).s = find([node_info.id] == mem.G.Edges.info(j).s_by_id);
    mem.G.Edges.info(j).t = find([node_info.id] == mem.G.Edges.info(j).t_by_id);
end