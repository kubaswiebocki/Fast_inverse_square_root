#include <stdio.h>
#include <math.h>

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

float ieee754_to_float(unsigned int value) {
    return *((float*)&value);
}

int main() {
	while(1){
		float input;
		printf("Enter a value: ");
		scanf("%f", &input);
		
		if(input <= 0.0){
			printf("This value is not allowed\n");
		}
		else{
			float math_out  = 1.0 / sqrt(input);
			float fisr_out = ieee754_to_float(Q_rsqrt(input));
			float abs_val = fabs(fisr_out - math_out);
			printf("---------------------------------------------\n");
			printf("Entered Value -> %.3f\n", input);
			printf("Algorithm Output -> %.8f\n", fisr_out);
			printf("Math.h Function -> %.8f\n", math_out);
			printf("Difference |FISR - MATH| -> %.8f\n", abs_val);
			printf("---------------------------------------------\n");
		}

	}
}