
clear all;

generate_test_database;

d=min_dist_in_db/2;

ks=8:16;
ls=40;
error=zeros(length(ls),length(ks));
time_search=error;
time_build=error;


a=rand(n,L)<0.2;
query=xor(db,a);

for i=1:length(ls)
    l=ls(i);
    for j=1:length(ks)
        disp([i,j]);
        k=ks(j);
        [db_idx,distance,time]=lsh_query(db,query,l,k);
        error(i,j)=sum(db_idx~=(1:n)')/n;
        time_search(i,j)=time(2);
        time_build(i,j)=time(1);
    end
end


