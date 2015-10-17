% l number of lsh tables
% k length of each hash function
% length length of the input vectors

function table=lsh_init(l,k,length)

for i=1:l
    temp=randperm(length);
    table(i).key=temp(1:k); %#ok<AGROW>
    table(i).bucket=cell(2^k,1); %#ok<AGROW>
end



