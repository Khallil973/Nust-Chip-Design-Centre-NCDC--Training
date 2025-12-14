#include <stdio.h>

#define ROWS 4
#define COLS 4
//Avoid dynamic memory complications.

// Function 1: Find pixel type (black=0, white=1, yellow=2)
void find_pixel_type(unsigned char img[ROWS][COLS][3], int type) {
    int count = 0;
    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
            unsigned char R = img[i][j][0];
            unsigned char G = img[i][j][1];
            unsigned char B = img[i][j][2];

            if (type == 0 && R == 0 && G == 0 && B == 0)
                count++;
            else if (type == 1 && R == 255 && G == 255 && B == 255)
                count++;
            else if (type == 2 && R == 255 && G == 255 && B == 0)
                count++;
        }
    }

    if (type == 0) printf("Black pixels: %d\n", count);
    else if (type == 1) printf("White pixels: %d\n", count);
    else if (type == 2) printf("Yellow pixels: %d\n", count);
}

// Function 2: RGB to Grayscale conversion
void rgb_to_grayscale(unsigned char img[ROWS][COLS][3], float gray[ROWS][COLS]) {
    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
            unsigned char R = img[i][j][0];
            unsigned char G = img[i][j][1];
            unsigned char B = img[i][j][2];
            gray[i][j] = 0.2989 * R + 0.5870 * G + 0.1140 * B;
        }
    }
}

// Function 3: Apply 3x3 mean filter
void apply_filter(float input[ROWS][COLS], float output[ROWS][COLS]) {
    float filter[3][3] = {
        {1.0/9, 1.0/9, 1.0/9},
        {1.0/9, 1.0/9, 1.0/9},
        {1.0/9, 1.0/9, 1.0/9}
    };

    for (int i = 1; i < ROWS - 1; i++) {
        for (int j = 1; j < COLS - 1; j++) {
            float sum = 0.0;
            for (int fi = -1; fi <= 1; fi++) {
                for (int fj = -1; fj <= 1; fj++) {
                    sum += input[i + fi][j + fj] * filter[fi + 1][fj + 1];
                }
            }
            output[i][j] = sum;
        }
    }
}

int main() {
    // Sample image with known RGB colors
    unsigned char image[ROWS][COLS][3] = {
        { {0,0,0}, {255,255,255}, {255,255,0}, {100,100,100} },
        { {255,255,0}, {0,0,0}, {255,255,255}, {200,200,200} },
        { {255,255,255}, {255,255,0}, {0,0,0}, {50,50,50} },
        { {255,255,0}, {100,100,100}, {0,0,0}, {255,255,255} }
    };

    float gray[ROWS][COLS];
    float blurred[ROWS][COLS] = {0};

    // 1. Pixel Type Detection
    find_pixel_type(image, 0); // black
    find_pixel_type(image, 1); // white
    find_pixel_type(image, 2); // yellow

    // 2. RGB to Grayscale
    rgb_to_grayscale(image, gray);
    printf("\nGrayscale Image:\n");
    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
            printf("%.1f\t", gray[i][j]);
        }
        printf("\n");
    }

    // 3. Convolution using Mean Filter
    apply_filter(gray, blurred);
    printf("\nBlurred Image (Mean Filter):\n");
    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
            printf("%.1f\t", blurred[i][j]);
        }
        printf("\n");
    }

    return 0;
}
