#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]){
    set_prior(31);
    int i,j;
    for(i = 0 ; i < 10000 ; i++){
        asm("nop");
        for(j = 0 ; j < 10000 ; j++) {
            asm("nop");
        }
    }
    exit(0);
}

