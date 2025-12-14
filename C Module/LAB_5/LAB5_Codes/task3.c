#include <stdio.h>

// Function to calculate dot product of two vectors
int dot_product(int *a, int *b, int size) {
    int result = 0;
    for (int i = 0; i < size; i++) {
        result += a[i] * b[i];
    }
    return result;
}

// Function to perform matrix-vector multiplication
void matrix_vector_multiply(int A[][2], int x[], int result[], int M, int N) {
    for (int i = 0; i < M; i++) {
        result[i] = dot_product(A[i], x, N);
        //A*x*N to multiply with N no of array
    }
}

int main() {
    int A[2][2];        // 2x2 matrix
    int x[2];           // 2x1 vector
    int result[2];      // Resulting vector (2x1)

    // Input matrix A
    printf("Enter elements for 2x2 matrix A:\n");
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            printf("A[%d][%d]: ", i, j);
            scanf("%d", &A[i][j]);
        }
    }

    // Input vector x
    printf("Enter elements for 2x1 vector x:\n");
    for (int i = 0; i < 2; i++) {
        printf("x[%d]: ", i);
        scanf("%d", &x[i]);
    }

    // Call matrix-vector multiply function
    matrix_vector_multiply(A, x, result, 2, 2);

    // Print result
    printf("\nResult vector (y = A * x):\n");
    for (int i = 0; i < 2; i++) {
        printf("result[%d] = %d\n", i, result[i]);
    }

    return 0;
}




