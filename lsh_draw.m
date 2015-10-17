figure;
ch='rgbykc';
[x,y]=size(error);
subplot(2,3,1)
plot(ks,error(1,:));
xlabel('k');
hold on;
for i=1:x
    plot(ks,error(i,:),ch(mod(i,6)+1));
end
title('error l=20:50');
text(ks(ceil(y/2)),error(1,ceil(y/2)),'l_{min}');
text(ks(ceil(y/2)),error(x,ceil(y/2)),'l_{max}');

subplot(2,3,2)
plot(ks,time_search(1,:));
xlabel('k');
hold on;
for i=1:x
    plot(ks,time_search(i,:),ch(mod(i,6)+1));
end
title('search time /query (sec) l=20:50');
text(ks(ceil(y/2)),time_search(1,ceil(y/2)),'l_{min}');
text(ks(ceil(y/2)),time_search(x,ceil(y/2)),'l_{max}');

subplot(2,3,3)
plot(ks,time_build(1,:));
xlabel('k');
hold on;
for i=1:x
    plot(ks,time_build(i,:),ch(mod(i,6)+1));
end
title('table build time (sec) l=20:50');
text(ks(ceil(y/2)),time_build(1,ceil(y/2)),'l_{min}');
text(ks(ceil(y/2)),time_build(x,ceil(y/2)),'l_{max}');


%%
subplot(2,3,4)
plot(ls,error(:,1));
xlabel('l');
hold on;
for i=1:y
    plot(ls,error(:,i),ch(mod(i,6)+1));
end
title('error k=8:16');
text(ls(ceil(x/2)),error(ceil(x/2),1),'k_{min}');
text(ls(ceil(x/2)),error(ceil(x/2),y),'k_{max}');

subplot(2,3,5)
plot(ls,time_search(:,1));
xlabel('l');
hold on;
for i=1:y
    plot(ls,time_search(:,i),ch(mod(i,6)+1));
end
title('search time /query (sec) k=8:16');
text(ls(ceil(x/2)),time_search(ceil(x/2),1),'k_{min}');
text(ls(ceil(x/2)),time_search(ceil(x/2),y),'k_{max}');

subplot(2,3,6)
plot(ls,time_build(:,1));
xlabel('l');
hold on;
for i=1:y
    plot(ls,time_build(:,i),ch(mod(i,6)+1));
end
title('table build time (sec) k=8:16');
text(ls(ceil(x/2)),time_build(ceil(x/2),1),'k_{min}');
text(ls(ceil(x/2)),time_build(ceil(x/2),y),'k_{max}');
