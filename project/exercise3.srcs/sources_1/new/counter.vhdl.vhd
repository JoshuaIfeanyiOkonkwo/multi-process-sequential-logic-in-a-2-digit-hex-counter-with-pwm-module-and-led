library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
    generic (
        div : natural := 1000000  -- divide factor for internal clock divider
    );
    port (
        clk          : in  std_logic;
        arst_n       : in  std_logic;
        enable_in    : in  std_logic;
        load_in      : in  std_logic;
        dir_in       : in  std_logic;  -- 0=up, 1=down
        data_in      : in  std_logic_vector(7 downto 0);
        count_lo_out : out std_logic_vector(3 downto 0);
        count_hi_out : out std_logic_vector(3 downto 0);
        over_out     : out std_logic
    );
end entity;

architecture Behavioral of counter is
    -- Counter state
    signal count      : std_logic_vector(7 downto 0) := (others => '0');
    signal next_count : std_logic_vector(7 downto 0);
    signal over       : std_logic := '0';
    signal next_over  : std_logic := '0';

    -- Clock divider signals
    signal clk_div    : std_logic := '0';
    signal div_cnt    : unsigned(31 downto 0) := (others => '0');
begin

    -- Internal clock divider process
    process(clk, arst_n)
    begin
        if arst_n = '0' then
            div_cnt <= (others => '0');
            clk_div <= '0';
        elsif rising_edge(clk) then
            if div_cnt = to_unsigned(div / 2 - 1, div_cnt'length) then
                div_cnt <= (others => '0');
                clk_div <= not clk_div;
            else
                div_cnt <= div_cnt + 1;
            end if;
        end if;
    end process;

    -- Combinational logic
    process(enable_in, load_in, dir_in, data_in, count)
    begin
        next_count <= count;
        next_over  <= '0';

        if enable_in = '1' then
            if load_in = '1' then
                next_count <= data_in;
           -- elsif enable_in = '1' then
              elsif dir_in = '0' then  -- count up
                    if count = x"FF" then
                        next_over  <= '1';
                        next_count <= x"00";
                        
                    else
                        next_count <= std_logic_vector(unsigned(count) + 1);
                    end if;
                else  -- count down
                    if count = x"00" then
                        next_over  <= '1';
                        next_count <= x"FF";
                    else
                        next_count <= std_logic_vector(unsigned(count) - 1);
                    end if;
                end if;
            end if;
     --   end if;
    end process;

    -- Clocked process using divided clock
    process(clk_div, arst_n)
    begin
        if arst_n = '0' then
            count <= (others => '0');
            over  <= '0';
        elsif rising_edge(clk_div) then
            count <= next_count;
            over  <= next_over;
        end if;
    end process;

    count_lo_out <= std_logic_vector(count(3 downto 0));
    count_hi_out <= std_logic_vector(count(7 downto 4));
    over_out     <= over;
end architecture Behavioral;
