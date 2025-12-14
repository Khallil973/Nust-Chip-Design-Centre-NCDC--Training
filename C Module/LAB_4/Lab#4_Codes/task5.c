#include<stdio.h>
#include<math.h>

int main(){

	float v[12] = {0.25,0.5,0.1,1.0,0.75,0.5,-0.5,-0.2,-0.75,-1.0,-0.75,-0.5};
	float sum;
	float avg;
	float drop;

	for(int i=0; i<11; i++){
		sum += v[i];
	}
	avg = sum/12;
	printf("DC (Average):%f\n", avg);
	
	
	for(int i=0; i<11; i++){
		if(v[i] * v[i+1] < 0){
		printf("Signal Crosses the X-axis between t =%d and t = %d\n", i, i+1);	
		}
	}
/*	
	
    // ---------- Part 3: Glitch Detection ----------
    printf("\nGlitch Detection:\n");
    for (int i = 0; i < 11; i++) {
        if (fabs(v[i] - v[i + 1])  > 0.25) {
                printf("    => Glitch detected at t = %d\n", i+1 );
            }
  
  }
  */
  
  
      // --------- PART 3: Glitch Detection (Valley drop check) ---------
    printf("\nGlitch Detection:\n");
    for (int i = 1; i < 11; i++) {
        if (v[i] < v[i - 1] && v[i] < v[i + 1]) {
            float drop = v[i - 1] - v[i];
            if (drop > 0.25) {
                printf("  Glitch detected at t = %d (drop = %.2f)\n", i, drop);
            }
        }
    }


	return 0;
}


