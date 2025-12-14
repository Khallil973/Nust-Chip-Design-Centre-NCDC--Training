#include <stdio.h>

int main() {
    int row, col;
    char move;


    printf("Enter x1: ");
    scanf("%d", &row);
    printf("Enter y1: ");
    scanf("%d", &col);

    // Taking direction input from user
    printf("Input Move (U, D, L, R): ");
    scanf(" %c", &move);

    if(row < 1 || row > 4 || col < 1 || col > 4){
        printf("Invalid Starting Position. Range within 1 to 4.\n");
        return 0;
    }

    if (move == 'U') {
        if (row > 1) {
            row--;
        } else {
            printf("Invalid Move: Already at top edge!\n");
        }

    } else if (move == 'D') {
        if (row < 4) {
            row++;
        } else {
            printf("Invalid Move: Already at bottom edge!\n");
        }

    } else if (move == 'L') {
        if (col > 1) {
            col--;
        } else {
            printf("Invalid Move: Already at left edge!\n");
        }

    } else if (move == 'R') {
        if (col < 4) {
            col++;
        } else {
            printf("Invalid Move: Already at right edge!\n");
        }

    } else {
        printf("Invalid Direction Entered.\n");
    }

    // Final Position Output
    printf("Current Position: (%d, %d)\n", row, col);

    return 0;
}
