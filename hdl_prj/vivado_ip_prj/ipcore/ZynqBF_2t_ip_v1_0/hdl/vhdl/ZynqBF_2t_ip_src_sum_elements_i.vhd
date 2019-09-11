-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\ZynqBF_2tx_fpga\ZynqBF_2t_ip_src_sum_elements_i.vhd
-- Created: 2019-02-08 23:33:51
-- 
-- Generated by MATLAB 9.5 and HDL Coder 3.13
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: ZynqBF_2t_ip_src_sum_elements_i
-- Source Path: ZynqBF_2tx_fpga/channel_estimator/peakdetect_ch1/correlator1/sum_elements_i
-- Hierarchy Level: 4
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ZynqBF_2t_ip_src_ZynqBF_2tx_fpga_pkg.ALL;

ENTITY ZynqBF_2t_ip_src_sum_elements_i IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        din                               :   IN    vector_of_std_logic_vector32(0 TO 7);  -- sfix32_En16 [8]
        start                             :   IN    std_logic;
        dout                              :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
        vout                              :   OUT   std_logic
        );
END ZynqBF_2t_ip_src_sum_elements_i;


ARCHITECTURE rtl OF ZynqBF_2t_ip_src_sum_elements_i IS

  -- Signals
  SIGNAL Compare_To_Constant2_out1        : std_logic;
  SIGNAL HDL_Counter_out1                 : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL Compare_To_Constant1_out1        : std_logic;
  SIGNAL Logical_Operator_out1            : std_logic;
  SIGNAL HDL_Counter1_out1                : std_logic;  -- ufix1
  SIGNAL Constant1_out1_dtc               : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL Data_Type_Conversion_out1        : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL din_0                            : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL din_1                            : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL din_2                            : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL din_3                            : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL din_4                            : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL din_5                            : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL din_6                            : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL din_7                            : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL Selector_out1                    : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL Switch1_out1                     : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL Add_out1                         : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL Delay1_out1                      : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL Switch_out1                      : signed(31 DOWNTO 0);  -- sfix32_En16

BEGIN
  -- Free running, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  HDL_Counter_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        HDL_Counter_out1 <= to_unsigned(16#0#, 3);
      ELSIF enb = '1' THEN
        IF start = '1' THEN 
          HDL_Counter_out1 <= to_unsigned(16#0#, 3);
        ELSIF Compare_To_Constant2_out1 = '1' THEN 
          HDL_Counter_out1 <= HDL_Counter_out1 + to_unsigned(16#1#, 3);
        END IF;
      END IF;
    END IF;
  END PROCESS HDL_Counter_process;


  
  Compare_To_Constant1_out1 <= '1' WHEN HDL_Counter_out1 = to_unsigned(16#7#, 3) ELSE
      '0';

  Logical_Operator_out1 <= start OR Compare_To_Constant1_out1;

  -- Free running, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  HDL_Counter1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        HDL_Counter1_out1 <= '0';
      ELSIF enb = '1' AND Logical_Operator_out1 = '1' THEN
        HDL_Counter1_out1 <=  NOT HDL_Counter1_out1;
      END IF;
    END IF;
  END PROCESS HDL_Counter1_process;


  
  Compare_To_Constant2_out1 <= '1' WHEN HDL_Counter1_out1 = '1' ELSE
      '0';

  Constant1_out1_dtc <= to_signed(0, 32);

  Data_Type_Conversion_out1 <= resize(HDL_Counter_out1, 8);

  din_0 <= signed(din(0));

  din_1 <= signed(din(1));

  din_2 <= signed(din(2));

  din_3 <= signed(din(3));

  din_4 <= signed(din(4));

  din_5 <= signed(din(5));

  din_6 <= signed(din(6));

  din_7 <= signed(din(7));

  
  Selector_out1 <= din_0 WHEN Data_Type_Conversion_out1 = to_unsigned(16#00#, 8) ELSE
      din_1 WHEN Data_Type_Conversion_out1 = to_unsigned(16#01#, 8) ELSE
      din_2 WHEN Data_Type_Conversion_out1 = to_unsigned(16#02#, 8) ELSE
      din_3 WHEN Data_Type_Conversion_out1 = to_unsigned(16#03#, 8) ELSE
      din_4 WHEN Data_Type_Conversion_out1 = to_unsigned(16#04#, 8) ELSE
      din_5 WHEN Data_Type_Conversion_out1 = to_unsigned(16#05#, 8) ELSE
      din_6 WHEN Data_Type_Conversion_out1 = to_unsigned(16#06#, 8) ELSE
      din_7;

  
  Switch1_out1 <= Constant1_out1_dtc WHEN Compare_To_Constant2_out1 = '0' ELSE
      Selector_out1;

  Delay1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay1_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        Delay1_out1 <= Add_out1;
      END IF;
    END IF;
  END PROCESS Delay1_process;


  
  Switch_out1 <= Delay1_out1 WHEN start = '0' ELSE
      to_signed(0, 32);

  Add_out1 <= Switch1_out1 + Switch_out1;

  dout <= std_logic_vector(Add_out1);

  vout <= Compare_To_Constant1_out1;

END rtl;

