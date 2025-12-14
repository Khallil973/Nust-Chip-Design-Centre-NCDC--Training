#include<stdio.h>

void calculation_dotproduct(int N){

	float x[N], y[N],result[N],dot_product = 0;
    int i;
		
	//Step input x vector
	printf("Enter element for vector x:");
	for(i = 0; i < N; i++){
		scanf("%f", &x[i]);
	}
		
	printf("Enter element for vector y:");
	for(i = 0; i < N; i++){
		scanf("%f", &y[i]);
	}
	printf("Result of Dot Product (x[i] * y[i]): ");	
	for(i = 0; i < N; i++){
		result[i] = x[i] * y[i];
        dot_product += result[i]; 
	
	}
    //output the result
	printf("%f\n", dot_product);
}





int main(){

	int N;
	int i;
	
	printf("Enter Number:");
	scanf("%d", &N);
	

    //call the function
    calculation_dotproduct(N);

    return 0;


}
