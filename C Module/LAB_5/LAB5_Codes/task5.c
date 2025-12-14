#include<stdio.h>
#include<math.h>


float average( float v[], int size){
    float sum = 0;
    for (int i = 0; i < size; i++){
        sum += v[i];
    }
    return sum / size;
}

void zero_cross(float v[], int size){
	for(int i=0; i < size - 1; i++){
        //from i = 0 to i < size, so v[i+1] accesses v[12] on last iteration when i = 11
		if(v[i] * v[i+1] < 0){// Opposite signs = crossing x-axis
		printf("Signal Crosses the X-axis between t =%d and t = %d\n", i, i+1);	
		}
	}
}

void glitch(float v[], int size){
    for (int i = 0; i < size; i++) {
        if (v[i] < v[i - 1] && v[i] < v[i + 1]) {
            float drop = v[i - 1] - v[i];
            if (drop > 0.25) {
                printf("  Glitch detected at t = %d (drop = %.2f)\n", i, drop);
            }
        }
    }
}

void filter_signal(float input[], float output[], int signal_size, float h[], int h_size) {
    for (int i = 0; i < signal_size; i++) {
        output[i] = 0;
        for (int j = 0; j < h_size; j++) {
            if (i - j >= 0) {
                output[i] += input[i - j] * h[j];  // convolution
            }
        }
    }
}

int main() {
    float v[12] = {0.25, 0.5, 0.1, 1.0, 0.75, 0.5, -0.5, -0.2, -0.75, -1.0, -0.75, -0.5};
    float filtered[12];
    float h[3] = {1.0/3, 1.0/3, 1.0/3};  // Simple moving average filter

    // Part 1
    float avg = average(v, 12);
    printf("DC (Average) Voltage: %.2f\n", avg);

    // Part 2
    printf("\nZero Crossing Detection:\n");
    zero_cross(v, 12);

    // Part 3
    printf("\nGlitch Detection:\n");
    glitch(v, 12);

    // Part 4
    printf("\nFiltered Signal (Moving Average):\n");
    filter_signal(v, filtered, 12, h, 3);
    for (int i = 0; i < 12; i++) {
        printf("t = %d, Filtered Value = %.2f\n", i, filtered[i]);
    }

    return 0;
}