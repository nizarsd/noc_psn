% Power supply noise for Netwroks-on-Chip
% This file contains all tecnology parameters and design setup and required
% files paths assingmed to thier default values

%Define the microarchitectural process energies from ORION 2.0

PWR_ROUTING =      2.75377e-13/5; % Switch (except priotiry)
PWR_SELSELECTION = 2.2226e-013/5; % Switch priority
PWR_FORWARD =      1.14616e-11/5; % Crossbar
PWR_INCOMING =    5.1771e-12/5; % Input buffer energy
PWR_STANDBY =      2.39920e-12/5;  % Standby (static)

% microarchitectural process IDs
PROCESS_INCOMING = 0;
PROCESS_ROUTING  = 1;
PROCESS_SELECTION= 2;
PROCESS_FORWARD  = 3;
PROCESS_STANDBY  = 4;

DIRECTIONS      = 5;
DIRECTION_NORTH = 0;
DIRECTION_EAST  = 1;
DIRECTION_SOUTH = 2;
DIRECTION_WEST  = 3;
DIRECTION_LOCAL = 4;

% NoC size
NO_OF_TILES_X = 4; %The number of NoC tiles in the X direction
NO_OF_TILES_Y = 4; %The number of NoC tiles in the Y direction
NO_OF_TILES=NO_OF_TILES_X*NO_OF_TILES_Y;
%NoC traffic and routing
TRAFFIC = 'random'; % ..or // random //transpose1 // transpose2 // bitreversal //butterfly //shuffle //table FILENAME (traffic table file name)
ROUTING = 'xy';     %..or xy //westfirst //northlast //negativefirst //oddeven //Odd-Even //dyad T //fullyadaptive //table FILENAME (routing table file name)
PIR = 0.01;        % packet injectio rate
CYCLES = 10000;    % simulation cycles

%Volatge, frequency and floorplan
VDD=1.0 ;         %V.
FREQUENCY=1E9;     %operating frequency
FLOORPLAN_FILE='floor_plan_1600_4x_4y.txt';  % Floor plan file name
GRID_FILE='grid_1600_mesh.txt';   % Grid netlist file name
TRAFFIC_FILE= 'noxim_traffic.txt';   % traffic file name
NOXIM_PATH='/home/CAMPUS/a9902402/NOXIM/bin';


