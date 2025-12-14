#include<stdio.h>
#include<math.h>

int main (){

	float V1,R1,R2,R3;
	float i1,i2,i3;
	float k, denominator;
	
	//Input
	printf("Enter Voltage:");
	scanf("%f", &V1);
	
	printf("Enter Register1:");
	scanf("%f", &R1);
	
	printf("Enter Register2:");
	scanf("%f", &R2);

	printf("Enter Register3:");
	scanf("%f", &R3);
		
	
	
	//Subsituting 3 equations 
	//i1 = i2 + i3 --> (1)
	//V1 = I1.R1 + I2.R2 --> (2)
	//V1 = I1.R1 + I3.R3 --> (3)
	//After steps the final equation of i3 is;
	//i3 = (v1/((R3/R2) + 1)*R1 + R3))
	//i2 = R3/R2 * I3
	//i1 = I2 + I3
	
	k = R3/R2;
	denominator = (k + 1)*R1 +R3;
	i3 = V1/denominator;
	
	i2 = (R3/R2) * i3;
	
	i1 = i2 + i3;
	

    	// Output
    	printf("\nResults:\n");
    	printf("I1 = %.4f A\n", i1);
    	printf("I2 = %.4f A\n", i2);
    	printf("I3 = %.4f A\n", i3);


	return 0;


}
