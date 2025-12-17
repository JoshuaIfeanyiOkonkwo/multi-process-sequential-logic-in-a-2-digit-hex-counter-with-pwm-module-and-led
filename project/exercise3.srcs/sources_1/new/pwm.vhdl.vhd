library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm is
    port (
        clk     : in  std_logic;
        dc_in   : in  std_logic_vector(7 downto 0);
        pwm_out : out std_logic
    );
end entity;

architecture Behavioral of pwm is
    signal counter : unsigned(7 downto 0) := (others => '0');
begin

    process(clk)
    begin
        if rising_edge(clk) then
            counter <= counter + 1;
        end if;
    end process;

    pwm_out <= '1' when counter < unsigned(dc_in) else '0';

end architecture;
