#include<stdio.h>


int main(){

	float a,b,c;
	float x,y;
	
	printf("Enter Coefficient A:");
	scanf("%f", &a);
	
	if(a== 0) {
		printf("This is not Quadratic Equation\n");
		return 1; //stop

		
	}	
	
	printf("Enter Coefficient B:");
	scanf("%f", &b);
	
	printf("Enter Coefficient C:");
	scanf("%f", &c);

	
	//Quadratic Equation = ax2 + bx + c;
	x = -b/(2*a);
	y = (a*x*x) + (b*x) + c;
	
	printf("Extrema Results\n");
	printf("%2f\n", x);
	printf("%2f\n", y);
	
	if(a>0){
		printf("\nThis is the Minimum Point\n");


	}
	else {
		printf("This is the Maximum Point\n");
		
	}

	return 0;
		
}
