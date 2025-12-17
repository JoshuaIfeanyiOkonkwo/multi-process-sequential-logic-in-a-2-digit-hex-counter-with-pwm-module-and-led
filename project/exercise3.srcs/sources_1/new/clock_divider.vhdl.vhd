library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    port (
        clk_in  : in  std_logic;
        clk_out : out std_logic
    );
end entity;

architecture behavioral of clock_divider is
    constant DIVISOR : integer := 1000000;  -- ~1 kHz from 100 MHz
    signal counter : integer range 0 to DIVISOR - 1 := 0;
    signal clk_div : std_logic := '0';
begin
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            if counter = DIVISOR - 1 then
                counter <= 0;
                clk_div <= not clk_div;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    clk_out <= clk_div;
end architecture;
