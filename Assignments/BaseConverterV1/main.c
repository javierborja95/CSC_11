/* 
 * File:   main.c
 * Author: Javier Borja
 * Created on September 13, 2017, 1:00 PM
 * Purpose: Converts base 10 to other bases
 */

//System Libraries
#include <stdio.h>  

//User Libraries

//Global Constants

//Function Prototypes
void base2(int,char*);
void base16(int,char*);

//Execution

int main(int argc, char** argv) {
    //Variables
    const int MAX=36;
    int x, choice;
    char array[MAX];    //Character array to print number
    char *ptr=array;    //Pointer to array
    
    //Initialize array
    for(int i=0;i<10;i++){
        array[i]=i+48;    //Characters '0'-'9'
    }
    for(int i=0;i<MAX-10;i++){
        array[i+10]=i+65; //Characters 'A'-'Z'
    }
    
    
    //for(int i=0;i<MAX;i++){
    //    printf("%c",array[i]);
    //}
    
    //Input Data
    printf("Type in your unsigned int to convert: ");
    scanf("%u",&x);
    printf("You typed in %i \n Input 1 to convert to base 2 \n "
            "Input 2 to convert to base 16\n", x);
    scanf("%u",&choice);
    printf("Your choice is: %i \n", choice);
    //Process Data
    if(choice==1){
        base2(x,array);
    }
    else if(choice==2)
        base16(x,array);
    else printf("Invalid choice\n");
    //Output Data
    
    return 0;
}

void base2(int x,char* array){
    char string[100];
    int size=0;
    for(int j=0;j<1;size++){
        string[size]=array[x%2];
        x/=2;
        if(x==0)
            j=1;
    }
    while(size>=0){
        printf("%c",string[size]);
        size--;
    }
}
void base16(int x,char* array){
    char string[100];
    int size=0;
    for(int j=0;j<1;size++){
        string[size]=array[x%16];
        x/=16;
        if(x==0)
            j=1;
    }
    while(size>=0){
        printf("%c",string[size]);
        size--;
    }
}