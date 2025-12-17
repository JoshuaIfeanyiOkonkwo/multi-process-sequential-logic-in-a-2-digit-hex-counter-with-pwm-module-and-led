library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_tb is
end pwm_tb;

architecture tb of pwm_tb is
  signal clk : std_logic := '0';
  signal dc  : std_logic_vector(7 downto 0) := x"00";
  signal pwm_out : std_logic;
  constant CLKPER : time := 10 ns; -- 100 MHz
begin
  -- instantiate pwm
  uut: entity work.pwm
    port map (clk => clk, dc_in => dc, pwm_out => pwm_out);

  -- clock
  clk_proc: process
  begin
    while now < 2000 ns loop
      clk <= '0'; wait for CLKPER/2;
      clk <= '1'; wait for CLKPER/2;
    end loop;
    wait;
  end process;

  stim: process
    variable count_high: integer;
    variable samples: integer;
  begin
    -- test dc = 0
    dc <= x"00";
    wait for 256 * CLKPER; -- one PWM period sample
    -- collect some samples
    count_high := 0; samples := 512;
    for i in 1 to samples loop
      if pwm_out = '1' then
        count_high := count_high + 1;
      end if;
      wait for CLKPER;
    end loop;
    assert (count_high = 0) report "PWM duty 0 failed" severity warning;

    -- test dc = 128 (~50%)
    dc <= x"80";
    wait for 256 * CLKPER;
    count_high := 0;
    for i in 1 to samples loop
      if pwm_out = '1' then
        count_high := count_high + 1;
      end if;
      wait for CLKPER;
    end loop;
    assert (count_high > samples/4 and count_high < 3*samples/4) report "PWM duty ~50% unexpected" severity warning;

    -- test dc = 255 (~100%)
    dc <= x"FF";
    wait for 256 * CLKPER;
    count_high := 0;
    for i in 1 to samples loop
      if pwm_out = '1' then
        count_high := count_high + 1;
      end if;
      wait for CLKPER;
    end loop;
    assert (count_high > samples*9/10) report "PWM duty ~100% unexpected" severity warning;

    wait;
  end process;
end tb;
