#include <stdio.h>
#include <string.h>

#include "lwip/err.h"
#include "lwip/udp.h"
#include "xparameters.h"
#include "xil_io.h"
#include "adc_core.h"


struct ip_addr forward_ip;
//#define fwd_port 1234
#define fwd_port 5001
#define transmit_port 5001

void udp_echo_recv(void *arg, struct udp_pcb *pcb, struct pbuf *p, struct ip_addr *addr, u16_t port){
	int i;

	xil_printf("received at %d, echoing to the same port\n",pcb->local_port);
	//dst_ip = &(pcb->remote_ip); // this is zero always
      if (p != NULL) {
//    	  printf("UDP rcv %d bytes: ", (*p).len);
//    	  for (i = 0; i < (*p).len; ++i)
//			printf("%c",((char*)(*p).payload)[i]);
//    	printf("\n");
            //udp_sendto(pcb, p, IP_ADDR_BROADCAST, 1234); //dest port

    	udp_sendto(pcb, p, &forward_ip, fwd_port); //dest port
            pbuf_free(p);
      }
}

struct udp_pcb *broadcast_pcb;

#define out_buf_size ADC_DMA_TRANSFER_SIZE
int out_buf_i = 0;
int buf[out_buf_size];

void udp_sample(int baseaddr) {

	uint32_t addr;
	uint32_t data;
//	uint32_t baseaddr;
	uint32_t ch_est_base;



	ch_est_base = XPAR_ZYNQBF_2T_IP_0_BASEADDR + 0x100;
	for (int i = 0; i < 10; i++)
	{
		addr = ch_est_base + 4*i;
		data = Xil_In32(addr);
		buf[out_buf_i] = data;
		out_buf_i++;
	}


	for (int i = 0; i < ADC_DMA_TRANSFER_SIZE; i++)
//	for (int i = 0; i < 10; i++)
	{
		addr = baseaddr + 4*i;
		data = Xil_In32(addr);
		buf[out_buf_i] = data;
		out_buf_i++;
	}


//	if (out_buf_i == 10) {
//	if (out_buf_i == out_buf_size) {

			struct pbuf * p = pbuf_alloc(PBUF_TRANSPORT, out_buf_size * sizeof(uint32_t), PBUF_REF);
			p->payload = buf;

			//xil_printf("udp sampes to port %d\n", fwd_port);
			udp_sendto(broadcast_pcb, p, &forward_ip, fwd_port); //dest port
			pbuf_free(p);

			out_buf_i = 0;
//	}

}


void start_udp( vBasicTFTPServer, pvParameters ){
	struct udp_pcb *ptel_pcb = udp_new();
	int port = fwd_port;

	udp_bind(ptel_pcb, IP_ADDR_ANY, port);
	IP4_ADDR(&forward_ip, 192, 168,   1, 9);
	//IP4_ADDR(&forward_ip, 255, 255,   255,  255);
	//xil_printf("Listening UDP datagrams at %d, forwarding to port=%d at " , port, fwd_port);
	//print_ip("", &forward_ip);

	udp_recv(ptel_pcb, udp_echo_recv, NULL);

	broadcast_pcb = udp_new(); // AUDIO
//	int i;
//	for (i = 0 ; i != out_buf_size ; i++)
//		udp_sample(i);

}
