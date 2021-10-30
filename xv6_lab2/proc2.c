#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
    set_prior(15); // N being the priority value you assign to this proc
    int i,j;
    for (i = 0; i < 46000; i++) {
        asm("nop");
        for (j = 0; j < 46000; j++) {
            asm("nop");
        }
    }
    exit();
}