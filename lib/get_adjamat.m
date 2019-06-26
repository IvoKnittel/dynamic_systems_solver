function outmat = get_adjamat(node_info, edge_info, fieldname)
outmat = NaN(length(node_info.names));
for j=1:length(edge_info.s)
    for k=1:length(edge_info.t)
          eval(['outmat(edge_info.s(j), edge_info.t(j)) = edge_info.' fieldname '(j);']);
          eval(['outmat(edge_info.t(j), edge_info.s(j)) = edge_info.' fieldname '(j);']);
    end
end