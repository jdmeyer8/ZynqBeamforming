-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\ZynqBF_2tx_fpga\ZynqBF_2t_ip_addr_decoder.vhd
-- Created: 2019-02-08 23:34:53
-- 
-- Generated by MATLAB 9.5 and HDL Coder 3.13
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: ZynqBF_2t_ip_addr_decoder
-- Source Path: ZynqBF_2t_ip/ZynqBF_2t_ip_axi_lite/ZynqBF_2t_ip_addr_decoder
-- Hierarchy Level: 2
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ZynqBF_2t_ip_addr_decoder IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        data_write                        :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
        addr_sel                          :   IN    std_logic_vector(13 DOWNTO 0);  -- ufix14
        wr_enb                            :   IN    std_logic;  -- ufix1
        rd_enb                            :   IN    std_logic;  -- ufix1
        read_ip_timestamp                 :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
        read_ch1_i                        :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        read_ch1_q                        :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        read_ch2_i                        :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        read_ch2_q                        :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        data_read                         :   OUT   std_logic_vector(31 DOWNTO 0);  -- ufix32
        write_axi_enable                  :   OUT   std_logic  -- ufix1
        );
END ZynqBF_2t_ip_addr_decoder;


ARCHITECTURE rtl OF ZynqBF_2t_ip_addr_decoder IS

  -- Signals
  SIGNAL enb                              : std_logic;
  SIGNAL addr_sel_unsigned                : unsigned(13 DOWNTO 0);  -- ufix14
  SIGNAL read_ip_timestamp_unsigned       : unsigned(31 DOWNTO 0);  -- ufix32
  SIGNAL const_1                          : std_logic;  -- ufix1
  SIGNAL read_ch1_i_signed                : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL read_ch1_q_signed                : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL read_ch2_i_signed                : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL read_ch2_q_signed                : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL decode_sel_ch2_q                 : std_logic;  -- ufix1
  SIGNAL decode_sel_ch2_i                 : std_logic;  -- ufix1
  SIGNAL decode_sel_ch1_q                 : std_logic;  -- ufix1
  SIGNAL decode_sel_ch1_i                 : std_logic;  -- ufix1
  SIGNAL decode_sel_ip_timestamp          : std_logic;  -- ufix1
  SIGNAL read_reg_ip_timestamp            : unsigned(31 DOWNTO 0);  -- ufix32
  SIGNAL decode_rd_ip_timestamp           : unsigned(31 DOWNTO 0);  -- ufix32
  SIGNAL read_reg_ch1_i                   : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL data_in_ch1_i                    : unsigned(31 DOWNTO 0);  -- ufix32
  SIGNAL decode_rd_ch1_i                  : unsigned(31 DOWNTO 0);  -- ufix32
  SIGNAL read_reg_ch1_q                   : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL data_in_ch1_q                    : unsigned(31 DOWNTO 0);  -- ufix32
  SIGNAL decode_rd_ch1_q                  : unsigned(31 DOWNTO 0);  -- ufix32
  SIGNAL read_reg_ch2_i                   : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL data_in_ch2_i                    : unsigned(31 DOWNTO 0);  -- ufix32
  SIGNAL decode_rd_ch2_i                  : unsigned(31 DOWNTO 0);  -- ufix32
  SIGNAL read_reg_ch2_q                   : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL data_in_ch2_q                    : unsigned(31 DOWNTO 0);  -- ufix32
  SIGNAL decode_rd_ch2_q                  : unsigned(31 DOWNTO 0);  -- ufix32
  SIGNAL decode_sel_axi_enable            : std_logic;  -- ufix1
  SIGNAL reg_enb_axi_enable               : std_logic;  -- ufix1
  SIGNAL data_write_unsigned              : unsigned(31 DOWNTO 0);  -- ufix32
  SIGNAL data_in_axi_enable               : std_logic;  -- ufix1
  SIGNAL write_reg_axi_enable             : std_logic;  -- ufix1

