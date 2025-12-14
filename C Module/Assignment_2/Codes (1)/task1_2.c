#include <stdio.h>

int main() {
    float N, increment, i = 0;

    printf("Enter the limit N: ");
    scanf("%f", &N);

    printf("Enter the increment (must be > 0 and <= 1): ");
    scanf("%f", &increment);

    if (increment <= 0 || increment > 1.0) {
        printf("Error: Increment must be greater than 0 and less than or equal to 1.\n");
        return 0;
    }

    printf("Numbers from 0 to %.2f with increment %.2f:\n", N, increment);

    while (i <= N + 0.0001) {  // Added small margin to handle float comparison safely
        printf("%.2f ", i);
        i += increment;
    }

    printf("\n");
    return 0;
}
