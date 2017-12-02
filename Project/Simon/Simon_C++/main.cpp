/* 
 * File:   main.cpp
 * Author: Javier Borja
 * Created on December 1, 2016, 10:00 AM
 * Purpose:  Simon
 */

//System Libraries Here
#include <iostream>
#include <ctime>
#include <cstdlib>
#include <cstdio>
using namespace std;

//User Libraries Here

//Global Constants Only, No Global Variables
//Like PI, e, Gravity, or conversions

//Function Prototypes Here
void menu();
void startGame(int[],int);
void setArr(int[],int);
void getArr(int[],int);
int getInput();
int mod(int,int);
void lose();
void buzz(int);
int compare(int[],int);
//Program Execution Begins Here
int main(int argc, char** argv) {
    //Seed
    srand(time(0));
    //Declare all Variables Here
    const int maxTurn=32;
    int flag=0;
    int input;
    int arr[maxTurn];
    //Input or initialize values Here
    while(flag==0){
        menu();
        input=getInput();
        if(input==0) startGame(arr,maxTurn);
        if(input==1) setArr(arr,maxTurn);
        if(input==2) ;
        if(input==3) flag=1;
    }
    //Process/Calculations Here
    
    //Output Located Here

    //Exit
    return 0;
}

void menu(){
    cout<<"0 Play\n1 SetArr\n2\n3 Exit"<<endl;
}
void startGame(int a[],int maxTurn){
    cout<<"Playing game"<<endl;
    for(int turn=0; turn<maxTurn; turn++){
        cout<<endl<<endl<<"turn ="<<turn+1<<endl;
        getArr(a,turn);
        if(compare(a,turn+1)==1) {lose(); return;}
    }
    cout<<"you win"<<endl;
}

int compare(int a[],int maxTurn){
    int input;
    for(int turn=0; turn<maxTurn; turn++){
        input=getInput();
        if(input!=(a[turn])) return 1;
    }
    return 0;
}
void setArr(int a[],int max){
    int i=0;
    do{
        a[i]=mod(rand(),4);
        cout<<a[i]<<" ";
        i++;
    }while(i<max);
    cout<<endl;
}

void getArr(int a[],int turn){
    cout<<"ai: ";
    int i=0;
    turn++;
    while(i<turn){
        buzz(a[i]);
        i++;
    }
    cout<<endl;
}

int getInput(){
    int input;
    scanf("%d",&input);
    cin.ignore();
    return (input);
}
int mod(int x,int mod){
    int q=x/mod;
    int p=q*mod;
    return x-p;
}
void lose(){
    cout<<"you lose"<<endl;
}
void buzz(int x){
    cout<<x<<" ";
}
