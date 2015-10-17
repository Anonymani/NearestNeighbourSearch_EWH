%%
%[db_idx,distance]=lsh_query(db,query,l,k)
%%%% or
%[db_idx,distance]=lsh_query(db,query,table);


function [db_idx,distance,time]=lsh_query(db,query,l,k)
tic;
if nargin==4
    table=lsh_db(db,l,k);
elseif nargin==3
    table=l;
    l=length(table);
    k=length(table(1).key);
end
time(1)=toc;

tic;
[num,L]=size(query);
bin2dec=2.^(0:k-1);
db_idx=zeros(num,1);
distance=zeros(num,1);
for i=1:num %for each query separatley
    f=query(i,:);
    % find the list of potential matches through the tables
    list=[];
    for j=1:l
        temp=f(table(j).key);
        idx=sum(temp.*bin2dec)+1;
        list=[list table(j).bucket{idx}]; %#ok<AGROW>
    end
    % do an exhaustive search on the potential
    if ~isempty(list)
        len=length(list);
        dist=zeros(len,1);
        for m=1:len
            dist(m)=sum(xor(f,db(list(m),:)))/L;
        end
        [min_dist,index]=min(dist);
        db_idx(i)=list(index);
        distance(i)=min_dist;
    else
        db_idx(i)=0;
        distance(i)=1;
    end
end
time(2)=toc;
time(2)=time(2)/num;
