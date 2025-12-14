//Function defination file

int length(char sentence[]){
	int length = 0;
	while(sentence[length] != '\n'){
		length++;
	}
	return length;
	
}


void lowercase(char sentence[]){
	int i = 0;
	for(i=0; sentence[i] != '\n'; i++){
		if(sentence[i] >= 65 && sentence[i] <= 90){
			sentence[i] = sentence[i]+32;
	}

}
}

void uppercase(char sentence[]){
    int i = 0;
    for(i=0; sentence[i] != '\n'; i++){
        if(sentence[i] >= 97 && sentence[i] <= 122){
            sentence[i] = sentence[i] - 32;
        }
    }
}

// You must use return in a function when the function has a non-void return type, like int
int word(char sentence[]){
	    int i = 0;
        int word = 0;
        while(sentence[i] != '\n'){
        if(sentence[i] == ' '){
       		word++; 

      }
	      i++;      	
     }
     return word;
    }
	
//Function to count total number of vowels in the sentence
int vowelcount(char sentence[]){
	int i = 0;
    int count = 0;
	for(i = 0; sentence[i] != '\n'; i++){
        switch (sentence[i]) {
            	case 'A': case 'a': count++; 
            			    break;
            	case 'E': case 'e': count++;
            	 		    break;
            	case 'I': case 'i': count++; 
            			    break;
            	case 'O': case 'o': count++; 
            			    break;
            	case 'U': case 'u': count++; 
            			    break;
                break;
        }
        }
        return count;
    
    }

//function to count frequency of a specific vowel (A/a, E/e, etc.)
//char vowel define to compare the vowel through input
int vowelfreq(char sentence[], char vowel){
    int i = 0;
    int freq = 0;
    for(i = 0; sentence[i] != '\n'; i++){
        if(sentence[i] == vowel || sentence[i] == vowel + 32 || sentence[i] == vowel - 32){
            freq++;
        }
    }
    return freq;
}

