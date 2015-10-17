% Error Weighted Indices
% n number of words
% m length of each word
% k the maximum number of errors tolerated
% length length of the input vectors

function [table,e_index]=ewi_init(n,m,k,length)

for i=1:n
    temp=randperm(length);
    table(i).key=temp(1:m); %#ok<AGROW>
    table(i).index=cell(2^m,1); %#ok<AGROW>
end

e_index=cell(2^m,k);

% creating the erroneous index table
bin2dec=2.^(0:m-1);
for i=1:k
    pattern=nchoosek(1:m,i);
        for j=1:2^m
            current=bitget(j-1,1:m);
            idx=zeros(1,size(pattern,1));
            for l=1:size(pattern,1)
                temp=current;
                temp(pattern(l,:))=~temp(pattern(l,:));
                idx(l)=sum(temp.*bin2dec)+1;
            end
            e_index{j,i}=idx;
        end
end