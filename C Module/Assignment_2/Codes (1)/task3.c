#include <stdio.h>

int main() {
    int N, combinations;

    printf("Enter number of toy types: ");
    scanf("%d", &N);

    if (N < 2) {
        printf("At least two toy types are needed for a pair.\n");
        return 0;
    }

    combinations = (N * (N - 1)) / 2;
    printf("Number of unique pairs: %d\n", combinations);

    return 0;
}
