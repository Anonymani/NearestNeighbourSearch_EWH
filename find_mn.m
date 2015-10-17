function find_mn(N,M,K,thd,thr)

%M  : Length of the words (can be a vector, the best will be returned)
%N  : Number of the words (can be a vector, ...
%K  : Maximum errors tolerated in a word ((can be a vector,...
%thd: Threshold for detection
%thr: Threshold for rejection

out=zeros(length(N),length(M),length(K));
min_out=2;
m_min=0;
n_min=0;
k_min=0;

for x=1:length(N)
    for y=1:length(M)
        for z=1:length(K)
            n=N(x);
            m=M(y);
            k=0:K(z);
            p_d=binopdf(k,m,thd);
            p_r=binopdf(k,m,thr);
            alpha=(m-k)/m;
            mu_d=n*sum(alpha.*p_d);
            mu_r=n*sum(alpha.*p_r);
            sigma_d=sqrt(n*sum((alpha.^2).*p_d.*(1-p_d)));
            sigma_r=sqrt(n*sum((alpha.^2).*p_r.*(1-p_r)));
            out(x,y,z)=(mu_r-mu_d+2.054*sigma_r)/(sigma_d);
            if out(x,y,z)< min_out
                min_out=out(x,y,z);
                m_min=m;
                n_min=n;
                k_min=k(end);
            end
        end
    end
end


s= sprintf('---\nprob.:\t %1.4f \nmin:\t %2.2f\nm:\t %d \nn:\t %d \nk:\t %d', ...
    1-normcdf(min_out),min_out,m_min,n_min,k_min);
disp(s);

%% For different k's
plot(k,ones(length(k),1));
hold on;
p=zeros(1,length(K));
load=zeros(length(K),2);
for z=1:length(K)
    out2=out(:,:,z);
    if length(N)>1
        [minvalue,idx]=min(out2);
        [minvalue,idx2]=min(minvalue);
    m_min=M(idx2);
    n_min=N(idx(idx2));
    else
        [minvalue,idx2]=min(out2);
        m_min=M(idx2);
        n_min=N;
    end
    p(z)=1-normcdf(minvalue);
    load(z,1)=n*binocdf(K(z),m_min,0.5)/(0.5)^m_min;
    load(z,2)=4*n*2^(m_min-20);
    text(K(z),p(z),{'',['m=' num2str(m_min)], ['n=' num2str(n_min)]});
    text(K(z),p(z),{'','','','',['RAM [Ac,size]=' num2str(load(z,1:2)) ]});
end
s='rgbkymc';
plot(k,p,s(ceil(rand*7)),'LineWidth',2);
    



