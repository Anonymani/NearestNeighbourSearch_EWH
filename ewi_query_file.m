%[db_idx,distance]=ewi_query(db,query,n,m,k);
%%%% or
%[db_idx,distance]=ewi_query(db,query,table,e_index);
%test to see if works

function [db_idx,distance,time]=ewi_query_file(db,query,table,e_index)

fid=fopen(db,'r');
n=length(table);
m=length(table(1).key);
k=size(e_index,2);

[num,L]=size(query);
bin2dec=2.^(0:m-1);
db_idx=zeros(num,1);
distance=zeros(num,1);
coeff=(m-1:-1:m-k)/m;

tic;
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
            fseek(fid,(list(m)-1)*L/8,'bof');
            temp=logical(fread(fid,L,'ubit1')');
            dist(m)=sum(bitxor(f,temp))/L;
        end
        [min_dist,index]=min(dist);
        db_idx(i)=list(index);
        distance(i)=min_dist;
    else
        db_idx(i)=0;
        distance(i)=1;
    end
end
time=toc;
time=time/num;
fclose(fid);
