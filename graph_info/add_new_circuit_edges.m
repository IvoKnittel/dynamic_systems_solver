function mem = add_new_circuit_edges(mem, new_edges)
% add circuit edges to graph
% ----------------------------------------------------------------------
% INPUTS:
% mem        ... graph info memory
% new_edges  ... array of edge info type
% OUTPUTS:
% mem        ... graph info memory
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved

node_info = mem.G.Nodes.info';

% add new edges
% -------------
for j=1:length(new_edges)
   endnodes_new_edge = [find([node_info.id] == new_edges(j).s_by_id); find([node_info.id] == new_edges(j).t_by_id)]; 
   new_edges(end).id = mem.next_unique_id;
   mem.next_unique_id = mem.next_unique_id + 1;
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

% order edge info such that the
% right info items are deleted:
node_info = mem.G.Nodes.info;
mem.G = reorder_edge_info(mem.G, [node_info.id]);