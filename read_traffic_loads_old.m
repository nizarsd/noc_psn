 function sw_lds=read_traffic_lds()
    % This function will compute the loads for every router and for every
    % cycle. The load information will be taken from the traffic load file
    % fname
    % fname data structure: Cycle	router_id	process_id	outputchannel 
    INPUT_PARAM
    SIMULATOIN_WORMUP_TIME=1000;
    M = dlmread(TRAFFIC_FILE,',');
    M(:,1:2)=M(:,1:2)+1; % The router ID and the cycle ID start from 1 not 0
    
    nds=NO_OF_TILES_X*NO_OF_TILES_Y;
    mxcycle=max(M(:,1));
    mincycle=min(M(:,1));
    sw_lds=zeros(mxcycle,nds);
    
    load rndlds25  % Link traversal loads computed from the bus model switching activity assumed is 25%
    
    this_cycle=mincycle;
    cycle=mincycle;
    mxlds=length(lds);
    lidx=0;
    sw_idx =1; % switching index;
    
    while this_cycle < mxcycle-1
        this_cycle=M(sw_idx,1);
      while cycle == this_cycle
            cycle=M(sw_idx,1);
            rtr=M(sw_idx,2);
            proc=M(sw_idx,3);
            output_ch=M(sw_idx,4);
            switch proc
                case PROCESS_INCOMING 
                    proc_load = PWR_INCOMING;
                case PROCESS_ROUTING 
                    proc_load=PWR_ROUTING;
                case PROCESS_SELECTION
                    proc_load=PWR_ROUTING;
                case PROCESS_FORWARD
                    proc_load=PWR_FORWARD;
                    if  output_ch~=DIRECTION_LOCAL
                        lidx=mod(lidx,mxlds)+1;        % Update lidx 
                        link_load=lds(lidx);  % Take a link load from lds
                        proc_load=proc_load+link_load;
                    end
                    
                case PROCESS_STANDBY
                    proc_load=PWR_STANDBY;
            end
            sw_lds(this_cycle,rtr)=sw_lds(this_cycle,rtr)+proc_load;
            sw_idx=sw_idx+1;
      end % this cycle
   end % all cycles
   sw_lds=sw_lds(SIMULATOIN_WORMUP_TIME:end,:);