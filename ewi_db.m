%db the binary database with num fingerprints of length length
%l the number of lsh hash tables
%k length of the lsh hash function in each table 

function [table,e_index]=ewi_db(db,n,m,k)

[num,length]=size(db);

[table,e_index]=ewi_init(n,m,k,length);

bin2dec=2.^(0:m-1);

for i=1:n
    for j=1:num
        f=db(j,:);
        temp=f(table(i).key);
        idx=sum(temp.*bin2dec)+1;
        current=table(i).index{idx};
        table(i).index{idx}=[current j];
    end
end
        