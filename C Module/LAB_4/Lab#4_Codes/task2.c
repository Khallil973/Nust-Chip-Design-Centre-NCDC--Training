#include<stdio.h>

int main(){

	int N;
	int i;
	
	printf("Enter Number:");
	scanf("%d", &N);
	
	float a, b;
	float x[N], y[N],result[N];
	
	printf("Enter scalar a: ");
	scanf("%f", &a);
	
	printf("Enter scalar b: ");
	scanf("%f", &b);
		
	//Step input x vector
	printf("Enter element for vector a:");
	for(i = 0; i < N; i++){
		scanf("%f", &x[i]);
	}
		
	printf("Enter element for vector b:");
	for(i = 0; i < N; i++){
		scanf("%f", &y[i]);
	}
	printf("Result of axpy (a*x + b*y):");	
	for(i = 0; i < N; i++){
		result[i] = a*x[i] + b *y[i];
		printf("\n%f\n", result[i]);
	}
	

	


return 0;

}



