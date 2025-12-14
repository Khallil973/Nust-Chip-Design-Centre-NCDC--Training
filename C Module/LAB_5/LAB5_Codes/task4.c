#include <stdio.h>

float dot_product(float a[], float b[], int n) {
    float sum = 0;
    for (int i = 0; i < n; i++) {
        sum += a[i] * b[i];
    }
    return sum;
}

// Transpose function to convert columns of B into rows of BT
void transpose(float B[10][10], float BT[10][10], int N, int K) {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < K; j++) {
            BT[j][i] = B[i][j];  // Flip rows and columns
        }
    }
}

// Matrix multiplication using dot products (A * B = C)
void matrix_mul(float A[10][10], float BT[10][10], float C[10][10], int M, int N, int K) {
    for (int i = 0; i < M; i++) {         // For each row of A
        for (int j = 0; j < K; j++) {     // For each column of B (now row of BT)
            C[i][j] = dot_product(A[i], BT[j], N);
        }
    }
}

int main() {
    int M, N, K;
    float A[10][10], B[10][10], BT[10][10], C[10][10];

    // Input matrix sizes
    printf("Enter size of Matrix A (MxN): ");
    scanf("%d %d", &M, &N);

    printf("Enter size of Matrix B (NxK): ");
    scanf("%d %d", &N, &K);

    // Input Matrix A
    printf("Enter elements of Matrix A (%dx%d):\n", M, N);
    for (int i = 0; i < M; i++) {
        for (int j = 0; j < N; j++) {
            scanf("%f", &A[i][j]);
        }
    }

    // Input Matrix B
    printf("Enter elements of Matrix B (%dx%d):\n", N, K);
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < K; j++) {
            scanf("%f", &B[i][j]);
        }
    }

    // Step 1: Transpose B into BT
    transpose(B, BT, N, K);

    // Step 2: Multiply using dot products
    matrix_mul(A, BT, C, M, N, K);

    // Output Result
    printf("Resultant Matrix C = A x B:\n");
    for (int i = 0; i < M; i++) {
        for (int j = 0; j < K; j++) {
            printf("%.2f ", C[i][j]);
        }
        printf("\n");
    }

    return 0;
}
