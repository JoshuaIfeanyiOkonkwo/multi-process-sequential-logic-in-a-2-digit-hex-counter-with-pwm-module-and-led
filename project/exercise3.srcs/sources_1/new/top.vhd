library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    port (
        GCLK : in  std_logic;
        SW   : in  std_logic_vector(7 downto 0);  -- switches for data_in
        BTNU : in  std_logic;  -- enable
        BTNL : in  std_logic;  -- load
        BTNR : in  std_logic;  -- reset
        BTND : in  std_logic;  -- direction
        LD0  : out std_logic   -- LED output (PWM)
    );
end entity;

architecture behavioral of top is    
    signal reset_n      : std_logic;
    signal enable_in    : std_logic;
    signal load_in      : std_logic;
    signal dir_in       : std_logic;
    signal data_in      : std_logic_vector(7 downto 0);
    signal count_lo     : std_logic_vector(3 downto 0);
    signal count_hi     : std_logic_vector(3 downto 0);
    signal pwm_duty     : std_logic_vector(7 downto 0);
    signal clk_div      : std_logic;  -- <<< added clock divider signal
begin

    -- Map buttons and switches
    reset_n     <= not BTNR;        -- Active low reset
    load_in     <= BTNL;            -- Load when pressed
    enable_in   <= BTNU;            -- Enable counting when pressed
    dir_in      <= BTND;            -- Direction (0=up, 1=down)
    data_in     <= SW;              -- Switch input data

    -- Clock divider instance
    clkdiv_inst : entity work.clock_divider
        port map (
            clk_in  => GCLK,
            clk_out => clk_div
        );

    -- Counter instance
    u_counter: entity work.counter
        port map (
            clk          => clk_div,       -- slower clock from divider
            arst_n       => reset_n,
            enable_in    => enable_in,
            load_in      => load_in,
            dir_in       => dir_in,
            data_in      => data_in,
            count_lo_out => count_lo,
            count_hi_out => count_hi,
            over_out     => open            -- overflow LED not needed
        );
        
    -- Combine counter outputs for PWM duty cycle
    pwm_duty <= count_hi & count_lo;  -- 8-bit duty cycle

    -- PWM instance
    u_pwm: entity work.pwm
        port map (
            clk     => GCLK,        -- full speed clock for PWM
            dc_in   => pwm_duty,
            pwm_out => LD0
        );

end architecture;
