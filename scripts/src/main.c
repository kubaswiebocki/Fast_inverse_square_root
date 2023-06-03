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
#define NBR_OF_ANGLES 1
//Accelerator input buffer
u32 data_in[NBR_OF_ANGLES];// = {0, 100, 201, 304, 410, 522, 641, 770, 918, 1099, 1386};
//Accelerator output buffer
u32 data_out[NBR_OF_ANGLES];

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




int main()
{
u32 i; //Iterators
u32 nbr_of_results;
s32 max=0;  //Maximum value m
s32 val = 0;  //sin(x) + cos(x) function value
s32 dataout; //Auxiliary sinus and cosinus values

	// Initialize FIFOs and accelerator. Check status
	init_platform();
	if ( init_fisr_acc() == XST_FAILURE )
		goto error;

    print("Let's 1/sqrt(data_in) \n\r");
	data_in = read3DigitDecVal();
    //Initialize angles buffer with values in range from 0 to pi/2
    //As fix-point(13:10), we distribute values 0 to 1607 ( = pi/2 * 1024)
    // for(i=0; i < NBR_OF_ANGLES; i++) data_in[i] = i;

    //Run accelerator to get sin(x) and cos(x)
    fisr_calc(data_in, NBR_OF_ANGLES, data_out, &nbr_of_results );


    for(i=0; i<nbr_of_results; i++){
    	dataout = RESULT_REG_SIN(data_out[i]);
    }
    
	xil_printf("Value of 1/sqrt(data_in) is %d \n\r", dataout);

	
error:
	reset_fisr_acc();
    cleanup_platform();
    while(1);
}
