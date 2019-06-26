function mat = mat_symm(mat)
for j=1:size(mat,1)
     for k=1:size(mat,2)
        if isnan(mat(j,k))
           mat(j,k)=mat(k,j);
           if j==k
              mat(j,k)=0;
           end
        end
    end
end