Networks-on-Chip Power Supply Noise Tool
========================================
This tool is developed to compute the power supply noise due to communication workload in NOCs. The tool integrates a power grid model, router power model and an NOC simulator (NOXIM). The tool was written in MATLAB and can run on Octave too. It requires installing modified version on NOXIM which will provide the traffic output in the format needed by this tool to compute the router power. 

There are two program ms, the first, noc_psn_cycle_wise.m computes the cycle-wise node voltages for each node while the noc_psn_avr.m compute the node voltages considering the average switching activity of routers for the entire simulation period. The output is stored to an output file. The name of the output file is reported at the end of the program. 


The inputs to the tool are:-
1- Power grid netlist file (See the code for the format of the file).
2- Floorplan file which include the data of which power grid node belongs to which tile.
3- The traffic file which include the data of the cycle wise processes executed by each router.


All traffic parameters and other constraints can be modified by editing the INPUT_PARAM.m file.




