library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- 2 to 4 decoder with enable
entity decoder2to4 is
    Port (
        en  : in  STD_LOGIC;
        A   : in  STD_LOGIC_VECTOR(1 downto 0);
        Y   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end decoder2to4;

architecture Behavioral of decoder2to4 is
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

-- 3 to 8 decoder using 2 to 4 decoders
entity decoder3to8 is
    Port (
        A : in  STD_LOGIC_VECTOR(2 downto 0);
        Y : out STD_LOGIC_VECTOR(7 downto 0)
    );
end decoder3to8;

architecture Structural of decoder3to8 is
    signal Y0, Y1 : STD_LOGIC_VECTOR(3 downto 0);
begin
    -- Lower 2:4 decoder (enabled when A(2) = '0')
    DEC0: entity work.decoder2to4
        port map (
            en => not A(2),
            A  => A(1 downto 0),
            Y  => Y0
        );

    -- Upper 2:4 decoder (enabled when A(2) = '1')
    DEC1: entity work.decoder2to4
        port map (
            en => A(2),
            A  => A(1 downto 0),
            Y  => Y1
        );

    -- Combine outputs
    Y <= Y1 & Y0;
end Structural;
