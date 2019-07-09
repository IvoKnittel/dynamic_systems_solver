function G = rmnodes(G, delete_node_idx)
% vectorized matlab graph function
% -------------------------------
node_info = G.Nodes.info;

G = reorder_edge_info(G, [node_info.id]);

delete_node_ids = [node_info(delete_node_idx).id];
for j=1:length(delete_node_idx)
    node_info      = G.Nodes.info;
    crt_node_ids   = [node_info.id];
    G = rmnode(G,find(crt_node_ids==delete_node_ids(j)));
end