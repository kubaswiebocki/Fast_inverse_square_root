/*
 * main.c: find_mx application
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

//Initialize main
//***************************************************************************//
#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "str_acc.h"

#define NBR_OF_DATA 10 //All possible values for the range

u32 data_in[NBR_OF_DATA]; //Accelerator input buffer
u32 data_out[NBR_OF_DATA]; //Accelerator output buffer
float data_in_c[NBR_OF_DATA];
float data_out_c[NBR_OF_DATA];
float init_d = 0.001;

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
u32 read3DigitDecVal(){
u32 ret = 0;
char8 c;
    outbyte ( c = inbyte() );
    ret += 100 * (c - '0');

    outbyte ( c = inbyte() );
    ret += 10 * (c - '0');

	outbyte ( c = inbyte() );
	ret += (c - '0');
    return ret;
}
uint32_t floatToBits(float num) {
    union {
        float f;
        uint32_t bits;
    } converter;

    converter.f = num;
    return converter.bits;
}
float bitsToFloat(uint32_t bits) {
    union {
        float f;
        uint32_t bits;
    } converter;

    converter.bits = bits;
    return converter.f;
}

//float CompareData(float DataIn, float DataInC, int i){
//	float floatData, floatDataC, diff;
//	floatData = bitsToFloat(DataIn);
//	floatDataC = bitsToFloat(Q_rsqrt(DataInC));
//	diff = floatDataC - floatData;
//	if(diff < 0) diff = floatData - floatDataC;
//
//	if(diff > 0.000005){
//		printf("FAILED: ");
//		printf(" -> Sample: %.4f", (0.01 +  init_d*(i-1)));
//		printf(" -> Verilog: %.8f",floatData);
//		printf(" -> C_algorithm: %.8f",floatDataC);
//		printf(" -> Diff: %.8f\n\r",diff);
//		}
//	else{
//		printf("PASSED: ");
//		printf(" -> Sample: %.4f \n\r", (0.01 +  init_d*(i-1)));
//		}
//
//	return 0;
//}
//***************************************************************************//

//main
//***************************************************************************//
int main(){
	reset_fisr_acc();
	cleanup_platform();

	u32 i, nbr_of_results;
	float floatData, floatDataC, diff;

	for(i=0; i<NBR_OF_DATA; i++){
		float x = 0.01 +  init_d*i;
		data_in[i] = floatToBits(x);
		data_in_c[i] = x;
	}
//*****************************//

//FIFO and FPGA algorithm
//*****************************//
	// Initialize FIFOs and accelerator. Check status
	init_platform();
	if ( init_fisr_acc() == XST_FAILURE )
		goto error;

	print("Let's 1/sqrt(data_in) \n\r");
	//data_in = read3DigitDecVal();
	fisr_calc(data_in, NBR_OF_DATA, data_out, &nbr_of_results );

//*****************************//

//Generate data_out
//*****************************//
	for(i=1; i<nbr_of_results; i++){
		floatData = bitsToFloat(data_out[i]);
		floatDataC = bitsToFloat(Q_rsqrt(data_in_c[i-1]));
		diff = floatDataC - floatData;
		if(diff < 0) diff = floatData - floatDataC;
		//CompareData(data_out[i], data_in_c[i-1], i);

		if(diff > 0.000005){
			printf("FAILED: ");
			printf(" -> Sample: %.4f", (0.01 +  init_d*(i-1)));
			printf(" -> Verilog: %.8f",floatData);
			printf(" -> C_algorithm: %.8f",floatDataC);
			printf(" -> Diff: %.8f\n\r",diff);
			}
		else{
			printf("PASSED: ");
			printf(" -> Sample: %.4f \n\r", (0.01 +  init_d*(i-1)));
			}
	}
		printf("Processing done");

	error:
		reset_fisr_acc();
		cleanup_platform();
}
