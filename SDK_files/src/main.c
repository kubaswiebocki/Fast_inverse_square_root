/*
 * main.c: find_mx application
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "str_acc.h"

//All possible values for the range from 0 to pi/2 in fixed-point (13:10)
#define NBR_OF_DATA 100
//Accelerator input buffer
u32 data_in[NBR_OF_DATA];
//Accelerator output buffer
u32 data_out[NBR_OF_DATA];

float data_in_c[NBR_OF_DATA];
float data_out_c[NBR_OF_DATA];

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

int main()
{
reset_fisr_acc();
cleanup_platform();

u32 i; //Iterators
u32 nbr_of_results;
u32 dataout; //Auxiliary sinus and cosinus values
float init_d = 0.001;

for(i=0; i<NBR_OF_DATA; i++){
	float x = 0.01 +  init_d*i;
	data_in[i] = floatToBits(x);
	data_in_c[i] = x;
}

	// Initialize FIFOs and accelerator. Check status
	init_platform();
	if ( init_fisr_acc() == XST_FAILURE )
		goto error;

    print("Let's 1/sqrt(data_in) \n\r");
	//data_in = read3DigitDecVal();
    fisr_calc(data_in, NBR_OF_DATA, data_out, &nbr_of_results );


    for(i=1; i<nbr_of_results; i++){
    	dataout = RESULT_REG_SIN(data_out[i]);

    	float floatData = bitsToFloat(dataout);
    	float floatDataC = bitsToFloat(Q_rsqrt(data_in_c[i-1]));
    	float diff = floatDataC - floatData;
    	if(diff < 0) diff = floatData - floatDataC;

    	if(diff > 0.0000008){
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
