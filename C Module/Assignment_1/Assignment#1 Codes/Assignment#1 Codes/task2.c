#include<stdio.h>

int main(){
	
	int unit;
	printf("Enter No. of Units:");
	scanf("%d", &unit);
	
	switch(unit){
		case 200: printf("Your Bill is 3600\n");
				break;
		case 100: printf("Your Bill is 1800\n");
				break;
		case 250: printf("Your Bill is 7500\n");
				break;
		case 350: printf("Your Bill is 10500\n");
				break;
		case 500: printf("Your Bill is 20000\n");
				break;
		case 400: printf("Your Bill is 16000\n");
				break;
		default:  printf("Invalid"); 											
	}


	return 0;
}
