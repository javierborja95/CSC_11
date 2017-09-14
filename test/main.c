/* 
 * File:   main.c
 * Author: Javier Borja
 * Created on September , 2017,  PM
 * Purpose:
 */

//System Libraries
#include <stdio.h>  

//User Libraries

//Global Constants

//Function Prototypes
//void function(char*);
//Execution

int main(int argc, char** argv) {
    //Variables
    char array[5];
    //Input Data

    array[0]='A';
    array[3]='F';
    char *ptr=array;
    
    //Process Data
    
    //Output Data
    printf("%c \n",*(ptr+1));
    //function(string);
    
    return 0;
}

//void function(char* string){
//    printf("%*c\n",string[0]);
//}