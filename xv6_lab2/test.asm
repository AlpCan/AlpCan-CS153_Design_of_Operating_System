
_test:     file format elf32-i386


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
  13:	e8 ea 04 00 00       	call   502 <set_prior>
    int pid,pid1,pid2;
    printf(1,"%d's priority %d at start \n", getpid(), get_prior());
  18:	e8 ed 04 00 00       	call   50a <get_prior>
  1d:	89 c3                	mov    %eax,%ebx
  1f:	e8 be 04 00 00       	call   4e2 <getpid>
  24:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  28:	c7 44 24 04 28 09 00 	movl   $0x928,0x4(%esp)
  2f:	00 
  30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  37:	89 44 24 08          	mov    %eax,0x8(%esp)
  3b:	e8 80 05 00 00       	call   5c0 <printf>
    pid = fork();
  40:	e8 15 04 00 00       	call   45a <fork>
    if(pid == 0) {
  45:	85 c0                	test   %eax,%eax
    pid = fork();
  47:	89 c3                	mov    %eax,%ebx
    if(pid == 0) {
  49:	0f 85 ab 00 00 00    	jne    fa <main+0xfa>
        set_prior(30);
  4f:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
  56:	e8 a7 04 00 00       	call   502 <set_prior>
        printf(1,"child %d's priority %d at start \n",getpid(), get_prior());
  5b:	e8 aa 04 00 00       	call   50a <get_prior>
  60:	89 c3                	mov    %eax,%ebx
  62:	e8 7b 04 00 00       	call   4e2 <getpid>
  67:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
        int i, j;
        for (i = 0; i < 10; i++) {
  6b:	31 db                	xor    %ebx,%ebx
        printf(1,"child %d's priority %d at start \n",getpid(), get_prior());
  6d:	c7 44 24 04 44 09 00 	movl   $0x944,0x4(%esp)
  74:	00 
  75:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7c:	89 44 24 08          	mov    %eax,0x8(%esp)
  80:	e8 3b 05 00 00       	call   5c0 <printf>
  85:	8d 76 00             	lea    0x0(%esi),%esi
            asm("nop");
  88:	90                   	nop
  89:	b8 40 42 0f 00       	mov    $0xf4240,%eax
  8e:	66 90                	xchg   %ax,%ax
            for (j = 0; j < 1000000; j++) {
                asm("nop");
  90:	90                   	nop
            for (j = 0; j < 1000000; j++) {
  91:	83 e8 01             	sub    $0x1,%eax
  94:	75 fa                	jne    90 <main+0x90>
                //printf(1,"test1's priority %d \n", get_prior());
            }
            if(i%2 == 1)
  96:	f6 c3 01             	test   $0x1,%bl
  99:	75 35                	jne    d0 <main+0xd0>
        for (i = 0; i < 10; i++) {
  9b:	83 c3 01             	add    $0x1,%ebx
  9e:	83 fb 0a             	cmp    $0xa,%ebx
  a1:	75 e5                	jne    88 <main+0x88>
                //printf(1,"test1's priority %d \n", get_prior());
            }
            if(i%2 == 1)
                printf(1,"child %d's priority %d in between \n",getpid(), get_prior());
        }
        printf(1,"child %d's priority %d at end \n",getpid(), get_prior());
  a3:	e8 62 04 00 00       	call   50a <get_prior>
  a8:	89 c3                	mov    %eax,%ebx
  aa:	e8 33 04 00 00       	call   4e2 <getpid>
  af:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  b3:	c7 44 24 04 8c 09 00 	movl   $0x98c,0x4(%esp)
  ba:	00 
  bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  c6:	e8 f5 04 00 00       	call   5c0 <printf>
        exit();
  cb:	e8 92 03 00 00       	call   462 <exit>
                printf(1,"child %d's priority %d in between \n",getpid(), get_prior());
  d0:	e8 35 04 00 00       	call   50a <get_prior>
  d5:	89 c6                	mov    %eax,%esi
  d7:	e8 06 04 00 00       	call   4e2 <getpid>
  dc:	89 74 24 0c          	mov    %esi,0xc(%esp)
  e0:	c7 44 24 04 68 09 00 	movl   $0x968,0x4(%esp)
  e7:	00 
  e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  f3:	e8 c8 04 00 00       	call   5c0 <printf>
  f8:	eb a1                	jmp    9b <main+0x9b>
    pid1 = fork();
  fa:	e8 5b 03 00 00       	call   45a <fork>
    if(pid1 == 0) {
  ff:	85 c0                	test   %eax,%eax
    pid1 = fork();
 101:	89 c7                	mov    %eax,%edi
    if(pid1 == 0) {
 103:	75 5b                	jne    160 <main+0x160>
        set_prior(15);
 105:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
 10c:	e8 f1 03 00 00       	call   502 <set_prior>
        printf(1,"child %d's priority %d at start \n",getpid(), get_prior());
 111:	e8 f4 03 00 00       	call   50a <get_prior>
 116:	89 c3                	mov    %eax,%ebx
 118:	e8 c5 03 00 00       	call   4e2 <getpid>
 11d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
        for (i = 0; i < 10; i++) {
 121:	31 db                	xor    %ebx,%ebx
        printf(1,"child %d's priority %d at start \n",getpid(), get_prior());
 123:	c7 44 24 04 44 09 00 	movl   $0x944,0x4(%esp)
 12a:	00 
 12b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 132:	89 44 24 08          	mov    %eax,0x8(%esp)
 136:	e8 85 04 00 00       	call   5c0 <printf>
            asm("nop");
 13b:	90                   	nop
 13c:	b8 40 42 0f 00       	mov    $0xf4240,%eax
 141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                asm("nop");
 148:	90                   	nop
            for (j = 0; j < 1000000; j++) {
 149:	83 e8 01             	sub    $0x1,%eax
 14c:	75 fa                	jne    148 <main+0x148>
            if(i%2 == 1)
 14e:	f6 c3 01             	test   $0x1,%bl
 151:	75 39                	jne    18c <main+0x18c>
        for (i = 0; i < 10; i++) {
 153:	83 c3 01             	add    $0x1,%ebx
 156:	83 fb 0a             	cmp    $0xa,%ebx
 159:	75 e0                	jne    13b <main+0x13b>
 15b:	e9 43 ff ff ff       	jmp    a3 <main+0xa3>
    pid2 = fork();
 160:	e8 f5 02 00 00       	call   45a <fork>
    if(pid2 == 0) {
 165:	85 c0                	test   %eax,%eax
    pid2 = fork();
 167:	89 c6                	mov    %eax,%esi
    if(pid2 == 0) {
 169:	74 4f                	je     1ba <main+0x1ba>
    }
    if(pid > 0){
 16b:	85 db                	test   %ebx,%ebx
 16d:	7e 06                	jle    175 <main+0x175>
 16f:	90                   	nop
        wait();
 170:	e8 f5 02 00 00       	call   46a <wait>
    }
    if( pid1 > 0){
 175:	85 ff                	test   %edi,%edi
 177:	7e 05                	jle    17e <main+0x17e>
        wait();
 179:	e8 ec 02 00 00       	call   46a <wait>
    }
    if(pid2 > 0){
 17e:	85 f6                	test   %esi,%esi
 180:	7e 05                	jle    187 <main+0x187>
        wait();
 182:	e8 e3 02 00 00       	call   46a <wait>
    }
    exit();
 187:	e8 d6 02 00 00       	call   462 <exit>
 18c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                printf(1,"child %d's priority %d in between \n",getpid(), get_prior());
 190:	e8 75 03 00 00       	call   50a <get_prior>
 195:	89 c6                	mov    %eax,%esi
 197:	e8 46 03 00 00       	call   4e2 <getpid>
 19c:	89 74 24 0c          	mov    %esi,0xc(%esp)
 1a0:	c7 44 24 04 68 09 00 	movl   $0x968,0x4(%esp)
 1a7:	00 
 1a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1af:	89 44 24 08          	mov    %eax,0x8(%esp)
 1b3:	e8 08 04 00 00       	call   5c0 <printf>
 1b8:	eb 99                	jmp    153 <main+0x153>
        set_prior(0);
 1ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1c1:	e8 3c 03 00 00       	call   502 <set_prior>
        printf(1,"child %d's priority %d at start \n",getpid(), get_prior());
 1c6:	e8 3f 03 00 00       	call   50a <get_prior>
 1cb:	89 c3                	mov    %eax,%ebx
 1cd:	e8 10 03 00 00       	call   4e2 <getpid>
 1d2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
        for (i = 0; i < 10; i++) {
 1d6:	31 db                	xor    %ebx,%ebx
        printf(1,"child %d's priority %d at start \n",getpid(), get_prior());
 1d8:	c7 44 24 04 44 09 00 	movl   $0x944,0x4(%esp)
 1df:	00 
 1e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1e7:	89 44 24 08          	mov    %eax,0x8(%esp)
 1eb:	e8 d0 03 00 00       	call   5c0 <printf>
            asm("nop");
 1f0:	90                   	nop
 1f1:	b8 40 42 0f 00       	mov    $0xf4240,%eax
 1f6:	66 90                	xchg   %ax,%ax
                asm("nop");
 1f8:	90                   	nop
            for (j = 0; j < 1000000; j++) {
 1f9:	83 e8 01             	sub    $0x1,%eax
 1fc:	75 fa                	jne    1f8 <main+0x1f8>
            if(i%2 == 1)
 1fe:	f6 c3 01             	test   $0x1,%bl
 201:	75 0d                	jne    210 <main+0x210>
        for (i = 0; i < 10; i++) {
 203:	83 c3 01             	add    $0x1,%ebx
 206:	83 fb 0a             	cmp    $0xa,%ebx
 209:	75 e5                	jne    1f0 <main+0x1f0>
 20b:	e9 93 fe ff ff       	jmp    a3 <main+0xa3>
                printf(1,"child %d's priority %d in between \n",getpid(), get_prior());
 210:	e8 f5 02 00 00       	call   50a <get_prior>
 215:	89 c6                	mov    %eax,%esi
 217:	e8 c6 02 00 00       	call   4e2 <getpid>
 21c:	89 74 24 0c          	mov    %esi,0xc(%esp)
 220:	c7 44 24 04 68 09 00 	movl   $0x968,0x4(%esp)
 227:	00 
 228:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 22f:	89 44 24 08          	mov    %eax,0x8(%esp)
 233:	e8 88 03 00 00       	call   5c0 <printf>
 238:	eb c9                	jmp    203 <main+0x203>
 23a:	66 90                	xchg   %ax,%ax
 23c:	66 90                	xchg   %ax,%ax
 23e:	66 90                	xchg   %ax,%ax

00000240 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 249:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 24a:	89 c2                	mov    %eax,%edx
 24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 250:	83 c1 01             	add    $0x1,%ecx
 253:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 257:	83 c2 01             	add    $0x1,%edx
 25a:	84 db                	test   %bl,%bl
 25c:	88 5a ff             	mov    %bl,-0x1(%edx)
 25f:	75 ef                	jne    250 <strcpy+0x10>
    ;
  return os;
}
 261:	5b                   	pop    %ebx
 262:	5d                   	pop    %ebp
 263:	c3                   	ret    
 264:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 26a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000270 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	8b 55 08             	mov    0x8(%ebp),%edx
 276:	53                   	push   %ebx
 277:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 27a:	0f b6 02             	movzbl (%edx),%eax
 27d:	84 c0                	test   %al,%al
 27f:	74 2d                	je     2ae <strcmp+0x3e>
 281:	0f b6 19             	movzbl (%ecx),%ebx
 284:	38 d8                	cmp    %bl,%al
 286:	74 0e                	je     296 <strcmp+0x26>
 288:	eb 2b                	jmp    2b5 <strcmp+0x45>
 28a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 290:	38 c8                	cmp    %cl,%al
 292:	75 15                	jne    2a9 <strcmp+0x39>
    p++, q++;
 294:	89 d9                	mov    %ebx,%ecx
 296:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 299:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 29c:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 29f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 2a3:	84 c0                	test   %al,%al
 2a5:	75 e9                	jne    290 <strcmp+0x20>
 2a7:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 2a9:	29 c8                	sub    %ecx,%eax
}
 2ab:	5b                   	pop    %ebx
 2ac:	5d                   	pop    %ebp
 2ad:	c3                   	ret    
 2ae:	0f b6 09             	movzbl (%ecx),%ecx
  while(*p && *p == *q)
 2b1:	31 c0                	xor    %eax,%eax
 2b3:	eb f4                	jmp    2a9 <strcmp+0x39>
 2b5:	0f b6 cb             	movzbl %bl,%ecx
 2b8:	eb ef                	jmp    2a9 <strcmp+0x39>
 2ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002c0 <strlen>:

uint
strlen(const char *s)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 2c6:	80 39 00             	cmpb   $0x0,(%ecx)
 2c9:	74 12                	je     2dd <strlen+0x1d>
 2cb:	31 d2                	xor    %edx,%edx
 2cd:	8d 76 00             	lea    0x0(%esi),%esi
 2d0:	83 c2 01             	add    $0x1,%edx
 2d3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 2d7:	89 d0                	mov    %edx,%eax
 2d9:	75 f5                	jne    2d0 <strlen+0x10>
    ;
  return n;
}
 2db:	5d                   	pop    %ebp
 2dc:	c3                   	ret    
  for(n = 0; s[n]; n++)
 2dd:	31 c0                	xor    %eax,%eax
}
 2df:	5d                   	pop    %ebp
 2e0:	c3                   	ret    
 2e1:	eb 0d                	jmp    2f0 <memset>
 2e3:	90                   	nop
 2e4:	90                   	nop
 2e5:	90                   	nop
 2e6:	90                   	nop
 2e7:	90                   	nop
 2e8:	90                   	nop
 2e9:	90                   	nop
 2ea:	90                   	nop
 2eb:	90                   	nop
 2ec:	90                   	nop
 2ed:	90                   	nop
 2ee:	90                   	nop
 2ef:	90                   	nop

000002f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	8b 55 08             	mov    0x8(%ebp),%edx
 2f6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fd:	89 d7                	mov    %edx,%edi
 2ff:	fc                   	cld    
 300:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 302:	89 d0                	mov    %edx,%eax
 304:	5f                   	pop    %edi
 305:	5d                   	pop    %ebp
 306:	c3                   	ret    
 307:	89 f6                	mov    %esi,%esi
 309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000310 <strchr>:

char*
strchr(const char *s, char c)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	53                   	push   %ebx
 317:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 31a:	0f b6 18             	movzbl (%eax),%ebx
 31d:	84 db                	test   %bl,%bl
 31f:	74 1d                	je     33e <strchr+0x2e>
    if(*s == c)
 321:	38 d3                	cmp    %dl,%bl
 323:	89 d1                	mov    %edx,%ecx
 325:	75 0d                	jne    334 <strchr+0x24>
 327:	eb 17                	jmp    340 <strchr+0x30>
 329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 330:	38 ca                	cmp    %cl,%dl
 332:	74 0c                	je     340 <strchr+0x30>
  for(; *s; s++)
 334:	83 c0 01             	add    $0x1,%eax
 337:	0f b6 10             	movzbl (%eax),%edx
 33a:	84 d2                	test   %dl,%dl
 33c:	75 f2                	jne    330 <strchr+0x20>
      return (char*)s;
  return 0;
 33e:	31 c0                	xor    %eax,%eax
}
 340:	5b                   	pop    %ebx
 341:	5d                   	pop    %ebp
 342:	c3                   	ret    
 343:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000350 <gets>:

char*
gets(char *buf, int max)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 355:	31 f6                	xor    %esi,%esi
{
 357:	53                   	push   %ebx
 358:	83 ec 2c             	sub    $0x2c,%esp
    cc = read(0, &c, 1);
 35b:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 35e:	eb 31                	jmp    391 <gets+0x41>
    cc = read(0, &c, 1);
 360:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 367:	00 
 368:	89 7c 24 04          	mov    %edi,0x4(%esp)
 36c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 373:	e8 02 01 00 00       	call   47a <read>
    if(cc < 1)
 378:	85 c0                	test   %eax,%eax
 37a:	7e 1d                	jle    399 <gets+0x49>
      break;
    buf[i++] = c;
 37c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  for(i=0; i+1 < max; ){
 380:	89 de                	mov    %ebx,%esi
    buf[i++] = c;
 382:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 385:	3c 0d                	cmp    $0xd,%al
    buf[i++] = c;
 387:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 38b:	74 0c                	je     399 <gets+0x49>
 38d:	3c 0a                	cmp    $0xa,%al
 38f:	74 08                	je     399 <gets+0x49>
  for(i=0; i+1 < max; ){
 391:	8d 5e 01             	lea    0x1(%esi),%ebx
 394:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 397:	7c c7                	jl     360 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 399:	8b 45 08             	mov    0x8(%ebp),%eax
 39c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 3a0:	83 c4 2c             	add    $0x2c,%esp
 3a3:	5b                   	pop    %ebx
 3a4:	5e                   	pop    %esi
 3a5:	5f                   	pop    %edi
 3a6:	5d                   	pop    %ebp
 3a7:	c3                   	ret    
 3a8:	90                   	nop
 3a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	56                   	push   %esi
 3b4:	53                   	push   %ebx
 3b5:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b8:	8b 45 08             	mov    0x8(%ebp),%eax
 3bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3c2:	00 
 3c3:	89 04 24             	mov    %eax,(%esp)
 3c6:	e8 d7 00 00 00       	call   4a2 <open>
  if(fd < 0)
 3cb:	85 c0                	test   %eax,%eax
  fd = open(n, O_RDONLY);
 3cd:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 3cf:	78 27                	js     3f8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 3d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d4:	89 1c 24             	mov    %ebx,(%esp)
 3d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 3db:	e8 da 00 00 00       	call   4ba <fstat>
  close(fd);
 3e0:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 3e3:	89 c6                	mov    %eax,%esi
  close(fd);
 3e5:	e8 a0 00 00 00       	call   48a <close>
  return r;
 3ea:	89 f0                	mov    %esi,%eax
}
 3ec:	83 c4 10             	add    $0x10,%esp
 3ef:	5b                   	pop    %ebx
 3f0:	5e                   	pop    %esi
 3f1:	5d                   	pop    %ebp
 3f2:	c3                   	ret    
 3f3:	90                   	nop
 3f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 3f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3fd:	eb ed                	jmp    3ec <stat+0x3c>
 3ff:	90                   	nop

00000400 <atoi>:

int
atoi(const char *s)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	8b 4d 08             	mov    0x8(%ebp),%ecx
 406:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 407:	0f be 11             	movsbl (%ecx),%edx
 40a:	8d 42 d0             	lea    -0x30(%edx),%eax
 40d:	3c 09                	cmp    $0x9,%al
  n = 0;
 40f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 414:	77 17                	ja     42d <atoi+0x2d>
 416:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 418:	83 c1 01             	add    $0x1,%ecx
 41b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 41e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 422:	0f be 11             	movsbl (%ecx),%edx
 425:	8d 5a d0             	lea    -0x30(%edx),%ebx
 428:	80 fb 09             	cmp    $0x9,%bl
 42b:	76 eb                	jbe    418 <atoi+0x18>
  return n;
}
 42d:	5b                   	pop    %ebx
 42e:	5d                   	pop    %ebp
 42f:	c3                   	ret    

00000430 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 430:	55                   	push   %ebp
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 431:	31 d2                	xor    %edx,%edx
{
 433:	89 e5                	mov    %esp,%ebp
 435:	56                   	push   %esi
 436:	8b 45 08             	mov    0x8(%ebp),%eax
 439:	53                   	push   %ebx
 43a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 43d:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n-- > 0)
 440:	85 db                	test   %ebx,%ebx
 442:	7e 12                	jle    456 <memmove+0x26>
 444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 448:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 44c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 44f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 452:	39 da                	cmp    %ebx,%edx
 454:	75 f2                	jne    448 <memmove+0x18>
  return vdst;
}
 456:	5b                   	pop    %ebx
 457:	5e                   	pop    %esi
 458:	5d                   	pop    %ebp
 459:	c3                   	ret    

0000045a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 45a:	b8 01 00 00 00       	mov    $0x1,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <exit>:
SYSCALL(exit)
 462:	b8 02 00 00 00       	mov    $0x2,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <wait>:
SYSCALL(wait)
 46a:	b8 03 00 00 00       	mov    $0x3,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <pipe>:
SYSCALL(pipe)
 472:	b8 04 00 00 00       	mov    $0x4,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <read>:
SYSCALL(read)
 47a:	b8 05 00 00 00       	mov    $0x5,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <write>:
SYSCALL(write)
 482:	b8 10 00 00 00       	mov    $0x10,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <close>:
SYSCALL(close)
 48a:	b8 15 00 00 00       	mov    $0x15,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <kill>:
SYSCALL(kill)
 492:	b8 06 00 00 00       	mov    $0x6,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <exec>:
SYSCALL(exec)
 49a:	b8 07 00 00 00       	mov    $0x7,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <open>:
SYSCALL(open)
 4a2:	b8 0f 00 00 00       	mov    $0xf,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <mknod>:
SYSCALL(mknod)
 4aa:	b8 11 00 00 00       	mov    $0x11,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <unlink>:
SYSCALL(unlink)
 4b2:	b8 12 00 00 00       	mov    $0x12,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <fstat>:
SYSCALL(fstat)
 4ba:	b8 08 00 00 00       	mov    $0x8,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <link>:
SYSCALL(link)
 4c2:	b8 13 00 00 00       	mov    $0x13,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <mkdir>:
SYSCALL(mkdir)
 4ca:	b8 14 00 00 00       	mov    $0x14,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <chdir>:
SYSCALL(chdir)
 4d2:	b8 09 00 00 00       	mov    $0x9,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <dup>:
SYSCALL(dup)
 4da:	b8 0a 00 00 00       	mov    $0xa,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <getpid>:
SYSCALL(getpid)
 4e2:	b8 0b 00 00 00       	mov    $0xb,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <sbrk>:
SYSCALL(sbrk)
 4ea:	b8 0c 00 00 00       	mov    $0xc,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <sleep>:
SYSCALL(sleep)
 4f2:	b8 0d 00 00 00       	mov    $0xd,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <uptime>:
SYSCALL(uptime)
 4fa:	b8 0e 00 00 00       	mov    $0xe,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <set_prior>:
SYSCALL(set_prior)
 502:	b8 16 00 00 00       	mov    $0x16,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <get_prior>:
 50a:	b8 17 00 00 00       	mov    $0x17,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    
 512:	66 90                	xchg   %ax,%ax
 514:	66 90                	xchg   %ax,%ax
 516:	66 90                	xchg   %ax,%ax
 518:	66 90                	xchg   %ax,%ax
 51a:	66 90                	xchg   %ax,%ax
 51c:	66 90                	xchg   %ax,%ax
 51e:	66 90                	xchg   %ax,%ax

00000520 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	57                   	push   %edi
 524:	56                   	push   %esi
 525:	89 c6                	mov    %eax,%esi
 527:	53                   	push   %ebx
 528:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 52b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 52e:	85 db                	test   %ebx,%ebx
 530:	74 09                	je     53b <printint+0x1b>
 532:	89 d0                	mov    %edx,%eax
 534:	c1 e8 1f             	shr    $0x1f,%eax
 537:	84 c0                	test   %al,%al
 539:	75 75                	jne    5b0 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 53b:	89 d0                	mov    %edx,%eax
  neg = 0;
 53d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 544:	89 75 c0             	mov    %esi,-0x40(%ebp)
  }

  i = 0;
 547:	31 ff                	xor    %edi,%edi
 549:	89 ce                	mov    %ecx,%esi
 54b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 54e:	eb 02                	jmp    552 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 550:	89 cf                	mov    %ecx,%edi
 552:	31 d2                	xor    %edx,%edx
 554:	f7 f6                	div    %esi
 556:	8d 4f 01             	lea    0x1(%edi),%ecx
 559:	0f b6 92 b3 09 00 00 	movzbl 0x9b3(%edx),%edx
  }while((x /= base) != 0);
 560:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 562:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 565:	75 e9                	jne    550 <printint+0x30>
  if(neg)
 567:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    buf[i++] = digits[x % base];
 56a:	89 c8                	mov    %ecx,%eax
 56c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  if(neg)
 56f:	85 d2                	test   %edx,%edx
 571:	74 08                	je     57b <printint+0x5b>
    buf[i++] = '-';
 573:	8d 4f 02             	lea    0x2(%edi),%ecx
 576:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 57b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 57e:	66 90                	xchg   %ax,%ax
 580:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 585:	83 ef 01             	sub    $0x1,%edi
  write(fd, &c, 1);
 588:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 58f:	00 
 590:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 594:	89 34 24             	mov    %esi,(%esp)
 597:	88 45 d7             	mov    %al,-0x29(%ebp)
 59a:	e8 e3 fe ff ff       	call   482 <write>
  while(--i >= 0)
 59f:	83 ff ff             	cmp    $0xffffffff,%edi
 5a2:	75 dc                	jne    580 <printint+0x60>
    putc(fd, buf[i]);
}
 5a4:	83 c4 4c             	add    $0x4c,%esp
 5a7:	5b                   	pop    %ebx
 5a8:	5e                   	pop    %esi
 5a9:	5f                   	pop    %edi
 5aa:	5d                   	pop    %ebp
 5ab:	c3                   	ret    
 5ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    x = -xx;
 5b0:	89 d0                	mov    %edx,%eax
 5b2:	f7 d8                	neg    %eax
    neg = 1;
 5b4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 5bb:	eb 87                	jmp    544 <printint+0x24>
 5bd:	8d 76 00             	lea    0x0(%esi),%esi

000005c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5c4:	31 ff                	xor    %edi,%edi
{
 5c6:	56                   	push   %esi
 5c7:	53                   	push   %ebx
 5c8:	83 ec 3c             	sub    $0x3c,%esp
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  ap = (uint*)(void*)&fmt + 1;
 5ce:	8d 45 10             	lea    0x10(%ebp),%eax
{
 5d1:	8b 75 08             	mov    0x8(%ebp),%esi
  ap = (uint*)(void*)&fmt + 1;
 5d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 5d7:	0f b6 13             	movzbl (%ebx),%edx
 5da:	83 c3 01             	add    $0x1,%ebx
 5dd:	84 d2                	test   %dl,%dl
 5df:	75 39                	jne    61a <printf+0x5a>
 5e1:	e9 c2 00 00 00       	jmp    6a8 <printf+0xe8>
 5e6:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5e8:	83 fa 25             	cmp    $0x25,%edx
 5eb:	0f 84 bf 00 00 00    	je     6b0 <printf+0xf0>
  write(fd, &c, 1);
 5f1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 5f4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5fb:	00 
 5fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 600:	89 34 24             	mov    %esi,(%esp)
        state = '%';
      } else {
        putc(fd, c);
 603:	88 55 e2             	mov    %dl,-0x1e(%ebp)
  write(fd, &c, 1);
 606:	e8 77 fe ff ff       	call   482 <write>
 60b:	83 c3 01             	add    $0x1,%ebx
  for(i = 0; fmt[i]; i++){
 60e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 612:	84 d2                	test   %dl,%dl
 614:	0f 84 8e 00 00 00    	je     6a8 <printf+0xe8>
    if(state == 0){
 61a:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 61c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 61f:	74 c7                	je     5e8 <printf+0x28>
      }
    } else if(state == '%'){
 621:	83 ff 25             	cmp    $0x25,%edi
 624:	75 e5                	jne    60b <printf+0x4b>
      if(c == 'd'){
 626:	83 fa 64             	cmp    $0x64,%edx
 629:	0f 84 31 01 00 00    	je     760 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 62f:	25 f7 00 00 00       	and    $0xf7,%eax
 634:	83 f8 70             	cmp    $0x70,%eax
 637:	0f 84 83 00 00 00    	je     6c0 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 63d:	83 fa 73             	cmp    $0x73,%edx
 640:	0f 84 a2 00 00 00    	je     6e8 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 646:	83 fa 63             	cmp    $0x63,%edx
 649:	0f 84 35 01 00 00    	je     784 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 64f:	83 fa 25             	cmp    $0x25,%edx
 652:	0f 84 e0 00 00 00    	je     738 <printf+0x178>
  write(fd, &c, 1);
 658:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 65b:	83 c3 01             	add    $0x1,%ebx
 65e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 665:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 666:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 668:	89 44 24 04          	mov    %eax,0x4(%esp)
 66c:	89 34 24             	mov    %esi,(%esp)
 66f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 672:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 676:	e8 07 fe ff ff       	call   482 <write>
        putc(fd, c);
 67b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  write(fd, &c, 1);
 67e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 681:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 688:	00 
 689:	89 44 24 04          	mov    %eax,0x4(%esp)
 68d:	89 34 24             	mov    %esi,(%esp)
        putc(fd, c);
 690:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 693:	e8 ea fd ff ff       	call   482 <write>
  for(i = 0; fmt[i]; i++){
 698:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 69c:	84 d2                	test   %dl,%dl
 69e:	0f 85 76 ff ff ff    	jne    61a <printf+0x5a>
 6a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }
}
 6a8:	83 c4 3c             	add    $0x3c,%esp
 6ab:	5b                   	pop    %ebx
 6ac:	5e                   	pop    %esi
 6ad:	5f                   	pop    %edi
 6ae:	5d                   	pop    %ebp
 6af:	c3                   	ret    
        state = '%';
 6b0:	bf 25 00 00 00       	mov    $0x25,%edi
 6b5:	e9 51 ff ff ff       	jmp    60b <printf+0x4b>
 6ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 6c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 6c3:	b9 10 00 00 00       	mov    $0x10,%ecx
      state = 0;
 6c8:	31 ff                	xor    %edi,%edi
        printint(fd, *ap, 16, 0);
 6ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 6d1:	8b 10                	mov    (%eax),%edx
 6d3:	89 f0                	mov    %esi,%eax
 6d5:	e8 46 fe ff ff       	call   520 <printint>
        ap++;
 6da:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 6de:	e9 28 ff ff ff       	jmp    60b <printf+0x4b>
 6e3:	90                   	nop
 6e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 6e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 6eb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        s = (char*)*ap;
 6ef:	8b 38                	mov    (%eax),%edi
          s = "(null)";
 6f1:	b8 ac 09 00 00       	mov    $0x9ac,%eax
 6f6:	85 ff                	test   %edi,%edi
 6f8:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 6fb:	0f b6 07             	movzbl (%edi),%eax
 6fe:	84 c0                	test   %al,%al
 700:	74 2a                	je     72c <printf+0x16c>
 702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 708:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 70b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
          s++;
 70e:	83 c7 01             	add    $0x1,%edi
  write(fd, &c, 1);
 711:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 718:	00 
 719:	89 44 24 04          	mov    %eax,0x4(%esp)
 71d:	89 34 24             	mov    %esi,(%esp)
 720:	e8 5d fd ff ff       	call   482 <write>
        while(*s != 0){
 725:	0f b6 07             	movzbl (%edi),%eax
 728:	84 c0                	test   %al,%al
 72a:	75 dc                	jne    708 <printf+0x148>
      state = 0;
 72c:	31 ff                	xor    %edi,%edi
 72e:	e9 d8 fe ff ff       	jmp    60b <printf+0x4b>
 733:	90                   	nop
 734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 738:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      state = 0;
 73b:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 73d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 744:	00 
 745:	89 44 24 04          	mov    %eax,0x4(%esp)
 749:	89 34 24             	mov    %esi,(%esp)
 74c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 750:	e8 2d fd ff ff       	call   482 <write>
 755:	e9 b1 fe ff ff       	jmp    60b <printf+0x4b>
 75a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 760:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 763:	b9 0a 00 00 00       	mov    $0xa,%ecx
      state = 0;
 768:	66 31 ff             	xor    %di,%di
        printint(fd, *ap, 10, 1);
 76b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 772:	8b 10                	mov    (%eax),%edx
 774:	89 f0                	mov    %esi,%eax
 776:	e8 a5 fd ff ff       	call   520 <printint>
        ap++;
 77b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 77f:	e9 87 fe ff ff       	jmp    60b <printf+0x4b>
        putc(fd, *ap);
 784:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      state = 0;
 787:	31 ff                	xor    %edi,%edi
        putc(fd, *ap);
 789:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 78b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 792:	00 
 793:	89 34 24             	mov    %esi,(%esp)
        putc(fd, *ap);
 796:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 799:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 79c:	89 44 24 04          	mov    %eax,0x4(%esp)
 7a0:	e8 dd fc ff ff       	call   482 <write>
        ap++;
 7a5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 7a9:	e9 5d fe ff ff       	jmp    60b <printf+0x4b>
 7ae:	66 90                	xchg   %ax,%ax

000007b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b1:	a1 2c 0c 00 00       	mov    0xc2c,%eax
{
 7b6:	89 e5                	mov    %esp,%ebp
 7b8:	57                   	push   %edi
 7b9:	56                   	push   %esi
 7ba:	53                   	push   %ebx
 7bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7be:	8b 08                	mov    (%eax),%ecx
  bp = (Header*)ap - 1;
 7c0:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c3:	39 d0                	cmp    %edx,%eax
 7c5:	72 11                	jb     7d8 <free+0x28>
 7c7:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c8:	39 c8                	cmp    %ecx,%eax
 7ca:	72 04                	jb     7d0 <free+0x20>
 7cc:	39 ca                	cmp    %ecx,%edx
 7ce:	72 10                	jb     7e0 <free+0x30>
 7d0:	89 c8                	mov    %ecx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d2:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d4:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d6:	73 f0                	jae    7c8 <free+0x18>
 7d8:	39 ca                	cmp    %ecx,%edx
 7da:	72 04                	jb     7e0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7dc:	39 c8                	cmp    %ecx,%eax
 7de:	72 f0                	jb     7d0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7e3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 7e6:	39 cf                	cmp    %ecx,%edi
 7e8:	74 1e                	je     808 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7ea:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7ed:	8b 48 04             	mov    0x4(%eax),%ecx
 7f0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 7f3:	39 f2                	cmp    %esi,%edx
 7f5:	74 28                	je     81f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7f7:	89 10                	mov    %edx,(%eax)
  freep = p;
 7f9:	a3 2c 0c 00 00       	mov    %eax,0xc2c
}
 7fe:	5b                   	pop    %ebx
 7ff:	5e                   	pop    %esi
 800:	5f                   	pop    %edi
 801:	5d                   	pop    %ebp
 802:	c3                   	ret    
 803:	90                   	nop
 804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 808:	03 71 04             	add    0x4(%ecx),%esi
 80b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 80e:	8b 08                	mov    (%eax),%ecx
 810:	8b 09                	mov    (%ecx),%ecx
 812:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 815:	8b 48 04             	mov    0x4(%eax),%ecx
 818:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 81b:	39 f2                	cmp    %esi,%edx
 81d:	75 d8                	jne    7f7 <free+0x47>
    p->s.size += bp->s.size;
 81f:	03 4b fc             	add    -0x4(%ebx),%ecx
  freep = p;
 822:	a3 2c 0c 00 00       	mov    %eax,0xc2c
    p->s.size += bp->s.size;
 827:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 82a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 82d:	89 10                	mov    %edx,(%eax)
}
 82f:	5b                   	pop    %ebx
 830:	5e                   	pop    %esi
 831:	5f                   	pop    %edi
 832:	5d                   	pop    %ebp
 833:	c3                   	ret    
 834:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 83a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000840 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 840:	55                   	push   %ebp
 841:	89 e5                	mov    %esp,%ebp
 843:	57                   	push   %edi
 844:	56                   	push   %esi
 845:	53                   	push   %ebx
 846:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 849:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 84c:	8b 1d 2c 0c 00 00    	mov    0xc2c,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 852:	8d 48 07             	lea    0x7(%eax),%ecx
 855:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 858:	85 db                	test   %ebx,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 85a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 85d:	0f 84 9b 00 00 00    	je     8fe <malloc+0xbe>
 863:	8b 13                	mov    (%ebx),%edx
 865:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 868:	39 fe                	cmp    %edi,%esi
 86a:	76 64                	jbe    8d0 <malloc+0x90>
 86c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  if(nu < 4096)
 873:	bb 00 80 00 00       	mov    $0x8000,%ebx
 878:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 87b:	eb 0e                	jmp    88b <malloc+0x4b>
 87d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 880:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 882:	8b 78 04             	mov    0x4(%eax),%edi
 885:	39 fe                	cmp    %edi,%esi
 887:	76 4f                	jbe    8d8 <malloc+0x98>
 889:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 88b:	3b 15 2c 0c 00 00    	cmp    0xc2c,%edx
 891:	75 ed                	jne    880 <malloc+0x40>
  if(nu < 4096)
 893:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 896:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 89c:	bf 00 10 00 00       	mov    $0x1000,%edi
 8a1:	0f 43 fe             	cmovae %esi,%edi
 8a4:	0f 42 c3             	cmovb  %ebx,%eax
  p = sbrk(nu * sizeof(Header));
 8a7:	89 04 24             	mov    %eax,(%esp)
 8aa:	e8 3b fc ff ff       	call   4ea <sbrk>
  if(p == (char*)-1)
 8af:	83 f8 ff             	cmp    $0xffffffff,%eax
 8b2:	74 18                	je     8cc <malloc+0x8c>
  hp->s.size = nu;
 8b4:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 8b7:	83 c0 08             	add    $0x8,%eax
 8ba:	89 04 24             	mov    %eax,(%esp)
 8bd:	e8 ee fe ff ff       	call   7b0 <free>
  return freep;
 8c2:	8b 15 2c 0c 00 00    	mov    0xc2c,%edx
      if((p = morecore(nunits)) == 0)
 8c8:	85 d2                	test   %edx,%edx
 8ca:	75 b4                	jne    880 <malloc+0x40>
        return 0;
 8cc:	31 c0                	xor    %eax,%eax
 8ce:	eb 20                	jmp    8f0 <malloc+0xb0>
    if(p->s.size >= nunits){
 8d0:	89 d0                	mov    %edx,%eax
 8d2:	89 da                	mov    %ebx,%edx
 8d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 8d8:	39 fe                	cmp    %edi,%esi
 8da:	74 1c                	je     8f8 <malloc+0xb8>
        p->s.size -= nunits;
 8dc:	29 f7                	sub    %esi,%edi
 8de:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 8e1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 8e4:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 8e7:	89 15 2c 0c 00 00    	mov    %edx,0xc2c
      return (void*)(p + 1);
 8ed:	83 c0 08             	add    $0x8,%eax
  }
}
 8f0:	83 c4 1c             	add    $0x1c,%esp
 8f3:	5b                   	pop    %ebx
 8f4:	5e                   	pop    %esi
 8f5:	5f                   	pop    %edi
 8f6:	5d                   	pop    %ebp
 8f7:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 8f8:	8b 08                	mov    (%eax),%ecx
 8fa:	89 0a                	mov    %ecx,(%edx)
 8fc:	eb e9                	jmp    8e7 <malloc+0xa7>
    base.s.ptr = freep = prevp = &base;
 8fe:	c7 05 2c 0c 00 00 30 	movl   $0xc30,0xc2c
 905:	0c 00 00 
    base.s.size = 0;
 908:	ba 30 0c 00 00       	mov    $0xc30,%edx
    base.s.ptr = freep = prevp = &base;
 90d:	c7 05 30 0c 00 00 30 	movl   $0xc30,0xc30
 914:	0c 00 00 
    base.s.size = 0;
 917:	c7 05 34 0c 00 00 00 	movl   $0x0,0xc34
 91e:	00 00 00 
 921:	e9 46 ff ff ff       	jmp    86c <malloc+0x2c>
