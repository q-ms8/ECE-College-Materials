library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- 2 to 4 decoder with enable
entity decoder is
    Port (
        en  : in  STD_LOGIC;
        A   : in  STD_LOGIC_VECTOR(1 downto 0);
        Y   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end decoder;

architecture Behavioral of decoder is
begin
    process(en, A)
    begin
        if en = '1' then
            case A is
                when "00" => Y <= "0001";
                when "01" => Y <= "0010";
                when "10" => Y <= "0100";
                when "11" => Y <= "1000";
                when others => Y <= "0000";
            end case;
        else
            Y <= "0000";
        end if;
    end process;
end Behavioral;
