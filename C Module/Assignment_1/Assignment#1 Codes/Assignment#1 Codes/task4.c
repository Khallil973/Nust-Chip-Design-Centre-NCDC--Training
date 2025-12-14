#include <stdio.h>

int main() {
    float M1, M2, d, F;

    // Gravitational constant
    float k = 0.0000000667;

    // Input masses and distance
    printf("Enter mass of body 1 (in grams): ");
    scanf("%f", &M1);

    printf("Enter mass of body 2 (in grams): ");
    scanf("%f", &M2);

    printf("Enter distance between the bodies (in cm): ");
    scanf("%f", &d);

    // Calculate force
    F = k * (M1 * M2) / (d * d);

    // Output result
    printf("Gravitational Force: %f \n", F);

    return 0;
}
