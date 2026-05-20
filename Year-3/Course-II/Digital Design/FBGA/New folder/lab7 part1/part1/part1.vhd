

library ieee;
use ieee.std_logic_1164.all;

entity part1 is

	port(
		--clk		 : in	std_logic;  --KEY0
		KEY	 : in	std_logic_vector(0 downto 0);     --SW0
		--input	 : in	std_logic;		--SW1 (W)
		SW : in std_logic_vector (1 downto 0);
		--output	 : out	std_logic;
		LEDR : out std_logic_vector(9 downto 0)
	);

end entity;

architecture rtl of part1 is


	-- Build an enumerated type for the state machine
	type state_type is (A, B, C, D, E, F, G, H, I);

	-- Register to hold the current state
	signal current_state, next_state : state_type;
	
begin


	-- Logic to advance to the next state
	process(KEY(0))
	begin
	if(rising_edge(KEY(0))) then
		if SW(0) = '1' then 
		current_state <= A;
		else current_state <= next_state;
		end if;
	end if;
	end process;
	
	process (current_state, SW(1))
	begin
			case current_state is
				when A=>
					if  SW(1)= '1' then
						next_state <= F;
					else
						next_state <= B;
					end if;
				when B=>
					if  SW(1)= '1' then
						next_state <= F;
					else
						next_state <= C;
					end if;		
				when C=>	
					if  SW(1)= '1' then
						next_state <= F;
					else
						next_state <= D;
					end if;		
				when D=>
					if  SW(1)= '1' then
						next_state <= F;
					else
						next_state <= E;
					end if;
				when E=>
					if SW(1) = '1' then
						next_state <= F;
					else
						next_state <= E;
					end if;
					
				when F=>
					if  SW(1)= '1' then
						next_state <= G;
					else
						next_state <= B;
					end if;
				when G=>
					if  SW(1)= '1' then
						next_state <= H;
					else
						next_state <= B;
					end if;		
				when H=>	
					if  SW(1)= '1' then
						next_state <= I;
					else
						next_state <= B;
					end if;		
				when I=>
					if  SW(1)= '1' then
						next_state <= I;
					else
						next_state <= B;
					end if;
			end case;
	end process;

	-- Output depends solely on the current state
	process (current_state)
	begin
		case current_state is
			when A =>
				LEDR(0) <= '1';
			when B =>
				LEDR(1) <= '1';
			when C =>
				LEDR(2) <= '1';
			when D =>
				LEDR(3) <= '1';
		   when E =>
				LEDR(4) <= '1';
				LEDR(9) <= '1';  --NOTE OUTPUT Z

			when F =>
				LEDR(5) <= '1';
			when G =>
				LEDR(6) <= '1';
			when H =>
				LEDR(7) <= '1';
			when I =>
				LEDR(8) <= '1';
				LEDR(9) <= '1';   --NOTE OUTPUT Z

		end case;
	end process;

end rtl;
