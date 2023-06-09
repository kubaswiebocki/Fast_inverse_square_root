//Initialize main
//***************************************************************************//
#include <stdio.h>
#include <stdlib.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_types.h"
#include "str_acc.h"
#include "xuartps.h"
#include "sleep.h"

#define NBR_OF_VECT 600 //All possible values for the range
#define VectSize NBR_OF_VECT*4

u32 data_out[NBR_OF_VECT]; //Accelerator output buffer
u32 inputData32[NBR_OF_VECT];

//***************************************************************************//

//Functions
//***************************************************************************//
float Q_rsqrt( float number )
{
	long i;
	unsigned long r;
	float x2, y;
	const float threehalfs = 1.5F;

	x2 = number * 0.5F;
	y  = number;
	i  = * ( long * ) &y;
	i  = 0x5f3759df - ( i >> 1 );
	y  = * ( float * ) &i;
	y  = y * ( threehalfs - ( x2 * y * y ) );
	r  = * ( long * ) &y;
	return r;
}
uint32_t combine_8bit_to_32bit(uint8_t data1, uint8_t data2, uint8_t data3, uint8_t data4) {
    uint32_t result = 0;

    result |= (uint32_t)data1 << 24;
    result |= (uint32_t)data2 << 16;
    result |= (uint32_t)data3 << 8;
    result |= (uint32_t)data4;

    return result;
}

//***************************************************************************//

//main
//***************************************************************************//
int main(){
	reset_fisr_acc();
	cleanup_platform();
	init_platform();
	if ( init_fisr_acc() == XST_FAILURE )
		goto error;

	u8 *inputData;
	u8 *outputData8;
	u32 status;
	u32 receivedBytes = 0;
	u32 totalReceivedBytes = 0;
	u32 totalTransmittedBytes = 0;
	u32 transmittedBytes = 0;
	u32 nbr_of_results;
	u32 NBR_OF_DATA;
	u32 dataSize;
	XUartPs_Config *myUartConfig;
	XUartPs myUart;

	inputData = malloc(sizeof(u8)*VectSize);
	outputData8 = malloc(sizeof(u8)*VectSize);
	myUartConfig = XUartPs_LookupConfig(XPAR_PS7_UART_1_DEVICE_ID);
	status = XUartPs_CfgInitialize(&myUart, myUartConfig, myUartConfig->BaseAddress);
	if(status != XST_SUCCESS){
		print("Uart initialization failed...\n\n");
		}
	status = XUartPs_SetBaudRate(&myUart, 115200);
	if(status != XST_SUCCESS){
		print("Baudrate init failed....\n\n");
		}

//FIFO and FPGA algorithm
//**********************************************************//
while(1){
	//number of vectors
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	while(totalReceivedBytes < 4){
		receivedBytes = XUartPs_Recv(&myUart,(u8*)&inputData[totalReceivedBytes],100);
		totalReceivedBytes += receivedBytes;
	}
	receivedBytes = 0;
	totalReceivedBytes = 0;
	NBR_OF_DATA = combine_8bit_to_32bit(inputData[0], inputData[1], inputData[2], inputData[3]);;
	dataSize = NBR_OF_DATA*4;

	//Data to compute
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	while(totalReceivedBytes < dataSize){
		receivedBytes = XUartPs_Recv(&myUart,(u8*)&inputData[totalReceivedBytes],100);
		totalReceivedBytes += receivedBytes;
	}
	for(int i=0; i<NBR_OF_DATA; i++){
		inputData32[i] = combine_8bit_to_32bit(inputData[i*4], inputData[1+i*4], inputData[2+i*4], inputData[3+i*4]);
	}
	fisr_calc(inputData32, NBR_OF_DATA, data_out, &nbr_of_results);

	for(int i=0; i<NBR_OF_DATA; i++){
		for (int j=0; j<4; j++){outputData8[j+i*4] = (data_out[i] >> (3-j)*8) & 0xFF;}
		}

	while(totalTransmittedBytes < dataSize){
		transmittedBytes = XUartPs_Send(&myUart, (u8*)&outputData8[totalTransmittedBytes], 4);
		totalTransmittedBytes += transmittedBytes;
		usleep(10);
	}

	//Clean up data
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	receivedBytes = 0;
	totalReceivedBytes = 0;
	transmittedBytes = 0;
	totalTransmittedBytes = 0;
	reset_fisr_acc();
}
//**********************************************************//

//Generate data_out
//**********************************************************//
	error:
		reset_fisr_acc();
		cleanup_platform();
}
