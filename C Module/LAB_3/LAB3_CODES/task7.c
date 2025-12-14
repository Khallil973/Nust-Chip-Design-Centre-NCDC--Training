#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main() {
    int xt, yt; // Treasure coordinates
    int x, y;   // Loop variables

    // Initialize random seed
    srand(time(NULL));

    // Generate random treasure position within the grid (1 to 4)
    xt = rand() % 4 + 1; 
    yt = rand() % 4 + 1; 



    for (x = 1; x <= 4; x++) {
        for (y = 1; y <= 4; y++) {
            printf("Searching at (%d,%d)\n", x, y);
            if (x == xt && y == yt) {
                printf("Hurrah! I have found the hidden treasure at (%d,%d)\n", x, y);
                return 0; // exit the program once found
            }
        }
    }

    return 0;
}
