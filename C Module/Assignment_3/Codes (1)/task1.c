#include <stdio.h>

int main() {
    int population[10];
    int i, max, min;
    float avg = 0;

    // Input population of 10 cities
    printf("Enter population of 10 cities:\n");
    for (i = 0; i < 10; i++) {
        printf("City %d: ", i + 1);
        scanf("%d", &population[i]);
    }

    // Reverse Order
    printf("\nPopulation in Reverse Order:\n");
    for (i = 9; i >= 0; i--) {
        printf("City %d: %d\n", i + 1, population[i]);
    }

    // Max, Min, and Average
    max = min = population[0];
    for (i = 0; i < 10; i++) {
        if (population[i] > max){
            max = population[i];
        }
        if (population[i] < min){
            min = population[i];
        }
        avg += population[i];
    }

    avg = avg/10; // avg /= avg

    printf("\nMaximum Population: %d\n", max);
    printf("Minimum Population: %d\n", min);
    printf("Average Population: %.2f\n", avg);

    return 0;
}
