/*
 * File Name:         hdl_prj/ipcore/ZynqBF_2t_ip_v1_0/include/ZynqBF_2t_ip_addr.h
 * Description:       C Header File
 * Created:           2019-02-11 10:11:56
*/

#ifndef ZYNQBF_2T_IP_H_
#define ZYNQBF_2T_IP_H_

#define  IPCore_Reset_ZynqBF_2t_ip       0x0  //write 0x1 to bit 0 to reset IP core
#define  IPCore_Enable_ZynqBF_2t_ip      0x4  //enabled (by default) when bit 0 is 0x1
#define  IPCore_Timestamp_ZynqBF_2t_ip   0x8  //contains unique IP timestamp (yymmddHHMM): 1902111011
#define  ch1_i_Data_ZynqBF_2t_ip         0x100  //data register for Outport ch1_i
#define  ch1_q_Data_ZynqBF_2t_ip         0x104  //data register for Outport ch1_q
#define  ch2_i_Data_ZynqBF_2t_ip         0x108  //data register for Outport ch2_i
#define  ch2_q_Data_ZynqBF_2t_ip         0x10C  //data register for Outport ch2_q

#endif /* ZYNQBF_2T_IP_H_ */
