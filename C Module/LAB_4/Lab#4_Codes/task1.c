#include<stdio.h>



int main() {

	char sentence[100];

	int i = 0, length = 0;	
	int  word = 0;
	int vowelcount = 0, vowelfreq[5] = {0};
	
	printf("Enter Character: ");
	fgets(sentence,100, stdin);   //to call string without address &
	//fgets to call the input sentence and use 100 characters and using standard input 
	
	while(sentence[length] != '\n'){
		length++;
		
	}
	printf("Length of the Sentence: %d\n ", length);
	
	
	//A=65 - Z = 90
	for(i = 0; sentence[i] != '\n'; i++){
	if(sentence[i] >= 65 && sentence[i]<= 90){
		sentence[i] = sentence[i]+32;
	}
	printf("\nLowerCase:%c", sentence[i]);
	
	}
	printf("\n");
	//a=97 - z = 122
	i = 0;
	for(i = 0; sentence[i] != '\n'; i++){
	if(sentence[i] >= 97 && sentence[i]<= 122){
		sentence[i] = sentence[i]-32;
	}
	printf("\nUpperCase:%c", sentence[i]);
	}

	i = 0;
        while(sentence[i] != '\n'){
        if(sentence[i] == ' '){
       		word++; 

      }
	      i++;      	
     }

	printf("\nNo of Words in the sentence: %d", word+1);	

	i = 0;
	for(i = 0; sentence[i] != '\n'; i++){
        switch (sentence[i]) {
            	case 'A': case 'a': vowelcount++; 
            			    vowelfreq[0]++;
            			    break;
            	case 'E': case 'e': vowelcount++;
            	 		    vowelfreq[1]++;
            	 		    break;
            	case 'I': case 'i': vowelcount++; 
            			    vowelfreq[2]++; 
            			    break;
            	case 'O': case 'o': vowelcount++; 
            			    vowelfreq[3]++; 
            			    break;
            	case 'U': case 'u': vowelcount++; 
            			    vowelfreq[4]++; 
            			    break;
                break;
        }
        }
    

    printf("\nTotal Vowels: %d\n", vowelcount);
    printf("Vowel Frequencies:\n");
    printf("A/a: %d\n", vowelfreq[0]);
    printf("E/e: %d\n", vowelfreq[1]);
    printf("I/i: %d\n", vowelfreq[2]);
    printf("O/o: %d\n", vowelfreq[3]);
    printf("U/u: %d\n", vowelfreq[4]);

	return 0;
	
}


