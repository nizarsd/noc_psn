INPUT_PARAM
cc=40;  % No. of grid nodes
rr=40;
tx=4;  % No. of tiles in  x.
ty=4;  % No. of tiles in  y.
rnodes=floorplan(tx,ty,rr,cc);  %type help floorplan for more info
fid=fopen(FLOORPLAN_FILE,'w');

for router=1:NO_OF_TILES
    nds=find(rnodes==router);
    txt=[];
    txt=num2str(nds(1)) ;
    for n=2:length(nds) txt=[txt ',' num2str(nds(n))]; end
    fprintf(fid,  '%s\n', txt);    
end
fclose(fid);