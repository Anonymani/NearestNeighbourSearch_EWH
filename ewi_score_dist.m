function score_ewi=ewi_score_dist(db,query,table,e_index)


n=length(table);
m=length(table(1).key);
k=size(e_index,2);


[num,~]=size(query);
bin2dec=2.^(0:m-1);

coeff=(m-1:-1:m-k)/m;
score_ewi=zeros(num,1);
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
    score_ewi(i)=score(i);
%    score(score==0)=[];
end

