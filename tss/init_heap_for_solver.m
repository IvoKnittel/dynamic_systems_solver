function [params, heap, next_item_idx, latest_idx] = init_heap_for_solver()
% displays every onset found regardless if it is already known
params.size_max    = 80;
params.type        =  'linear_regression';
params.min_points = 2;
params.cum_update_range=4;
params.onset_significance_factor = 0.4;
params.empty_item   = log_empty_item(params.type);
params              = attach_log_entry(params);
params              = attach_merge_functions(params);
heap                              = init_heap(params.empty_item, 2*3*params.size_max, params.size_max);
heap.nullevent.timestep           = 2^-10;
[heap, next_item_idx, latest_idx] = get_initial_index(heap, [timeseries.time_vec(1); timeseries.data(1)], params);
