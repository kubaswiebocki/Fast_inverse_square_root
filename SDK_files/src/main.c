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
#define NBR_OF_DATA 4
//Accelerator input buffer
u32 data_in[NBR_OF_DATA];
//Accelerator output buffer
u32 data_out[NBR_OF_DATA];

//float data_in_c[NBR_OF_DATA];

int Q_rsqrt( float number )
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
u32 i; //Iterators
u32 nbr_of_results;
u32 dataout; //Auxiliary sinus and cosinus values
data_in[0] = floatToBits(1);
data_in[1] = floatToBits(0.5);
data_in[2] = floatToBits(0.1);

//data_in_c[0] = 1;
//data_in_c[1] = 0.5;
//data_in_c[2] = 0.1;

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
        float fval = floatData;
    	int whole, thousandths;
    	whole = fval;
    	thousandths = (fval - whole) * 1000000;
    	xil_printf("%d.%6d\n\r", whole, thousandths);

//        for(i=1; i<nbr_of_results; i++){
//        	dataout = RESULT_REG_SIN(data_out[i]);
//
//        float fval = floatData;
//    	int whole, thousandths;
//    	whole = fval;
//    	thousandths = (fval - whole) * 1000000;
//    	xil_printf("%d.%6d\n\r", whole, thousandths);

    }
	
error:
	reset_fisr_acc();
    cleanup_platform();

}
