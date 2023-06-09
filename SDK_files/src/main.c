#include <stdlib.h>
#include "xil_types.h"
#include "xuartps.h"
#include "sleep.h"

#define dataSize 1500*4


int main(){
	u8 *inputData;
	u32 status;
	u32 receivedBytes = 0;
	u32 totalReceivedBytes = 0;
	u32 totalTransmittedBytes = 0;
	u32 transmittedBytes = 0;
	XUartPs_Config *myUartConfig;
	XUartPs myUart;

	inputData = malloc(sizeof(u8)*dataSize);
	myUartConfig = XUartPs_LookupConfig(XPAR_PS7_UART_1_DEVICE_ID);
	status = XUartPs_CfgInitialize(&myUart, myUartConfig, myUartConfig->BaseAddress);
	if(status != XST_SUCCESS){
		print("Uart initialization failed...\n\n");
	}
	status = XUartPs_SetBaudRate(&myUart, 115200);
	if(status != XST_SUCCESS){
		print("Baudrate init failed....\n\n");
	}
	while(totalReceivedBytes < dataSize){
		receivedBytes = XUartPs_Recv(&myUart,(u8*)&inputData[totalReceivedBytes],100);
		totalReceivedBytes += receivedBytes;
	}

//	for(int i=0; i<dataSize; i++){
//		xil_printf("%x", inputData[i]);
//	}
	while(totalTransmittedBytes < dataSize){
		transmittedBytes = XUartPs_Send(&myUart, (u8*)&inputData[totalTransmittedBytes], 4);
		totalTransmittedBytes += transmittedBytes;
		usleep(1000);
	}

}
