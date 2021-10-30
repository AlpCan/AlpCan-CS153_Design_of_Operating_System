#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct shm_page {
    uint id;
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
  int i;
  initlock(&(shm_table.lock), "SHM lock");
  acquire(&(shm_table.lock));
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
    shm_table.shm_pages[i].frame =0;
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
}

int shm_open(int id, char **pointer) {

//you write this

    struct proc *current_process = myproc();
    uint sz = PGROUNDUP(current_process->sz);

    acquire(&(shm_table.lock));

    int i; int j = 64;
    int id_existence = 0;

    for(i = 0 ; i < 64 ; i++){ //there are 64 pages
        if(j == 64 && shm_table.shm_pages[i].id == 0) {//segment id does not exist
            j = i;//store the first empty page number
        }
        if(shm_table.shm_pages[i].id == id){//segment id exist
            id_existence = 1;
            // add the mapping between the virtual address and the physical address
            mappages(current_process->pgdir , (char *)sz, PGSIZE, V2P(shm_table.shm_pages[i].frame), PTE_W|PTE_U);
            //increase the refence count
            shm_table.shm_pages[i].refcnt++;
            break;
        }
    }

    //if we did not find the segment id, allocate a page and map it, and store this information in the shm_table
    if(id_existence == 0 && j < 64){
        shm_table.shm_pages[j].id = id;
        shm_table.shm_pages[j].frame = kalloc();
        memset(shm_table.shm_pages[j].frame, 0, PGSIZE);
        mappages(current_process->pgdir, (char *)sz, PGSIZE, V2P(shm_table.shm_pages[j].frame), PTE_W|PTE_U);
        shm_table.shm_pages[j].refcnt++;
    }

    current_process->sz = sz + PGSIZE;//increase the number of pages
    *pointer = (char *)sz;//update the pointer

    release(&(shm_table.lock));

    return id_existence; //added to remove compiler warning -- you should decide what to return
}


int shm_close(int id) {
//you write this too!
    int resultRefcnt;
    acquire(&(shm_table.lock));

    int i;

    for(i = 0 ; i < 64 ; i++) { //there are 64 pages
        if (shm_table.shm_pages[i].id == id) {//segment id exist
            if(shm_table.shm_pages[i].refcnt == 1){
                shm_table.shm_pages[i].id = 0;
                shm_table.shm_pages[i].frame = 0;
                shm_table.shm_pages[i].refcnt = 0;
                break;
            }
            if(shm_table.shm_pages[i].refcnt > 1){
                shm_table.shm_pages[i].refcnt--;
            }
        }
    }
    resultRefcnt = shm_table.shm_pages[id].refcnt;
    release(&(shm_table.lock));


    return resultRefcnt; //added to remove compiler warning -- you should decide what to return
}
