#include<stdio.h>

int main() {
	
	int min, sec;
	int n;
	
	
	printf("Enter Number:");
	scanf("%d",&n);
	
	for(min = 0; min < n; min++){
		for(sec = 0; sec < 60; sec++){
			printf("MM:SS (%d - %d)\n",min,sec);
}
}

return 0;
}

