#include <stdio.h>
#include <stdlib.h>
#include <time.h>  // Needed for time()
int main()
{
    
int Limit = 100;
srand(time(NULL));
int N = rand() % Limit;
int guess;

while(guess != N){
printf("Guess the Number:");
scanf("%d", &guess);

if(guess < N){
    printf("\nNumber is Less than N:%d\n",N);
}else if (guess > N){
    printf("\nNumber is Greater than:%d\n", N);
}else if (guess == N){
    printf("\nGuess is Equal to N:%d\n", N);
}else {
    printf("\nInvalid\n");
    break;
}
}

return 0;
}
