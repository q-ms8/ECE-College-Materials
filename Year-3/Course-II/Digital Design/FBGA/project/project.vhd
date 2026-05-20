LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;   --unsinged not singed 
 
ENTITY project IS
	PORT (  DIN						: IN STD_LOGIC_VECTOR(8 DOWNTO 0);  -- 9 bits
			Resetn, Clock, Run   : IN STD_LOGIC;
			Done						: BUFFER STD_LOGIC;
			BusOut : OUT STD_LOGIC_VECTOR(8 DOWNTO 0));
END project;
 
ARCHITECTURE Behavior OF project IS
	
	component dec3to8				-- 3x8 decoder to select which reg. has to be enabeled 
		port( E	: in std_logic;
				W	: in std_logic_vector(2 downto 0);
				Y	: out std_logic_vector(0 to 7));
	end component;
	
	component regn					-- multi use 9 bits reg. 
		generic (n	: integer :=9);
		port( R 							: in std_logic_vector(n-1 downto 0);
			   Resetn, Rin, Clock   : in std_logic;
			   Q							: out std_logic_vector(n-1 downto 0));
	end component;
	
	TYPE State_type IS (T0, T1, T2, T3);
   SIGNAL Tstep_Q, Tstep_D: State_type;
	SIGNAL Rin : STD_LOGIC_VECTOR(0 TO 7); -- r0, ..., r7 register enables
   SIGNAL rXin, IRin, Ain, Gin, AddSub : STD_LOGIC;   --rxin enable for decoder 
	
	SIGNAL Sel : STD_LOGIC_VECTOR(3 DOWNTO 0); -- bus selector

	SIGNAL III, rX, rY : STD_LOGIC_VECTOR(2 DOWNTO 0);

	SIGNAL r0, r1, r2, r3, r4, r5, r6, r7, A : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL G : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL Sum : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL IR, BusWires : STD_LOGIC_VECTOR(8 DOWNTO 0);


--	CONSTANT mv : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
--	CONSTANT mvi : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
--	CONSTANT add : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
--	CONSTANT sub : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";

	-- selectors for the BusWires multiplexer	
	CONSTANT SEL_R0           : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	CONSTANT SEL_R1           : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
	CONSTANT SEL_R2           : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
	CONSTANT SEL_R3           : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
	CONSTANT SEL_R4           : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
	CONSTANT SEL_R5           : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
	CONSTANT SEL_R6           : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110";
	CONSTANT SEL_R7           : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111";
	CONSTANT SEL_G            : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000";  -- G register

	
	CONSTANT SEL_SIGN_EXT	  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1001";  -- sign-extended #D 
--	CONSTANT SEL_SHIFT_IR7_0  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1010";  -- IR(7:0) << 1 or << 8
 
 

BEGIN
	III <= IR(8 DOWNTO 6);             -- 3-bit opcode
