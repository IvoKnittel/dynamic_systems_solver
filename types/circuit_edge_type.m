function edge = circuit_edge_type()
%on an edge, in general, there are several parallel devices 
% --------------------------------------------------------- 
edge.s=[];
edge.t=[];
edge.reverse =false;
edge.linear_device      = [];
edge.nonlinear_devices  = [];
edge.error              = false;
