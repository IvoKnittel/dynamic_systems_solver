function [edge_info, node_info] = delete_edges_from_info(edge_info, node_info, delete_idx)
% Deletes edges from edge_info
% ----------------------------------------------------------------------
% INPUTS:
% edge_info         ... edge_info_type
% delete_idx        ... array of edge indices in edge_info
% OUTPUTS:
% edge_info         ... edge_info_type
% ----------------------------------------------
% Ivo Knittel 2019 Copyright all rights reserved
edge_info.s(delete_idx)            = [];
edge_info.t(delete_idx)            = [];
edge_info.s_by_name(delete_idx)    = [];
edge_info.t_by_name(delete_idx)    = [];
edge_info.R(delete_idx)            = [];
edge_info.L(delete_idx)            = [];
edge_info.C(delete_idx)            = [];
edge_info.R_is_dummy(delete_idx)   = [];
edge_info.L_is_dummy(delete_idx)   = [];
edge_info.C_is_dummy(delete_idx)   = [];
edge_info.is_base(delete_idx)      = [];
edge_info.is_collector(delete_idx) = [];
edge_info.is_emitter(delete_idx)   = [];
edge_info.id(delete_idx)           = [];
edge_info.is_bc(delete_idx)        = [];
edge_info.is_ce(delete_idx)        = [];
edge_info.is_be(delete_idx)        = [];
edge_info.labels(delete_idx)       = [];
edge_info.colors(delete_idx)       = [];
[node_info, edge_info] = init_cicuit_nodes(node_info, edge_info);