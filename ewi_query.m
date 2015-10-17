%[db_idx,distance]=ewi_query(db,query,n,m,k);
%%%% or
%[db_idx,distance]=ewi_query(db,query,table,e_index);


function [db_idx,distance,time]=ewi_query(db,query,n,m,k)
tic;
if nargin==5
    [table,e_index]=ewi_db(db,n,m,k);
elseif nargin==4
    table=n;
    e_index=m;
    n=length(table);
    m=length(table(1).key);
    k=size(e_index,2);
end
time(1)=toc;

tic;
[num,L]=size(query);
bin2dec=2.^(0:m-1);
db_idx=zeros(num,1);
distance=zeros(num,1);
coeff=(m-1:-1:m-k)/m;
for i=1:num %for each query separatley
    f=query(i,:);
    % find the score of each finegrprint
    score=zeros(size(db,1),1);
    for j=1:n
        temp=f(table(j).key);
        idx=sum(temp.*bin2dec)+1;%index in the inverted file table
        indices=table(j).index{idx}; %indices of the fingerprints in the same bucket
        score(indices)=score(indices)+1;
        for l=1:k
            indices=table(j).index(e_index{idx,l});
            indices=cell2mat(indices');
            score(indices)=score(indices)+coeff(l);
        end
    end
    % do an exhaustive search on the potential
    M=max(score);
    list=find(score>0.9*M);
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
disp('currently 0.8*Max');
