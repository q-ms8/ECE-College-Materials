library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity PROBLEM514 is
    Port (
        A, B, C, D, E, X: in STD_LOGIC;
        Clock: in STD_LOGIC;
        Y: out STD_LOGIC
    );
end PROBLEM514;

architecture Structural of PROBLEM514 is
  
    signal nA, nB, nC, nD, nE, nX, DA, DB, DC, DD, DE: STD_LOGIC;
begin
   
    process (A, B, C, X)
    begin
        -- Invert single
        nA <= not A;
        nB <= not B;
        nC <= not C;
		  nD <= not D;
        nE <= not E;

        nX <= not X;
		  
        -- operations
		  DA <= nX and nA and B and nC and nD and nE;
		  DB <= (X and nE) and (((nA and nB) and (C xor D)) or (A and nB and nC and nD));
		  DC <= nX and nA and nB and nC and D and nE;		  
		  DD <= X and nA and nB and nC and nD and E;
		  DE <= (nX and nB) and (((A xor E) and (nC and nD)) or (nA and C and D and nE));


    end process;
   
    process (Clock)
    begin
        if rising_edge(Clock) then
            Y <= (A xor B) and (X and nC and nD and nE); 
        end if;
    end process;
end Structural;
