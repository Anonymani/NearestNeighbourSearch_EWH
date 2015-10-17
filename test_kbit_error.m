clear all;

j=0;
for k=0:5
    %% parameters
    j=j+1;
    %k=2;
    m=9;
    l=640;
    th=0.25*1024;
    %% values (actual)
    error(j)=nchoosek(m,k);  %#ok<SAGROW>
   for i=1:m-k
        error(j)=error(j)*(1-th/(l-i+1));  %#ok<SAGROW> 
    end
    for i=1:k
        error(j)=error(j)*(th-i+1)/(l-m+k-i+1);  %#ok<SAGROW>
    end
      %% values (upper bound)
      error_upper(j)=nchoosek(m,k)*((1-th/l)^(m-k))*(th/(l-m+k))^k;   %#ok<SAGROW>
      %% values (lower bound)
      error_lower(j)=nchoosek(m,k)*((1-th/(l-m+k))^(m-k))*((th-k)/(l-m))^k; %#ok<SAGROW>
      %% values (estimate 1)
      error_est1(j)=nchoosek(m,k)*((1-th/l)^(m-k))*(th/l)^k; %#ok<SAGROW>
    
end
plot(error,'k','LineWidth',2);
hold on;
plot(error_upper,':r','LineWidth',2);
plot(error_lower,':b','LineWidth',2);
plot(error_est1,':k','LineWidth',2);
