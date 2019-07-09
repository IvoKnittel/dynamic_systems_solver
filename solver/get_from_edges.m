function out = get_from_edges(edges, type, varargin)
out = NaN(1,length(edges));
switch type
    case 'edges_to_node'
        out = unique(find([edges.s]==varargin{1} | [edges.t]==varargin{1}));
    case 'timeconst_or_NaN'
        for j=1:length(edges)
            
        end
    case 'j_or_NaN'
        for j=1:length(edges)
            
        end
    case 'q_or_NaN'
        for j=1:length(edges)
        end
    case 'voltage_range_or_NaN'
        for j=1:length(edges)
            
        end
end