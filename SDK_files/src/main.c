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
#include "xuartps.h"

#define NBR_OF_DATA 11 //All possible values for the range

u32 data_in[NBR_OF_DATA]; //Accelerator input buffer
u32 data_out[NBR_OF_DATA]; //Accelerator output buffer
float data_in_c[NBR_OF_DATA];
float data_out_c[NBR_OF_DATA];
float init_d = 0.0001;
char line[32];

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
    printf("%c",inbyte);
    ret += 100 * (c - '0');

    outbyte ( c = inbyte() );
    printf("%c",inbyte);
    ret += 10 * (c - '0');

	outbyte ( c = inbyte() );
	printf("%c",inbyte);
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
float uint32ToFloat(uint32_t bits) {
    union {
        float f;
        uint32_t bits;
    } converter;

    converter.bits = bits;
    return converter.f;
}

int fromBinary(const char *s) {
  return (int) strtol(s, NULL, 2);
}

void CompareData(float DataIn, float DataInC, int i){
	float floatData, floatDataC, diff;
	floatData = bitsToFloat(DataIn);
	floatDataC = bitsToFloat(Q_rsqrt(DataInC));
	diff = floatDataC - floatData;
	if(diff < 0) diff = floatData - floatDataC;

	if(diff != 0){
		printf("FAILED: ");
		printf(" -> Sample: %.4f", (0.01 +  init_d*(i-1)));
		printf(" -> Verilog: %.10f",floatData);
		printf(" -> C_algorithm: %.10f",floatDataC);
		printf(" -> Diff: %.10f\n\r",diff);
		}
	else{
		printf("PASSED: ");
		printf(" -> Sample: %.4f\n\r", (0.01 +  init_d*(i-1)));
		}

	//return 0;
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

	while(1){
	//for(int v=0; v<10000000; v++){;}
	u32 i, nbr_of_results;
	float floatData; //floatDataC, diff;
//FIFO and FPGA algorithm
//*****************************//

	for(i=0; i<10; i++){
		fgets(line, sizeof(line), stdin);
		u32 bits = fromBinary(line);
		printf("%f\n\r", uint32ToFloat(bits));
		//printf("\n\r");
		data_in[i] = bits;
	}
	fisr_calc(data_in, NBR_OF_DATA, data_out, &nbr_of_results );

//*****************************//

//Generate data_out
//*****************************//
	for(i=1; i<nbr_of_results; i++){
		floatData = bitsToFloat(data_out[i]);
		printf(" -> Verilog: %.10f \n\r",floatData);
		}
	printf("Processing done\n\r");
	cleanup_platform();
	init_platform();

	}
	error:
		reset_fisr_acc();
		cleanup_platform();
}
