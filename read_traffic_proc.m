function[sw]=read_traffic_proc(fname,process)

    % This function will compute the switching for every router and for every
    % cycle. The load information will be taken from the traffic load file
    % fname
    % fname data structure: Cycle	router_id	process_id	process_power outputchannel 
    
    % Process ID
    
    SIMULATOIN_WORMUP_TIME=1000;
    M = dlmread(fname,',');
    M(:,1:2)=M(:,1:2)+1; % The router ID and the cycle ID start from 1 not from 0
    
    nds= max(M(:,2));
    mxcycle=max(M(:,1));
    mincycle=min(M(:,1));
    cycles=mxcycle-mincycle;
    sw=zeros(cycles,nds);
    cycle=mincycle;
    n=1;
    
    while n <= cycles
        nsw = find(M(:,1)==cycle);
        for k=1:length(nsw)
            sw_idx=nsw(k);
            rtr=M(sw_idx,2);
            proc=M(sw_idx,3);
                    
            if (proc == process) 
                sw(n,rtr) = sw(n,rtr) + 1;
            end
            
        end
        n=n+1;
        cycle=cycle+1;
    end

   sw=sw(SIMULATOIN_WORMUP_TIME:end,:);