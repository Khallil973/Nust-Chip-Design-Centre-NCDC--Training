#include<stdio.h>


int main(){

	float grade;

	printf("Please Enter Your Marks:");
	scanf("%f", &grade);

	if(grade >= 73 && grade <= 100){
	printf("Congrats! You got an A grade\n");
}
	else if(grade >= 68 && grade <= 73){
	printf("You got a B+ grade\n");
}	
	else if(grade >= 63 && grade <= 68){
	printf("You got a B grade\n");
}
	else if(grade  >= 58 && grade <= 63){
	printf("You got a C+ grade\n");
}
	else if(grade >= 52 && grade <= 58){
	printf("You got a C grade\n");
}
	else if(grade >= 47 && grade <= 52){
	printf("You got a D+ grade\n");
}
	else if(grade >= 41 && grade <= 47){
	printf("You got a D grade\n");
}
	else if(grade >= 0 && grade <= 41){
	printf("Fail\n");
}
	else {
	printf("Invalid Number\n");
}


return 0;

}

