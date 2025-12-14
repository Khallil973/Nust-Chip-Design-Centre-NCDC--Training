//strin.h

//header files to Declare the function prototypes for custom string operations (like length(), lowercase(), uppercase(), etc.).
//header guards to prevent the files from duplication
//ifndef endif
#ifndef STRING.H
#define STRING_H

int length(char sentence[]);
void lowercase(char sentence[]);
void uppercase(char sentence[]);
int word(char sentence[]);
int vowelcount(char sentence[]);
int vowelfreg(char sentence[], char vowel);


#endif