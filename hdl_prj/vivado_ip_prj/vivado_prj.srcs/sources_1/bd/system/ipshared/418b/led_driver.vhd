-- ----------------------------------------------
-- file name: led_driver.vhd
-- created:   23-apr-2013 15:26:53
-- copyright  2013 mathworks, inc.
-- ----------------------------------------------

library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity led_driver is 
generic 
(
    cntwidth   : integer := 32;
    cnt_significant_bit  : integer := 26
);

port
(
    clk_ps7 : in  std_logic;
    clk_rf  : in  std_logic;
    rst     : in  std_logic;
    led     : out std_logic
);
end led_driver;

architecture rtl of led_driver is

  signal cnt_tmp            : unsigned(cntwidth - 1 downto 0); 
  signal led_int            : std_logic;
  signal enb                : std_logic;
  signal clk_rf_by_2        : std_logic;
  signal rf_clk_sync1       : std_logic;
  signal rf_clk_sync2       : std_logic;
  signal rf_clk_sync3       : std_logic;
  signal counter_rst        : std_logic;
  signal watchdog_counter   : unsigned(cntwidth - 1 downto 0);

begin

-- Process to blink LED at ~1Hz, cnt_tmp(26), clk_ps7=100MHZ
process(clk_ps7,rst)
begin 
  if (rst = '1') then
     cnt_tmp <= (others => '0');
     led_int <= '0';
  elsif clk_ps7'event and clk_ps7 = '1' then
    if cnt_tmp(cnt_significant_bit) = '1' then 
        cnt_tmp <= (others=>'0');
        led_int <= not(led_int);
    else
        cnt_tmp <= cnt_tmp + to_unsigned(1,cntwidth);
    end if;
  end if;
end process;

led <= led_int when enb='1' else '0';

-- clk_ps7 is assumed to always be faster than RF clock rate
-- clk_ps7 is fixed at 100MHZ
-- clk_rf variable from 500kHz up to 61.44MHz
-- Half RF clock to ensure correct sampling of RF clock even at higher rates
process(clk_rf, rst)
begin
    if (rst='1') then 
        clk_rf_by_2 <= '0';
    elsif clk_rf'event and clk_rf='1' then
        clk_rf_by_2 <= not(clk_rf_by_2);
    end if;
end process;


-- Register RF clock in PS7_CLK domain
process(clk_ps7, rst, clk_rf_by_2)
begin
    if (rst='1') then
        rf_clk_sync1 <= '0';
        rf_clk_sync2 <= '0';
        rf_clk_sync3 <= '0';
    elsif clk_ps7'event and clk_ps7 = '1' then
        rf_clk_sync1 <= clk_rf_by_2;
        rf_clk_sync2 <= rf_clk_sync1;
        rf_clk_sync3 <= rf_clk_sync2;
    end if;
end process;

-- Edged detect the registered clocks
counter_rst <= rf_clk_sync2 xor rf_clk_sync3;

-- Watchdog downcounter
process(clk_ps7,rst, counter_rst)
begin
    if (rst='1') then 
        watchdog_counter <= (others=>'0');
        enb <= '0';
    elsif clk_ps7'event and clk_ps7 = '1' then
        if counter_rst='1' then
            watchdog_counter <= (others=>'1');
            enb <= '1';
        elsif watchdog_counter = to_unsigned(0,cntwidth) then
            enb <= '0';
        else
            watchdog_counter <= watchdog_counter - to_unsigned(1,cntwidth);
        end if;
    end if;
end process;

end;