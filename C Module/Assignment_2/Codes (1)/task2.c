#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main() {
    int N, toss, heads = 0, tails = 0;

    printf("Enter number of coin toss trials: ");
    scanf("%d", &N);

    srand(time(0));  // Seed for randomness

    for (int i = 0; i < N; i++) {
        toss = rand() % 2; // Generates 0 or 1
        if (toss == 1)
            heads++;
        else
            tails++;
    }

    printf("Heads: %d (%.2f%%)\n", heads, (heads * 100.0) / N);
    printf("Tails: %d (%.2f%%)\n", tails, (tails * 100.0) / N);

    return 0;
}
