
_test1:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	83 ec 10             	sub    $0x10,%esp
    set_prior(0);
   c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  13:	e8 4a 05 00 00       	call   562 <set_prior>
    int pid,pid1,pid2;
    printf(1,"%d's priority %d at start \n", getpid(), get_prior());
  18:	e8 4d 05 00 00       	call   56a <get_prior>
  1d:	89 c3                	mov    %eax,%ebx
  1f:	e8 1e 05 00 00       	call   542 <getpid>
  24:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  28:	c7 44 24 04 88 09 00 	movl   $0x988,0x4(%esp)
  2f:	00 
  30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  37:	89 44 24 08          	mov    %eax,0x8(%esp)
  3b:	e8 e0 05 00 00       	call   620 <printf>
    pid = fork();
  40:	e8 75 04 00 00       	call   4ba <fork>
    if(pid == 0) {
  45:	85 c0                	test   %eax,%eax
    pid = fork();
  47:	89 c7                	mov    %eax,%edi
    if(pid == 0) {
  49:	0f 85 c9 00 00 00    	jne    118 <main+0x118>
        set_prior(30);
  4f:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
            asm("nop");
            for (j = 0; j < 100000; j++) {
                asm("nop");
                //printf(1,"test1's priority %d \n", get_prior());
            }
            if(i%1000 == 0)
  56:	be d3 4d 62 10       	mov    $0x10624dd3,%esi
        set_prior(30);
  5b:	e8 02 05 00 00       	call   562 <set_prior>
        printf(1,"child %d's priority %d at start \n",getpid(), get_prior());
  60:	e8 05 05 00 00       	call   56a <get_prior>
  65:	89 c3                	mov    %eax,%ebx
  67:	e8 d6 04 00 00       	call   542 <getpid>
  6c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
        for (i = 0; i < 5000; i++) {
  70:	31 db                	xor    %ebx,%ebx
        printf(1,"child %d's priority %d at start \n",getpid(), get_prior());
  72:	c7 44 24 04 a4 09 00 	movl   $0x9a4,0x4(%esp)
  79:	00 
  7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  81:	89 44 24 08          	mov    %eax,0x8(%esp)
  85:	e8 96 05 00 00       	call   620 <printf>
  8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            asm("nop");
  90:	90                   	nop
  91:	ba a0 86 01 00       	mov    $0x186a0,%edx
  96:	66 90                	xchg   %ax,%ax
                asm("nop");
  98:	90                   	nop
            for (j = 0; j < 100000; j++) {
  99:	83 ea 01             	sub    $0x1,%edx
  9c:	75 fa                	jne    98 <main+0x98>
            if(i%1000 == 0)
  9e:	89 d8                	mov    %ebx,%eax
  a0:	f7 ee                	imul   %esi
  a2:	89 d8                	mov    %ebx,%eax
  a4:	c1 f8 1f             	sar    $0x1f,%eax
  a7:	c1 fa 06             	sar    $0x6,%edx
  aa:	29 c2                	sub    %eax,%edx
  ac:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
  b2:	39 d3                	cmp    %edx,%ebx
  b4:	74 38                	je     ee <main+0xee>
        for (i = 0; i < 5000; i++) {
  b6:	83 c3 01             	add    $0x1,%ebx
  b9:	81 fb 88 13 00 00    	cmp    $0x1388,%ebx
  bf:	75 cf                	jne    90 <main+0x90>
                //printf(1,"test1's priority %d \n", get_prior());
            }
            if(i%1000 == 0)
                printf(1,"child %d's priority %d in between \n",getpid(), get_prior());
        }
        printf(1,"child %d's priority %d at end \n",getpid(), get_prior());
  c1:	e8 a4 04 00 00       	call   56a <get_prior>
  c6:	89 c3                	mov    %eax,%ebx
  c8:	e8 75 04 00 00       	call   542 <getpid>
  cd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  d1:	c7 44 24 04 ec 09 00 	movl   $0x9ec,0x4(%esp)
  d8:	00 
  d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  e4:	e8 37 05 00 00       	call   620 <printf>
        exit();
  e9:	e8 d4 03 00 00       	call   4c2 <exit>
                printf(1,"child %d's priority %d in between \n",getpid(), get_prior());
  ee:	e8 77 04 00 00       	call   56a <get_prior>
  f3:	89 c7                	mov    %eax,%edi
  f5:	e8 48 04 00 00       	call   542 <getpid>
  fa:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  fe:	c7 44 24 04 c8 09 00 	movl   $0x9c8,0x4(%esp)
 105:	00 
 106:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 10d:	89 44 24 08          	mov    %eax,0x8(%esp)
 111:	e8 0a 05 00 00       	call   620 <printf>
 116:	eb 9e                	jmp    b6 <main+0xb6>
    pid1 = fork();
 118:	e8 9d 03 00 00       	call   4ba <fork>
    if(pid1 == 0) {
 11d:	85 c0                	test   %eax,%eax
    pid1 = fork();
 11f:	89 c6                	mov    %eax,%esi
    if(pid1 == 0) {
 121:	0f 85 9c 00 00 00    	jne    1c3 <main+0x1c3>
        set_prior(15);
 127:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
            if(i%1000 == 0)
 12e:	be d3 4d 62 10       	mov    $0x10624dd3,%esi
        set_prior(15);
 133:	e8 2a 04 00 00       	call   562 <set_prior>
        printf(1,"child %d's priority %d at start \n",getpid(), get_prior());
 138:	e8 2d 04 00 00       	call   56a <get_prior>
 13d:	89 c3                	mov    %eax,%ebx
 13f:	e8 fe 03 00 00       	call   542 <getpid>
 144:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
        for (i = 0; i < 5000; i++) {
 148:	31 db                	xor    %ebx,%ebx
        printf(1,"child %d's priority %d at start \n",getpid(), get_prior());
 14a:	c7 44 24 04 a4 09 00 	movl   $0x9a4,0x4(%esp)
 151:	00 
 152:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 159:	89 44 24 08          	mov    %eax,0x8(%esp)
 15d:	e8 be 04 00 00       	call   620 <printf>
            asm("nop");
 162:	90                   	nop
 163:	ba a0 86 01 00       	mov    $0x186a0,%edx
                asm("nop");
 168:	90                   	nop
            for (j = 0; j < 100000; j++) {
 169:	83 ea 01             	sub    $0x1,%edx
 16c:	75 fa                	jne    168 <main+0x168>
            if(i%1000 == 0)
 16e:	89 d8                	mov    %ebx,%eax
 170:	f7 ee                	imul   %esi
 172:	89 d8                	mov    %ebx,%eax
 174:	c1 f8 1f             	sar    $0x1f,%eax
 177:	c1 fa 06             	sar    $0x6,%edx
 17a:	29 c2                	sub    %eax,%edx
 17c:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
 182:	39 d3                	cmp    %edx,%ebx
 184:	74 12                	je     198 <main+0x198>
        for (i = 0; i < 5000; i++) {
 186:	83 c3 01             	add    $0x1,%ebx
 189:	81 fb 88 13 00 00    	cmp    $0x1388,%ebx
 18f:	75 d1                	jne    162 <main+0x162>
 191:	e9 2b ff ff ff       	jmp    c1 <main+0xc1>
 196:	66 90                	xchg   %ax,%ax
                printf(1,"child %d's priority %d in between \n",getpid(), get_prior());
 198:	e8 cd 03 00 00       	call   56a <get_prior>
 19d:	89 c7                	mov    %eax,%edi
 19f:	90                   	nop
 1a0:	e8 9d 03 00 00       	call   542 <getpid>
 1a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
 1a9:	c7 44 24 04 c8 09 00 	movl   $0x9c8,0x4(%esp)
 1b0:	00 
 1b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1b8:	89 44 24 08          	mov    %eax,0x8(%esp)
 1bc:	e8 5f 04 00 00       	call   620 <printf>
 1c1:	eb c3                	jmp    186 <main+0x186>
    pid2 = fork();
 1c3:	e8 f2 02 00 00       	call   4ba <fork>
    if(pid2 == 0) {
 1c8:	85 c0                	test   %eax,%eax
    pid2 = fork();
 1ca:	89 c3                	mov    %eax,%ebx
 1cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pid2 == 0) {
 1d0:	74 28                	je     1fa <main+0x1fa>
    }
    if(pid > 0){
 1d2:	85 ff                	test   %edi,%edi
 1d4:	7e 05                	jle    1db <main+0x1db>
            wait();
 1d6:	e8 ef 02 00 00       	call   4ca <wait>
    }
    if( pid1 > 0){
 1db:	85 f6                	test   %esi,%esi
 1dd:	8d 76 00             	lea    0x0(%esi),%esi
 1e0:	7e 05                	jle    1e7 <main+0x1e7>
        wait();
 1e2:	e8 e3 02 00 00       	call   4ca <wait>
    }
    if(pid2 > 0){
 1e7:	85 db                	test   %ebx,%ebx
 1e9:	7e 0a                	jle    1f5 <main+0x1f5>
 1eb:	90                   	nop
 1ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        wait();
 1f0:	e8 d5 02 00 00       	call   4ca <wait>
    }
    exit();
 1f5:	e8 c8 02 00 00       	call   4c2 <exit>
        set_prior(0);
 1fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
            if(i%1000 == 0)
 201:	be d3 4d 62 10       	mov    $0x10624dd3,%esi
        set_prior(0);
 206:	e8 57 03 00 00       	call   562 <set_prior>
        printf(1,"child %d's priority %d at start \n",getpid(), get_prior());
 20b:	e8 5a 03 00 00       	call   56a <get_prior>
 210:	89 c3                	mov    %eax,%ebx
 212:	e8 2b 03 00 00       	call   542 <getpid>
 217:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
        for (i = 0; i < 5000; i++) {
 21b:	31 db                	xor    %ebx,%ebx
        printf(1,"child %d's priority %d at start \n",getpid(), get_prior());
 21d:	c7 44 24 04 a4 09 00 	movl   $0x9a4,0x4(%esp)
 224:	00 
 225:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 22c:	89 44 24 08          	mov    %eax,0x8(%esp)
 230:	e8 eb 03 00 00       	call   620 <printf>
            asm("nop");
 235:	90                   	nop
 236:	ba a0 86 01 00       	mov    $0x186a0,%edx
 23b:	90                   	nop
 23c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                asm("nop");
 240:	90                   	nop
            for (j = 0; j < 100000; j++) {
 241:	83 ea 01             	sub    $0x1,%edx
 244:	75 fa                	jne    240 <main+0x240>
            if(i%1000 == 0)
 246:	89 d8                	mov    %ebx,%eax
 248:	f7 ee                	imul   %esi
 24a:	89 d8                	mov    %ebx,%eax
 24c:	c1 f8 1f             	sar    $0x1f,%eax
 24f:	c1 fa 06             	sar    $0x6,%edx
 252:	29 c2                	sub    %eax,%edx
 254:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
 25a:	39 d3                	cmp    %edx,%ebx
 25c:	74 12                	je     270 <main+0x270>
        for (i = 0; i < 5000; i++) {
 25e:	83 c3 01             	add    $0x1,%ebx
 261:	81 fb 88 13 00 00    	cmp    $0x1388,%ebx
 267:	75 cc                	jne    235 <main+0x235>
 269:	e9 53 fe ff ff       	jmp    c1 <main+0xc1>
 26e:	66 90                	xchg   %ax,%ax
                printf(1,"child %d's priority %d in between \n",getpid(), get_prior());
 270:	e8 f5 02 00 00       	call   56a <get_prior>
 275:	89 c7                	mov    %eax,%edi
 277:	e8 c6 02 00 00       	call   542 <getpid>
 27c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
 280:	c7 44 24 04 c8 09 00 	movl   $0x9c8,0x4(%esp)
 287:	00 
 288:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 28f:	89 44 24 08          	mov    %eax,0x8(%esp)
 293:	e8 88 03 00 00       	call   620 <printf>
 298:	eb c4                	jmp    25e <main+0x25e>
 29a:	66 90                	xchg   %ax,%ax
 29c:	66 90                	xchg   %ax,%ax
 29e:	66 90                	xchg   %ax,%ax

000002a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2a9:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2aa:	89 c2                	mov    %eax,%edx
 2ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2b0:	83 c1 01             	add    $0x1,%ecx
 2b3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 2b7:	83 c2 01             	add    $0x1,%edx
 2ba:	84 db                	test   %bl,%bl
 2bc:	88 5a ff             	mov    %bl,-0x1(%edx)
 2bf:	75 ef                	jne    2b0 <strcpy+0x10>
    ;
  return os;
}
 2c1:	5b                   	pop    %ebx
 2c2:	5d                   	pop    %ebp
 2c3:	c3                   	ret    
 2c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000002d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	8b 55 08             	mov    0x8(%ebp),%edx
 2d6:	53                   	push   %ebx
 2d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 2da:	0f b6 02             	movzbl (%edx),%eax
 2dd:	84 c0                	test   %al,%al
 2df:	74 2d                	je     30e <strcmp+0x3e>
 2e1:	0f b6 19             	movzbl (%ecx),%ebx
 2e4:	38 d8                	cmp    %bl,%al
 2e6:	74 0e                	je     2f6 <strcmp+0x26>
 2e8:	eb 2b                	jmp    315 <strcmp+0x45>
 2ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2f0:	38 c8                	cmp    %cl,%al
 2f2:	75 15                	jne    309 <strcmp+0x39>
    p++, q++;
 2f4:	89 d9                	mov    %ebx,%ecx
 2f6:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 2f9:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 2fc:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 2ff:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 303:	84 c0                	test   %al,%al
 305:	75 e9                	jne    2f0 <strcmp+0x20>
 307:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 309:	29 c8                	sub    %ecx,%eax
}
 30b:	5b                   	pop    %ebx
 30c:	5d                   	pop    %ebp
 30d:	c3                   	ret    
 30e:	0f b6 09             	movzbl (%ecx),%ecx
  while(*p && *p == *q)
 311:	31 c0                	xor    %eax,%eax
 313:	eb f4                	jmp    309 <strcmp+0x39>
 315:	0f b6 cb             	movzbl %bl,%ecx
 318:	eb ef                	jmp    309 <strcmp+0x39>
 31a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000320 <strlen>:

uint
strlen(const char *s)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 326:	80 39 00             	cmpb   $0x0,(%ecx)
 329:	74 12                	je     33d <strlen+0x1d>
 32b:	31 d2                	xor    %edx,%edx
 32d:	8d 76 00             	lea    0x0(%esi),%esi
 330:	83 c2 01             	add    $0x1,%edx
 333:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 337:	89 d0                	mov    %edx,%eax
 339:	75 f5                	jne    330 <strlen+0x10>
    ;
  return n;
}
 33b:	5d                   	pop    %ebp
 33c:	c3                   	ret    
  for(n = 0; s[n]; n++)
 33d:	31 c0                	xor    %eax,%eax
}
 33f:	5d                   	pop    %ebp
 340:	c3                   	ret    
 341:	eb 0d                	jmp    350 <memset>
 343:	90                   	nop
 344:	90                   	nop
 345:	90                   	nop
 346:	90                   	nop
 347:	90                   	nop
 348:	90                   	nop
 349:	90                   	nop
 34a:	90                   	nop
 34b:	90                   	nop
 34c:	90                   	nop
 34d:	90                   	nop
 34e:	90                   	nop
 34f:	90                   	nop

00000350 <memset>:

void*
memset(void *dst, int c, uint n)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	8b 55 08             	mov    0x8(%ebp),%edx
 356:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 357:	8b 4d 10             	mov    0x10(%ebp),%ecx
 35a:	8b 45 0c             	mov    0xc(%ebp),%eax
 35d:	89 d7                	mov    %edx,%edi
 35f:	fc                   	cld    
 360:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 362:	89 d0                	mov    %edx,%eax
 364:	5f                   	pop    %edi
 365:	5d                   	pop    %ebp
 366:	c3                   	ret    
 367:	89 f6                	mov    %esi,%esi
 369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000370 <strchr>:

char*
strchr(const char *s, char c)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	53                   	push   %ebx
 377:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 37a:	0f b6 18             	movzbl (%eax),%ebx
 37d:	84 db                	test   %bl,%bl
 37f:	74 1d                	je     39e <strchr+0x2e>
    if(*s == c)
 381:	38 d3                	cmp    %dl,%bl
 383:	89 d1                	mov    %edx,%ecx
 385:	75 0d                	jne    394 <strchr+0x24>
 387:	eb 17                	jmp    3a0 <strchr+0x30>
 389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 390:	38 ca                	cmp    %cl,%dl
 392:	74 0c                	je     3a0 <strchr+0x30>
  for(; *s; s++)
 394:	83 c0 01             	add    $0x1,%eax
 397:	0f b6 10             	movzbl (%eax),%edx
 39a:	84 d2                	test   %dl,%dl
 39c:	75 f2                	jne    390 <strchr+0x20>
      return (char*)s;
  return 0;
 39e:	31 c0                	xor    %eax,%eax
}
 3a0:	5b                   	pop    %ebx
 3a1:	5d                   	pop    %ebp
 3a2:	c3                   	ret    
 3a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003b0 <gets>:

char*
gets(char *buf, int max)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b5:	31 f6                	xor    %esi,%esi
{
 3b7:	53                   	push   %ebx
 3b8:	83 ec 2c             	sub    $0x2c,%esp
    cc = read(0, &c, 1);
 3bb:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 3be:	eb 31                	jmp    3f1 <gets+0x41>
    cc = read(0, &c, 1);
 3c0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3c7:	00 
 3c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
 3cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 3d3:	e8 02 01 00 00       	call   4da <read>
    if(cc < 1)
 3d8:	85 c0                	test   %eax,%eax
 3da:	7e 1d                	jle    3f9 <gets+0x49>
      break;
    buf[i++] = c;
 3dc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  for(i=0; i+1 < max; ){
 3e0:	89 de                	mov    %ebx,%esi
    buf[i++] = c;
 3e2:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 3e5:	3c 0d                	cmp    $0xd,%al
    buf[i++] = c;
 3e7:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 3eb:	74 0c                	je     3f9 <gets+0x49>
 3ed:	3c 0a                	cmp    $0xa,%al
 3ef:	74 08                	je     3f9 <gets+0x49>
  for(i=0; i+1 < max; ){
 3f1:	8d 5e 01             	lea    0x1(%esi),%ebx
 3f4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3f7:	7c c7                	jl     3c0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 3f9:	8b 45 08             	mov    0x8(%ebp),%eax
 3fc:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 400:	83 c4 2c             	add    $0x2c,%esp
 403:	5b                   	pop    %ebx
 404:	5e                   	pop    %esi
 405:	5f                   	pop    %edi
 406:	5d                   	pop    %ebp
 407:	c3                   	ret    
 408:	90                   	nop
 409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000410 <stat>:

int
stat(const char *n, struct stat *st)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	56                   	push   %esi
 414:	53                   	push   %ebx
 415:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 418:	8b 45 08             	mov    0x8(%ebp),%eax
 41b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 422:	00 
 423:	89 04 24             	mov    %eax,(%esp)
 426:	e8 d7 00 00 00       	call   502 <open>
  if(fd < 0)
 42b:	85 c0                	test   %eax,%eax
  fd = open(n, O_RDONLY);
 42d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 42f:	78 27                	js     458 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 431:	8b 45 0c             	mov    0xc(%ebp),%eax
 434:	89 1c 24             	mov    %ebx,(%esp)
 437:	89 44 24 04          	mov    %eax,0x4(%esp)
 43b:	e8 da 00 00 00       	call   51a <fstat>
  close(fd);
 440:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 443:	89 c6                	mov    %eax,%esi
  close(fd);
 445:	e8 a0 00 00 00       	call   4ea <close>
  return r;
 44a:	89 f0                	mov    %esi,%eax
}
 44c:	83 c4 10             	add    $0x10,%esp
 44f:	5b                   	pop    %ebx
 450:	5e                   	pop    %esi
 451:	5d                   	pop    %ebp
 452:	c3                   	ret    
 453:	90                   	nop
 454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 458:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 45d:	eb ed                	jmp    44c <stat+0x3c>
 45f:	90                   	nop

00000460 <atoi>:

int
atoi(const char *s)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	8b 4d 08             	mov    0x8(%ebp),%ecx
 466:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 467:	0f be 11             	movsbl (%ecx),%edx
 46a:	8d 42 d0             	lea    -0x30(%edx),%eax
 46d:	3c 09                	cmp    $0x9,%al
  n = 0;
 46f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 474:	77 17                	ja     48d <atoi+0x2d>
 476:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 478:	83 c1 01             	add    $0x1,%ecx
 47b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 47e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 482:	0f be 11             	movsbl (%ecx),%edx
 485:	8d 5a d0             	lea    -0x30(%edx),%ebx
 488:	80 fb 09             	cmp    $0x9,%bl
 48b:	76 eb                	jbe    478 <atoi+0x18>
  return n;
}
 48d:	5b                   	pop    %ebx
 48e:	5d                   	pop    %ebp
 48f:	c3                   	ret    

00000490 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 490:	55                   	push   %ebp
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 491:	31 d2                	xor    %edx,%edx
{
 493:	89 e5                	mov    %esp,%ebp
 495:	56                   	push   %esi
 496:	8b 45 08             	mov    0x8(%ebp),%eax
 499:	53                   	push   %ebx
 49a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 49d:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n-- > 0)
 4a0:	85 db                	test   %ebx,%ebx
 4a2:	7e 12                	jle    4b6 <memmove+0x26>
 4a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 4a8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 4ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 4af:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 4b2:	39 da                	cmp    %ebx,%edx
 4b4:	75 f2                	jne    4a8 <memmove+0x18>
  return vdst;
}
 4b6:	5b                   	pop    %ebx
 4b7:	5e                   	pop    %esi
 4b8:	5d                   	pop    %ebp
 4b9:	c3                   	ret    

000004ba <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4ba:	b8 01 00 00 00       	mov    $0x1,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <exit>:
SYSCALL(exit)
 4c2:	b8 02 00 00 00       	mov    $0x2,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <wait>:
SYSCALL(wait)
 4ca:	b8 03 00 00 00       	mov    $0x3,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <pipe>:
SYSCALL(pipe)
 4d2:	b8 04 00 00 00       	mov    $0x4,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <read>:
SYSCALL(read)
 4da:	b8 05 00 00 00       	mov    $0x5,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <write>:
SYSCALL(write)
 4e2:	b8 10 00 00 00       	mov    $0x10,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <close>:
SYSCALL(close)
 4ea:	b8 15 00 00 00       	mov    $0x15,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <kill>:
SYSCALL(kill)
 4f2:	b8 06 00 00 00       	mov    $0x6,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <exec>:
SYSCALL(exec)
 4fa:	b8 07 00 00 00       	mov    $0x7,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <open>:
SYSCALL(open)
 502:	b8 0f 00 00 00       	mov    $0xf,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <mknod>:
SYSCALL(mknod)
 50a:	b8 11 00 00 00       	mov    $0x11,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <unlink>:
SYSCALL(unlink)
 512:	b8 12 00 00 00       	mov    $0x12,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <fstat>:
SYSCALL(fstat)
 51a:	b8 08 00 00 00       	mov    $0x8,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <link>:
SYSCALL(link)
 522:	b8 13 00 00 00       	mov    $0x13,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <mkdir>:
SYSCALL(mkdir)
 52a:	b8 14 00 00 00       	mov    $0x14,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <chdir>:
SYSCALL(chdir)
 532:	b8 09 00 00 00       	mov    $0x9,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <dup>:
SYSCALL(dup)
 53a:	b8 0a 00 00 00       	mov    $0xa,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <getpid>:
SYSCALL(getpid)
 542:	b8 0b 00 00 00       	mov    $0xb,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <sbrk>:
SYSCALL(sbrk)
 54a:	b8 0c 00 00 00       	mov    $0xc,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <sleep>:
SYSCALL(sleep)
 552:	b8 0d 00 00 00       	mov    $0xd,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <uptime>:
SYSCALL(uptime)
 55a:	b8 0e 00 00 00       	mov    $0xe,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <set_prior>:
SYSCALL(set_prior)
 562:	b8 16 00 00 00       	mov    $0x16,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <get_prior>:
 56a:	b8 17 00 00 00       	mov    $0x17,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    
 572:	66 90                	xchg   %ax,%ax
 574:	66 90                	xchg   %ax,%ax
 576:	66 90                	xchg   %ax,%ax
 578:	66 90                	xchg   %ax,%ax
 57a:	66 90                	xchg   %ax,%ax
 57c:	66 90                	xchg   %ax,%ax
 57e:	66 90                	xchg   %ax,%ax

00000580 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	57                   	push   %edi
 584:	56                   	push   %esi
 585:	89 c6                	mov    %eax,%esi
 587:	53                   	push   %ebx
 588:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 58b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 58e:	85 db                	test   %ebx,%ebx
 590:	74 09                	je     59b <printint+0x1b>
 592:	89 d0                	mov    %edx,%eax
 594:	c1 e8 1f             	shr    $0x1f,%eax
 597:	84 c0                	test   %al,%al
 599:	75 75                	jne    610 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 59b:	89 d0                	mov    %edx,%eax
  neg = 0;
 59d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 5a4:	89 75 c0             	mov    %esi,-0x40(%ebp)
  }

  i = 0;
 5a7:	31 ff                	xor    %edi,%edi
 5a9:	89 ce                	mov    %ecx,%esi
 5ab:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 5ae:	eb 02                	jmp    5b2 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 5b0:	89 cf                	mov    %ecx,%edi
 5b2:	31 d2                	xor    %edx,%edx
 5b4:	f7 f6                	div    %esi
 5b6:	8d 4f 01             	lea    0x1(%edi),%ecx
 5b9:	0f b6 92 13 0a 00 00 	movzbl 0xa13(%edx),%edx
  }while((x /= base) != 0);
 5c0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 5c2:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 5c5:	75 e9                	jne    5b0 <printint+0x30>
  if(neg)
 5c7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    buf[i++] = digits[x % base];
 5ca:	89 c8                	mov    %ecx,%eax
 5cc:	8b 75 c0             	mov    -0x40(%ebp),%esi
  if(neg)
 5cf:	85 d2                	test   %edx,%edx
 5d1:	74 08                	je     5db <printint+0x5b>
    buf[i++] = '-';
 5d3:	8d 4f 02             	lea    0x2(%edi),%ecx
 5d6:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 5db:	8d 79 ff             	lea    -0x1(%ecx),%edi
 5de:	66 90                	xchg   %ax,%ax
 5e0:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 5e5:	83 ef 01             	sub    $0x1,%edi
  write(fd, &c, 1);
 5e8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5ef:	00 
 5f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 5f4:	89 34 24             	mov    %esi,(%esp)
 5f7:	88 45 d7             	mov    %al,-0x29(%ebp)
 5fa:	e8 e3 fe ff ff       	call   4e2 <write>
  while(--i >= 0)
 5ff:	83 ff ff             	cmp    $0xffffffff,%edi
 602:	75 dc                	jne    5e0 <printint+0x60>
    putc(fd, buf[i]);
}
 604:	83 c4 4c             	add    $0x4c,%esp
 607:	5b                   	pop    %ebx
 608:	5e                   	pop    %esi
 609:	5f                   	pop    %edi
 60a:	5d                   	pop    %ebp
 60b:	c3                   	ret    
 60c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    x = -xx;
 610:	89 d0                	mov    %edx,%eax
 612:	f7 d8                	neg    %eax
    neg = 1;
 614:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 61b:	eb 87                	jmp    5a4 <printint+0x24>
 61d:	8d 76 00             	lea    0x0(%esi),%esi

00000620 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 624:	31 ff                	xor    %edi,%edi
{
 626:	56                   	push   %esi
 627:	53                   	push   %ebx
 628:	83 ec 3c             	sub    $0x3c,%esp
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 62b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  ap = (uint*)(void*)&fmt + 1;
 62e:	8d 45 10             	lea    0x10(%ebp),%eax
{
 631:	8b 75 08             	mov    0x8(%ebp),%esi
  ap = (uint*)(void*)&fmt + 1;
 634:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 637:	0f b6 13             	movzbl (%ebx),%edx
 63a:	83 c3 01             	add    $0x1,%ebx
 63d:	84 d2                	test   %dl,%dl
 63f:	75 39                	jne    67a <printf+0x5a>
 641:	e9 c2 00 00 00       	jmp    708 <printf+0xe8>
 646:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 648:	83 fa 25             	cmp    $0x25,%edx
 64b:	0f 84 bf 00 00 00    	je     710 <printf+0xf0>
  write(fd, &c, 1);
 651:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 654:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 65b:	00 
 65c:	89 44 24 04          	mov    %eax,0x4(%esp)
 660:	89 34 24             	mov    %esi,(%esp)
        state = '%';
      } else {
        putc(fd, c);
 663:	88 55 e2             	mov    %dl,-0x1e(%ebp)
  write(fd, &c, 1);
 666:	e8 77 fe ff ff       	call   4e2 <write>
 66b:	83 c3 01             	add    $0x1,%ebx
  for(i = 0; fmt[i]; i++){
 66e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 672:	84 d2                	test   %dl,%dl
 674:	0f 84 8e 00 00 00    	je     708 <printf+0xe8>
    if(state == 0){
 67a:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 67c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 67f:	74 c7                	je     648 <printf+0x28>
      }
    } else if(state == '%'){
 681:	83 ff 25             	cmp    $0x25,%edi
 684:	75 e5                	jne    66b <printf+0x4b>
      if(c == 'd'){
 686:	83 fa 64             	cmp    $0x64,%edx
 689:	0f 84 31 01 00 00    	je     7c0 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 68f:	25 f7 00 00 00       	and    $0xf7,%eax
 694:	83 f8 70             	cmp    $0x70,%eax
 697:	0f 84 83 00 00 00    	je     720 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 69d:	83 fa 73             	cmp    $0x73,%edx
 6a0:	0f 84 a2 00 00 00    	je     748 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6a6:	83 fa 63             	cmp    $0x63,%edx
 6a9:	0f 84 35 01 00 00    	je     7e4 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6af:	83 fa 25             	cmp    $0x25,%edx
 6b2:	0f 84 e0 00 00 00    	je     798 <printf+0x178>
  write(fd, &c, 1);
 6b8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 6bb:	83 c3 01             	add    $0x1,%ebx
 6be:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6c5:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6c6:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 6c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6cc:	89 34 24             	mov    %esi,(%esp)
 6cf:	89 55 d0             	mov    %edx,-0x30(%ebp)
 6d2:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 6d6:	e8 07 fe ff ff       	call   4e2 <write>
        putc(fd, c);
 6db:	8b 55 d0             	mov    -0x30(%ebp),%edx
  write(fd, &c, 1);
 6de:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6e1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6e8:	00 
 6e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ed:	89 34 24             	mov    %esi,(%esp)
        putc(fd, c);
 6f0:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 6f3:	e8 ea fd ff ff       	call   4e2 <write>
  for(i = 0; fmt[i]; i++){
 6f8:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 6fc:	84 d2                	test   %dl,%dl
 6fe:	0f 85 76 ff ff ff    	jne    67a <printf+0x5a>
 704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }
}
 708:	83 c4 3c             	add    $0x3c,%esp
 70b:	5b                   	pop    %ebx
 70c:	5e                   	pop    %esi
 70d:	5f                   	pop    %edi
 70e:	5d                   	pop    %ebp
 70f:	c3                   	ret    
        state = '%';
 710:	bf 25 00 00 00       	mov    $0x25,%edi
 715:	e9 51 ff ff ff       	jmp    66b <printf+0x4b>
 71a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 720:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 723:	b9 10 00 00 00       	mov    $0x10,%ecx
      state = 0;
 728:	31 ff                	xor    %edi,%edi
        printint(fd, *ap, 16, 0);
 72a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 731:	8b 10                	mov    (%eax),%edx
 733:	89 f0                	mov    %esi,%eax
 735:	e8 46 fe ff ff       	call   580 <printint>
        ap++;
 73a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 73e:	e9 28 ff ff ff       	jmp    66b <printf+0x4b>
 743:	90                   	nop
 744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 748:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 74b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        s = (char*)*ap;
 74f:	8b 38                	mov    (%eax),%edi
          s = "(null)";
 751:	b8 0c 0a 00 00       	mov    $0xa0c,%eax
 756:	85 ff                	test   %edi,%edi
 758:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 75b:	0f b6 07             	movzbl (%edi),%eax
 75e:	84 c0                	test   %al,%al
 760:	74 2a                	je     78c <printf+0x16c>
 762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 768:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 76b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
          s++;
 76e:	83 c7 01             	add    $0x1,%edi
  write(fd, &c, 1);
 771:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 778:	00 
 779:	89 44 24 04          	mov    %eax,0x4(%esp)
 77d:	89 34 24             	mov    %esi,(%esp)
 780:	e8 5d fd ff ff       	call   4e2 <write>
        while(*s != 0){
 785:	0f b6 07             	movzbl (%edi),%eax
 788:	84 c0                	test   %al,%al
 78a:	75 dc                	jne    768 <printf+0x148>
      state = 0;
 78c:	31 ff                	xor    %edi,%edi
 78e:	e9 d8 fe ff ff       	jmp    66b <printf+0x4b>
 793:	90                   	nop
 794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 798:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      state = 0;
 79b:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 79d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7a4:	00 
 7a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 7a9:	89 34 24             	mov    %esi,(%esp)
 7ac:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 7b0:	e8 2d fd ff ff       	call   4e2 <write>
 7b5:	e9 b1 fe ff ff       	jmp    66b <printf+0x4b>
 7ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 7c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 7c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
      state = 0;
 7c8:	66 31 ff             	xor    %di,%di
        printint(fd, *ap, 10, 1);
 7cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 7d2:	8b 10                	mov    (%eax),%edx
 7d4:	89 f0                	mov    %esi,%eax
 7d6:	e8 a5 fd ff ff       	call   580 <printint>
        ap++;
 7db:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 7df:	e9 87 fe ff ff       	jmp    66b <printf+0x4b>
        putc(fd, *ap);
 7e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      state = 0;
 7e7:	31 ff                	xor    %edi,%edi
        putc(fd, *ap);
 7e9:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 7eb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7f2:	00 
 7f3:	89 34 24             	mov    %esi,(%esp)
        putc(fd, *ap);
 7f6:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 7f9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 7fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 800:	e8 dd fc ff ff       	call   4e2 <write>
        ap++;
 805:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 809:	e9 5d fe ff ff       	jmp    66b <printf+0x4b>
 80e:	66 90                	xchg   %ax,%ax

00000810 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 810:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 811:	a1 8c 0c 00 00       	mov    0xc8c,%eax
{
 816:	89 e5                	mov    %esp,%ebp
 818:	57                   	push   %edi
 819:	56                   	push   %esi
 81a:	53                   	push   %ebx
 81b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81e:	8b 08                	mov    (%eax),%ecx
  bp = (Header*)ap - 1;
 820:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 823:	39 d0                	cmp    %edx,%eax
 825:	72 11                	jb     838 <free+0x28>
 827:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 828:	39 c8                	cmp    %ecx,%eax
 82a:	72 04                	jb     830 <free+0x20>
 82c:	39 ca                	cmp    %ecx,%edx
 82e:	72 10                	jb     840 <free+0x30>
 830:	89 c8                	mov    %ecx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 832:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 834:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 836:	73 f0                	jae    828 <free+0x18>
 838:	39 ca                	cmp    %ecx,%edx
 83a:	72 04                	jb     840 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83c:	39 c8                	cmp    %ecx,%eax
 83e:	72 f0                	jb     830 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 840:	8b 73 fc             	mov    -0x4(%ebx),%esi
 843:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 846:	39 cf                	cmp    %ecx,%edi
 848:	74 1e                	je     868 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 84a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 84d:	8b 48 04             	mov    0x4(%eax),%ecx
 850:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 853:	39 f2                	cmp    %esi,%edx
 855:	74 28                	je     87f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 857:	89 10                	mov    %edx,(%eax)
  freep = p;
 859:	a3 8c 0c 00 00       	mov    %eax,0xc8c
}
 85e:	5b                   	pop    %ebx
 85f:	5e                   	pop    %esi
 860:	5f                   	pop    %edi
 861:	5d                   	pop    %ebp
 862:	c3                   	ret    
 863:	90                   	nop
 864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 868:	03 71 04             	add    0x4(%ecx),%esi
 86b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 86e:	8b 08                	mov    (%eax),%ecx
 870:	8b 09                	mov    (%ecx),%ecx
 872:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 875:	8b 48 04             	mov    0x4(%eax),%ecx
 878:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 87b:	39 f2                	cmp    %esi,%edx
 87d:	75 d8                	jne    857 <free+0x47>
    p->s.size += bp->s.size;
 87f:	03 4b fc             	add    -0x4(%ebx),%ecx
  freep = p;
 882:	a3 8c 0c 00 00       	mov    %eax,0xc8c
    p->s.size += bp->s.size;
 887:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 88a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 88d:	89 10                	mov    %edx,(%eax)
}
 88f:	5b                   	pop    %ebx
 890:	5e                   	pop    %esi
 891:	5f                   	pop    %edi
 892:	5d                   	pop    %ebp
 893:	c3                   	ret    
 894:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 89a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000008a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	57                   	push   %edi
 8a4:	56                   	push   %esi
 8a5:	53                   	push   %ebx
 8a6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8ac:	8b 1d 8c 0c 00 00    	mov    0xc8c,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b2:	8d 48 07             	lea    0x7(%eax),%ecx
 8b5:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 8b8:	85 db                	test   %ebx,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ba:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 8bd:	0f 84 9b 00 00 00    	je     95e <malloc+0xbe>
 8c3:	8b 13                	mov    (%ebx),%edx
 8c5:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 8c8:	39 fe                	cmp    %edi,%esi
 8ca:	76 64                	jbe    930 <malloc+0x90>
 8cc:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  if(nu < 4096)
 8d3:	bb 00 80 00 00       	mov    $0x8000,%ebx
 8d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 8db:	eb 0e                	jmp    8eb <malloc+0x4b>
 8dd:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8e2:	8b 78 04             	mov    0x4(%eax),%edi
 8e5:	39 fe                	cmp    %edi,%esi
 8e7:	76 4f                	jbe    938 <malloc+0x98>
 8e9:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8eb:	3b 15 8c 0c 00 00    	cmp    0xc8c,%edx
 8f1:	75 ed                	jne    8e0 <malloc+0x40>
  if(nu < 4096)
 8f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8f6:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 8fc:	bf 00 10 00 00       	mov    $0x1000,%edi
 901:	0f 43 fe             	cmovae %esi,%edi
 904:	0f 42 c3             	cmovb  %ebx,%eax
  p = sbrk(nu * sizeof(Header));
 907:	89 04 24             	mov    %eax,(%esp)
 90a:	e8 3b fc ff ff       	call   54a <sbrk>
  if(p == (char*)-1)
 90f:	83 f8 ff             	cmp    $0xffffffff,%eax
 912:	74 18                	je     92c <malloc+0x8c>
  hp->s.size = nu;
 914:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 917:	83 c0 08             	add    $0x8,%eax
 91a:	89 04 24             	mov    %eax,(%esp)
 91d:	e8 ee fe ff ff       	call   810 <free>
  return freep;
 922:	8b 15 8c 0c 00 00    	mov    0xc8c,%edx
      if((p = morecore(nunits)) == 0)
 928:	85 d2                	test   %edx,%edx
 92a:	75 b4                	jne    8e0 <malloc+0x40>
        return 0;
 92c:	31 c0                	xor    %eax,%eax
 92e:	eb 20                	jmp    950 <malloc+0xb0>
    if(p->s.size >= nunits){
 930:	89 d0                	mov    %edx,%eax
 932:	89 da                	mov    %ebx,%edx
 934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 938:	39 fe                	cmp    %edi,%esi
 93a:	74 1c                	je     958 <malloc+0xb8>
        p->s.size -= nunits;
 93c:	29 f7                	sub    %esi,%edi
 93e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 941:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 944:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 947:	89 15 8c 0c 00 00    	mov    %edx,0xc8c
      return (void*)(p + 1);
 94d:	83 c0 08             	add    $0x8,%eax
  }
}
 950:	83 c4 1c             	add    $0x1c,%esp
 953:	5b                   	pop    %ebx
 954:	5e                   	pop    %esi
 955:	5f                   	pop    %edi
 956:	5d                   	pop    %ebp
 957:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 958:	8b 08                	mov    (%eax),%ecx
 95a:	89 0a                	mov    %ecx,(%edx)
 95c:	eb e9                	jmp    947 <malloc+0xa7>
    base.s.ptr = freep = prevp = &base;
 95e:	c7 05 8c 0c 00 00 90 	movl   $0xc90,0xc8c
 965:	0c 00 00 
    base.s.size = 0;
 968:	ba 90 0c 00 00       	mov    $0xc90,%edx
    base.s.ptr = freep = prevp = &base;
 96d:	c7 05 90 0c 00 00 90 	movl   $0xc90,0xc90
 974:	0c 00 00 
    base.s.size = 0;
 977:	c7 05 94 0c 00 00 00 	movl   $0x0,0xc94
 97e:	00 00 00 
 981:	e9 46 ff ff ff       	jmp    8cc <malloc+0x2c>
