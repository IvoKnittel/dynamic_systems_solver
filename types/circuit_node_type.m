function node = circuit_node_type()

node.C                    = 0;
node.invC                 = Inf;
node.timeconstant         = 0;
node.is_active            = false;
node.var.potential        = NaN;
node.var.timeconstant     = NaN;