#include<stdio.h>


int main(){

	int row,col;
	char move;
	
	printf("Entwer Starting Position x1:");
	scanf("%d", &row);
	printf("Entwer Starting Position y1:");
	scanf("%d", &col);
	
	printf("INput Move:");
	scanf("\n%c", &move);	
		
		
		if(move == 'U'){
			if(row > 1){
				row--;
			}
			else {
				printf("Invalid Move:");			
			}
			
		}else if(move == 'D'){
			if(row < 4){
				row++;
			}
			else {
				printf("Invalid Move:");			
			}
			
		}else if(move == 'L'){
			if(col > 1){
				col--;
			}
			else {
				printf("Invalid Move:");			
			}
			
		}else if(move == 'R'){
			if(col < 4){
				col++;
			}
			else {
				printf("Invalid Move:");			
			}
			
		}else {
			printf("Invalid Direction Entered.\n");
		}
		
		
	printf("Current Position: (%d, %d)\n", row, col);	
		
	
	
	
	

s


	return 0;
}
