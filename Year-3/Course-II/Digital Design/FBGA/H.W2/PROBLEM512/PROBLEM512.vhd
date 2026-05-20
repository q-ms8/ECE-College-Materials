library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PROBLEM512 is
    Port (
        A, B, C, X, Clock: in STD_LOGIC;
        Y : out STD_LOGIC
    );
end PROBLEM512;

architecture Structural of PROBLEM512 is
    signal nA, nB, nC, nX : STD_LOGIC;
    signal nXA, nXnC, nXnCB, nXC, nAnB, nAnBnX, AX, BC, nAnBnC: STD_LOGIC;
begin
    -- Combinational process
    process (A, B, C, X)
    begin
        -- Invert signals
        nA <= not A;
        nB <= not B;
        nC <= not C;
        nX <= not X;

        -- AND operations
        nXA    <= nX and A;
        nXnC   <= nX and nC;
        nXnCB  <= nXnC and B;
        nXC    <= nX and C;
        nAnB   <= nA and nB;
        nAnBnX <= nAnB and nX;
        AX     <= A and X;
        BC     <= B and C;
        nAnBnC <= nAnB and nC;
    end process;

    -- Sequential process for clocked logic
    process (Clock)
    begin
        if rising_edge(Clock) then
            Y <= (A and X) or (B and nX) or (C and B); 
        end if;
    end process;
end Structural;
