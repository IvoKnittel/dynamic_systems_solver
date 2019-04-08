function ivec=u_to_i(u)
%          device         edge       voltage drop      node
%         15V power       1          u(1) - u(4)       15V
%          diode          2          u(1) - u(2)       - 
%          R2             3          u(2) - u(3)       -
%          transistor     4          u(3) - u(4)       -
%          ground         -          -                 0
%
%    node  1    2    3    4
adja=     [[ 0    1    0    4];
           [ 1    0    2    0];
           [ 0    2    0    3];   
           [ 4    0    3    0]];
for j=1:size(adja,2)
    for k=1:size(adja,2)
        if k>=j
            break;
        end
        current = current_from_du_by_device(adja(k,j), u(k)-u(j));
    end
end

%
%

function current = current_from_du_by_device(device_id, du)
        switch 
            case 1
                 current = diode(du);
            case 2
                 current         = G2*du;
            case 3
                [dummy,current] = ebersmoll2(3-du,3-du);
            case 4
                current = (15V-du);
        end
   