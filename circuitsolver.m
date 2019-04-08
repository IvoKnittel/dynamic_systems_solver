schmitt
%led

u = u0;
u(isnan(u0))=0;
isvar = double(isnan(u0))';
%load u
uvec=u';
%figure(3); clf;hold on; 
ivec=[];
for j = 1:length(t)
    uvec(uvaridx,end)           = ut(j);
    [crt_voltages,crt_currents] = get_u_next_real_timepoint(t(j), uvec(:,end),adja_mat, cap_mat, current_select_matrix);
    icrt = get_current_vector(crt_currents,current_select_matrix);
    [crt_voltages';icrt*1000];
    j/length(t);
    ivec=[ivec icrt'];
    
    uvec = [uvec crt_voltages];
end
t=[0 t];

col_array={'k.','b.','g.','r.','c.','m.','y.'};
figure(2); subplot(2,1,1); cla; hold on
sel_idx = find(voltage_select);
for j=1:length(sel_idx)
   plot(t,uvec(sel_idx(j),:),col_array{sel_idx(j)});
end
legend(u_names(voltage_select));
subplot(2,1,2); cla;hold on;
t=t(2:end);
sel_idx = find(current_select);
for j=1:length(sel_idx)
   plot(t,ivec(sel_idx(j),:),col_array{sel_idx(j)});
end
legend(current_names(current_select));