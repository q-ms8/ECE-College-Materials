library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PART3 is
    port (
        A, B, C, Clock: in std_logic;
        O: out std_logic 
    );
end PART3;

architecture Behavioral of PART3 is
    signal D : std_logic;
begin
    process (A, B)
    begin
        D <= A and B;  
    end process;

    process (Clock)
    begin
        if rising_edge(Clock) then
            O <= D xor C; 
        end if;
    end process;
end Behavioral;
