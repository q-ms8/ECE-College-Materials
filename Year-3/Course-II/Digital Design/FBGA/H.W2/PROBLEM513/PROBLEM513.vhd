library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity PROBLEM513 is
    Port (
        A, B, C: in STD_LOGIC;
        X: in STD_LOGIC_VECTOR(10 downto 0);
        Clock: in STD_LOGIC;
        Y: out STD_LOGIC
    );
end PROBLEM513;

architecture Structural of PROBLEM513 is
  
    signal nA, nB, nC: STD_LOGIC;
    signal nX: STD_LOGIC_VECTOR(10 downto 0); 
    signal X_bit: STD_LOGIC; 
    signal nXA, nXnC, nXnCB, nXC, nAnB, nAnBnX, AX, BC, nAnBnC: STD_LOGIC;
begin
   
    process (A, B, C, X)
    begin
        -- Invert single
        nA <= not A;
        nB <= not B;
        nC <= not C;

      
        nX <= not X;

   
        X_bit <= X(0); 

        -- AND operations
        nXA    <= not X_bit and A;
        nXnC   <= not X_bit and nC;
        nXnCB  <= nXnC and B;
        nXC    <= not X_bit and C;
        nAnB   <= nA and nB;
        nAnBnX <= nAnB and not X_bit;
        AX     <= A and X_bit;
        BC     <= B and C;
        nAnBnC <= nAnB and nC;
    end process;

   
    process (Clock)
    begin
        if rising_edge(Clock) then
            Y <= (A and X_bit) or (B and not X_bit) or (C and B); 
        end if;
    end process;
end Structural;
