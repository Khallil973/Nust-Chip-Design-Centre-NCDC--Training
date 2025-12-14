#include <stdio.h>

int main()
{
    int n;
    int bin[32];
    int i = 0;  

    printf("Enter a decimal number: ");
    scanf("%d", &n);

    printf("Octal: %o\n", n);
    printf("Hexadecimal: %X\n", n);  
    
    int temp = n;

    // Binary conversion logic
    while(temp > 0){
        bin[i] = temp % 2;
        temp = temp / 2;
        i++;
    }

    printf("Binary: ");
    if (n == 0)
        printf("0");
    else {
        for(int j = i - 1; j >= 0; j--) {
            printf("%d", bin[j]);
        }
    }

    printf("\n");

    return 0;
}
