#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]){
    set_prior(0);
    int pid,pid1,pid2;
    printf(1,"%d's priority %d at start \n", getpid(), get_prior());
    pid = fork();
    if(pid == 0) {
        set_prior(30);
        printf(1,"child %d's priority %d at start \n",getpid(), get_prior());
        int i, j;
        for (i = 0; i < 5000; i++) {
            asm("nop");
            for (j = 0; j < 100000; j++) {
                asm("nop");
                //printf(1,"test1's priority %d \n", get_prior());
            }
            if(i%1000 == 0)
                printf(1,"child %d's priority %d in between \n",getpid(), get_prior());
        }
        printf(1,"child %d's priority %d at end \n",getpid(), get_prior());
        exit();
    }
    pid1 = fork();
    if(pid1 == 0) {
        set_prior(15);
        printf(1,"child %d's priority %d at start \n",getpid(), get_prior());
        int i, j;
        for (i = 0; i < 5000; i++) {
            asm("nop");
            for (j = 0; j < 100000; j++) {
                asm("nop");
                //printf(1,"test1's priority %d \n", get_prior());
            }
            if(i%1000 == 0)
                printf(1,"child %d's priority %d in between \n",getpid(), get_prior());
        }
        printf(1,"child %d's priority %d at end \n",getpid(), get_prior());
        exit();
    }
    pid2 = fork();
    if(pid2 == 0) {
        set_prior(0);
        printf(1,"child %d's priority %d at start \n",getpid(), get_prior());
        int i, j;
        for (i = 0; i < 5000; i++) {
            asm("nop");
            for (j = 0; j < 100000; j++) {
                asm("nop");
                //printf(1,"test1's priority %d \n", get_prior());
            }
            if(i%1000 == 0)
                printf(1,"child %d's priority %d in between \n",getpid(), get_prior());
        }
        printf(1,"child %d's priority %d at end \n",getpid(), get_prior());
        exit();
    }
    if(pid > 0){
            wait();
    }
    if( pid1 > 0){
        wait();
    }
    if(pid2 > 0){
        wait();
    }
    exit();
}