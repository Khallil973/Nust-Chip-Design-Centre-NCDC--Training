#include<stdio.h>

int main() {


	int num;
	
	printf("Enter number:");
	scanf("%d", &num);

	if(num % 400 == 0 || num % 4 == 0){
		printf("This is Leap Year\n");
	
	}else {
		printf("This is not Leap Year\n");
	}


	return 0;
	
}
