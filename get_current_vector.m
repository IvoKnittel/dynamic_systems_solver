function     i_vector = get_current_vector(i_matrix,current_select_matrix)
M = size(i_matrix,1);
i_vector =zeros(1,M);
for j=1:M
    for k=1:M
        if current_select_matrix(k,j)>0
            i_vector(current_select_matrix(k,j))=i_matrix(k,j);
        end
    end
end