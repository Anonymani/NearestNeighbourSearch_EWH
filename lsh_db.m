
%db the binary database with num fingerprints of length length
%l the number of lsh hash tables
%k length of the lsh hash function in each table 

function table=lsh_db(db,l,k)

[num,length]=size(db);

table=lsh_init(l,k,length);

bin2dec=2.^(0:k-1);

for i=1:l
    for j=1:num
        f=db(j,:);
        temp=f(table(i).key);
        idx=sum(temp.*bin2dec)+1;
        current=table(i).bucket{idx};
        table(i).bucket{idx}=[current j];
    end
end
        