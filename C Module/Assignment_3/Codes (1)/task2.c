#include <stdio.h>

#define SIZE 10

int seats[SIZE] = {0}; // 0 = empty, 1 = booked

// Function to assign seat in range
int assignSeat(int start, int end) {
    for (int i = start; i <= end; i++) {
        if (seats[i] == 0) {
            seats[i] = 1;
            return i + 1; // seat number (1-indexed)
        }
    }
    return -1; // no seat available
}

int main() {
    int choice;
    char confirm;

    while (1) {
        printf("\n--- Airline Reservation Menu ---\n");
        printf("Please type 1 for \"First Class\"\n");
        printf("Please type 2 for \"Economy\"\n");
        printf("Enter your choice (or 0 to exit): ");
        scanf("%d", &choice);

        if (choice == 0) {
            printf("Exiting reservation system.\n");
            break;
        }

        if (choice == 1) {
            int seat = assignSeat(0, 4); // First class: index 0–4
            if (seat != -1) {
                printf("Boarding Pass: Seat #%d (First Class)\n", seat);
            } else {
                printf("First Class is full. Is Economy acceptable? (y/n): ");
                scanf(" %c", &confirm);
                if (confirm == 'y' || confirm == 'Y') {
                    seat = assignSeat(5, 9);
                    if (seat != -1) {
                        printf("Boarding Pass: Seat #%d (Economy)\n", seat);
                    } else {
                        printf("Next flight leaves in 3 hours.\n");
                    }
                } else {
                    printf("Next flight leaves in 3 hours.\n");
                }
            }
        } else if (choice == 2) {
            int seat = assignSeat(5, 9); // Economy: index 5–9
            if (seat != -1) {
                printf("Boarding Pass: Seat #%d (Economy)\n", seat);
            } else {
                printf("Economy is full. Is First Class acceptable? (y/n): ");
                scanf(" %c", &confirm);
                if (confirm == 'y' || confirm == 'Y') {
                    seat = assignSeat(0, 4);
                    if (seat != -1) {
                        printf("Boarding Pass: Seat #%d (First Class)\n", seat);
                    } else {
                        printf("Next flight leaves in 3 hours.\n");
                    }
                } else {
                    printf("Next flight leaves in 3 hours.\n");
                }
            }
        } else {
            printf("Invalid input. Please choose 1 or 2.\n");
        }
    }

    return 0;
}
