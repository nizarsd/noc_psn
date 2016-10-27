Networks-on-Chip Power Supply Noise Tool
========================================
This tool is developed to compute the power supply noise caused by communication workload in NOCs. The tool integrates a power grid model, router power model and an NOC simulator (NOXIM). 

The tool is written in MATLAB and can run on Octave too. It is highly recommended to use Linux to run this tool. The tool requires installing modified version of NOXIM (the traffic simulator) which will provide the traffic output in the format needed by this tool to compute the router power. The sources for this modified noxim are provided under "MODIFIED_NOXM" folder

There are two main octave scripts:
1- The first, noc_psn_cycle_wise.m computes the cycle-wise node voltages for each node 
2- The noc_psn_avr.m compute the node voltages considering the average switching activity of routers for the entire simulation period. 

The output is stored to an output file. The name of the output file is reported when the script finishes running 

The inputs to the tool are:-
1- Power grid netlist file (See the code for the format of the file).
2- Floorplan file which include the data of which power grid node belongs to which tile.
3- The traffic file which include the data of the cycle wise processes executed by each router.


All traffic parameters and other constraints can be modified by editing the INPUT_PARAM.m file.


Related Publications:
==============================================

N. S. Dahir, T. Mak, F. Xia and A. Yakovlev, "Modeling and Tools for Power Supply Variations Analysis in Networks-on-Chip," in IEEE Transactions on Computers, vol. 63, no. 3, pp. 679-690, March 2014. doi: 10.1109/TC.2012.272 
URL: http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6357185&isnumber=6778691

Dahir, Nizar, Terrence Mak, and Alex Yakovlev. "Communication centric on-chip power grid models for networks-on-chip." 2011 IEEE/IFIP 19th International Conference on VLSI and System-on-Chip. IEEE, 2011.

Nizar Dahir, Terrence Mak, Fei Xia, and Alex Yakovlev. 2012. Minimizing power supply noise through harmonic mappings in networks-on-chip. In Proceedings of the eighth IEEE/ACM/IFIP international conference on Hardware/software codesign and system synthesis (CODES+ISSS '12). ACM, New York, NY, USA, 113-122. DOI=http://dx.doi.org/10.1145/2380445.2380468

