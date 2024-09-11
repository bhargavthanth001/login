// Online C compiler to run C program online
#include <stdio.h>

int main() {
    for(int i = 0; i <= 5; i++){
        for(int j = 0; j <= 30;j++){
            if(i == 0 || i == 5 || j == 0 || j == 30){
                printf("*");
            }
            else{
                if ((i == 1 && j == 26) ||
                    (i == 2 && (j == 21 || j == 26)) ||
                    (i == 3 && j == 5) ||
                    (i == 4 && (j == 5 || j == 10))) {
                    printf("#");
                } else {
                    printf(" ");
                }
            }
        }
        printf("\n");
    }
}
