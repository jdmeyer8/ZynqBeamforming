-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\ZynqBF_2tx_fpga\ZynqBF_2t_ip_src_correlator_i.vhd
-- Created: 2019-02-08 23:33:51
-- 
-- Generated by MATLAB 9.5 and HDL Coder 3.13
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: ZynqBF_2t_ip_src_correlator_i
-- Source Path: ZynqBF_2tx_fpga/channel_estimator/peakdetect_ch1/correlator1/correlator_i
-- Hierarchy Level: 4
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ZynqBF_2t_ip_src_correlator_i IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        rx                                :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        gs                                :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        start                             :   IN    std_logic;
        vin                               :   IN    std_logic;
        dout                              :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
        vout                              :   OUT   std_logic
        );
END ZynqBF_2t_ip_src_correlator_i;


ARCHITECTURE rtl OF ZynqBF_2t_ip_src_correlator_i IS

  -- Signals
  SIGNAL rx_signed                        : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL Switch1_out1                     : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL gs_signed                        : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL Switch2_out1                     : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL mulOutput                        : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL Multiply_Add_out1                : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL Delay1_out1                      : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL Switch_out1                      : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL HDL_Counter_out1                 : unsigned(6 DOWNTO 0);  -- ufix7
  SIGNAL Compare_To_Constant1_out1        : std_logic;
  signal start_d1, vin_d1:                  std_logic;

  ATTRIBUTE use_dsp48 : string;

  ATTRIBUTE use_dsp48 OF mulOutput : SIGNAL IS "yes";

BEGIN
  rx_signed <= signed(rx);

  
  Switch1_out1 <= to_signed(16#0000#, 16) WHEN vin_d1 = '0' ELSE
      rx_signed;

  gs_signed <= signed(gs);

  
  Switch2_out1 <= to_signed(16#0000#, 16) WHEN vin_d1 = '0' ELSE
      gs_signed;

  mulOutput <= Switch1_out1 * Switch2_out1;

  Delay1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay1_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        Delay1_out1 <= Multiply_Add_out1;
      END IF;
    END IF;
  END PROCESS Delay1_process;

  
  input_delay_process: process(clk,reset)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        start_d1 <= '0';
        vin_d1 <= '0';
      elsif enb = '1' then
        start_d1 <= start;
        vin_d1 <= vin;
      end if;
    end if;
  end process;

  
  Switch_out1 <= Delay1_out1 WHEN start = '0' ELSE
      to_signed(0, 32);

  Multiply_Add_out1 <= Switch_out1 + (resize(mulOutput(31 DOWNTO 14), 32));

  dout <= std_logic_vector(Multiply_Add_out1);

  -- Free running, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  HDL_Counter_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        HDL_Counter_out1 <= to_unsigned(16#00#, 7);
      ELSIF enb = '1' THEN
        IF start_d1 = '1' THEN 
          HDL_Counter_out1 <= to_unsigned(16#00#, 7);
        ELSIF vin_d1 = '1' THEN 
          HDL_Counter_out1 <= HDL_Counter_out1 + to_unsigned(16#01#, 7);
        END IF;
      END IF;
    END IF;
  END PROCESS HDL_Counter_process;


  
  Compare_To_Constant1_out1 <= '1' WHEN HDL_Counter_out1 = to_unsigned(16#3F#, 7) ELSE
      '0';

  vout <= Compare_To_Constant1_out1;

END rtl;
