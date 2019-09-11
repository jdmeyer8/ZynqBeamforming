-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\ZynqBF_2tx_fpga\ZynqBF_2t_ip_src_gold_sequences.vhd
-- Created: 2019-02-08 23:33:51
-- 
-- Generated by MATLAB 9.5 and HDL Coder 3.13
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: ZynqBF_2t_ip_src_goldSeq1
-- Source Path: ZynqBF_2tx_fpga/channel_estimator/peakdetect_ch1/correlator1/gold_sequences
-- Hierarchy Level: 4
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ZynqBF_2t_ip_src_ZynqBF_2tx_fpga_pkg.ALL;

ENTITY ZynqBF_2t_ip_src_goldSeq IS
  GENERIC( NDSP                           :   integer := 32;
           N                              :   integer := 2      -- number of gold sequences to use
        );
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        -- addr                              :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
        -- addr_lsb                          :   IN    std_logic_vector(5 downto 0);
        addr                              :   IN    vector_of_std_logic_vector7(0 to (N-1));  -- ufix6
        addr_lsb                          :   IN    vector_of_std_logic_vector5(0 to (N-1));
        gs_out_single                     :   OUT   vector_of_std_logic_vector16(0 to (N-1));
        gs_out                            :   OUT   vector_of_std_logic_vector16(0 to (N*NDSP - 1))
        );
END ZynqBF_2t_ip_src_goldSeq;


ARCHITECTURE rtl OF ZynqBF_2t_ip_src_goldSeq IS

  component ZynqBF_2t_ip_src_goldSeq_ram
  generic( NDSP                           :   integer := 32;
           CHANNEL                        :   integer := 1
        );
  port( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        addr                              :   IN    std_logic_vector(6 downto 0);
        addr_lsb                          :   IN    std_logic_vector(4 downto 0);
        dout_single                       :   OUT   std_logic_vector(15 downto 0);
        dout                              :   OUT   vector_of_std_logic_vector16(0 to (NDSP-1))
        );
  end component;

  FOR ALL : ZynqBF_2t_ip_src_goldSeq_ram
    USE ENTITY work.ZynqBF_2t_ip_src_goldSeq_ram(rtl); 
        
BEGIN

gen_rams: for i in 1 to N generate
  u_gs_ram_i : ZynqBF_2t_ip_src_goldSeq_ram
  generic map( NDSP => NDSP,
               CHANNEL => i)
  port map( 
    clk => clk,
    reset => reset,
    enb => enb,
    addr => addr(i-1),
    addr_lsb => addr_lsb(i-1),
    dout_single => gs_out_single(i-1),
    dout => gs_out(NDSP*(i-1) to (NDSP*i - 1))
    );
end generate;
  


END rtl;

