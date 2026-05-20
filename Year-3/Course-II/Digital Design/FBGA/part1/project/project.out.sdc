## Generated SDC file "project.out.sdc"

## Copyright (C) 2016  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Intel and sold by Intel or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 16.1.0 Build 196 10/24/2016 SJ Lite Edition"

## DATE    "Sat Apr 26 18:00:06 2025"

##
## DEVICE  "5CGXFC7C7F23C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {KEY[0]} -period 1.000 -waveform { 0.000 0.500 } [get_ports {KEY[0]}]
create_clock -name {KEY[1]} -period 1.000 -waveform { 0.000 0.500 } [get_ports {KEY[1]}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {KEY[1]}] -rise_to [get_clocks {KEY[1]}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {KEY[1]}] -rise_to [get_clocks {KEY[1]}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {KEY[1]}] -fall_to [get_clocks {KEY[1]}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {KEY[1]}] -fall_to [get_clocks {KEY[1]}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {KEY[1]}] -rise_to [get_clocks {KEY[1]}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {KEY[1]}] -rise_to [get_clocks {KEY[1]}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {KEY[1]}] -fall_to [get_clocks {KEY[1]}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {KEY[1]}] -fall_to [get_clocks {KEY[1]}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {KEY[0]}] -rise_to [get_clocks {KEY[1]}]  0.100  
set_clock_uncertainty -rise_from [get_clocks {KEY[0]}] -fall_to [get_clocks {KEY[1]}]  0.100  
set_clock_uncertainty -rise_from [get_clocks {KEY[0]}] -rise_to [get_clocks {KEY[0]}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {KEY[0]}] -rise_to [get_clocks {KEY[0]}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {KEY[0]}] -fall_to [get_clocks {KEY[0]}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {KEY[0]}] -fall_to [get_clocks {KEY[0]}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {KEY[0]}] -rise_to [get_clocks {KEY[1]}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {KEY[0]}] -fall_to [get_clocks {KEY[1]}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {KEY[0]}] -rise_to [get_clocks {KEY[0]}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {KEY[0]}] -rise_to [get_clocks {KEY[0]}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {KEY[0]}] -fall_to [get_clocks {KEY[0]}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {KEY[0]}] -fall_to [get_clocks {KEY[0]}] -hold 0.060  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

