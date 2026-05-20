LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY tb_project IS
END tb_project;

ARCHITECTURE behavior OF tb_project IS

    -- Component Under Test
    COMPONENT project
        PORT (
            DIN     : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
            Resetn  : IN  STD_LOGIC;
            Clock   : IN  STD_LOGIC;
            Run     : IN  STD_LOGIC;
            Done    : BUFFER STD_LOGIC;
            BusOut  : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals for simulation
    SIGNAL DIN     : STD_LOGIC_VECTOR(8 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Resetn  : STD_LOGIC := '0';
    SIGNAL Clock   : STD_LOGIC := '0';
    SIGNAL Run     : STD_LOGIC := '0';
    SIGNAL Done    : STD_LOGIC;
    SIGNAL BusOut  : STD_LOGIC_VECTOR(8 DOWNTO 0);

    -- Clock generation (period = 20ns)
    CONSTANT clk_period : TIME := 20 ns;

BEGIN

    -- Instantiate the Unit Under Test
    uut: project PORT MAP (
        DIN     => DIN,
        Resetn  => Resetn,
        Clock   => Clock,
        Run     => Run,
        Done    => Done,
        BusOut  => BusOut
    );

    -- Clock process
    clk_process : PROCESS
    BEGIN
        Clock <= '0';
        WAIT FOR clk_period/2;
        Clock <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    -- Stimulus process
    stim_proc: PROCESS
    BEGIN
        -- Initial reset
        WAIT FOR 10 ns;
        Resetn <= '0';
        WAIT FOR 40 ns;
        Resetn <= '1';

        -- === Test 1: mvi r1, #5 (assume #5 = 000000101) ===
        DIN <= "001001001"; -- opcode=001, rX=001 (r1), #D=001
        Run <= '1';
        WAIT FOR clk_period;
        Run <= '0';

        -- Second cycle for mvi to load the constant
        DIN <= "000000101"; -- #D = 000000101
        WAIT FOR clk_period*4;

        -- === Test 2: mvi r2, #3 ===
        DIN <= "001010010"; -- opcode=001, rX=010 (r2)
        Run <= '1';
        WAIT FOR clk_period;
        Run <= '0';

        DIN <= "000000011"; -- #D = 3
        WAIT FOR clk_period*4;

        -- === Test 3: add r3, r1 + r2 ===
        DIN <= "010011001"; -- opcode=010, rX=011 (r3), rY=001 (r1)
        Run <= '1';
        WAIT FOR clk_period;
        Run <= '0';
        WAIT FOR clk_period*4;

        -- Stop simulation
        WAIT FOR 50 ns;
        ASSERT FALSE REPORT "Simulation completed" SEVERITY FAILURE;
    END PROCESS;

END behavior;
