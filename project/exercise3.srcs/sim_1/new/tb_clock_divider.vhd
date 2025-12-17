library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_clock_divider is
end tb_clock_divider;

architecture Behavioral of tb_clock_divider is
  signal clk      : std_logic := '0';
 -- signal arst_n   : std_logic := '1'; 
  signal clk_out  : std_logic;
  constant CLKPER : time := 10 ns;
begin
  uut: entity work.clock_divider
    port map (
      clk_in  => clk,
      clk_out => clk_out
    );

  clk_proc: process
  begin
    while now < 500 ns loop
      clk <= '0'; wait for CLKPER/2;
      clk <= '1'; wait for CLKPER/2;
    end loop;
    wait;
  end process;

  stim_proc: process
    variable toggle_count : integer := 0;
    variable last_clk_out : std_logic := '0';
  begin
    for i in 0 to 100 loop
      wait until rising_edge(clk);
      if clk_out /= last_clk_out then
        toggle_count := toggle_count + 1;
        last_clk_out := clk_out;
      end if;
    end loop;

    assert toggle_count > 0
      report "Clock divider failed: no toggles detected"
      severity error;

    wait;
  end process;
end Behavioral;
