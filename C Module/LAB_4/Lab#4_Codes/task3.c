#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main() {
    int arr[10];
    int i, j;

    // Seed the random number generator
    srand(time(NULL));

    // Initialize array with random values between 1 and 20
    for(i = 0; i < 10; i++) {
        arr[i] = rand() % 20 + 1;
    }

    // Print the histogram
    printf("Element\tValue\tHistogram\n");
    for(i = 0; i < 10; i++) {
        printf("%d\t%d\t", i, arr[i]);

        // Print '*' for the value
        for(j = 0; j < arr[i]; j++) {
            printf("*");
        }
        printf("\n");
    }

    return 0;
}
