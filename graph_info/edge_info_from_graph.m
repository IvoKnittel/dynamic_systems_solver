function edge_info = edge_info_from_graph(G)
% gets edge_info from graph
% updating numbering of endnodes 
% -------------------------

edge_info = G.Edges.info';
endnodes = G.Edges{:,1};
for j=1:size(endnodes, 1)
    edge_info(j).s = endnodes(j,1);
    edge_info(j).t = endnodes(j,2);
end