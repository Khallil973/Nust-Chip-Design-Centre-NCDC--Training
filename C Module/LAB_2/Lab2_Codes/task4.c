#include <stdio.h>
#include <math.h>

int main() {
    int a[5] ,temp, mode, count, maxCount = 0;
    float sum = 0, mean, median, std = 0;


    printf("Enter 5 numbers:\n");
    for (int i = 0; i < 5; i++) {
        scanf("%d", &a[i]);
        sum += a[i];
    }

    // Mean
    mean = sum / 5;
    printf("\nMean = %f\n", mean);

    // Sort for median & mode
    for (int i = 0; i < 5 - 1; i++) {
        for (int j = i + 1; j < 5; j++) {
            if (a[i] > a[j]) {
                temp = a[i];
                a[i] = a[j];
                a[j] = temp;
            }
        }
    }

    // Median
    median = a[2];
    printf("Median = %f\n", median);
    
    
    // Mode
    for (int i = 0; i < 5; i++) {
        count = 1;
        for (int j = i + 1; j < 5; j++) {
            if (a[i] == a[j])
                count++;
        }
        if (count > maxCount) {
            maxCount = count;
            mode = a[i];
        }
    }
    
    if (maxCount > 1)
        printf("Mode = %d\n", mode);
    else
        printf("Mode = No mode (all unique)\n");
        
        
   

    // Std Dev
    for (int i = 0; i < 5; i++) {
        std += (a[i] - mean) * (a[i] - mean);
    }
    std = sqrt(std / 5);

    printf("Standard Deviation = %f\n", std);

    return 0;
}
