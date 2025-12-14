#include<stdio.h>	


int main() {

	int x1,x2,x3,y1,y2,y3;
	int AB,BC,CA;
	
	printf("Enter X1:");
	scanf("%d", &x1);

	printf("Enter X2:");
	scanf("%d", &x2);

	printf("Enter X3:");
	scanf("%d", &x3);

	printf("Enter Y1:");
	scanf("%d", &y1);

	printf("Enter Y2:");
	scanf("%d", &y2);

	printf("Enter Y3:");
	scanf("%d", &y3);

	AB = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
	BC = (x3-x2)*(x3-x2) + (y3-y2)*(y3-y2);
	CA = (x1-x3)*(x1-x3) + (y1-y3)*(y1-y3);
	
	printf("\nEnter AB:%d",AB);
	printf("\nEnter BC:%d",BC);
	printf("\nEnter CA:%d",CA);
	
	
	//right triangle at point B = CA
 	//right triangle at point A = BC
	//right triangle at point C = AB
	
	if(AB + BC == CA){
		printf("\nRight triangle at point B");
	}
	else if(AB + CA == BC){
		printf("\nRight triangle at point A\n");		
	}else if(BC + CA == AB){
		printf("\nright triangle at point C");
	
	}	
	else {
		printf("\nNot a Right Triangle\n");
	}
	
	return 0;

}
