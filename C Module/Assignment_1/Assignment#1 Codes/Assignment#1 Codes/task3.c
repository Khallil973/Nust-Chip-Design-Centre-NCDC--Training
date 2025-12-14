#include<stdio.h>

int main(){
	
	int age; // Age of the person
	int pizzas;  // pizzas eat per week
	char excercise;  // Daily Morning Excercise
	
	printf("Please enter the age of the person (years) : ");
	scanf("%d", &age);
	
	printf("Please enter how many pizzas he eat per week : ");
	scanf("%d", &pizzas);
	
	printf("Please mention whether he exercises daily in the morning: ");
	scanf(" %c", &excercise);
	
	if(age == 25 && pizzas == 7 && excercise == 'Y'){
		printf("The person is ‘Unfit’\n");
	}
	else if(age == 35 && pizzas == 1 && excercise == 'N'){
		printf("The person is ‘Unfit’\n");
}
	else if(age == 40 && pizzas == 3 && excercise == 'Y'){
		printf("The person is ‘Fit’\n");
}
	else if(age == 20 && pizzas == 2 && excercise == 'N'){
		printf("The person is ‘Fit’\n");
}
	else if(age == 50 && pizzas == 0 && excercise == 'N'){
		printf("The person is ‘Unfit’\n");
}
	else{
		printf("Invalid");
}

	return 0;
}
