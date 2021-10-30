#CS-153 Design of Operating System

##Lab 1 - Objectives

* Understand the system call interface
* Understand how user programs send parameters to the kernel, and receive values back
* See how the event handling in the Operating System works
* Understand the process structure and modify it

##Lab 2 - Objectives

Implement Priority Scheduling
* We change the scheduler from a simple round-robin to a priority scheduler. Add a priority value to each process (lets say taking a range between 0 to 31). The range does not matter, it is just a proof of concept. When scheduling from the ready list you will always schedule the highest priority process (the one with the lowest value) first.
* Add a system call to change the priority of a process. A process can change its priority at any time. If the priority becomes lower than any process on the ready list, you must switch to that process.
* To avoid starvation, you need to implement aging of priority. If a process waits increase its priority (decrease its value). When it runs, decrease it (increase its value).
* We also need to add fields to track the scheduling performance of each process. These values should allow you to compute the turnaround time and wait time for each process. Add a system call to extract these values or alternatively print them out when the process exits.

##Lab 3 - Objectives

* Modify memory layout to move stack to top of address space
* Implement stack growth

##Lab 4 - Objectives

* Implement Shared Memory
