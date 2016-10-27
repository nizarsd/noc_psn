 function result=read_cycle_loads()
    % This function will compute the loads for every router and for every
    % cycle. The load information will be taken from the traffic load file
    % fname
    % fname data structure: Cycle	router_id	process_id	outputchannel 
    INPUT_PARAM
    SIM_WORMUP_TIME=1000;
    fid= fopen(TRAFFIC_FILE,'r');
    fid2= fopen('traffic_load.txt','w');
    
    load rndlds25  % Link traversal loads computed from the bus model switching activity assumed is 25%
    mxlds=length(lds);
    lidx=0;
    
    cycle=0;
   
while cycle < SIM_WORMUP_TIME
      tline= fgetl(fid);
      line_data=sscanf(tline,['%i,%i,%i,%i']); %Cycle	router_id	process_id	outputchannel 
      this_cycle=line_data(1);
      cycle=this_cycle;
end

     
     
while ischar(tline)
      cycle_load=zeros(1,NO_OF_TILES);      
    while (cycle == this_cycle) && ischar(tline)
            line_data=sscanf(tline,['%i,%i,%i,%i']);
            cycle=line_data(1)+1
            rtr=line_data(2)+1;
            proc=line_data(3);
           switch proc
                case PROCESS_INCOMING 
                    proc_load = PWR_INCOMING;
                case PROCESS_ROUTING 
                    proc_load=PWR_ROUTING;
                case PROCESS_SELECTION
                    proc_load=PWR_ROUTING;
                case PROCESS_FORWARD
                    proc_load=PWR_FORWARD;
                    output_ch=line_data(4);
                    if  output_ch~=DIRECTION_LOCAL
                        lidx=mod(lidx,mxlds)+1;        % Update lidx 
                        link_load=lds(lidx);  % Take a link load from lds
                        proc_load=proc_load+link_load;
                    end
                    
                case PROCESS_STANDBY
                    proc_load=PWR_STANDBY;
            end
%           sw_lds(this_cycle+1,rtr)=sw_lds(this_cycle+1,rtr)+proc_load;
            cycle_load(rtr)=cycle_load(rtr)+ proc_load;
            tline= fgetl(fid);
    end % this cycle
      this_cycle=line_data(1)+1;
      
      fprintf(fid2,'%i ',cycle);
      for rr=1:NO_OF_TILES fprintf(fid2,'%e ',cycle_load(rr)); end
      fprintf(fid2,'\n');
      
 end % all cycles
 fclose(fid);
 fclose(fid2);
result=1;
