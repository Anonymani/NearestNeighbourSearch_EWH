%% Data generation
n=10^3;
L=1024;
db=false(n,L);

for i=1:n/1000
    a=rand(1000,1024);
    for j=1:1000
        db((i-1)*1000+j,:)=a(j,:)>median(a(j,:));
    end
end
    
%% test validity
k=0;
min_dist_in_db=1;
for i=1:n
    for j=i+1:n
        temp=sum(xor(db(i,:),db(j,:)));
        if temp<=256
            k=k+1;
            disp([i,j]);
        elseif temp<(min_dist_in_db*L)
            min_dist_in_db=(temp/L);
        end
    end
end

%% Data generation 2
%% half of DB
n=10^7;
L=1024;
th=0.4;
db_temp=false(ceil(sqrt(n)),L/2);
j=1;
a=rand(1,L/2);
db_temp(1,:)=a<median(a);
for i=1:n
    if j>=sqrt(n);
        break;
    end
    a=rand(1,L/2);
    temp=a<median(a);
    add=true;
    for k=1:j
        if sum(xor(temp,db_temp(k,:)))<(th*L/2);
            add=false;
            break;
        end
    end
    if add
        j=j+1;
        db_temp(j,:)=temp;
    end
end
%% test
min_dist_in_db=L/2;
a=true;
for i=1:j
    for k=i+1:j
        temp=sum(xor(db_temp(i,:),db_temp(j,:)));
        if temp<=(th*L/2)
            a=false;
            break;
        end
        if temp<=min_dist_in_db
           min_dist_in_db=temp;
       end
    end
end

              
 %% full DB
 db=false(j^2,L);
 for i=1:j
     for k=1:j
         db((i-1)*j+k,:)=[db_temp(i,:),db_temp(k,:)];
     end
 end
 

    