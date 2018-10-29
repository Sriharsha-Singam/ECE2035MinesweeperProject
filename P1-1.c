/*    This program solves a minesweeper game.
 
 PLEASE FILL IN THESE FIELDS:
 Your Name: Sriharsha Singam
 Date: 23rd September 2018
 */

#include "minefield.h"

int arr[100] = {-3,-3,-3,-3,-3,-3,-3,-3,   -3,-3,-3,-2, -2,-2,-2,-2 , -2,-2,-2,-3 , -3,-2,-2,-2 , -2,-2,-2,-2 , -2,-3,-3,-2 , -2,-2,-2,-2 , -2,-2,-2,-3 , -3,-2,-2,-2 , -2,-2,-2,-2 , -2,-3,-3,-2 , -2,-2,-2,-2 , -2,-2,-2,-3 , -3,-2,-2,-2 , -2,-2,-2,-2 , -2,-3,-3,-2 , -2,-2,-2,-2 , -2,-2,-2,-3 , -3,-2,-2,-2 , -2,-2,-2,-2 , -2,-3,-3,-3 , -3,-3,-3,-3 , -3,-3,-3,-3};     //Array that holds the entire minefield matrix -- "-2" state means unopened
int numberAdd[8] = {1,11,10,9,-1,-11,-10,-9};
int checkNotOpenOrFlag(int in, int openOrFlag, int check);
int getX(int in){
    int x = (in%10);
    x = (in - x)/10;
    return (x-1);
}
int getY(int in){
    int y = (in%10);
    return (y-1);
}
int changeToOne(int x, int y){return (((x+1)*10)+y+1);}
int checkSides(int in){
    int z = 0;
    int value = arr[in];                      //$6
    int notOpen = checkNotOpenOrFlag(in ,0,-2);   //
    int flags = checkNotOpenOrFlag(in ,0,-1);     // -1 == 9
    int neededFlags = value - flags;
    if(flags == value){
        checkNotOpenOrFlag(in,-1,0);
        z++;
    }
    if(notOpen == neededFlags){
        checkNotOpenOrFlag(in,-2,0);
        z++;
    }
    return z;
}

int checkNotOpenOrFlag(int in, int openOrFlag, int check){
    int num = 0;
    for(int c = 0; c < 8; c++){
        if(arr[in + numberAdd[c]] != -3){
            if(openOrFlag == 0){
                if(arr[in + numberAdd[c]] == check)
                    num++;
            }
            if(openOrFlag == -1 && arr[in + numberAdd[c]] == -2)
                arr[in+numberAdd[c]] = open(getX(in + numberAdd[c]), getY(in + numberAdd[c]));
            if(openOrFlag == -2 && arr[in + numberAdd[c]] == -2){
                flag(getX(in + numberAdd[c]), getY(in + numberAdd[c]));
                arr[in+numberAdd[c]] = -1;
            }
        }
    }
    return num;
}
void solver(int mn){
    for(int i = 0; i < 10; i++){
        for(int j = 0; j < 10; j++){
            int in = changeToOne(i, j);
            if(arr[in] != -2 && arr[in] != -3 && arr[in] != -1 && arr[in] != 10){
                if(checkSides(in) != 0){
                    arr[in] = 10;
                    solver(mn);
                }
            }
        }
    }
   for(int i = 0; i < 10; i++){
       for(int j = 0; j < 10; j++){
           int in = changeToOne(i, j);
           if(arr[in] == -2){
               arr[in] = guess(getX(in),getY(in));
               solver(mn);
            }
        }
    }
                   
}
