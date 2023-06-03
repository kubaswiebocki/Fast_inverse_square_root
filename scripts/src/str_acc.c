/*
 * str_acc.c

 *
 *  Created on: 22 gru 2017
 *      Author: Pawel
 */

#include "xparameters.h"
#include "xllfifo.h"
#include "xstatus.h"
#include "str_acc.h"

XLlFifo Instance;

#define FIFO_DEVICE_ID XPAR_AXI_FIFO_MM_S_0_DEVICE_ID
#define ACCELERATOR_LATENCY 15
#define ACCELERATOR_FIFO_LEN 2048


/**
 * Calculates sine and cosine for the angle values in angles buffer
 * angle is in fixed-point(13:10) format
 * Results are placed in sin_cos buffer
 * sin(angle[i]) value is located in sin_cos[i](12:0)
 * cos(angle[i]) value is in sin_cos[i](28:16)
 *  */
int fisr_calc( u32* data_in, u32 nbr_of_data, u32* data_out, u32 *nbr_of_results )
{

u32 results = 0;

	// Buffers longer than FIFO len are not supported
	if(ACCELERATOR_FIFO_LEN > 2048) return 0;

	//Send angle values to accelerator
	//Send ACCELERATOR_LATENCY more values to push out results form accelerator
	if( send_buffer(data_in, (nbr_of_data+ACCELERATOR_LATENCY)*sizeof(u32)) == XST_FAILURE )
		goto error;
	//Get results
    if( receive_buffer(data_out, nbr_of_data*sizeof(u32), &results) == XST_FAILURE )
		goto error;
    //Return number of results in bytes
    *nbr_of_results = results/4;

	return 1;

error:
	return 0;

}


/**
 * Initialize FIFOs and its driver
 */
int init_fisr_acc(){
XLlFifo_Config *Config;
int Status;

	/* Initialize the Device Configuration Interface driver */
	Config = XLlFfio_LookupConfig(FIFO_DEVICE_ID);
	if (!Config) {
		return XST_FAILURE;
	}

	Status = XLlFifo_CfgInitialize(&Instance, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS) {
		return Status;
	}

	/* Check for the Reset value */
	Status = XLlFifo_Status(&Instance);
	XLlFifo_IntClear(&Instance,0xffffffff);
	Status = XLlFifo_Status(&Instance);
	if(Status != 0x0) {
		return XST_FAILURE;
	}


	return XST_SUCCESS;

}

/**
 * Send reset signal to FIFOs and accelrator
 */
void reset_fisr_acc(){
	XLlFifo_RxReset(&Instance);
	XLlFifo_TxReset(&Instance);
}

/**
 * Send data to the input FIFO and accelerator
 */
int send_buffer(u32* buf, u32 len){

	//Write data to the input FIFO
	XLlFifo_Write(&Instance, buf, len);
	//Initialize data transfer
 	XLlFifo_TxSetLen(&Instance, len);

 	// Check for Transmission completion
 	while( !(XLlFifo_IsTxDone(&Instance)) ){

 	}

 	return XST_SUCCESS;

}


/**
 * Receive date form the output FIFO
 */
int receive_buffer(u32* buf, u32 len, u32* received){
u32 bytes;
int Status;

	//wait for data frame ready
	while(XLlFifo_RxOccupancy(&Instance)==0);
	//get number of data in frame
	bytes = XLlFifo_RxGetLen(&Instance);
	//Expected number of elements should be ready
	if( len < bytes ) return XST_FAILURE;

    //Perform read operation form FIFO
	XLlFifo_Read(&Instance, buf, len);
	//Return number of data read
	*received = len;

	//Check operation status
	Status = XLlFifo_IsRxDone(&Instance);
	if(Status != TRUE){
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

