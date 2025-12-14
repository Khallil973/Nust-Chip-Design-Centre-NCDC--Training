#include <stdio.h>

int main() {
    int runs[5], balls[5];
    int totalRuns, totalBalls;
    int min, max = -1, cen;
    float SR, av;

    printf("Enter stats for 5 matches of Babar Azam:\n");

    for(int i = 0; i < 5; i++) {
        printf("Match %d - Runs: ", i+1);
        scanf("%d", &runs[i]);

        printf("Match %d - Balls: ", i+1);
        scanf("%d", &balls[i]);

        totalRuns += runs[i];
        totalBalls += balls[i];

        if (runs[i] < min){
            min = runs[i];
   }
        else if (runs[i] > max){
            max = runs[i];
   }
        else if (runs[i] > 100){
            cen++;
     }
    }

	 SR = totalRuns / totalBalls * 100;
	 av = (totalRuns) / 10;

    printf("\nBabar Azam Stats for 5 Matches\n");
    printf("Total Runs = %d\n", totalRuns);
    printf("Strike Rate = %f\n", SR);
    printf("Batting Average = %f\n", av);
    printf("Minimum Score = %d\n", min);
    printf("Maximum Score = %d\n", max);
    printf("Centuries = %d\n", cen);

    return 0;
}


