#include<stdio.h>
#include "string.h"  //created header file



int main(){

	char sentence[100];
	printf("Enter Sentence: ");
	fgets(sentence, 100, stdin);
	
	printf("Length of the Sentence: %d\n ", length(sentence));
	
	lowercase(sentence);
	printf("\nLowerCase: %s", sentence);

	uppercase(sentence);
	printf("\nUpperCase: %s", sentence);

    printf("\nNo of Words in the sentence: %d\n", word(sentence)+1);
	

    printf("\nTotal Vowels: %d\n", vowelcount(sentence));
    printf("Vowel Frequencies:\n");
    //Print frequency of each vowel
    //vowel as per the provided input
    printf("A/a: %d\n", vowelfreq(sentence, 'A'));
    printf("E/e: %d\n", vowelfreq(sentence, 'E'));
    printf("I/i: %d\n", vowelfreq(sentence, 'I'));
    printf("O/o: %d\n", vowelfreq(sentence, 'O'));
    printf("U/u: %d\n", vowelfreq(sentence, 'U'));




	return 0;
}