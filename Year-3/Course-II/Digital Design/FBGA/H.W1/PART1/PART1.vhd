
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity PART1 is
    port (
        A, B, C, D: in std_logic;
        O: out std_logic
    );
end PART1;



architecture AND_GATES of PART1 is
    SIGNAL E, F: std_logic;
begin
    E <= A and B;
    F <= C and D;
    O <= F and E; 
end AND_GATES;
