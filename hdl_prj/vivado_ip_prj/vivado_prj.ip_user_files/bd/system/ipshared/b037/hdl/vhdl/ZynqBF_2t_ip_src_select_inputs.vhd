-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\ZynqBF_2tx_fpga\ZynqBF_2t_ip_src_select_inputs.vhd
-- Created: 2019-02-08 23:33:51
-- 
-- Generated by MATLAB 9.5 and HDL Coder 3.13
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: ZynqBF_2t_ip_src_select_inputs
-- Source Path: ZynqBF_2tx_fpga/channel_estimator/ram_rd_counter/select_inputs
-- Hierarchy Level: 3
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ZynqBF_2t_ip_src_select_inputs IS
  PORT( en1                               :   IN    std_logic;
        en2                               :   IN    std_logic;
        in1                               :   IN    std_logic_vector(14 DOWNTO 0);  -- ufix15
        in2                               :   IN    std_logic_vector(14 DOWNTO 0);  -- ufix15
        y                                 :   OUT   std_logic_vector(14 DOWNTO 0)  -- ufix15
        );
END ZynqBF_2t_ip_src_select_inputs;


ARCHITECTURE rtl OF ZynqBF_2t_ip_src_select_inputs IS

  -- Signals
  SIGNAL in1_unsigned                     : unsigned(14 DOWNTO 0);  -- ufix15
  SIGNAL in2_unsigned                     : unsigned(14 DOWNTO 0);  -- ufix15
  SIGNAL y_tmp                            : unsigned(14 DOWNTO 0);  -- ufix15

BEGIN
  in1_unsigned <= unsigned(in1);

  in2_unsigned <= unsigned(in2);

  select_inputs_output : PROCESS (en1, en2, in1_unsigned, in2_unsigned)
  BEGIN
    --MATLAB Function 'channel_estimator/ram_rd_counter/select_inputs'
    IF (en1 AND en2) = '1' THEN 
      y_tmp <= to_unsigned(16#0000#, 15);
    ELSIF en1 = '1' THEN 
      y_tmp <= in1_unsigned;
    ELSIF en2 = '1' THEN 
      y_tmp <= in2_unsigned;
    ELSE 
      y_tmp <= to_unsigned(16#0000#, 15);
    END IF;
  END PROCESS select_inputs_output;


  y <= std_logic_vector(y_tmp);

END rtl;

