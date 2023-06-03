/*
 * str_acc.h
 *
 *  Created on: 22 gru 2017
 *      Author: Pawel
 */

#ifndef STR_ACC_H_
#define STR_ACC_H_

#include "xstatus.h"

// Macros to extract sinus and cosinus values from 13-bit register fields to 32-bit variable
// cos - reg (28:16). sin reg(12:0)
// Looks tricky because we need to save sign bit if sine and cosine
#define RESULT_REG_SIN(param)  ((((s32)param & (s32)0x00001FFF)<<19)>>19)
#define RESULT_REG_COS(param)  ((((s32)param & (s32)0x1FFF0000)<< 3)>>19)


// Driver user functions
int fisr_calc( u32* data_in_buf, u32 nbr_of_angles, u32* data_out_buf, u32 *nbr_of_results );
int init_fisr_acc();
void reset_fisr_acc();

// Lower level driver function
int send_buffer(u32* buf, u32 len);
int receive_buffer(u32* buf, u32 len, u32* received);


#endif /* STR_ACC_H_ */
