----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/02/2019 02:14:07 PM
-- Design Name: 
-- Module Name: ZynqBF_2tx_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ZynqBF_2tx_tb is
end ZynqBF_2tx_tb;

architecture Behavioral of ZynqBF_2tx_tb is

component ZynqBF_2t_ip_src_ZynqBF_2tx_fpga
port(
    clk:            in std_logic;
    clk200:         in std_logic;
    reset:          in std_logic;
    reset200:       in std_logic;
    clk_enable:     in std_logic;
    rx_i_in:        in std_logic_vector(15 downto 0);
    rx_q_in:        in std_logic_vector(15 downto 0);
    rx_v_in:        in std_logic;
    ce_out_0:       out std_logic;
    ce_out_1:       out std_logic;
    rx_i_out:       out std_logic_vector(15 downto 0);
    rx_q_out:       out std_logic_vector(15 downto 0);
    rx_v_out:       out std_logic;
    ch1_i:          out std_logic_vector(31 downto 0);
    ch1_q:          out std_logic_vector(31 downto 0);
    ch2_i:          out std_logic_vector(31 downto 0);
    ch2_q:          out std_logic_vector(31 downto 0);
    ch3_i:          out std_logic_vector(31 downto 0);
    ch3_q:          out std_logic_vector(31 downto 0);
    ch4_i:          out std_logic_vector(31 downto 0);
    ch4_q:          out std_logic_vector(31 downto 0);
    ch5_i:          out std_logic_vector(31 downto 0);
    ch5_q:          out std_logic_vector(31 downto 0);
    probe:          out std_logic_vector(14 downto 0);
    probe_xcorr1:   out std_logic_vector(31 downto 0);        -- correlator for ch1
    probe_xcorr2:   out std_logic_vector(31 downto 0);        -- correlator for ch2
    probe_state:    out std_logic_vector( 7 downto 0);        -- peak detect/channel estimate state
    probe_ch1i:     out std_logic_vector(31 downto 0);        -- ch1_i numerator
    probe_ch1q:     out std_logic_vector(31 downto 0);        -- ch1_q numerator
    probe_ch1r:     out std_logic_vector(31 downto 0)         -- ch1 denom. reciprocal
);
end component;

signal clk:             std_logic := '1';   -- 420 kHz clock
signal clk200:          std_logic := '1';   -- 200 MHz clock
signal reset:           std_logic := '1';
signal reset200:        std_logic := '1';

signal rx_i_in:         std_logic_vector(15 downto 0);
signal rx_q_in:         std_logic_vector(15 downto 0);
signal rx_v_in:         std_logic;

signal ce_out_0:        std_logic;
signal ce_out_1:        std_logic;

signal rx_i_out:        std_logic_vector(15 downto 0);
signal rx_q_out:        std_logic_vector(15 downto 0);
signal rx_v_out:        std_logic;

signal ch1_i:           std_logic_vector(31 downto 0);
signal ch1_q:           std_logic_vector(31 downto 0);
signal ch2_i:           std_logic_vector(31 downto 0);
signal ch2_q:           std_logic_vector(31 downto 0);
signal ch3_i:           std_logic_vector(31 downto 0);
signal ch3_q:           std_logic_vector(31 downto 0);
signal ch4_i:           std_logic_vector(31 downto 0);
signal ch4_q:           std_logic_vector(31 downto 0);
signal ch5_i:           std_logic_vector(31 downto 0);
signal ch5_q:           std_logic_vector(31 downto 0);
signal probe:           std_logic_vector(14 downto 0);

signal probe_xcorr1:    std_logic_vector(31 downto 0);
signal probe_xcorr2:    std_logic_vector(31 downto 0);
signal probe_state:     std_logic_vector( 7 downto 0);
signal probe_ch1i:      std_logic_vector(31 downto 0);
signal probe_ch1q:      std_logic_vector(31 downto 0);
signal probe_ch1r:      std_logic_vector(31 downto 0);


begin

-- clocks for 400 kHz radio sample rate and 200 MHz processing rate
-- 1/400 kHz = 2500 ns
-- clk <= not clk after 1250 ns;
clk <= not clk after 926 ns;            -- 0.5*1/540 kHz
clk200 <= not clk200 after 5 ns;        -- 1/100 MHz
-- clk200 <= not clk200 after 2.5 ns;

-- reset for 200 ns
reset <= '1', '0' after 20 us;
reset200 <= '1', '0' after 20 us;

rx_in_proc: process(reset, clk)
    file file_rxi:      text;
    file file_rxq:      text;
    variable line_rxi:  line;
    variable line_rxq:  line;
    variable rxi:       std_logic_vector(15 downto 0);
    variable rxq:       std_logic_vector(15 downto 0);
begin
    if reset = '1' then
            file_open(file_rxi, "rx_test_i.txt", read_mode);
            file_open(file_rxq, "rx_test_q.txt", read_mode);
            rx_i_in <= x"0000";
            rx_q_in <= x"0000";
    elsif clk'event and clk = '1' then
        if (not endfile(file_rxi) and not endfile(file_rxq)) then
            readline(file_rxi, line_rxi);
            readline(file_rxq, line_rxq);
            read(line_rxi, rxi);
            read(line_rxq, rxq);
            rx_i_in <= rxi;
            rx_q_in <= rxq;
        else
            rx_i_in <= rx_i_in;
            rx_q_in <= rx_q_in;
        end if;
    end if;
end process;

rx_v_in <= '1';

-- results_file_proc: process(reset,clk200)
   -- file rfile:         text;
   -- variable rline:     line;
-- begin
   -- if reset = '1' then
       -- file_open(rfile, "sim_results.txt", write_mode);
   -- elsif rising_edge(clk200) then
       -- write(rline,conv_integer(probe_xcorr1),right,10);
       -- write(rline,string'(", "));
       -- write(rline,conv_integer(probe_xcorr2),right,10);
       -- write(rline,string'(", "));
       -- write(rline,conv_integer(probe_state),right,10);
       -- write(rline,string'(", "));
       -- write(rline,conv_integer(ch1_i),right,10);
       -- write(rline,string'(", "));
       -- write(rline,conv_integer(ch1_q),right,10);
       -- write(rline,string'(", "));
       -- write(rline,conv_integer(ch2_i),right,10);
       -- write(rline,string'(", "));
       -- write(rline,conv_integer(ch2_q),right,10);
       -- writeline(rfile, rline);
   -- end if;
-- end process;
    


dut: ZynqBF_2t_ip_src_ZynqBF_2tx_fpga
port map(
    clk => clk,
    clk200 => clk200,
    reset => reset,
    reset200 => reset200,
    clk_enable => '1',
    rx_i_in => rx_i_in,
    rx_q_in => rx_q_in,
    rx_v_in => rx_v_in,
    ce_out_0 => ce_out_0,
    ce_out_1 => ce_out_1,
    rx_i_out => rx_i_out,
    rx_q_out => rx_q_out,
    rx_v_out => rx_v_out,
    ch1_i => ch1_i,
    ch1_q => ch1_q,
    ch2_i => ch2_i,
    ch2_q => ch2_q,
    ch3_i => ch3_i,
    ch3_q => ch3_q,
    ch4_i => ch4_i,
    ch4_q => ch4_q,
    ch5_i => ch5_i,
    ch5_q => ch5_q,
    probe => probe,
    probe_xcorr1 => probe_xcorr1,
    probe_xcorr2 => probe_xcorr2,
    probe_state => probe_state,
    probe_ch1i => probe_ch1i,
    probe_ch1q => probe_ch1q,
    probe_ch1r => probe_ch1r
);

end Behavioral;
