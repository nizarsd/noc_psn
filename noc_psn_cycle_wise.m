% This is the main program. It will run the simulation for the entire
% simulation period determined by the traffic file from noxim. The output
% will be wirtten in the <output_file_name> which will formatted in this
% program. The power supply noise computed here is per cycle power
% consumption of each router.
clear
clc
VISUAL=0;
INPUT_PARAM
file_grid=fopen(GRID_FILE,'r'); 
ts=1/FREQUENCY;

idx=1;
idx2=1;

% Reading and parsing the grid netlist
% The format of the file is;
% 'N n1 n2 R L C' efines and grid RLC segment between nodes n1 and n2
% or 'V n  V_DD' defines the package pin psitions at node n
tline= fgetl(file_grid);
while ischar(tline)
    line_type=tline(1);
    switch line_type
        case 'N'  % If the line is a grid segment n1_id_x1_y1, n2_id_x2_y2, R, L, C
            c1=sscanf(tline,['N %i_%i_%i %i_%i_%i %f %f %f']);
            node1=c1(1);
            node2=c1(4);
            nd1_idx(idx)=node1;
            nd2_idx(idx)=node2;
            rg(idx) =c1(7);
            lg(idx) =c1(8);
            cg(idx) =c1(9);
            idx=idx+1;
         case 'V' % the line is a package pin V, id, VDD
            c1=sscanf(tline,['V %i %f']);
            vpi(idx2)=c1(1); 
            idx2=idx2+1;
    end
    tline= fgetl(file_grid);
end

fclose(file_grid);

            
cg=[cg cg];
rg=[rg rg];
lg=[lg lg];
node=[nd1_idx' nd2_idx' ; nd2_idx' nd1_idx'];
gnodes=unique(node(:,1));  % Node indicies
no_of_nodes=length(gnodes);
cl=zeros(no_of_nodes,1);

xt=(ts^2)./(6*lg+3*rg*ts);
xg=full(sparse(node(:,1),node(:,2),xt));

np = length(vpi); % No of prescribed nodes
vfi=setdiff(gnodes,vpi);  %free voltage indexes (all except vpi)
m=length(vfi);  % No of free nodes
vp=ones(np,1)*VDD;

qff=zeros(m,m);
qfp=zeros(m,np);
qpf=zeros(np,m);
qpp=zeros(np,np);
bp=zeros(np,1);
bf=zeros(m,1);



% Reading the floorplan file 
fp=dlmread(FLOORPLAN_FILE,',');

% DRAWING ***************
if VISUAL==1
    rr=40;cc=40;
    vr=zeros(no_of_nodes,1);
    svr = reshape(vr,cc,rr);

    colormap('hot')
    hv=surfc(svr);
    zlim([.9 1.1])
    set(hv,'ZDataSource','svr')
    ylabel('Grid X');
    xlabel('Grid Y');
    zlabel('Voltage');
end
% ***********************

%Output file name
output_file_name=[ROUTING '_' TRAFFIC(1:4) '_' num2str(100*PIR) '_cycle_output.txt'];
output_file= fopen([output_file_name],'w');

% Creating the traffic file using NOXIM
delete('noxim_traffic.txt') % Delete the old one
systemcommand=[NOXIM_PATH '/noxim -dimx ' num2str(NO_OF_TILES_X) ' -dimy ' num2str(NO_OF_TILES_Y) ...
    ' -traffic '  TRAFFIC ' -routing ' ROUTING ' -pir ' num2str(PIR) ' poisson -sim ' num2str(CYCLES) ' -verbose 1 >> ' TRAFFIC_FILE];          
system(systemcommand);

% Creating traffic_load.txt << noxim_traffic.txt file
rr=read_cycle_loads();

% Opening the file and reading it line by line.
file_loads= fopen('traffic_load.txt','r');
tline2= fgetl(file_loads);
    
while ischar(tline2) % simulation starts here ..
   
    % Reading load from the tile loads file *******************
   
    line_data=sscanf(tline2,'%e'); %cycle <TILE_LOADS>
    cycle=int16(line_data(1));
    router_loads=line_data(2:end);
    for r=1:NO_OF_TILES% For all switching routers
        tile_nodes=fp(r,:);    
        router_workload=router_loads(r);  
        cl(tile_nodes)=router_workload/length(tile_nodes);  % DISTRIBUTE EVENLY 
    end
    %**********************************************************
 
    % Computing Qff
    for j=1:m
        fi=vfi(j); % Which node
        jj=find(node(:,1)==fi); % What are the neighbors the node
        jn=node(jj,2);
        yj =sum(xg(fi,jn))+.5*sum(cg(jj))+cl(fi); 
       
        for k =1:m
            if xg(fi,vfi(k))>0  % Save time
                qff(j,k)=xg(fi,vfi(k))/yj;
            end
        end               
        qff(j,j)=-1  ;
    end

    % Computing Qfp

    % disp('Finished, now computing Qfp...');

    for j=1:m
        fi=vfi(j); % Which node
        jj=find(node(:,1)==fi); % What are the neighbors the node
        jn=node(jj,2);
        yj =sum(xg(fi,jn))+.5*sum(cg(jj))+cl(fi); 
       
        for k =1:np
            qfp(j,k)=xg(fi,vpi(k))/yj;
        end               
    end


    % Computing Qpf
    % disp('Finished, now computing Qpf...');

    for j=1:np
        fi=vpi(j); % Which node
        jj=find(node(:,1)==fi); % What are the neighbors the node
        jn=node(jj,2);
        yj =sum(xg(fi,jn))+.5*sum(cg(jj))+cl(fi); 
       
        for k =1:m
            if xg(fi,vfi(k))>0  % save time
                qpf(j,k)=xg(fi,vfi(k))/yj;
            end
        end               
    end

    % Computing Qpp

    % disp('Finished, now computing Qpp...');
    for j=1:np
        fi=vpi(j); % Which node
        jj=find(node(:,1)==fi); % What are the neighbors the node
        jn=node(jj,2);
        yj =sum(xg(fi,jn))+.5*sum(cg(jj))+cl(fi); 
       
        for k =1:np
            qpp(j,k)=xg(fi,vpi(k))/yj;
        end               
        qpp(j,j)=-1  ;
    end


% pf
% disp('Finished, now computing pf...');

    for i=1:m
        fi=vfi(j); % Which node
        jj=find(node(:,1)==fi); % What are the neighbors the node
        jn=node(jj,2);
        yj =sum(xg(fi,jn))+.5*sum(cg(jj))+cl(fi); % Assuming a homogenous segment length
        bf(i)= -1*(1/(2*yj))*sum(cg(jj))*VDD;
    end


    vf=qff\(bf-qfp*vp);
 
    % Merging the voltages vp and vf
    for i=1:m
         vr(vfi(i))=vf(i);
    end
 
    for i=1:np
        vr(vpi(i))=vp(i);
    end
   
    % Update drawing
    if VISUAL==1
        svr = reshape(vr,cc,rr);
        refreshdata(hv,'caller') % Evaluate y in the function workspace
        title(num2str(cycle))
        drawnow('update'); pause(0.001)
    end
    
    fprintf(output_file,'%i ',cycle);
        for nd=1:length(vr) fprintf(output_file,'%f ',vr(nd)); end
            fprintf(output_file,'\n');

tline2= fgetl(file_loads);
end

fclose(file_loads);
fclose(output_file);
disp(['result written to file:''' output_file_name '''']);
