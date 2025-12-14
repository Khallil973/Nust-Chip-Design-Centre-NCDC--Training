#include <stdio.h>

int main() {
    int n;
    int byte;
    int checksum = 0;
    int reciever_checksum = 0;
    int i;
    
    printf("Enter number of bytes: "); 
    scanf("%d", &n);
    
    printf("Enter sender bytes one by one:\n");   
    for (i = 0; i < n; i++) {
        scanf("%d", &byte);
        checksum = checksum ^ byte; // XOR operation
    }

    printf("Enter receiver bytes one by one:\n");       
    for (i = 0; i < n; i++) {
        scanf("%d", &byte);
        reciever_checksum = reciever_checksum ^ byte; // XOR operation
    }

    if (checksum == reciever_checksum) {
        printf("Data is Correct\n");
    } else {
        printf("Data is Not Correct\n");
    }

    return 0;
}