BEGIN
  addr_sel_unsigned <= unsigned(addr_sel);

  read_ip_timestamp_unsigned <= unsigned(read_ip_timestamp);

  const_1 <= '1';

  enb <= const_1;

  read_ch1_i_signed <= signed(read_ch1_i);

  read_ch1_q_signed <= signed(read_ch1_q);

  read_ch2_i_signed <= signed(read_ch2_i);

  read_ch2_q_signed <= signed(read_ch2_q);

  
  decode_sel_ch2_q <= '1' WHEN addr_sel_unsigned = to_unsigned(16#0043#, 14) ELSE
      '0';

  
  decode_sel_ch2_i <= '1' WHEN addr_sel_unsigned = to_unsigned(16#0042#, 14) ELSE
      '0';

  
  decode_sel_ch1_q <= '1' WHEN addr_sel_unsigned = to_unsigned(16#0041#, 14) ELSE
      '0';

  
  decode_sel_ch1_i <= '1' WHEN addr_sel_unsigned = to_unsigned(16#0040#, 14) ELSE
      '0';

  
  decode_sel_ip_timestamp <= '1' WHEN addr_sel_unsigned = to_unsigned(16#0002#, 14) ELSE
      '0';

  reg_ip_timestamp_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        read_reg_ip_timestamp <= to_unsigned(0, 32);
      ELSIF enb = '1' THEN
        read_reg_ip_timestamp <= read_ip_timestamp_unsigned;
      END IF;
    END IF;
  END PROCESS reg_ip_timestamp_process;


  
  decode_rd_ip_timestamp <= to_unsigned(0, 32) WHEN decode_sel_ip_timestamp = '0' ELSE
      read_reg_ip_timestamp;

  reg_ch1_i_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        read_reg_ch1_i <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        read_reg_ch1_i <= read_ch1_i_signed;
      END IF;
    END IF;
  END PROCESS reg_ch1_i_process;


  data_in_ch1_i <= unsigned(resize(read_reg_ch1_i, 32));

  
  decode_rd_ch1_i <= decode_rd_ip_timestamp WHEN decode_sel_ch1_i = '0' ELSE
      data_in_ch1_i;

  reg_ch1_q_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        read_reg_ch1_q <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        read_reg_ch1_q <= read_ch1_q_signed;
      END IF;
    END IF;
  END PROCESS reg_ch1_q_process;


  data_in_ch1_q <= unsigned(resize(read_reg_ch1_q, 32));

  
  decode_rd_ch1_q <= decode_rd_ch1_i WHEN decode_sel_ch1_q = '0' ELSE
      data_in_ch1_q;

  reg_ch2_i_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        read_reg_ch2_i <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        read_reg_ch2_i <= read_ch2_i_signed;
      END IF;
    END IF;
  END PROCESS reg_ch2_i_process;


  data_in_ch2_i <= unsigned(resize(read_reg_ch2_i, 32));

  
  decode_rd_ch2_i <= decode_rd_ch1_q WHEN decode_sel_ch2_i = '0' ELSE
      data_in_ch2_i;

  reg_ch2_q_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        read_reg_ch2_q <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        read_reg_ch2_q <= read_ch2_q_signed;
      END IF;
    END IF;
  END PROCESS reg_ch2_q_process;


  data_in_ch2_q <= unsigned(resize(read_reg_ch2_q, 32));

  
  decode_rd_ch2_q <= decode_rd_ch2_i WHEN decode_sel_ch2_q = '0' ELSE
      data_in_ch2_q;

  data_read <= std_logic_vector(decode_rd_ch2_q);

  
  decode_sel_axi_enable <= '1' WHEN addr_sel_unsigned = to_unsigned(16#0001#, 14) ELSE
      '0';

  reg_enb_axi_enable <= decode_sel_axi_enable AND wr_enb;

  data_write_unsigned <= unsigned(data_write);

  data_in_axi_enable <= data_write_unsigned(0);

  reg_axi_enable_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        write_reg_axi_enable <= '1';
      ELSIF enb = '1' AND reg_enb_axi_enable = '1' THEN
        write_reg_axi_enable <= data_in_axi_enable;
      END IF;
    END IF;
  END PROCESS reg_axi_enable_process;


  write_axi_enable <= write_reg_axi_enable;

END rtl;

