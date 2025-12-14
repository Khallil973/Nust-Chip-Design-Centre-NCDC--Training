#include<stdio.h>


int main (){

	float ch1, ch2, ch3;
	char c1[20], c2[20], c3[20]; 
	float g1,g2,g3;
    	float total_credit, total_points, GPA;
	
	//Course 1
	printf("Enter Your Course:");
	scanf("%s", c1);
	
	printf("\nEnter Your Credit Hours:");
	scanf("%d", &ch1);
	
	printf("\nEnter Your Grade:");
	scanf("%f", &g1);
	
	//Course 2
	printf("\nEnter Your Course:");
	scanf("%s", &c2);
	
	printf("\nEnter Your Credit Hours:");
	scanf("%d", &ch2);
	
	printf("\nEnter Your Grade:");
	scanf("%f", &g2);
	
	//Course 3 
	printf("\nEnter Your Course:");
	scanf("%s", &c3);
	
	printf("\nEnter Your Credit Hours:");
	scanf("%d", &ch3);
	
	printf("\nEnter Your Grade:");
	scanf("%f", &g3);

    	// GPA Calculation
    	total_credit = ch1 + ch2 + ch3;
    	total_points = (ch1 * g1) + (ch2 * g2) + (ch3 * g3);
    	GPA = total_points / total_credit;
	
	printf("\nYour Semester GPA is: %.2f\n", GPA);


	
	return 0;
}





