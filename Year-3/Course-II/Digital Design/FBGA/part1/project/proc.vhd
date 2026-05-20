LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; -- unsigned not signed

ENTITY proc IS
    PORT (
        DIN     : IN STD_LOGIC_VECTOR(8 DOWNTO 0); -- 9 bits
        Resetn  : IN STD_LOGIC;
        Clock   : IN STD_LOGIC;
        Run     : IN STD_LOGIC;
        Done    : BUFFER STD_LOGIC;
        BusOut  : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
    );
END proc;

ARCHITECTURE Behavior OF proc IS

    -- Component Declarations (only!)
    COMPONENT dec3to8
        PORT (
            E : IN STD_LOGIC;
            W : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Y : OUT STD_LOGIC_VECTOR(0 TO 7)
        );
    END COMPONENT;

    COMPONENT regn
        GENERIC (n : INTEGER := 9);
        PORT (
            R      : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            Resetn : IN STD_LOGIC;
            Rin    : IN STD_LOGIC;
            Clock  : IN STD_LOGIC;
            Q      : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
        );
    END COMPONENT;

    -- Signal Declarations
    TYPE State_type IS (T0, T1, T2, T3);
    SIGNAL Tstep_Q, Tstep_D : State_type;

    SIGNAL Rin : STD_LOGIC_VECTOR(0 TO 7);
    SIGNAL rXin, IRin, Ain, Gin, AddSub : STD_LOGIC;

    SIGNAL Sel : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL III, rX, rY : STD_LOGIC_VECTOR(2 DOWNTO 0);

    SIGNAL r0, r1, r2, r3, r4, r5, r6, r7, A : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL G : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL Sum : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL IR, BusWires : STD_LOGIC_VECTOR(8 DOWNTO 0);

    -- Bus Multiplexer Selector Constants
    CONSTANT SEL_R0          : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    CONSTANT SEL_R1          : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
    CONSTANT SEL_R2          : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
    CONSTANT SEL_R3          : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
    CONSTANT SEL_R4          : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
    CONSTANT SEL_R5          : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
    CONSTANT SEL_R6          : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110";
    CONSTANT SEL_R7          : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111";
    CONSTANT SEL_G           : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000";
    CONSTANT SEL_SIGN_EXT    : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1001";

BEGIN

    -- Decode instruction
    III <= IR(8 DOWNTO 6);
    rX  <= IR(5 DOWNTO 3);
    rY  <= IR(2 DOWNTO 0);

    decX: dec3to8 PORT MAP (rXin, rX, Rin);

    -- State machine
    statetable: PROCESS(Tstep_Q, Run, Done)
    BEGIN
        CASE Tstep_Q IS
            WHEN T0 =>
                IF Run = '0' THEN Tstep_D <= T0;
                ELSE Tstep_D <= T1;
                END IF;
            WHEN T1 =>
                IF Done = '1' THEN Tstep_D <= T0;
                ELSE Tstep_D <= T2;
                END IF;
            WHEN T2 =>
                Tstep_D <= T3;
            WHEN T3 =>
                Tstep_D <= T0;
        END CASE;
    END PROCESS;

    -- Control signals
    controlsignals: PROCESS(Tstep_Q, III, rX, rY)
    BEGIN
        -- Default values
        IRin   <= '0';
        rXin   <= '0';
        Ain    <= '0';
        Gin    <= '0';
        AddSub <= '0';
        Done   <= '0';
        Sel    <= (others => '0');

        CASE Tstep_Q IS
            WHEN T0 =>
                IRin <= '1';

            WHEN T1 =>
                CASE III IS
                    WHEN "000" => -- mv Rx, Ry
                        Sel   <= '0' & rY;
                        rXin  <= '1';
                    WHEN "001" => -- mvi Rx, #D
                        Sel   <= SEL_SIGN_EXT;
                        rXin  <= '1';
                    WHEN "010" | "011" => -- add or sub
                        Sel   <= '0' & rX;
                        Ain   <= '1';
                    WHEN OTHERS => NULL;
                END CASE;

            WHEN T2 =>
                CASE III IS
                    WHEN "010" => -- add
                        Sel  <= '0' & rY;
                        Gin  <= '1';
                    WHEN "011" => -- sub
                        Sel    <= '0' & rY;
                        Gin    <= '1';
                        AddSub <= '1';
                    WHEN OTHERS => NULL;
                END CASE;

            WHEN T3 =>
                CASE III IS
                    WHEN "010" | "011" => -- store result
                        Sel   <= SEL_G;
                        rXin  <= '1';
                        Done  <= '1';
                    WHEN "000" | "001" => -- mv or mvi
                        Done <= '1';
                    WHEN OTHERS => NULL;
                END CASE;
        END CASE;
    END PROCESS;

    -- FSM flip-flops
    fsmflipflops: PROCESS(Clock, Resetn)
    BEGIN
        IF Resetn = '0' THEN
            Tstep_Q <= T0;
        ELSIF rising_edge(Clock) THEN
            Tstep_Q <= Tstep_D;
        END IF;
    END PROCESS;

    
	 
	 -- Registers
    reg_0: regn PORT MAP (BusWires, Resetn, Rin(0), Clock, r0);
    reg_1: regn PORT MAP (BusWires, Resetn, Rin(1), Clock, r1);
    reg_2: regn PORT MAP (BusWires, Resetn, Rin(2), Clock, r2);
    reg_3: regn PORT MAP (BusWires, Resetn, Rin(3), Clock, r3);
    reg_4: regn PORT MAP (BusWires, Resetn, Rin(4), Clock, r4);
    reg_5: regn PORT MAP (BusWires, Resetn, Rin(5), Clock, r5);
    reg_6: regn PORT MAP (BusWires, Resetn, Rin(6), Clock, r6);
    reg_7: regn PORT MAP (BusWires, Resetn, Rin(7), Clock, r7);

    reg_A: regn PORT MAP (BusWires, Resetn, Ain, Clock, A);
    reg_IR: regn PORT MAP (DIN, Resetn, IRin, Clock, IR);
    reg_G: regn PORT MAP (Sum, Resetn, Gin, Clock, G);

    -- ALU
    ALU: PROCESS(AddSub, A, BusWires)
    BEGIN
        IF AddSub = '0' THEN
            Sum <= A + BusWires;
        ELSE
            Sum <= A - BusWires;
        END IF;
    END PROCESS;

    -- Bus multiplexer
    busmux: PROCESS(Sel, r0, r1, r2, r3, r4, r5, r6, r7, G, DIN)
    BEGIN
        CASE Sel IS
            WHEN SEL_R0 => BusWires <= r0;
            WHEN SEL_R1 => BusWires <= r1;
            WHEN SEL_R2 => BusWires <= r2;
            WHEN SEL_R3 => BusWires <= r3;
            WHEN SEL_R4 => BusWires <= r4;
            WHEN SEL_R5 => BusWires <= r5;
            WHEN SEL_R6 => BusWires <= r6;
            WHEN SEL_R7 => BusWires <= r7;
            WHEN SEL_G  => BusWires <= G;
            WHEN SEL_SIGN_EXT => BusWires <= DIN;
            WHEN OTHERS => BusWires <= (others => '0');
        END CASE;
    END PROCESS;

    
	 -- Output to Top
    BusOut <= BusWires;
	 

END Behavior;
