function [rnodes] =floorplan(tx,ty,rr,cc)
% [rnodes] =floorplan(tx,ty,rr,cc)
% floor planning: power grid nodes for the tile. 
% returns a vector rnodes with values represent 
% the router index attched to the node and assumes 
% regular mesh topology for both tiles, with size (tx X ty),  
% and power grid with size (cc X rr)

rx=floor((cc)/(tx));
ry=floor((rr)/(ty));   
rnodes=zeros(rr,cc);
for yi=1:ty;
    for xi=1:tx
        r=(yi-1)*ty+xi;
        rows=[(yi-1)*ry+1:yi*ry];
        col= [(xi-1)*rx+1:xi*rx];
        rnodes(col,rows)=r;
    end
end
rnodes=reshape(rnodes,1,rr*cc);
end

