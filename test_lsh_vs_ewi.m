n=20;
m=10;
k=2;
stream=RandStream.getDefaultStream;
%% lsh table
stream.reset; % so that keys are the same
tic;
table_lsh=lsh_db(db,n,m);
t=toc;
disp(['table generation lsh= ' num2str(t) ' s']);
%% ewi table
stream.reset; %so that keys are the same
tic;
[table_ewi,eindex_ewi]=ewi_db(db,n,m,k);
t=toc;
disp(['table generation ewi= ' num2str(t) ' s']);
%% query
num=100000;
temp=rand(num,1024)<0.1;
distance=sum(temp,2);
disp(['max error= ' num2str(max(distance)/1024)]);
query=xor(db(1:num,:),temp);

%% search
[idx_lsh,distance_lsh,time_lsh]=lsh_query(db,query,table_lsh);
[idx_ewi,distance_ewi,time_ewi]=ewi_query(db,query,table_ewi,eindex_ewi);

err_lsh=sum(idx_lsh~=(1:num)')/num; t_lsh=time_lsh(2);
err_ewi=sum(idx_ewi~=(1:num)')/num; t_ewi=time_ewi(2);
disp('LSH (err/time)= '); disp([err_lsh t_lsh]);
disp('EWI (err/time)= '); disp([err_ewi t_ewi]); 

%% query dist
score=ewi_score_dist(db,query,table_ewi,eindex_ewi);
hist(distance); 
th=100/1024;
th1=120/1024;
th2=80/1024;
step=0.1;
temp2=hist(score,0:step:30);
temp2=temp2/num;
kt=0:k;
p=binopdf(kt,m,th);
p1=binopdf(kt,m,th1);
p2=binopdf(kt,m,th2);
alpha=(m-kt)/m;
mu1=n*sum(alpha.*p1);
mu2=n*sum(alpha.*p2);
mu=n*sum(alpha.*p);
sigma1=sqrt(n*sum((alpha.^2).*p1.*(1-p1)));
sigma2=sqrt(n*sum((alpha.^2).*p2.*(1-p2)));
sigma=sqrt(n*sum((alpha.^2).*p.*(1-p)));

p1=normpdf(0:step:30,mu1,sigma1)*step;
p2=normpdf(0:step:30,mu2,sigma2)*step;
p=normpdf(0:step:30,mu,sigma)*step;

plot(0:step:30,temp2,'ko');
hold on;
plot(0:step:30,p1,'b:');
plot(0:step:30,p2,'r-.');
plot(0:step:30,p,'k-.');

figure;
temp22=cumsum(temp2);
p12=normcdf(0:step:30,mu1,sigma1);
p22=normcdf(0:step:30,mu2,sigma2);
p_2=normcdf(0:step:30,mu,sigma);

plot(0:step:30,temp22,'ko');
hold on;
plot(0:step:30,p12,'b:');
plot(0:step:30,p22,'r-.');
plot(0:step:30,p_2,'k-.');