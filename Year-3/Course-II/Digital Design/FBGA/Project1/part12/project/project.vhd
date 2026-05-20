--=====================================================
-- 9-bit Processor with Instruction Memory
-- Part 1: Simple Processor
-- Part 2: Instruction Memory
--=====================================================

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY project IS
    PORT (
        KEY   : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);  -- KEY(0): Processor Clock, KEY(1): Memory Clock
        SW    : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);  -- SW(8:0): Data / Control, SW(9): Run
        LEDR  : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);  -- Output LEDs
        HEX0  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- HEX displays (lower nibble)
        HEX1  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- HEX displays (upper nibble)
        HEX2  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        HEX3  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        HEX4  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        HEX5  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END project;

ARCHITECTURE Behavior OF project IS

    COMPONENT proc
        PORT (
            DIN     : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
            Resetn  : IN  STD_LOGIC;
            Clock   : IN  STD_LOGIC;
            Run     : IN  STD_LOGIC;
            Done    : BUFFER STD_LOGIC;
            BusOut  : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT inst_mem
        PORT (
            address : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
            clock   : IN  STD_LOGIC;
            q       : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT count5
        PORT (
            Resetn : IN STD_LOGIC;
            Clock  : IN STD_LOGIC;
            Q      : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
        );
    END COMPONENT;

    -- HEX Decoder Function
    FUNCTION HexDigitTo7Seg(input : STD_LOGIC_VECTOR(3 DOWNTO 0)) RETURN STD_LOGIC_VECTOR IS
        VARIABLE seg : STD_LOGIC_VECTOR(6 DOWNTO 0);
    BEGIN
        CASE input IS
            WHEN "0000" => seg := "1000000"; -- 0
            WHEN "0001" => seg := "1111001"; -- 1
            WHEN "0010" => seg := "0100100"; -- 2
            WHEN "0011" => seg := "0110000"; -- 3
            WHEN "0100" => seg := "0011001"; -- 4
            WHEN "0101" => seg := "0010010"; -- 5
            WHEN "0110" => seg := "0000010"; -- 6
            WHEN "0111" => seg := "1111000"; -- 7
            WHEN "1000" => seg := "0000000"; -- 8
            WHEN "1001" => seg := "0010000"; -- 9
            WHEN "1010" => seg := "0001000"; -- A
            WHEN "1011" => seg := "0000011"; -- B
            WHEN "1100" => seg := "1000110"; -- C
            WHEN "1101" => seg := "0100001"; -- D
            WHEN "1110" => seg := "0000110"; -- E
            WHEN "1111" => seg := "0001110"; -- F
            WHEN OTHERS => seg := "1111111"; -- Blank
        END CASE;
        RETURN seg;
    END;

    -- Signals
    SIGNAL Done    : STD_LOGIC;
    SIGNAL BusOut  : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL Resetn  : STD_LOGIC;
    SIGNAL MClock  : STD_LOGIC;
    SIGNAL PClock  : STD_LOGIC;
    SIGNAL Run     : STD_LOGIC;
    SIGNAL DIN     : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL pc      : STD_LOGIC_VECTOR(4 DOWNTO 0);

BEGIN

    -- Control Assignments
    Resetn <= SW(0);      -- Reset active low
    MClock <= KEY(1);     -- Memory clock
    PClock <= KEY(0);     -- Processor clock
    Run    <= SW(9);      -- Run signal

    -- Processor instance
    U1: proc PORT MAP (
        DIN    => DIN,
        Resetn => Resetn,
        Clock  => PClock,
        Run    => Run,
        Done   => Done,
        BusOut => BusOut
    );

    -- Instruction Memory instance
    U2: inst_mem PORT MAP (
        address => pc,
        clock   => MClock,
        q       => DIN
    );

    -- Program Counter (counter for memory addresses)
    U3: count5 PORT MAP (
        Resetn => Resetn,
        Clock  => MClock,
        Q      => pc
    );

    -- Output Assignments
    LEDR(8 DOWNTO 0) <= BusOut;
    LEDR(9) <= Done;

    HEX0 <= HexDigitTo7Seg(BusOut(3 DOWNTO 0)); -- Lower nibble
    HEX1 <= HexDigitTo7Seg(BusOut(7 DOWNTO 4)); -- Upper nibble
    HEX2 <= "1111111"; -- Blank
    HEX3 <= "1111111"; -- Blank
    HEX4 <= "1111111"; -- Blank
    HEX5 <= "1111111"; -- Blank

END Behavior;







































--
--
--
--LIBRARY ieee;
--USE ieee.std_logic_1164.all;
--
--ENTITY project IS 
--    PORT (  KEY   	: IN   STD_LOGIC_VECTOR(1 DOWNTO 0);
--				CLOCK_50 : IN STD_LOGIC;
--            SW    	: IN   STD_LOGIC_VECTOR(9 DOWNTO 0);
--            LEDR     : OUT  STD_LOGIC_VECTOR(9 DOWNTO 0);
--				HEX0     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- 7-segment display
--				HEX1     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
--				HEX2     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
--				HEX3     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
--				HEX4     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
--				HEX5     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
--END project;
--
--ARCHITECTURE Behavior OF project IS
--   COMPONENT proc
--      PORT ( DIN                 : IN      STD_LOGIC_VECTOR(8 DOWNTO 0);
--             Resetn, Clock, Run  : IN      STD_LOGIC;
--             Done                : BUFFER  STD_LOGIC);
--   END COMPONENT;
----	
--   COMPONENT inst_mem 
--      PORT ( address   : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
--             clock     : IN STD_LOGIC ;
--             q         : OUT STD_LOGIC_VECTOR (8 DOWNTO 0));
--   END COMPONENT;
--	
--   COMPONENT count5
--      PORT ( Resetn, Clock   : IN   STD_LOGIC;
--             Q               : OUT  STD_LOGIC_VECTOR(4 DOWNTO 0));
--   END COMPONENT;
--	
--	
--	    -- 7-segment HEX digit decoder function
--	FUNCTION HexDigitTo7Seg(input : STD_LOGIC_VECTOR(3 DOWNTO 0)) RETURN STD_LOGIC_VECTOR IS
--	  VARIABLE seg : STD_LOGIC_VECTOR(6 DOWNTO 0);
--	BEGIN
--	  CASE input IS
--			WHEN "0000" => seg := "1000000"; -- 0
--			WHEN "0001" => seg := "1111001"; -- 1
--			WHEN "0010" => seg := "0100100"; -- 2
--			WHEN "0011" => seg := "0110000"; -- 3
--			WHEN "0100" => seg := "0011001"; -- 4
--			WHEN "0101" => seg := "0010010"; -- 5
--			WHEN "0110" => seg := "0000010"; -- 6
--			WHEN "0111" => seg := "1111000"; -- 7
--			WHEN "1000" => seg := "0000000"; -- 8
--			WHEN "1001" => seg := "0010000"; -- 9
--			WHEN "1010" => seg := "0001000"; -- A
--			WHEN "1011" => seg := "0000011"; -- B
--			WHEN "1100" => seg := "1000110"; -- C
--			WHEN "1101" => seg := "0100001"; -- D
--			WHEN "1110" => seg := "0000110"; -- E
--			WHEN "1111" => seg := "0001110"; -- F
--			WHEN OTHERS => seg := "1111111"; -- All OFF
--	  END CASE;
--	  RETURN seg;
--	END FUNCTION;
--
--	
--	
--	SIGNAL Done    : STD_LOGIC;
--	SIGNAL BusOut  : STD_LOGIC_VECTOR(8 DOWNTO 0);
--   SIGNAL Resetn, Clock, Run : STD_LOGIC;
--   SIGNAL DIN : STD_LOGIC_VECTOR(8 DOWNTO 0); 
--   SIGNAL pc : STD_LOGIC_VECTOR(4 DOWNTO 0); 
----	SIGNAL BusOut  : STD_LOGIC_VECTOR(8 DOWNTO 0);
--	
--	
--	
--BEGIN
--   Resetn <= SW(9);
--	Clock <= CLOCK_50;
--	
----   MClock <= KEY(0);
----   PClock <= KEY(1);
--   Run <= Key(0);
--   U1: proc PORT MAP (DIN, Resetn, Clock, Run, Done);
--	LEDR(9) <= Done;
----	SW(8 DOWNTO 0) <= DIN ;
----   LEDR(9) <= Run;
--	
----   LEDR(8 DOWNTO 1) <= "00000000";
--	LEDR(8 DOWNTO 0) <= BusOut;	
--
--	-- Show BusOut on HEX displays
--	HEX0 <= HexDigitTo7Seg(BusOut(3 DOWNTO 0)); -- Low nibble
--	HEX1 <= HexDigitTo7Seg(BusOut(7 DOWNTO 4)); -- High nibble
--	HEX2 <= "1111111";
--	HEX3 <= "1111111";
--	HEX4 <= "1111111";
--	HEX5 <= "1111111";
--	
----    -- Instantiate the processor
--    U4: proc PORT MAP (
--        DIN     => SW(8 DOWNTO 0),   -- SW0–SW8: instruction/data input
--        Resetn  => KEY(0),           -- KEY0: Reset (active low)
--        Clock   => CLOCK_50,         -- 50 MHz board clock
--        Run     => NOT KEY(1),       -- KEY1: Run (active high), invert because KEY is active low
--        Done    => Done
----        BusOut  => BusOut
--    );
--
----   U2: inst_mem PORT MAP (pc, MClock, DIN);
----   U3: count5 PORT MAP (Resetn, MClock, pc);
--END Behavior;
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY count5 IS 
    PORT ( Resetn, Clock   : IN   STD_LOGIC;
           Q               : OUT  STD_LOGIC_VECTOR(4 DOWNTO 0));
END count5;

ARCHITECTURE Behavior OF count5 IS
   SIGNAL Count : STD_LOGIC_VECTOR(4 DOWNTO 0); 
BEGIN
   PROCESS (Clock, Resetn)
   BEGIN
         IF (Resetn = '0') THEN
            Count <= "00000";
         ELSIF (rising_edge(Clock)) THEN
            Count <= Count + '1';
         END IF;
   END PROCESS;
   Q <= Count;
END Behavior;
