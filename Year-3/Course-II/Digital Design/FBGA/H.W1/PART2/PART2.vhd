library IEEE;
use IEEE.STD_LOGIC_1164.ALL;




entity PART2 is
    port (
        A0, A1, S, Clock: in std_logic;
        Q: out std_logic 
    );
end PART2;




architecture Behavioral of PART2 is
    signal D : std_logic;
begin
    process (A0, A1, S)
    begin
        if S = '0' then
            D <= A0;
        else
            D <= A1;
        end if;
    end process;

    process (Clock)
    begin
        if rising_edge(Clock) then
            Q <= D;
        end if;
    end process;
end Behavioral;
