function[sw]=bus_switching(p,n)
% mxn=power(2,n);
% r = abs((mxn/2) + (mxn/4).*randn(2,1));
% x=dec2bin(floor(r),n);
% sw=x(2,:)-x(1,:);

%Retruns a switching pattern for n bit line 
%The switching pattern follows normal distribution

swn=p;  % No. of wires switching, mean of p;
sw=zeros(1,n);
rr=(rand(1,swn)>0.5);
swv=(rr)*-1 + (~(rr)*1); % Switching values
swp=randperm(n) ;  %switching position
sw(swp(1:swn))=swv;
end
