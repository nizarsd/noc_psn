function bl = bus_load(sw)
% To compute the load (C) caused by the bus switching
nl=length(sw); % No. of lines
h= 1;% wire lenght in mm

l11= 1.762;
l12 = 1.574;
l13 = 1.436;
l14 = 1.355;

c11 = 169.074;
c12 = 115.298;
r11 = 448.979;

vrs = ones(1,nl)*100;
vls = ones(1,nl)*1e-9;
vtau = ones(1,nl)* 0e-12 ;
tend = .25e-9;
vcl  =  ones(1,nl)*40e-15;
step = 1e-12;
tr=50e-12;
 
 for ki=1:nl
     mr(ki,ki)=r11;
     mc(ki,ki)=c11;
     mc(ki,ki+1)=c12;
     mc(ki+1,ki)=c12;
     
     ml(ki,ki)=l11;
     ml(ki,ki+1)=l12;
     ml(ki,ki+2)=l13;
     ml(ki,ki+3)=l14;
     
     ml(ki+1,ki)=l12;
     ml(ki+2,ki)=l13;
     ml(ki+3,ki)=l14;
 end



mc=1e-15*mc(1:nl,1:nl);
ml=1e-9*ml(1:nl,1:nl);


[mt eigv]=eig(ml);
mcd1 = ((mt'*mc*mt));
mld1 = ((mt'*ml*mt));

mcd = abs((mcd1));
mld = abs((mld1));

% eigv = eigv/(max(max(abs(eigv))));  %Normalization of the eig vlaue matrix
% mt = mt/(max(max(abs(mt))));

mtot =(mt);
mtott=mtot';
qt=0;

for w=1:nl
    ss=sw(w);
    % Call  wire_load(h,cl,tau,rs,ls,r,l,c,tr)
    [wq]=wire_load(h,vcl(w),vtau(w),vrs(w),vls(w),mr(w,w),mld(w,w),mcd(w,w),tr);
    q(w)=ss*wq;
end


for k = 1: nl 
    for i=1:nl
        qt1=0;
        for j=1:nl
           qt1 = qt1 +  mtott(i,j)*(q(i));
        end
        qt = qt +qt1*mtot(k,i);
     
    end 
end       
       

bl=qt;
