#include<stdio.h>



int main() {

	int degree, mints,sec;
	float decimal_degree;

	
	printf("Enter Degree:");
	scanf("%d", &degree);

	printf("Enter Minutes:");
	scanf("%d", &mints);
	
	printf("Enter Seconds:");
	scanf("%d", &sec);
	
	//Decimal Degree = degree + (minutes/60) + (second/3600)
	//Condition
	decimal_degree = degree + (mints/60) + (sec/3600);
	
	printf("\nLatitute & Longitute in Decimal Degree: %f", decimal_degree);
	
	
	//for equator	
	if(decimal_degree > 0 ){
		printf("\nIt is above the equator:\n");
		
	}else {
	
		printf("It is not above the equator:\n");
	}
	
	
	
	return 0;


}
