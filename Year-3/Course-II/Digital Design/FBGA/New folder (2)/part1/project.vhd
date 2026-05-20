LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY project IS
    PORT (
		  CLOCK_50 : IN STD_LOGIC;
        KEY    : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);   -- Pushbuttons
        SW     : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);   -- Switches
        LEDR   : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);   -- LEDs
        HEX0   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);   -- 7-segment display
        HEX1   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        HEX2   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        HEX3   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        HEX4   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        HEX5   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END project;

ARCHITECTURE Behavior OF project IS

    COMPONENT proc
        PORT (
            DIN     : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
            Resetn  : IN STD_LOGIC;
            Clock   : IN STD_LOGIC;
            Run     : IN STD_LOGIC;
            Done    : BUFFER STD_LOGIC;
            BusOut  : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
        );
    END COMPONENT;
	 

    SIGNAL Done    : STD_LOGIC;
    SIGNAL BusOut  : STD_LOGIC_VECTOR(8 DOWNTO 0);

    -- HEX Decoder function
    FUNCTION HexDigitTo7Seg(input : STD_LOGIC_VECTOR(2 DOWNTO 0)) RETURN STD_LOGIC_VECTOR IS
        VARIABLE seg : STD_LOGIC_VECTOR(6 DOWNTO 0);
    BEGIN
        CASE input IS
            WHEN "000" => seg := "1000000"; -- 0
            WHEN "001" => seg := "1111001"; -- 1
            WHEN "010" => seg := "0100100"; -- 2
            WHEN "011" => seg := "0110000"; -- 3
            WHEN "100" => seg := "0011001"; -- 4
            WHEN "101" => seg := "0010010"; -- 5
            WHEN "110" => seg := "0000010"; -- 6
            WHEN "111" => seg := "1111000"; -- 7
--            WHEN "000" => seg := "0000000"; -- 8
--            WHEN "001" => seg := "0010000"; -- 9
--            WHEN "010" => seg := "0001000"; -- A
--            WHEN "011" => seg := "0000011"; -- B
--            WHEN "100" => seg := "1000110"; -- C
--            WHEN "101" => seg := "0100001"; -- D
--            WHEN "110" => seg := "0000110"; -- E
--            WHEN "111" => seg := "0001110"; -- F
            WHEN OTHERS => seg := "1111111"; -- All segments off
        END CASE;
        RETURN seg;
    END FUNCTION;

BEGIN

    -- Connect the processor (part 1 only)
    U1: proc PORT MAP (
        DIN    => SW(8 DOWNTO 0),   -- Input data from SW[8:0]
        Resetn => KEY(3),           -- Reset from KEY(3)
        Clock  => CLOCK_50,           -- Clock from KEY(0)
        Run    => SW(9),            -- Run signal from SW(9)
        Done   => Done,
        BusOut => BusOut
    );

    -- Outputs:
    LEDR(8 DOWNTO 0) <= BusOut;     -- Show BusWires on LEDs 8..0
    LEDR(9) <= Done;                -- Done signal on LED9

    HEX0 <= HexDigitTo7Seg(BusOut(2 DOWNTO 0)); -- Show low nibble
    HEX1 <= HexDigitTo7Seg(BusOut(5 DOWNTO 3)); -- Show high nibble
    HEX2 <= HexDigitTo7Seg(BusOut(8 DOWNTO 6)); -- Show high nibble
	 

    -- Other HEX off
--    HEX2 <= "1111111";
    HEX3 <= "1111111";
    HEX4 <= "1111111";
    HEX5 <= "1111111";

END Behavior;
