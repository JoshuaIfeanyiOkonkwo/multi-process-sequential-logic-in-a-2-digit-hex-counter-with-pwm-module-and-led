library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_tb is
end counter_tb;

architecture Behavioral of counter_tb is
  signal clk        : std_logic := '1';
  signal arst_n     : std_logic := '0';
  signal enable_in  : std_logic := '0';
  signal load_in    : std_logic := '0';
  signal dir_in     : std_logic := '0';
  signal data_in    : std_logic_vector(7 downto 0) := (others => '1');
  signal lo, hi     : std_logic_vector(3 downto 0);
  signal over       : std_logic;
 -- signal count      : std_logic_vector(7 downto 0);
  constant CLKPER   : time := 10 ns;
begin

  uut: entity work.counter
    generic map ( div => 10 )  -- small for simulation
    port map (
      clk          => clk,
      arst_n       => arst_n,
      enable_in    => enable_in,
      load_in      => load_in,
      dir_in       => dir_in,
      data_in      => data_in,
      count_lo_out => lo,
      count_hi_out => hi,
      over_out     => over
    );

  clk_proc: process
  begin
    while now < 200000 ns loop
      clk <= '0'; wait for CLKPER / 2;
      clk <= '1'; wait for CLKPER / 2;
    end loop;
    wait;
  end process;

  stim: process
  --Q and Q_data the value of count and data
    variable Q       : std_logic_vector(7 downto 0);
    variable Q_data  : std_logic_vector(7 downto 0);
  begin
    -- Reset
    arst_n <= '0'; wait for 100 ns;
    arst_n <= '1'; wait for 100 ns;
    assert (hi & lo = x"00" and over = '0') report "Reset failed" severity error;

    -- Hold (enable = 0)
    Q := hi & lo;
    enable_in <= '0'; 
    wait for 100 ns;
    assert (hi & lo = Q and over = '0') report "Hold failed" severity error;

    -- Count up
    enable_in <= '1'; 
    dir_in <= '0'; 
    load_in <= '0'; 
    wait for 100 ns;
    assert (hi & lo = std_logic_vector(unsigned(Q) + 1) and over = '0') report "Count up failed" severity error;

    -- Count down
    Q := hi & lo;
    enable_in <= '1';
    dir_in <= '1'; 
    load_in <= '0'; 
    wait for 100 ns;
    assert (hi & lo = std_logic_vector(unsigned(Q) - 1) and over = '0') report "Count down failed" severity error;

    -- Overflow test (FF → 00)
    data_in <= x"FF"; 
    load_in <= '1'; 
    wait for 100 ns;
    load_in <= '0'; 
    dir_in <= '0'; 
    wait for 100 ns;
    assert (hi & lo = x"00" and over = '1') report "Overflow failed" severity error;

    -- Underflow test (00 → FF)
    data_in <= x"00"; load_in <= '1'; wait for 100 ns;
    load_in <= '0'; dir_in <= '1'; wait for 100 ns;
    assert (hi & lo = x"FF" and over = '1') report "Underflow failed" severity error;

    -- Load Q_data
    Q_data := x"3C";
    data_in <= Q_data; load_in <= '1'; wait for 100 ns;
    load_in <= '0'; wait for 100 ns;
    assert (hi & lo = Q_data and over = '0') report "Load Q_data failed" severity error;

    wait;
  end process;

end Behavioral;
