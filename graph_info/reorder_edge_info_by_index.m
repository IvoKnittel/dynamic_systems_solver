function edge_info = reorder_edge_info_by_index(edge_info, reorder_idx)
edge_info.s = edge_info.s(reorder_idx);
edge_info.t = edge_info.t(reorder_idx);
edge_info.s_by_name = edge_info.s_by_name(reorder_idx);
edge_info.t_by_name = edge_info.t_by_name(reorder_idx);
edge_info.R = edge_info.R(reorder_idx);
edge_info.C = edge_info.C(reorder_idx);
edge_info.L = edge_info.L(reorder_idx);
edge_info.is_base = edge_info.is_base(reorder_idx);
edge_info.is_collector = edge_info.is_collector(reorder_idx);
edge_info.is_emitter = edge_info.is_emitter(reorder_idx);
edge_info.is_bc = edge_info.is_bc(reorder_idx);
edge_info.is_be = edge_info.is_be(reorder_idx);
edge_info.is_ce = edge_info.is_ce(reorder_idx);
edge_info.id = edge_info.id(reorder_idx);
edge_info.colors = edge_info.colors(reorder_idx);
edge_info.labels = edge_info.labels(reorder_idx);