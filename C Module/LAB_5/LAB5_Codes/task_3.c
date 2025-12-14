#include <stdio.h>


// Dot Product Function
float dot_product(int *a, int *b, int size) {
    float result = 0;
    for (int i = 0; i < size; i++) {
        result += a[i] * b[i];
    }
    return result;
}


void mux_vec(A[],x[]){

    int A[2][2];        // 2x2 matrix
    int x[2];           // 2x1 vector
    int result[2] = {0}; // result vector (2x1)
    int i, j;

    // Input for matrix A
    printf("Enter elements for 2x2 matrix A:\n");
    for(i = 0; i < 2; i++) {
        for(j = 0; j < 2; j++) {
            printf("A[%d][%d]: ", i, j);
            scanf("%d", &A[i][j]);
        }
    }

    // Input for vector x
    printf("Enter elements for 2x1 vector x:\n");
    for(i = 0; i < 2; i++) {
        printf("x[%d]: ", i);
        scanf("%d", &x[i]);
    }

    // Multiply A * x = result
    for(i = 0; i < 2; i++) {
        result[i] = 0; // initialize result[i]
        for(j = 0; j < 2; j++) {
            result[i] += dot_product(A[i], x[i]);
        }
    }

    // Print result
    printf("Result of A * x:\n");
    for(i = 0; i < 2; i++) {
        printf("result[%d] = %d\n", i, result[i]);
    }
    return result;
}

int main() {
 
    printf("Results: ");

    mux_vec(result);


    return 0;
}

