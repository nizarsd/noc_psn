% Creates an example of the input file FLOOTPLAN_FILE 
% assuming mesh power grid with uniform segment length
% from PTM assuming intermediate metal layer for the grid 
% with segment length 100 um
% PTM http://ptm.asu.edu/ 

INPUT_PARAM % Deine parameters
x_seg_length=100; %um;
y_seg_length=100; %um;
rg = 3.819;  
lg= 0.292e-9;
cg = 28.84775e-15;
cc=40;  % No. of grid COLUMNS
rr=40;  % No. of grid ROWS

% ###############CRAGING THE GRID NETLIST###############
% <N,<node_index1>_xpos_ypos,<node_index2>_xpos_ypos,r,l,c>  //r l and c between the nodes
% <V,<node_index>,VDD> //is connected to VDD
% <D,<node_index>> //decopling capacitance

fid=fopen(GRID_FILE,'w');
% tic
idx=0;
vr=zeros(1,rr*cc);
for i=1:rr*cc
     y_row=ceil(i/cc)-1; % Y coordinate of the row
     x_column=mod(i-1,cc); % X coordinate of the column took me 1 hr. to make it !!
   
    if mod(i,cc) > 0 % Set c r and l  entries across the row 
            x_pos1=(x_column)*x_seg_length;
            y_pos1=(y_row)*y_seg_length;
            x_pos2=(x_column+1)*x_seg_length;
            y_pos2=(y_row)*y_seg_length;
            line([x_pos1 x_pos2],[y_pos1 y_pos2])
%             xx=[x_pos1 x_pos2 y_pos1 y_pos2]
            node_index1=i;
            node_index2=i+1;
             txt = (['N ' num2str(node_index1) '_' num2str(x_pos1)  '_' num2str(y_pos1) ...
                    ' '  num2str(node_index2) '_' num2str(x_pos2) '_' num2str(y_pos2)...
                    ' '  num2str(rg) ' '  num2str(lg) ' '  num2str(cg)]);
            fprintf(fid,  '%s\n', txt);
   end
   if i <= rr*cc-cc   % Set c r and l entries across the column
            x_pos1=(x_column)*x_seg_length;
            y_pos1=(y_row)*y_seg_length;
            x_pos2=(x_column)*x_seg_length;
            y_pos2=(y_row+1)*y_seg_length;
            node_index1=i;
            node_index2=i+cc;
            txt = (['N ' num2str(node_index1) '_' num2str(x_pos1)  '_' num2str(y_pos1) ...
                    ' '  num2str(node_index2) '_' num2str(x_pos2) '_' num2str(y_pos2)...
                    ' '  num2str(rg) ' '  num2str(lg) ' '  num2str(cg)]);
            fprintf(fid,  '%s\n', txt);
            line([x_pos1 x_pos2],[y_pos1 y_pos2])
%             xx=[x_pos1 x_pos2 y_pos1 y_pos2]
           
            
   end
       
end


%Assigning package pins
vvv=zeros(rr*cc,1);
dvp=floor(rr/NO_OF_TILES_Y);  % The distance between prescribed voltage nodes
nx=floor(cc/dvp);
ny=floor(rr/dvp);
svp=zeros(ny+1,nx+1);
for nr =1:ny+1
     for nc=1:nx+1
       svp(nr,nc)=((nr-1)*cc + nc-1)*dvp;
         if nr>ny 
             svp(nr,nc)= svp(nr,nc)- cc;
         end
      end 
      svp(nr,1)= svp(nr,1)+1;
 end
vpi = reshape(svp',1,(nx+1)*(ny+1));
vvv(vpi)=1;
figure
bar3d(reshape(vvv,rr,cc))
for i=1:length(vpi)
     txt = (['V ' num2str(vpi(i)) ' ' num2str(VDD)]);
     fprintf(fid,  '%s\n', txt);
end

fclose(fid);