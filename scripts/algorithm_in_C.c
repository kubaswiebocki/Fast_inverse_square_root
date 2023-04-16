#include <stdio.h>

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

int main() {
    for(double long x = 0.01; x < 10.01; x = x + 0.01){
        printf("%X\n", x, Q_rsqrt(x));
    }
    return 0;
}