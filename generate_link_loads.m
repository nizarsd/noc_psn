% This script will create a random link loads for link with <link_bits> no
% of bits. The switching activity of the link is 25% in average (25% of wires are
% changing). The the load_bus function uses the bus current model to
% compute the load equivalent capacitance of the link switching.

clear
link_bits=32;
iter =100000;
ss=floor((randn(1,iter)));  % CREATE A NORMAL SWITCIHNG WITH A MEAN OF 25%
ss=ss-mean(ss);
ss=ss-min(ss);
ss=0.5*ss/max(ss);
p=floor(ss*link_bits+0.5); 

for i=1:iter
       lds(i)=bus_load(bus_switching(p(i),link_bits));
end


save rndlds25 lds