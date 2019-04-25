function circuitsolver()
[t, ut, u0, uvaridx, u_names, voltage_select, adja_mat, R_mat, cap_mat, L_mat, current_select_matrix, current_names, current_select]=coaxial();
%led

u = u0;
u(isnan(u0))=0;
isvar = double(isnan(u0))';
uvec=u';
ivec=[];
crt_currents= zeros(size(cap_mat));
dI_mat=zeros(size(cap_mat));
dI_mat(isinf(L_mat))=1;

for j = 2:length(t)-1
    uvec(uvaridx,end)           = ut(j);
    [crt_voltages, ~, crt_currents, dI_mat] = get_u_next_real_timepoint(t(j)-t(j-1), uvec(:,end),crt_currents, dI_mat, adja_mat, R_mat, cap_mat, L_mat);
    icrt = get_current_vector(crt_currents,current_select_matrix);
    [crt_voltages';icrt*1000];
    j/length(t);
    ivec=[ivec icrt'];
    uvec = [uvec crt_voltages];
end

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