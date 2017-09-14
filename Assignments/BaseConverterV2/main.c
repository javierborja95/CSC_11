/* 
 * File:   main.c
 * Author: Javier Borja
 * Created on September 13, 2017, 6:00 PM
 * Purpose: Converts base 10 number to other bases
 */

//System Libraries
#include <stdio.h>  

//User Libraries

//Global Constants

//Function Prototypes
void convert(int,int,char*);

//Execution

int main(int argc, char** argv) {
    //Variables
    const int MAX=36;   //Max base
    int n, base;        //number, new base
    char array[MAX];    //Array from [0-9]U[A-Z]
    char *ptr=array;    //Pointer to array
    
    //Initialize array
    for(int i=0;i<10;i++){
        array[i]=i+48;    //Characters '0'-'9'
    }
    for(int i=0;i<MAX-10;i++){
        array[i+10]=i+65; //Characters 'A'-'Z'
    }
    
    //Input Data
    printf("Type in unsigned int (base 10): ");
    scanf("%u",&n);
    printf("Input new base to convert: ");
    scanf("%u",&base);
    
    //Process Data
    convert(n,base,ptr);
    
    return 0;
}

void convert(int n,int base,char* array){
    //Variables
    char string[100]; //String to hold conversion
    int size=0;       //Size of string
    
    //Process Data
    for(int j=0;j<1;size++){ //j is a bool
        string[size]=array[n%base]; //Tack on remainder to string
        n/=base;                    //Reduce number by a factor of base
        if(n==0)                    //Break loop when done
            j=1;
    }
    
    //Output Data
    printf("\n%i (base 10) = ",n);
    while(size>=0){
        printf("%c",string[size]);
        size--;
    }
    printf(" (base %i)\n",base);
}