#include<stdio.h>

int main() {


	int num;
	int unit, tenth, hundred;
	
	printf("Enter number:");
	scanf("%d", &num);

	unit = num % 10;
	tenth = (num / 10) % 10;
	hundred = num/100;
	
	printf("\nUnit Digit:%d", unit);
	printf("\nTenth Digit:%d", tenth);
	printf("\nHundred Digit:%d\n",hundred);
	

	return 0;
	
}
