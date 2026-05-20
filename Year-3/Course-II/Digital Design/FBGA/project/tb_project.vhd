LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY tb_project IS
END tb_project;

ARCHITECTURE sim OF tb_project IS

    -- Component under test
    COMPONENT project
        PORT (
            DIN     : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
            Resetn  : IN STD_LOGIC;
            Clock   : IN STD_LOGIC;
            Run     : IN STD_LOGIC;
            Done    : BUFFER STD_LOGIC;
            BusOut  : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals
    SIGNAL DIN     : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL Resetn  : STD_LOGIC := '0';
    SIGNAL Clock   : STD_LOGIC := '0';
    SIGNAL Run     : STD_LOGIC := '0';
    SIGNAL Done    : STD_LOGIC;
    SIGNAL BusOut  : STD_LOGIC_VECTOR(8 DOWNTO 0);

    -- Clock period
    CONSTANT clk_period : TIME := 20 ns;

BEGIN

    -- Instantiate the DUT (Device Under Test)
    UUT: project
        PORT MAP (
            DIN     => DIN,
            Resetn  => Resetn,
            Clock   => Clock,
            Run     => Run,
            Done    => Done,
            BusOut  => BusOut
        );

    -- Clock generation
    clk_process : PROCESS
    BEGIN
        WHILE true LOOP
            Clock <= '0';
            WAIT FOR clk_period/2;
            Clock <= '1';
            WAIT FOR clk_period/2;
        END LOOP;
    END PROCESS;

    -- Test sequence
    stim_proc : PROCESS
    BEGIN
        -- Reset
        Resetn <= '0';
        WAIT FOR 40 ns;
        Resetn <= '1';

        -----------------------------------------------------------------
        -- Instruction: mvi r1, #5 → opcode=001, Rx=001, D=000000101
        -----------------------------------------------------------------
        DIN <= "001001101";  -- mvi r1, 5
        Run <= '1';
        WAIT FOR clk_period;
        Run <= '0';

        -- wait until done
        WAIT UNTIL Done = '1';
        WAIT FOR clk_period;

        -----------------------------------------------------------------
        -- Instruction: mvi r2, #2 → opcode=001, Rx=010, D=000000010
        -----------------------------------------------------------------
        DIN <= "001010010";  -- mvi r2, 2
        Run <= '1';
        WAIT FOR clk_period;
        Run <= '0';
        WAIT UNTIL Done = '1';
        WAIT FOR clk_period;

        -----------------------------------------------------------------
        -- Instruction: add r1, r2 → opcode=010, rX=001, rY=010
        -----------------------------------------------------------------
        DIN <= "010001010";  -- add r1, r2
        Run <= '1';
        WAIT FOR clk_period;
        Run <= '0';
        WAIT UNTIL Done = '1';
        WAIT FOR clk_period;

        -----------------------------------------------------------------
        -- Instruction: mv r3, r1 → opcode=000, rX=011, rY=001
        -----------------------------------------------------------------
        DIN <= "000011001";  -- mv r3, r1
        Run <= '1';
        WAIT FOR clk_period;
        Run <= '0';
        WAIT UNTIL Done = '1';
        WAIT FOR clk_period;

        -----------------------------------------------------------------
        -- Instruction: sub r3, r2 → opcode=011, rX=011, rY=010
        -----------------------------------------------------------------
        DIN <= "011011010";  -- sub r3, r2
        Run <= '1';
        WAIT FOR clk_period;
        Run <= '0';
        WAIT UNTIL Done = '1';
        WAIT FOR clk_period;

        -----------------------------------------------------------------
        -- End simulation
        WAIT FOR 200 ns;
        ASSERT FALSE REPORT "End of testbench." SEVERITY NOTE;
        WAIT;
    END PROCESS;

END sim;