--	Imm <= IR(5);                      -- immediate flag (if you're using one)
	rX <= IR(5 DOWNTO 3);              -- destination register
	rY <= IR(2 DOWNTO 0);              -- source register
	decX: dec3to8 PORT MAP (rXin, rX, Rin);  -- decode rX to enable a register from r0 to r7

	
	 statetable: PROCESS(Tstep_Q, Run, Done)
    BEGIN
        CASE Tstep_Q IS
            WHEN T0 =>    -- data is loaded into IR in this time step
                IF Run = '0' THEN Tstep_D <= T0;
                ELSE Tstep_D <= T1;
                END IF;
            WHEN T1 =>   -- some instructions end after this time step   
                IF Done = '1' THEN Tstep_D <= T0;
                ELSE Tstep_D <= T2;
                END IF;
            WHEN T2 =>   -- always go to T3 after this
                Tstep_D <= T3;
            WHEN T3 =>   -- instructions end after this time step   
                Tstep_D <= T0;
        END CASE;
    END PROCESS;	 
	 
	 
--	III	Instruction		Format			Operation				Description
-- ---   -----------    ------         ---------           ------------
-- 000	mv					mv Rx,Ry			Rx ← [Ry]				Register-to-register move
-- 001	mvi				mvi Rx,#D		Rx ← D (next cycle)	Load immediate (D comes on DIN next cycle)
-- 010	add				add Rx,Ry		Rx ← [Rx] + [Ry]		Register addition
-- 011	sub				sub Rx,Ry		Rx ← [Rx] - [Ry]		Register subtraction

	controlsignals: PROCESS (Tstep_Q, III, rX, rY)
		BEGIN
			 -- Default values for all control signals
			 IRin   <= '0';
			 rXin   <= '0';
			 Ain    <= '0';
			 Gin    <= '0';
			 AddSub <= '0';
			 Done   <= '0';

			 Sel    <= (others => '0');

			 CASE Tstep_Q IS

				  -- T0: Fetch instruction into IR
				  WHEN T0 =>
						IRin <= '1';

				  -- T1: Decode and perform first operation
				  WHEN T1 =>
						CASE III IS
							 WHEN "000" =>  -- mv Rx, Ry
								  Sel <= '0' & rY;
								  rXin  <= '1';

							 WHEN "001" =>  -- mvi Rx, #D
								  Sel   <= SEL_SIGN_EXT;
								  rXin  <= '1';

							 WHEN "010" | "011" =>  -- add or sub
								  Sel   <= '0' & rX;
								  Ain   <= '1';

							 WHEN OTHERS => NULL;
						END CASE;

				  -- T2: Second step for add or sub
				  WHEN T2 =>
						CASE III IS
							 WHEN "010" =>  -- add Rx, Ry
								  Sel <= '0' & rY;
								  Gin  <= '1';

							 WHEN "011" =>  -- sub Rx, Ry
								  Sel <= '0' & rY;
								  Gin    <= '1';
								  AddSub <= '1';

							 WHEN OTHERS => NULL;
						END CASE;

				  -- T3: Store result into Rx and signal Done
				  WHEN T3 =>
						CASE III IS
							 WHEN "010" | "011" =>  -- add or sub
								  Sel   <= SEL_G;
								  rXin  <= '1';
								  Done  <= '1';

							 WHEN "000" | "001" =>  -- mv or mvi
								  Done  <= '1';

							 WHEN OTHERS => NULL;
						END CASE;

			 END CASE;
		END PROCESS;

	
	
	
    fsmflipflops: PROCESS (Clock, Resetn, Tstep_D)
    BEGIN
        IF (Resetn = '0') THEN
            Tstep_Q <= T0;
        ELSIF (rising_edge(Clock)) THEN
            Tstep_Q <= Tstep_D;
        END IF;
    END PROCESS;     
   
	

	


	reg_0:  regn PORT MAP (BusWires, Resetn, Rin(0), Clock, r0);
	reg_1:  regn PORT MAP (BusWires, Resetn, Rin(1), Clock, r1);
	reg_2:  regn PORT MAP (BusWires, Resetn, Rin(2), Clock, r2);
	reg_3:  regn PORT MAP (BusWires, Resetn, Rin(3), Clock, r3);
	reg_4:  regn PORT MAP (BusWires, Resetn, Rin(4), Clock, r4);
	reg_5:  regn PORT MAP (BusWires, Resetn, Rin(5), Clock, r5);
	reg_6:  regn PORT MAP (BusWires, Resetn, Rin(6), Clock, r6);
	reg_7:  regn PORT MAP (BusWires, Resetn, Rin(7), Clock, r7);

	reg_A:  regn PORT MAP (BusWires, Resetn, Ain, Clock, A);
	reg_IR: regn PORT MAP (DIN, Resetn, IRin, Clock, IR);

	reg_G: regn PORT MAP (Sum, Resetn, Gin, Clock, G);


	
	
	ALU: PROCESS (AddSub, A, BusWires) -- arithmitec logic unit
    BEGIN
        IF AddSub = '0' THEN
            Sum <= A + BusWires;
        ELSE
            Sum <= A - BusWires;
        END IF;
    END PROCESS;
	

	
   busmux: PROCESS (Sel, r0, r1, r2, r3, r4, r5, r6, r7, G, DIN)
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
            WHEN SEL_G =>  BusWires <= G;
				
				
            WHEN SEL_SIGN_EXT => BusWires <= DIN;
				
				
            WHEN OTHERS => BusWires <= (OTHERS => '0');
        END CASE;
    END PROCESS;   
	 
	 BusOut <= BusWires;
	 
--	 
--	    BUSWIRES: PROCESS (Sel, r0, r1, r2, r3, r4, r5, r6, r7, G, DIN)
--    BEGIN
--        CASE Sel IS
--            WHEN S_R0 => BusWires <= r0;
--            WHEN S_R1 => BusWires <= r1;
--            WHEN S_R2 => BusWires <= r2;
--            WHEN S_R3 => BusWires <= r3;
--            WHEN S_R4 => BusWires <= r4;
--            WHEN S_R5 => BusWires <= r5;
--            WHEN S_R6 => BusWires <= r6;
--            WHEN S_R7 => BusWires <= r7;
--            WHEN S_G =>  BusWires <= G;
--				
--				
--            WHEN S_D# => BusWires <= DIN; ---notes here****
--				
--				
--				
--            WHEN OTHERS => BusWires <= (OTHERS => '0');
--        END CASE;
--    END PROCESS;   
--	 
END Behavior;
	 
	 
	 
	 

--LIBRARY ieee;
--USE ieee.std_logic_1164.all;
--
--ENTITY dec3to8 IS
--    PORT ( E   : IN   STD_LOGIC;
--           W   : IN   STD_LOGIC_VECTOR(2 DOWNTO 0);
--           Y   : OUT  STD_LOGIC_VECTOR(0 TO 7));
--END dec3to8;
--
--ARCHITECTURE Behavior OF dec3to8 IS
--BEGIN
--    PROCESS (E, W)
--    BEGIN
--        IF E = '0'THEN
--            Y <= "00000000";
--        ELSE
--            CASE W IS
--                WHEN "000" => Y <= "10000000";
--                WHEN "001" => Y <= "01000000";
--                WHEN "010" => Y <= "00100000";
--                WHEN "011" => Y <= "00010000";
--                WHEN "100" => Y <= "00001000";
--                WHEN "101" => Y <= "00000100";
--                WHEN "110" => Y <= "00000010";
--                WHEN "111" => Y <= "00000001";
--                WHEN OTHERS => Y <= "00000000";
--            END CASE;
--        END IF;
--    END PROCESS;
--END Behavior;



--LIBRARY ieee;
--USE ieee.std_logic_1164.all;
--
--ENTITY regn IS
--    GENERIC ( n : INTEGER := 9);
--    PORT ( R                   : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--           Resetn, Rin, Clock  : IN  STD_LOGIC;
--           Q                   : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
--END regn;
--ARCHITECTURE Behavior OF regn IS
--BEGIN
--    PROCESS (Clock)
--    BEGIN
--        IF Clock'EVENT AND Clock = '1' THEN
--            IF Resetn = '0' THEN
--                Q <= (OTHERS => '0');
--            ELSIF Rin = '1' THEN
--                Q <= R;
--            END IF;
--        END IF;
--    END PROCESS;
--END Behavior;



-- ------- this code is from the lab9 file
-- BEGIN
--		High <= ’1’;
--		I <=IR(1 TO 3);
--		decX: dec3to8 PORT MAP (IR(4 TO 6), High, Xreg);
--		decY: dec3to8 PORT MAP (IR(7 TO 9), High, Yreg);
-- 
--		statetable: PROCESS (Tstep_Q, Run, Done)
--		
--		
--			BEGIN
--				 CASE Tstep_Q IS
--				 WHEN T0 =>
--				 IF(Run=’0’) THEN Tstep_D <= T0;
--				 ELSE Tstep_D <= T1;
--				 END IF;-- data is loaded into IR in this time step
--				 other states
--				 END CASE;
--				 END PROCESS;
--				 
--				 
--				 
--				 controlsignals: PROCESS (Tstep_Q, I, Xreg, Yreg)
--				 BEGIN
--				 specify initial values
--				 CASE Tstep_Q IS
--				 WHEN T0=>--store DIN in IR as long as Tstep_Q = 0
--				 IRin <= ’1’;
--				 WHENT1=>--define signals in time step T1
--				 CASE IIS
--				 END CASE;
--				 WHENT2=>--define signals in time step T2
--				 CASE IIS
--				 END CASE;
--				 WHENT3=>--define signals in time step T3
--				 CASE IIS
--				 
--				 END CASE;
--				 END CASE;
--			END PROCESS;
--			
--				 fsmflipflops: PROCESS (Clock, Resetn, Tstep_D)
--				 BEGIN
--				 END PROCESS;
--				 reg_0: regn PORT MAP (BusWires, Rin(0), Clock, R0);
--				 instantiate other registers and the adder/subtractor unit
--				 define the bus
--				 END Behavior;
--				 