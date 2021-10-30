
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 10 2e 10 80       	mov    $0x80102e10,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 14             	sub    $0x14,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 60 6e 10 	movl   $0x80106e60,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 40 42 00 00       	call   801042a0 <initlock>
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 67 6e 10 	movl   $0x80106e67,0x4(%esp)
8010009b:	80 
8010009c:	e8 cf 40 00 00       	call   80104170 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000e6:	e8 25 43 00 00       	call   80104410 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 1a 43 00 00       	call   80104480 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 3f 40 00 00       	call   801041b0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 c2 1f 00 00       	call   80102140 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
  panic("bget: no buffers");
80100188:	c7 04 24 6e 6e 10 80 	movl   $0x80106e6e,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 9b 40 00 00       	call   80104250 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
  iderw(b);
801001c4:	e9 77 1f 00 00       	jmp    80102140 <iderw>
    panic("bwrite");
801001c9:	c7 04 24 7f 6e 10 80 	movl   $0x80106e7f,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 5a 40 00 00       	call   80104250 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 0e 40 00 00       	call   80104210 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 02 42 00 00       	call   80104410 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100250:	e9 2b 42 00 00       	jmp    80104480 <release>
    panic("brelse");
80100255:	c7 04 24 86 6e 10 80 	movl   $0x80106e86,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 29 15 00 00       	call   801017b0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 7d 41 00 00       	call   80104410 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 33 34 00 00       	call   801036e0 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 a8 3a 00 00       	call   80103d70 <sleep>
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 6a 41 00 00       	call   80104480 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 b2 13 00 00       	call   801016d0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 4c 41 00 00       	call   80104480 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 94 13 00 00       	call   801016d0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        input.r--;
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 05 24 00 00       	call   80102780 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 8d 6e 10 80 	movl   $0x80106e8d,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 3f 78 10 80 	movl   $0x8010783f,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 0c 3f 00 00       	call   801042c0 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 a1 6e 10 80 	movl   $0x80106ea1,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 c2 55 00 00       	call   801059d0 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx
  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 
  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 12 55 00 00       	call   801059d0 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 06 55 00 00       	call   801059d0 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 fa 54 00 00       	call   801059d0 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 6f 40 00 00       	call   80104570 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 b2 3f 00 00       	call   801044d0 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    panic("pos under/overflow");
8010052a:	c7 04 24 a5 6e 10 80 	movl   $0x80106ea5,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 d0 6e 10 80 	movzbl -0x7fef9130(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>
  if(sign)
801005a8:	85 ff                	test   %edi,%edi
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 a9 11 00 00       	call   801017b0 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 fd 3d 00 00       	call   80104410 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 45 3e 00 00       	call   80104480 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 8a 10 00 00       	call   801016d0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 88 3d 00 00       	call   80104480 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 b8 6e 10 80       	mov    $0x80106eb8,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 74 3c 00 00       	call   80104410 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
    panic("null fmt");
801007a1:	c7 04 24 bf 6e 10 80 	movl   $0x80106ebf,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 46 3c 00 00       	call   80104410 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
      if(input.e != input.w){
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 54 3c 00 00       	call   80104480 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          wakeup(&input.r);
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
          input.w = input.e;
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008b2:	e8 59 36 00 00       	call   80103f10 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
      while(input.e != input.w &&
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 d4 36 00 00       	jmp    80104000 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 c8 6e 10 	movl   $0x80106ec8,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 36 39 00 00       	call   801042a0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100997:	e8 34 19 00 00       	call   801022d0 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 2f 2d 00 00       	call   801036e0 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 74 21 00 00       	call   80102b30 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 59 15 00 00       	call   80101f20 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 c2 01 00 00    	je     80100b93 <exec+0x1f3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 f7 0c 00 00       	call   801016d0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 85 0f 00 00       	call   80101980 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 28 0f 00 00       	call   80101930 <iunlockput>
    end_op();
80100a08:	e8 93 21 00 00       	call   80102ba0 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 8f 61 00 00       	call   80106bc0 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 ed 0e 00 00       	call   80101980 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 59 5f 00 00       	call   80106a30 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 58 5e 00 00       	call   80106970 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 12 60 00 00       	call   80106b40 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 f5 0d 00 00       	call   80101930 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 5b 20 00 00       	call   80102ba0 <end_op>
  sz = PGROUNDUP(sz);
80100b45:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 bf 5e 00 00       	call   80106a30 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100b79:	75 33                	jne    80100bae <exec+0x20e>
    freevm(pgdir);
80100b7b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 b7 5f 00 00       	call   80106b40 <freevm>
  return -1;
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 7f fe ff ff       	jmp    80100a12 <exec+0x72>
    end_op();
80100b93:	e8 08 20 00 00       	call   80102ba0 <end_op>
    cprintf("exec: fail\n");
80100b98:	c7 04 24 e1 6e 10 80 	movl   $0x80106ee1,(%esp)
80100b9f:	e8 ac fa ff ff       	call   80100650 <cprintf>
    return -1;
80100ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba9:	e9 64 fe ff ff       	jmp    80100a12 <exec+0x72>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bae:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100bb4:	89 d8                	mov    %ebx,%eax
80100bb6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bc5:	89 04 24             	mov    %eax,(%esp)
80100bc8:	e8 a3 60 00 00       	call   80106c70 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bd0:	8b 00                	mov    (%eax),%eax
80100bd2:	85 c0                	test   %eax,%eax
80100bd4:	0f 84 7c 01 00 00    	je     80100d56 <exec+0x3b6>
80100bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bdd:	31 d2                	xor    %edx,%edx
80100bdf:	8d 71 04             	lea    0x4(%ecx),%esi
80100be2:	89 cf                	mov    %ecx,%edi
80100be4:	89 d1                	mov    %edx,%ecx
80100be6:	89 f2                	mov    %esi,%edx
80100be8:	89 fe                	mov    %edi,%esi
80100bea:	89 cf                	mov    %ecx,%edi
80100bec:	eb 0a                	jmp    80100bf8 <exec+0x258>
80100bee:	66 90                	xchg   %ax,%ax
80100bf0:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bf3:	83 ff 20             	cmp    $0x20,%edi
80100bf6:	74 83                	je     80100b7b <exec+0x1db>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bf8:	89 04 24             	mov    %eax,(%esp)
80100bfb:	89 95 ec fe ff ff    	mov    %edx,-0x114(%ebp)
80100c01:	e8 ea 3a 00 00       	call   801046f0 <strlen>
80100c06:	f7 d0                	not    %eax
80100c08:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0a:	8b 06                	mov    (%esi),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c0c:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0f:	89 04 24             	mov    %eax,(%esp)
80100c12:	e8 d9 3a 00 00       	call   801046f0 <strlen>
80100c17:	83 c0 01             	add    $0x1,%eax
80100c1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c1e:	8b 06                	mov    (%esi),%eax
80100c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c2e:	89 04 24             	mov    %eax,(%esp)
80100c31:	e8 9a 61 00 00       	call   80106dd0 <copyout>
80100c36:	85 c0                	test   %eax,%eax
80100c38:	0f 88 3d ff ff ff    	js     80100b7b <exec+0x1db>
  for(argc = 0; argv[argc]; argc++) {
80100c3e:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
    ustack[3+argc] = sp;
80100c44:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100c4a:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c51:	83 c7 01             	add    $0x1,%edi
80100c54:	8b 02                	mov    (%edx),%eax
80100c56:	89 d6                	mov    %edx,%esi
80100c58:	85 c0                	test   %eax,%eax
80100c5a:	75 94                	jne    80100bf0 <exec+0x250>
80100c5c:	89 fa                	mov    %edi,%edx
  ustack[3+argc] = 0;
80100c5e:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c65:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c69:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
  ustack[1] = argc;
80100c70:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c76:	89 da                	mov    %ebx,%edx
80100c78:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100c7a:	83 c0 0c             	add    $0xc,%eax
80100c7d:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c83:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c8d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  ustack[0] = 0xffffffff;  // fake return PC
80100c91:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c98:	ff ff ff 
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c9b:	89 04 24             	mov    %eax,(%esp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c9e:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ca4:	e8 27 61 00 00       	call   80106dd0 <copyout>
80100ca9:	85 c0                	test   %eax,%eax
80100cab:	0f 88 ca fe ff ff    	js     80100b7b <exec+0x1db>
  for(last=s=path; *s; s++)
80100cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb4:	0f b6 10             	movzbl (%eax),%edx
80100cb7:	84 d2                	test   %dl,%dl
80100cb9:	74 19                	je     80100cd4 <exec+0x334>
80100cbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cbe:	83 c0 01             	add    $0x1,%eax
      last = s+1;
80100cc1:	80 fa 2f             	cmp    $0x2f,%dl
  for(last=s=path; *s; s++)
80100cc4:	0f b6 10             	movzbl (%eax),%edx
      last = s+1;
80100cc7:	0f 44 c8             	cmove  %eax,%ecx
80100cca:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100ccd:	84 d2                	test   %dl,%dl
80100ccf:	75 f0                	jne    80100cc1 <exec+0x321>
80100cd1:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cd4:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cda:	8b 45 08             	mov    0x8(%ebp),%eax
80100cdd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100ce4:	00 
80100ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce9:	89 f8                	mov    %edi,%eax
80100ceb:	83 c0 6c             	add    $0x6c,%eax
80100cee:	89 04 24             	mov    %eax,(%esp)
80100cf1:	e8 ba 39 00 00       	call   801046b0 <safestrcpy>
  curproc->pgdir = pgdir;
80100cf6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100cfc:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->tf->eip = elf.entry;  // main
80100cff:	8b 47 18             	mov    0x18(%edi),%eax
  curproc->pgdir = pgdir;
80100d02:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100d05:	8b 8d e8 fe ff ff    	mov    -0x118(%ebp),%ecx
80100d0b:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d0d:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d13:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d16:	8b 47 18             	mov    0x18(%edi),%eax
80100d19:	89 58 44             	mov    %ebx,0x44(%eax)
  acquire(&tickslock);
80100d1c:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
80100d23:	e8 e8 36 00 00       	call   80104410 <acquire>
  curproc->T_start = ticks;
80100d28:	a1 a0 59 11 80       	mov    0x801159a0,%eax
80100d2d:	89 87 80 00 00 00    	mov    %eax,0x80(%edi)
  release(&tickslock);
80100d33:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
80100d3a:	e8 41 37 00 00       	call   80104480 <release>
  switchuvm(curproc);
80100d3f:	89 3c 24             	mov    %edi,(%esp)
80100d42:	e8 99 5a 00 00       	call   801067e0 <switchuvm>
  freevm(oldpgdir);
80100d47:	89 34 24             	mov    %esi,(%esp)
80100d4a:	e8 f1 5d 00 00       	call   80106b40 <freevm>
  return 0;
80100d4f:	31 c0                	xor    %eax,%eax
80100d51:	e9 bc fc ff ff       	jmp    80100a12 <exec+0x72>
  for(argc = 0; argv[argc]; argc++) {
80100d56:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100d5c:	31 d2                	xor    %edx,%edx
80100d5e:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d64:	e9 f5 fe ff ff       	jmp    80100c5e <exec+0x2be>
80100d69:	66 90                	xchg   %ax,%ax
80100d6b:	66 90                	xchg   %ax,%ax
80100d6d:	66 90                	xchg   %ax,%ax
80100d6f:	90                   	nop

80100d70 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d76:	c7 44 24 04 ed 6e 10 	movl   $0x80106eed,0x4(%esp)
80100d7d:	80 
80100d7e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d85:	e8 16 35 00 00       	call   801042a0 <initlock>
}
80100d8a:	c9                   	leave  
80100d8b:	c3                   	ret    
80100d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d90 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d90:	55                   	push   %ebp
80100d91:	89 e5                	mov    %esp,%ebp
80100d93:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d94:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d99:	83 ec 14             	sub    $0x14,%esp
  acquire(&ftable.lock);
80100d9c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100da3:	e8 68 36 00 00       	call   80104410 <acquire>
80100da8:	eb 11                	jmp    80100dbb <filealloc+0x2b>
80100daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100db0:	83 c3 18             	add    $0x18,%ebx
80100db3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100db9:	74 25                	je     80100de0 <filealloc+0x50>
    if(f->ref == 0){
80100dbb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dbe:	85 c0                	test   %eax,%eax
80100dc0:	75 ee                	jne    80100db0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100dc2:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
      f->ref = 1;
80100dc9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dd0:	e8 ab 36 00 00       	call   80104480 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dd5:	83 c4 14             	add    $0x14,%esp
      return f;
80100dd8:	89 d8                	mov    %ebx,%eax
}
80100dda:	5b                   	pop    %ebx
80100ddb:	5d                   	pop    %ebp
80100ddc:	c3                   	ret    
80100ddd:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ftable.lock);
80100de0:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100de7:	e8 94 36 00 00       	call   80104480 <release>
}
80100dec:	83 c4 14             	add    $0x14,%esp
  return 0;
80100def:	31 c0                	xor    %eax,%eax
}
80100df1:	5b                   	pop    %ebx
80100df2:	5d                   	pop    %ebp
80100df3:	c3                   	ret    
80100df4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100e00 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	53                   	push   %ebx
80100e04:	83 ec 14             	sub    $0x14,%esp
80100e07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e0a:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e11:	e8 fa 35 00 00       	call   80104410 <acquire>
  if(f->ref < 1)
80100e16:	8b 43 04             	mov    0x4(%ebx),%eax
80100e19:	85 c0                	test   %eax,%eax
80100e1b:	7e 1a                	jle    80100e37 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100e1d:	83 c0 01             	add    $0x1,%eax
80100e20:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e23:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e2a:	e8 51 36 00 00       	call   80104480 <release>
  return f;
}
80100e2f:	83 c4 14             	add    $0x14,%esp
80100e32:	89 d8                	mov    %ebx,%eax
80100e34:	5b                   	pop    %ebx
80100e35:	5d                   	pop    %ebp
80100e36:	c3                   	ret    
    panic("filedup");
80100e37:	c7 04 24 f4 6e 10 80 	movl   $0x80106ef4,(%esp)
80100e3e:	e8 1d f5 ff ff       	call   80100360 <panic>
80100e43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e50 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	57                   	push   %edi
80100e54:	56                   	push   %esi
80100e55:	53                   	push   %ebx
80100e56:	83 ec 1c             	sub    $0x1c,%esp
80100e59:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e5c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e63:	e8 a8 35 00 00       	call   80104410 <acquire>
  if(f->ref < 1)
80100e68:	8b 57 04             	mov    0x4(%edi),%edx
80100e6b:	85 d2                	test   %edx,%edx
80100e6d:	0f 8e 89 00 00 00    	jle    80100efc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e73:	83 ea 01             	sub    $0x1,%edx
80100e76:	85 d2                	test   %edx,%edx
80100e78:	89 57 04             	mov    %edx,0x4(%edi)
80100e7b:	74 13                	je     80100e90 <fileclose+0x40>
    release(&ftable.lock);
80100e7d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e84:	83 c4 1c             	add    $0x1c,%esp
80100e87:	5b                   	pop    %ebx
80100e88:	5e                   	pop    %esi
80100e89:	5f                   	pop    %edi
80100e8a:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e8b:	e9 f0 35 00 00       	jmp    80104480 <release>
  ff = *f;
80100e90:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e94:	8b 37                	mov    (%edi),%esi
80100e96:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->type = FD_NONE;
80100e99:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  ff = *f;
80100e9f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ea2:	8b 47 10             	mov    0x10(%edi),%eax
  release(&ftable.lock);
80100ea5:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  ff = *f;
80100eac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100eaf:	e8 cc 35 00 00       	call   80104480 <release>
  if(ff.type == FD_PIPE)
80100eb4:	83 fe 01             	cmp    $0x1,%esi
80100eb7:	74 0f                	je     80100ec8 <fileclose+0x78>
  else if(ff.type == FD_INODE){
80100eb9:	83 fe 02             	cmp    $0x2,%esi
80100ebc:	74 22                	je     80100ee0 <fileclose+0x90>
}
80100ebe:	83 c4 1c             	add    $0x1c,%esp
80100ec1:	5b                   	pop    %ebx
80100ec2:	5e                   	pop    %esi
80100ec3:	5f                   	pop    %edi
80100ec4:	5d                   	pop    %ebp
80100ec5:	c3                   	ret    
80100ec6:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100ecc:	89 1c 24             	mov    %ebx,(%esp)
80100ecf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100ed3:	e8 a8 23 00 00       	call   80103280 <pipeclose>
80100ed8:	eb e4                	jmp    80100ebe <fileclose+0x6e>
80100eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    begin_op();
80100ee0:	e8 4b 1c 00 00       	call   80102b30 <begin_op>
    iput(ff.ip);
80100ee5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ee8:	89 04 24             	mov    %eax,(%esp)
80100eeb:	e8 00 09 00 00       	call   801017f0 <iput>
}
80100ef0:	83 c4 1c             	add    $0x1c,%esp
80100ef3:	5b                   	pop    %ebx
80100ef4:	5e                   	pop    %esi
80100ef5:	5f                   	pop    %edi
80100ef6:	5d                   	pop    %ebp
    end_op();
80100ef7:	e9 a4 1c 00 00       	jmp    80102ba0 <end_op>
    panic("fileclose");
80100efc:	c7 04 24 fc 6e 10 80 	movl   $0x80106efc,(%esp)
80100f03:	e8 58 f4 ff ff       	call   80100360 <panic>
80100f08:	90                   	nop
80100f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 14             	sub    $0x14,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	8b 43 10             	mov    0x10(%ebx),%eax
80100f22:	89 04 24             	mov    %eax,(%esp)
80100f25:	e8 a6 07 00 00       	call   801016d0 <ilock>
    stati(f->ip, st);
80100f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f2d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
80100f34:	89 04 24             	mov    %eax,(%esp)
80100f37:	e8 14 0a 00 00       	call   80101950 <stati>
    iunlock(f->ip);
80100f3c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f3f:	89 04 24             	mov    %eax,(%esp)
80100f42:	e8 69 08 00 00       	call   801017b0 <iunlock>
    return 0;
  }
  return -1;
}
80100f47:	83 c4 14             	add    $0x14,%esp
    return 0;
80100f4a:	31 c0                	xor    %eax,%eax
}
80100f4c:	5b                   	pop    %ebx
80100f4d:	5d                   	pop    %ebp
80100f4e:	c3                   	ret    
80100f4f:	90                   	nop
80100f50:	83 c4 14             	add    $0x14,%esp
  return -1;
80100f53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f58:	5b                   	pop    %ebx
80100f59:	5d                   	pop    %ebp
80100f5a:	c3                   	ret    
80100f5b:	90                   	nop
80100f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 1c             	sub    $0x1c,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 68                	je     80100fe0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 49                	je     80100fc8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 63                	jne    80100fe7 <fileread+0x87>
    ilock(f->ip);
80100f84:	8b 43 10             	mov    0x10(%ebx),%eax
80100f87:	89 04 24             	mov    %eax,(%esp)
80100f8a:	e8 41 07 00 00       	call   801016d0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f93:	8b 43 14             	mov    0x14(%ebx),%eax
80100f96:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f9a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f9e:	8b 43 10             	mov    0x10(%ebx),%eax
80100fa1:	89 04 24             	mov    %eax,(%esp)
80100fa4:	e8 d7 09 00 00       	call   80101980 <readi>
80100fa9:	85 c0                	test   %eax,%eax
80100fab:	89 c6                	mov    %eax,%esi
80100fad:	7e 03                	jle    80100fb2 <fileread+0x52>
      f->off += r;
80100faf:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fb2:	8b 43 10             	mov    0x10(%ebx),%eax
80100fb5:	89 04 24             	mov    %eax,(%esp)
80100fb8:	e8 f3 07 00 00       	call   801017b0 <iunlock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fbd:	89 f0                	mov    %esi,%eax
    return r;
  }
  panic("fileread");
}
80100fbf:	83 c4 1c             	add    $0x1c,%esp
80100fc2:	5b                   	pop    %ebx
80100fc3:	5e                   	pop    %esi
80100fc4:	5f                   	pop    %edi
80100fc5:	5d                   	pop    %ebp
80100fc6:	c3                   	ret    
80100fc7:	90                   	nop
    return piperead(f->pipe, addr, n);
80100fc8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fcb:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fce:	83 c4 1c             	add    $0x1c,%esp
80100fd1:	5b                   	pop    %ebx
80100fd2:	5e                   	pop    %esi
80100fd3:	5f                   	pop    %edi
80100fd4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fd5:	e9 26 24 00 00       	jmp    80103400 <piperead>
80100fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fe5:	eb d8                	jmp    80100fbf <fileread+0x5f>
  panic("fileread");
80100fe7:	c7 04 24 06 6f 10 80 	movl   $0x80106f06,(%esp)
80100fee:	e8 6d f3 ff ff       	call   80100360 <panic>
80100ff3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101000 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	57                   	push   %edi
80101004:	56                   	push   %esi
80101005:	53                   	push   %ebx
80101006:	83 ec 2c             	sub    $0x2c,%esp
80101009:	8b 45 0c             	mov    0xc(%ebp),%eax
8010100c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010100f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101012:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101015:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
{
80101019:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010101c:	0f 84 ae 00 00 00    	je     801010d0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101022:	8b 07                	mov    (%edi),%eax
80101024:	83 f8 01             	cmp    $0x1,%eax
80101027:	0f 84 c2 00 00 00    	je     801010ef <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010102d:	83 f8 02             	cmp    $0x2,%eax
80101030:	0f 85 d7 00 00 00    	jne    8010110d <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101036:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101039:	31 db                	xor    %ebx,%ebx
8010103b:	85 c0                	test   %eax,%eax
8010103d:	7f 31                	jg     80101070 <filewrite+0x70>
8010103f:	e9 9c 00 00 00       	jmp    801010e0 <filewrite+0xe0>
80101044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101048:	8b 4f 10             	mov    0x10(%edi),%ecx
        f->off += r;
8010104b:	01 47 14             	add    %eax,0x14(%edi)
8010104e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101051:	89 0c 24             	mov    %ecx,(%esp)
80101054:	e8 57 07 00 00       	call   801017b0 <iunlock>
      end_op();
80101059:	e8 42 1b 00 00       	call   80102ba0 <end_op>
8010105e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101061:	39 f0                	cmp    %esi,%eax
80101063:	0f 85 98 00 00 00    	jne    80101101 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101069:	01 c3                	add    %eax,%ebx
    while(i < n){
8010106b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010106e:	7e 70                	jle    801010e0 <filewrite+0xe0>
      int n1 = n - i;
80101070:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101073:	b8 00 06 00 00       	mov    $0x600,%eax
80101078:	29 de                	sub    %ebx,%esi
8010107a:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80101080:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
80101083:	e8 a8 1a 00 00       	call   80102b30 <begin_op>
      ilock(f->ip);
80101088:	8b 47 10             	mov    0x10(%edi),%eax
8010108b:	89 04 24             	mov    %eax,(%esp)
8010108e:	e8 3d 06 00 00       	call   801016d0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101093:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101097:	8b 47 14             	mov    0x14(%edi),%eax
8010109a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010109e:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010a1:	01 d8                	add    %ebx,%eax
801010a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801010a7:	8b 47 10             	mov    0x10(%edi),%eax
801010aa:	89 04 24             	mov    %eax,(%esp)
801010ad:	e8 ce 09 00 00       	call   80101a80 <writei>
801010b2:	85 c0                	test   %eax,%eax
801010b4:	7f 92                	jg     80101048 <filewrite+0x48>
      iunlock(f->ip);
801010b6:	8b 4f 10             	mov    0x10(%edi),%ecx
801010b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010bc:	89 0c 24             	mov    %ecx,(%esp)
801010bf:	e8 ec 06 00 00       	call   801017b0 <iunlock>
      end_op();
801010c4:	e8 d7 1a 00 00       	call   80102ba0 <end_op>
      if(r < 0)
801010c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010cc:	85 c0                	test   %eax,%eax
801010ce:	74 91                	je     80101061 <filewrite+0x61>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d0:	83 c4 2c             	add    $0x2c,%esp
    return -1;
801010d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
801010dc:	c3                   	ret    
801010dd:	8d 76 00             	lea    0x0(%esi),%esi
    return i == n ? n : -1;
801010e0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010e3:	89 d8                	mov    %ebx,%eax
801010e5:	75 e9                	jne    801010d0 <filewrite+0xd0>
}
801010e7:	83 c4 2c             	add    $0x2c,%esp
801010ea:	5b                   	pop    %ebx
801010eb:	5e                   	pop    %esi
801010ec:	5f                   	pop    %edi
801010ed:	5d                   	pop    %ebp
801010ee:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801010ef:	8b 47 0c             	mov    0xc(%edi),%eax
801010f2:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010f5:	83 c4 2c             	add    $0x2c,%esp
801010f8:	5b                   	pop    %ebx
801010f9:	5e                   	pop    %esi
801010fa:	5f                   	pop    %edi
801010fb:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010fc:	e9 0f 22 00 00       	jmp    80103310 <pipewrite>
        panic("short filewrite");
80101101:	c7 04 24 0f 6f 10 80 	movl   $0x80106f0f,(%esp)
80101108:	e8 53 f2 ff ff       	call   80100360 <panic>
  panic("filewrite");
8010110d:	c7 04 24 15 6f 10 80 	movl   $0x80106f15,(%esp)
80101114:	e8 47 f2 ff ff       	call   80100360 <panic>
80101119:	66 90                	xchg   %ax,%ax
8010111b:	66 90                	xchg   %ax,%ax
8010111d:	66 90                	xchg   %ax,%ax
8010111f:	90                   	nop

80101120 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	57                   	push   %edi
80101124:	89 d7                	mov    %edx,%edi
80101126:	56                   	push   %esi
80101127:	53                   	push   %ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101128:	bb 01 00 00 00       	mov    $0x1,%ebx
{
8010112d:	83 ec 1c             	sub    $0x1c,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101130:	c1 ea 0c             	shr    $0xc,%edx
80101133:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101139:	89 04 24             	mov    %eax,(%esp)
8010113c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101140:	e8 8b ef ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80101145:	89 f9                	mov    %edi,%ecx
  bi = b % BPB;
80101147:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
8010114d:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
8010114f:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101152:	c1 fa 03             	sar    $0x3,%edx
  m = 1 << (bi % 8);
80101155:	d3 e3                	shl    %cl,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101157:	89 c6                	mov    %eax,%esi
  if((bp->data[bi/8] & m) == 0)
80101159:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
8010115e:	0f b6 c8             	movzbl %al,%ecx
80101161:	85 d9                	test   %ebx,%ecx
80101163:	74 20                	je     80101185 <bfree+0x65>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101165:	f7 d3                	not    %ebx
80101167:	21 c3                	and    %eax,%ebx
80101169:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
8010116d:	89 34 24             	mov    %esi,(%esp)
80101170:	e8 5b 1b 00 00       	call   80102cd0 <log_write>
  brelse(bp);
80101175:	89 34 24             	mov    %esi,(%esp)
80101178:	e8 63 f0 ff ff       	call   801001e0 <brelse>
}
8010117d:	83 c4 1c             	add    $0x1c,%esp
80101180:	5b                   	pop    %ebx
80101181:	5e                   	pop    %esi
80101182:	5f                   	pop    %edi
80101183:	5d                   	pop    %ebp
80101184:	c3                   	ret    
    panic("freeing free block");
80101185:	c7 04 24 1f 6f 10 80 	movl   $0x80106f1f,(%esp)
8010118c:	e8 cf f1 ff ff       	call   80100360 <panic>
80101191:	eb 0d                	jmp    801011a0 <balloc>
80101193:	90                   	nop
80101194:	90                   	nop
80101195:	90                   	nop
80101196:	90                   	nop
80101197:	90                   	nop
80101198:	90                   	nop
80101199:	90                   	nop
8010119a:	90                   	nop
8010119b:	90                   	nop
8010119c:	90                   	nop
8010119d:	90                   	nop
8010119e:	90                   	nop
8010119f:	90                   	nop

801011a0 <balloc>:
{
801011a0:	55                   	push   %ebp
801011a1:	89 e5                	mov    %esp,%ebp
801011a3:	57                   	push   %edi
801011a4:	56                   	push   %esi
801011a5:	53                   	push   %ebx
801011a6:	83 ec 2c             	sub    $0x2c,%esp
801011a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011ac:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011b1:	85 c0                	test   %eax,%eax
801011b3:	0f 84 8c 00 00 00    	je     80101245 <balloc+0xa5>
801011b9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011c0:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011c3:	89 f0                	mov    %esi,%eax
801011c5:	c1 f8 0c             	sar    $0xc,%eax
801011c8:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801011d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011d5:	89 04 24             	mov    %eax,(%esp)
801011d8:	e8 f3 ee ff ff       	call   801000d0 <bread>
801011dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011e0:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011e8:	31 c0                	xor    %eax,%eax
801011ea:	eb 33                	jmp    8010121f <balloc+0x7f>
801011ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011f0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011f3:	89 c2                	mov    %eax,%edx
      m = 1 << (bi % 8);
801011f5:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011f7:	c1 fa 03             	sar    $0x3,%edx
      m = 1 << (bi % 8);
801011fa:	83 e1 07             	and    $0x7,%ecx
801011fd:	bf 01 00 00 00       	mov    $0x1,%edi
80101202:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101204:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx
      m = 1 << (bi % 8);
80101209:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010120b:	0f b6 fb             	movzbl %bl,%edi
8010120e:	85 cf                	test   %ecx,%edi
80101210:	74 46                	je     80101258 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101212:	83 c0 01             	add    $0x1,%eax
80101215:	83 c6 01             	add    $0x1,%esi
80101218:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010121d:	74 05                	je     80101224 <balloc+0x84>
8010121f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101222:	72 cc                	jb     801011f0 <balloc+0x50>
    brelse(bp);
80101224:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101227:	89 04 24             	mov    %eax,(%esp)
8010122a:	e8 b1 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010122f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101236:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101239:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
8010123f:	0f 82 7b ff ff ff    	jb     801011c0 <balloc+0x20>
  panic("balloc: out of blocks");
80101245:	c7 04 24 32 6f 10 80 	movl   $0x80106f32,(%esp)
8010124c:	e8 0f f1 ff ff       	call   80100360 <panic>
80101251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101258:	09 d9                	or     %ebx,%ecx
8010125a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010125d:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
80101261:	89 1c 24             	mov    %ebx,(%esp)
80101264:	e8 67 1a 00 00       	call   80102cd0 <log_write>
        brelse(bp);
80101269:	89 1c 24             	mov    %ebx,(%esp)
8010126c:	e8 6f ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
80101271:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101274:	89 74 24 04          	mov    %esi,0x4(%esp)
80101278:	89 04 24             	mov    %eax,(%esp)
8010127b:	e8 50 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101280:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101287:	00 
80101288:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010128f:	00 
  bp = bread(dev, bno);
80101290:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101292:	8d 40 5c             	lea    0x5c(%eax),%eax
80101295:	89 04 24             	mov    %eax,(%esp)
80101298:	e8 33 32 00 00       	call   801044d0 <memset>
  log_write(bp);
8010129d:	89 1c 24             	mov    %ebx,(%esp)
801012a0:	e8 2b 1a 00 00       	call   80102cd0 <log_write>
  brelse(bp);
801012a5:	89 1c 24             	mov    %ebx,(%esp)
801012a8:	e8 33 ef ff ff       	call   801001e0 <brelse>
}
801012ad:	83 c4 2c             	add    $0x2c,%esp
801012b0:	89 f0                	mov    %esi,%eax
801012b2:	5b                   	pop    %ebx
801012b3:	5e                   	pop    %esi
801012b4:	5f                   	pop    %edi
801012b5:	5d                   	pop    %ebp
801012b6:	c3                   	ret    
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801012c0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	89 c7                	mov    %eax,%edi
801012c6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012c7:	31 f6                	xor    %esi,%esi
{
801012c9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ca:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
801012cf:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&icache.lock);
801012d2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
{
801012d9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012dc:	e8 2f 31 00 00       	call   80104410 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012e4:	eb 14                	jmp    801012fa <iget+0x3a>
801012e6:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012e8:	85 f6                	test   %esi,%esi
801012ea:	74 3c                	je     80101328 <iget+0x68>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ec:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012f2:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012f8:	74 46                	je     80101340 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012fa:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012fd:	85 c9                	test   %ecx,%ecx
801012ff:	7e e7                	jle    801012e8 <iget+0x28>
80101301:	39 3b                	cmp    %edi,(%ebx)
80101303:	75 e3                	jne    801012e8 <iget+0x28>
80101305:	39 53 04             	cmp    %edx,0x4(%ebx)
80101308:	75 de                	jne    801012e8 <iget+0x28>
      ip->ref++;
8010130a:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010130d:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010130f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
      ip->ref++;
80101316:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101319:	e8 62 31 00 00       	call   80104480 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010131e:	83 c4 1c             	add    $0x1c,%esp
80101321:	89 f0                	mov    %esi,%eax
80101323:	5b                   	pop    %ebx
80101324:	5e                   	pop    %esi
80101325:	5f                   	pop    %edi
80101326:	5d                   	pop    %ebp
80101327:	c3                   	ret    
80101328:	85 c9                	test   %ecx,%ecx
8010132a:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010132d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101333:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101339:	75 bf                	jne    801012fa <iget+0x3a>
8010133b:	90                   	nop
8010133c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(empty == 0)
80101340:	85 f6                	test   %esi,%esi
80101342:	74 29                	je     8010136d <iget+0xad>
  ip->dev = dev;
80101344:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101346:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101349:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101350:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101357:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010135e:	e8 1d 31 00 00       	call   80104480 <release>
}
80101363:	83 c4 1c             	add    $0x1c,%esp
80101366:	89 f0                	mov    %esi,%eax
80101368:	5b                   	pop    %ebx
80101369:	5e                   	pop    %esi
8010136a:	5f                   	pop    %edi
8010136b:	5d                   	pop    %ebp
8010136c:	c3                   	ret    
    panic("iget: no inodes");
8010136d:	c7 04 24 48 6f 10 80 	movl   $0x80106f48,(%esp)
80101374:	e8 e7 ef ff ff       	call   80100360 <panic>
80101379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101380 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	57                   	push   %edi
80101384:	56                   	push   %esi
80101385:	53                   	push   %ebx
80101386:	89 c3                	mov    %eax,%ebx
80101388:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010138b:	83 fa 0b             	cmp    $0xb,%edx
8010138e:	77 18                	ja     801013a8 <bmap+0x28>
80101390:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
80101393:	8b 46 5c             	mov    0x5c(%esi),%eax
80101396:	85 c0                	test   %eax,%eax
80101398:	74 66                	je     80101400 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010139a:	83 c4 1c             	add    $0x1c,%esp
8010139d:	5b                   	pop    %ebx
8010139e:	5e                   	pop    %esi
8010139f:	5f                   	pop    %edi
801013a0:	5d                   	pop    %ebp
801013a1:	c3                   	ret    
801013a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;
801013a8:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
801013ab:	83 fe 7f             	cmp    $0x7f,%esi
801013ae:	77 77                	ja     80101427 <bmap+0xa7>
    if((addr = ip->addrs[NDIRECT]) == 0)
801013b0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801013b6:	85 c0                	test   %eax,%eax
801013b8:	74 5e                	je     80101418 <bmap+0x98>
    bp = bread(ip->dev, addr);
801013ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801013be:	8b 03                	mov    (%ebx),%eax
801013c0:	89 04 24             	mov    %eax,(%esp)
801013c3:	e8 08 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013c8:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
    bp = bread(ip->dev, addr);
801013cc:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013ce:	8b 32                	mov    (%edx),%esi
801013d0:	85 f6                	test   %esi,%esi
801013d2:	75 19                	jne    801013ed <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
801013d4:	8b 03                	mov    (%ebx),%eax
801013d6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013d9:	e8 c2 fd ff ff       	call   801011a0 <balloc>
801013de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013e1:	89 02                	mov    %eax,(%edx)
801013e3:	89 c6                	mov    %eax,%esi
      log_write(bp);
801013e5:	89 3c 24             	mov    %edi,(%esp)
801013e8:	e8 e3 18 00 00       	call   80102cd0 <log_write>
    brelse(bp);
801013ed:	89 3c 24             	mov    %edi,(%esp)
801013f0:	e8 eb ed ff ff       	call   801001e0 <brelse>
}
801013f5:	83 c4 1c             	add    $0x1c,%esp
    brelse(bp);
801013f8:	89 f0                	mov    %esi,%eax
}
801013fa:	5b                   	pop    %ebx
801013fb:	5e                   	pop    %esi
801013fc:	5f                   	pop    %edi
801013fd:	5d                   	pop    %ebp
801013fe:	c3                   	ret    
801013ff:	90                   	nop
      ip->addrs[bn] = addr = balloc(ip->dev);
80101400:	8b 03                	mov    (%ebx),%eax
80101402:	e8 99 fd ff ff       	call   801011a0 <balloc>
80101407:	89 46 5c             	mov    %eax,0x5c(%esi)
}
8010140a:	83 c4 1c             	add    $0x1c,%esp
8010140d:	5b                   	pop    %ebx
8010140e:	5e                   	pop    %esi
8010140f:	5f                   	pop    %edi
80101410:	5d                   	pop    %ebp
80101411:	c3                   	ret    
80101412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101418:	8b 03                	mov    (%ebx),%eax
8010141a:	e8 81 fd ff ff       	call   801011a0 <balloc>
8010141f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101425:	eb 93                	jmp    801013ba <bmap+0x3a>
  panic("bmap: out of range");
80101427:	c7 04 24 58 6f 10 80 	movl   $0x80106f58,(%esp)
8010142e:	e8 2d ef ff ff       	call   80100360 <panic>
80101433:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101440 <readsb>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	83 ec 10             	sub    $0x10,%esp
  bp = bread(dev, 1);
80101448:	8b 45 08             	mov    0x8(%ebp),%eax
8010144b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101452:	00 
{
80101453:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101456:	89 04 24             	mov    %eax,(%esp)
80101459:	e8 72 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010145e:	89 34 24             	mov    %esi,(%esp)
80101461:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101468:	00 
  bp = bread(dev, 1);
80101469:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010146b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010146e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101472:	e8 f9 30 00 00       	call   80104570 <memmove>
  brelse(bp);
80101477:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010147a:	83 c4 10             	add    $0x10,%esp
8010147d:	5b                   	pop    %ebx
8010147e:	5e                   	pop    %esi
8010147f:	5d                   	pop    %ebp
  brelse(bp);
80101480:	e9 5b ed ff ff       	jmp    801001e0 <brelse>
80101485:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101490 <iinit>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101499:	83 ec 24             	sub    $0x24,%esp
  initlock(&icache.lock, "icache");
8010149c:	c7 44 24 04 6b 6f 10 	movl   $0x80106f6b,0x4(%esp)
801014a3:	80 
801014a4:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801014ab:	e8 f0 2d 00 00       	call   801042a0 <initlock>
    initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	89 1c 24             	mov    %ebx,(%esp)
801014b3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014b9:	c7 44 24 04 72 6f 10 	movl   $0x80106f72,0x4(%esp)
801014c0:	80 
801014c1:	e8 aa 2c 00 00       	call   80104170 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014c6:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014cc:	75 e2                	jne    801014b0 <iinit+0x20>
  readsb(dev, &sb);
801014ce:	8b 45 08             	mov    0x8(%ebp),%eax
801014d1:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014d8:	80 
801014d9:	89 04 24             	mov    %eax,(%esp)
801014dc:	e8 5f ff ff ff       	call   80101440 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014e1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014e6:	c7 04 24 d8 6f 10 80 	movl   $0x80106fd8,(%esp)
801014ed:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014f1:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801014f6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014fa:	a1 d0 09 11 80       	mov    0x801109d0,%eax
801014ff:	89 44 24 14          	mov    %eax,0x14(%esp)
80101503:	a1 cc 09 11 80       	mov    0x801109cc,%eax
80101508:	89 44 24 10          	mov    %eax,0x10(%esp)
8010150c:	a1 c8 09 11 80       	mov    0x801109c8,%eax
80101511:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101515:	a1 c4 09 11 80       	mov    0x801109c4,%eax
8010151a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010151e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101523:	89 44 24 04          	mov    %eax,0x4(%esp)
80101527:	e8 24 f1 ff ff       	call   80100650 <cprintf>
}
8010152c:	83 c4 24             	add    $0x24,%esp
8010152f:	5b                   	pop    %ebx
80101530:	5d                   	pop    %ebp
80101531:	c3                   	ret    
80101532:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101540 <ialloc>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	57                   	push   %edi
80101544:	56                   	push   %esi
80101545:	53                   	push   %ebx
80101546:	83 ec 2c             	sub    $0x2c,%esp
80101549:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010154c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101553:	8b 7d 08             	mov    0x8(%ebp),%edi
80101556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101559:	0f 86 a2 00 00 00    	jbe    80101601 <ialloc+0xc1>
8010155f:	be 01 00 00 00       	mov    $0x1,%esi
80101564:	bb 01 00 00 00       	mov    $0x1,%ebx
80101569:	eb 1a                	jmp    80101585 <ialloc+0x45>
8010156b:	90                   	nop
8010156c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    brelse(bp);
80101570:	89 14 24             	mov    %edx,(%esp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101573:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101576:	e8 65 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010157b:	89 de                	mov    %ebx,%esi
8010157d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101583:	73 7c                	jae    80101601 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101585:	89 f0                	mov    %esi,%eax
80101587:	c1 e8 03             	shr    $0x3,%eax
8010158a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101590:	89 3c 24             	mov    %edi,(%esp)
80101593:	89 44 24 04          	mov    %eax,0x4(%esp)
80101597:	e8 34 eb ff ff       	call   801000d0 <bread>
8010159c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010159e:	89 f0                	mov    %esi,%eax
801015a0:	83 e0 07             	and    $0x7,%eax
801015a3:	c1 e0 06             	shl    $0x6,%eax
801015a6:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015aa:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015ae:	75 c0                	jne    80101570 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015b0:	89 0c 24             	mov    %ecx,(%esp)
801015b3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801015ba:	00 
801015bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015c2:	00 
801015c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015c9:	e8 02 2f 00 00       	call   801044d0 <memset>
      dip->type = type;
801015ce:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
      dip->type = type;
801015d5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015d8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      dip->type = type;
801015db:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015de:	89 14 24             	mov    %edx,(%esp)
801015e1:	e8 ea 16 00 00       	call   80102cd0 <log_write>
      brelse(bp);
801015e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015e9:	89 14 24             	mov    %edx,(%esp)
801015ec:	e8 ef eb ff ff       	call   801001e0 <brelse>
}
801015f1:	83 c4 2c             	add    $0x2c,%esp
      return iget(dev, inum);
801015f4:	89 f2                	mov    %esi,%edx
}
801015f6:	5b                   	pop    %ebx
      return iget(dev, inum);
801015f7:	89 f8                	mov    %edi,%eax
}
801015f9:	5e                   	pop    %esi
801015fa:	5f                   	pop    %edi
801015fb:	5d                   	pop    %ebp
      return iget(dev, inum);
801015fc:	e9 bf fc ff ff       	jmp    801012c0 <iget>
  panic("ialloc: no inodes");
80101601:	c7 04 24 78 6f 10 80 	movl   $0x80106f78,(%esp)
80101608:	e8 53 ed ff ff       	call   80100360 <panic>
8010160d:	8d 76 00             	lea    0x0(%esi),%esi

80101610 <iupdate>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	56                   	push   %esi
80101614:	53                   	push   %ebx
80101615:	83 ec 10             	sub    $0x10,%esp
80101618:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010161b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101621:	c1 e8 03             	shr    $0x3,%eax
80101624:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010162a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010162e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101631:	89 04 24             	mov    %eax,(%esp)
80101634:	e8 97 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101639:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010163c:	83 e2 07             	and    $0x7,%edx
8010163f:	c1 e2 06             	shl    $0x6,%edx
80101642:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101646:	89 c6                	mov    %eax,%esi
  dip->type = ip->type;
80101648:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010164c:	83 c2 0c             	add    $0xc,%edx
  dip->type = ip->type;
8010164f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101653:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101657:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010165b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010165f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101663:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101667:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010166b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010166e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101671:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101675:	89 14 24             	mov    %edx,(%esp)
80101678:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010167f:	00 
80101680:	e8 eb 2e 00 00       	call   80104570 <memmove>
  log_write(bp);
80101685:	89 34 24             	mov    %esi,(%esp)
80101688:	e8 43 16 00 00       	call   80102cd0 <log_write>
  brelse(bp);
8010168d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101690:	83 c4 10             	add    $0x10,%esp
80101693:	5b                   	pop    %ebx
80101694:	5e                   	pop    %esi
80101695:	5d                   	pop    %ebp
  brelse(bp);
80101696:	e9 45 eb ff ff       	jmp    801001e0 <brelse>
8010169b:	90                   	nop
8010169c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016a0 <idup>:
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	53                   	push   %ebx
801016a4:	83 ec 14             	sub    $0x14,%esp
801016a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016aa:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016b1:	e8 5a 2d 00 00       	call   80104410 <acquire>
  ip->ref++;
801016b6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016ba:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016c1:	e8 ba 2d 00 00       	call   80104480 <release>
}
801016c6:	83 c4 14             	add    $0x14,%esp
801016c9:	89 d8                	mov    %ebx,%eax
801016cb:	5b                   	pop    %ebx
801016cc:	5d                   	pop    %ebp
801016cd:	c3                   	ret    
801016ce:	66 90                	xchg   %ax,%ax

801016d0 <ilock>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	83 ec 10             	sub    $0x10,%esp
801016d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016db:	85 db                	test   %ebx,%ebx
801016dd:	0f 84 b3 00 00 00    	je     80101796 <ilock+0xc6>
801016e3:	8b 53 08             	mov    0x8(%ebx),%edx
801016e6:	85 d2                	test   %edx,%edx
801016e8:	0f 8e a8 00 00 00    	jle    80101796 <ilock+0xc6>
  acquiresleep(&ip->lock);
801016ee:	8d 43 0c             	lea    0xc(%ebx),%eax
801016f1:	89 04 24             	mov    %eax,(%esp)
801016f4:	e8 b7 2a 00 00       	call   801041b0 <acquiresleep>
  if(ip->valid == 0){
801016f9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016fc:	85 c0                	test   %eax,%eax
801016fe:	74 08                	je     80101708 <ilock+0x38>
}
80101700:	83 c4 10             	add    $0x10,%esp
80101703:	5b                   	pop    %ebx
80101704:	5e                   	pop    %esi
80101705:	5d                   	pop    %ebp
80101706:	c3                   	ret    
80101707:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101708:	8b 43 04             	mov    0x4(%ebx),%eax
8010170b:	c1 e8 03             	shr    $0x3,%eax
8010170e:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101714:	89 44 24 04          	mov    %eax,0x4(%esp)
80101718:	8b 03                	mov    (%ebx),%eax
8010171a:	89 04 24             	mov    %eax,(%esp)
8010171d:	e8 ae e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101722:	8b 53 04             	mov    0x4(%ebx),%edx
80101725:	83 e2 07             	and    $0x7,%edx
80101728:	c1 e2 06             	shl    $0x6,%edx
8010172b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010172f:	89 c6                	mov    %eax,%esi
    ip->type = dip->type;
80101731:	0f b7 02             	movzwl (%edx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101734:	83 c2 0c             	add    $0xc,%edx
    ip->type = dip->type;
80101737:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010173b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010173f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101743:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101747:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010174b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010174f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101753:	8b 42 fc             	mov    -0x4(%edx),%eax
80101756:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101759:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010175c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101760:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101767:	00 
80101768:	89 04 24             	mov    %eax,(%esp)
8010176b:	e8 00 2e 00 00       	call   80104570 <memmove>
    brelse(bp);
80101770:	89 34 24             	mov    %esi,(%esp)
80101773:	e8 68 ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101778:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010177d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101784:	0f 85 76 ff ff ff    	jne    80101700 <ilock+0x30>
      panic("ilock: no type");
8010178a:	c7 04 24 90 6f 10 80 	movl   $0x80106f90,(%esp)
80101791:	e8 ca eb ff ff       	call   80100360 <panic>
    panic("ilock");
80101796:	c7 04 24 8a 6f 10 80 	movl   $0x80106f8a,(%esp)
8010179d:	e8 be eb ff ff       	call   80100360 <panic>
801017a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801017b0 <iunlock>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	56                   	push   %esi
801017b4:	53                   	push   %ebx
801017b5:	83 ec 10             	sub    $0x10,%esp
801017b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017bb:	85 db                	test   %ebx,%ebx
801017bd:	74 24                	je     801017e3 <iunlock+0x33>
801017bf:	8d 73 0c             	lea    0xc(%ebx),%esi
801017c2:	89 34 24             	mov    %esi,(%esp)
801017c5:	e8 86 2a 00 00       	call   80104250 <holdingsleep>
801017ca:	85 c0                	test   %eax,%eax
801017cc:	74 15                	je     801017e3 <iunlock+0x33>
801017ce:	8b 43 08             	mov    0x8(%ebx),%eax
801017d1:	85 c0                	test   %eax,%eax
801017d3:	7e 0e                	jle    801017e3 <iunlock+0x33>
  releasesleep(&ip->lock);
801017d5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	5b                   	pop    %ebx
801017dc:	5e                   	pop    %esi
801017dd:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017de:	e9 2d 2a 00 00       	jmp    80104210 <releasesleep>
    panic("iunlock");
801017e3:	c7 04 24 9f 6f 10 80 	movl   $0x80106f9f,(%esp)
801017ea:	e8 71 eb ff ff       	call   80100360 <panic>
801017ef:	90                   	nop

801017f0 <iput>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	57                   	push   %edi
801017f4:	56                   	push   %esi
801017f5:	53                   	push   %ebx
801017f6:	83 ec 1c             	sub    $0x1c,%esp
801017f9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017fc:	8d 7e 0c             	lea    0xc(%esi),%edi
801017ff:	89 3c 24             	mov    %edi,(%esp)
80101802:	e8 a9 29 00 00       	call   801041b0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101807:	8b 56 4c             	mov    0x4c(%esi),%edx
8010180a:	85 d2                	test   %edx,%edx
8010180c:	74 07                	je     80101815 <iput+0x25>
8010180e:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101813:	74 2b                	je     80101840 <iput+0x50>
  releasesleep(&ip->lock);
80101815:	89 3c 24             	mov    %edi,(%esp)
80101818:	e8 f3 29 00 00       	call   80104210 <releasesleep>
  acquire(&icache.lock);
8010181d:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101824:	e8 e7 2b 00 00       	call   80104410 <acquire>
  ip->ref--;
80101829:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010182d:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101834:	83 c4 1c             	add    $0x1c,%esp
80101837:	5b                   	pop    %ebx
80101838:	5e                   	pop    %esi
80101839:	5f                   	pop    %edi
8010183a:	5d                   	pop    %ebp
  release(&icache.lock);
8010183b:	e9 40 2c 00 00       	jmp    80104480 <release>
    acquire(&icache.lock);
80101840:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101847:	e8 c4 2b 00 00       	call   80104410 <acquire>
    int r = ip->ref;
8010184c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010184f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101856:	e8 25 2c 00 00       	call   80104480 <release>
    if(r == 1){
8010185b:	83 fb 01             	cmp    $0x1,%ebx
8010185e:	75 b5                	jne    80101815 <iput+0x25>
80101860:	8d 4e 30             	lea    0x30(%esi),%ecx
80101863:	89 f3                	mov    %esi,%ebx
80101865:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101868:	89 cf                	mov    %ecx,%edi
8010186a:	eb 0b                	jmp    80101877 <iput+0x87>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101870:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101873:	39 fb                	cmp    %edi,%ebx
80101875:	74 19                	je     80101890 <iput+0xa0>
    if(ip->addrs[i]){
80101877:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010187a:	85 d2                	test   %edx,%edx
8010187c:	74 f2                	je     80101870 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010187e:	8b 06                	mov    (%esi),%eax
80101880:	e8 9b f8 ff ff       	call   80101120 <bfree>
      ip->addrs[i] = 0;
80101885:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010188c:	eb e2                	jmp    80101870 <iput+0x80>
8010188e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101890:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101896:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101899:	85 c0                	test   %eax,%eax
8010189b:	75 2b                	jne    801018c8 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010189d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801018a4:	89 34 24             	mov    %esi,(%esp)
801018a7:	e8 64 fd ff ff       	call   80101610 <iupdate>
      ip->type = 0;
801018ac:	31 c0                	xor    %eax,%eax
801018ae:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
801018b2:	89 34 24             	mov    %esi,(%esp)
801018b5:	e8 56 fd ff ff       	call   80101610 <iupdate>
      ip->valid = 0;
801018ba:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018c1:	e9 4f ff ff ff       	jmp    80101815 <iput+0x25>
801018c6:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018cc:	8b 06                	mov    (%esi),%eax
    for(j = 0; j < NINDIRECT; j++){
801018ce:	31 db                	xor    %ebx,%ebx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018d0:	89 04 24             	mov    %eax,(%esp)
801018d3:	e8 f8 e7 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801018d8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    a = (uint*)bp->data;
801018db:	8d 48 5c             	lea    0x5c(%eax),%ecx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801018e1:	89 cf                	mov    %ecx,%edi
801018e3:	31 c0                	xor    %eax,%eax
801018e5:	eb 0e                	jmp    801018f5 <iput+0x105>
801018e7:	90                   	nop
801018e8:	83 c3 01             	add    $0x1,%ebx
801018eb:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018f1:	89 d8                	mov    %ebx,%eax
801018f3:	74 10                	je     80101905 <iput+0x115>
      if(a[j])
801018f5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018f8:	85 d2                	test   %edx,%edx
801018fa:	74 ec                	je     801018e8 <iput+0xf8>
        bfree(ip->dev, a[j]);
801018fc:	8b 06                	mov    (%esi),%eax
801018fe:	e8 1d f8 ff ff       	call   80101120 <bfree>
80101903:	eb e3                	jmp    801018e8 <iput+0xf8>
    brelse(bp);
80101905:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101908:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010190b:	89 04 24             	mov    %eax,(%esp)
8010190e:	e8 cd e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101913:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101919:	8b 06                	mov    (%esi),%eax
8010191b:	e8 00 f8 ff ff       	call   80101120 <bfree>
    ip->addrs[NDIRECT] = 0;
80101920:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101927:	00 00 00 
8010192a:	e9 6e ff ff ff       	jmp    8010189d <iput+0xad>
8010192f:	90                   	nop

80101930 <iunlockput>:
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	53                   	push   %ebx
80101934:	83 ec 14             	sub    $0x14,%esp
80101937:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010193a:	89 1c 24             	mov    %ebx,(%esp)
8010193d:	e8 6e fe ff ff       	call   801017b0 <iunlock>
  iput(ip);
80101942:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101945:	83 c4 14             	add    $0x14,%esp
80101948:	5b                   	pop    %ebx
80101949:	5d                   	pop    %ebp
  iput(ip);
8010194a:	e9 a1 fe ff ff       	jmp    801017f0 <iput>
8010194f:	90                   	nop

80101950 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	8b 55 08             	mov    0x8(%ebp),%edx
80101956:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101959:	8b 0a                	mov    (%edx),%ecx
8010195b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010195e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101961:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101964:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101968:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010196b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010196f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101973:	8b 52 58             	mov    0x58(%edx),%edx
80101976:	89 50 10             	mov    %edx,0x10(%eax)
}
80101979:	5d                   	pop    %ebp
8010197a:	c3                   	ret    
8010197b:	90                   	nop
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101980 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	57                   	push   %edi
80101984:	56                   	push   %esi
80101985:	53                   	push   %ebx
80101986:	83 ec 2c             	sub    $0x2c,%esp
80101989:	8b 45 0c             	mov    0xc(%ebp),%eax
8010198c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010198f:	8b 75 10             	mov    0x10(%ebp),%esi
80101992:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101995:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101998:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
8010199d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(ip->type == T_DEV){
801019a0:	0f 84 aa 00 00 00    	je     80101a50 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019a6:	8b 47 58             	mov    0x58(%edi),%eax
801019a9:	39 f0                	cmp    %esi,%eax
801019ab:	0f 82 c7 00 00 00    	jb     80101a78 <readi+0xf8>
801019b1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019b4:	89 da                	mov    %ebx,%edx
801019b6:	01 f2                	add    %esi,%edx
801019b8:	0f 82 ba 00 00 00    	jb     80101a78 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019be:	89 c1                	mov    %eax,%ecx
801019c0:	29 f1                	sub    %esi,%ecx
801019c2:	39 d0                	cmp    %edx,%eax
801019c4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c7:	31 c0                	xor    %eax,%eax
801019c9:	85 c9                	test   %ecx,%ecx
    n = ip->size - off;
801019cb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ce:	74 70                	je     80101a40 <readi+0xc0>
801019d0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019d3:	89 c7                	mov    %eax,%edi
801019d5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019db:	89 f2                	mov    %esi,%edx
801019dd:	c1 ea 09             	shr    $0x9,%edx
801019e0:	89 d8                	mov    %ebx,%eax
801019e2:	e8 99 f9 ff ff       	call   80101380 <bmap>
801019e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019eb:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019ed:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019f2:	89 04 24             	mov    %eax,(%esp)
801019f5:	e8 d6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019fa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019fd:	29 f9                	sub    %edi,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ff:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a01:	89 f0                	mov    %esi,%eax
80101a03:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a08:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0a:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a0e:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a10:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a14:	8b 45 e0             	mov    -0x20(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a17:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a1a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a1e:	01 df                	add    %ebx,%edi
80101a20:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a22:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a25:	89 04 24             	mov    %eax,(%esp)
80101a28:	e8 43 2b 00 00       	call   80104570 <memmove>
    brelse(bp);
80101a2d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a30:	89 14 24             	mov    %edx,(%esp)
80101a33:	e8 a8 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a38:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a3b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a3e:	77 98                	ja     801019d8 <readi+0x58>
  }
  return n;
80101a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a43:	83 c4 2c             	add    $0x2c,%esp
80101a46:	5b                   	pop    %ebx
80101a47:	5e                   	pop    %esi
80101a48:	5f                   	pop    %edi
80101a49:	5d                   	pop    %ebp
80101a4a:	c3                   	ret    
80101a4b:	90                   	nop
80101a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a50:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a54:	66 83 f8 09          	cmp    $0x9,%ax
80101a58:	77 1e                	ja     80101a78 <readi+0xf8>
80101a5a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a61:	85 c0                	test   %eax,%eax
80101a63:	74 13                	je     80101a78 <readi+0xf8>
    return devsw[ip->major].read(ip, dst, n);
80101a65:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a68:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101a6b:	83 c4 2c             	add    $0x2c,%esp
80101a6e:	5b                   	pop    %ebx
80101a6f:	5e                   	pop    %esi
80101a70:	5f                   	pop    %edi
80101a71:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a72:	ff e0                	jmp    *%eax
80101a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101a78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a7d:	eb c4                	jmp    80101a43 <readi+0xc3>
80101a7f:	90                   	nop

80101a80 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	57                   	push   %edi
80101a84:	56                   	push   %esi
80101a85:	53                   	push   %ebx
80101a86:	83 ec 2c             	sub    $0x2c,%esp
80101a89:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a8f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a92:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a97:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a9a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a9d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101aa0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101aa3:	0f 84 b7 00 00 00    	je     80101b60 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101aa9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aac:	39 70 58             	cmp    %esi,0x58(%eax)
80101aaf:	0f 82 e3 00 00 00    	jb     80101b98 <writei+0x118>
80101ab5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ab8:	89 c8                	mov    %ecx,%eax
80101aba:	01 f0                	add    %esi,%eax
80101abc:	0f 82 d6 00 00 00    	jb     80101b98 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ac2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ac7:	0f 87 cb 00 00 00    	ja     80101b98 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101acd:	85 c9                	test   %ecx,%ecx
80101acf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ad6:	74 77                	je     80101b4f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101adb:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101add:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae2:	c1 ea 09             	shr    $0x9,%edx
80101ae5:	89 f8                	mov    %edi,%eax
80101ae7:	e8 94 f8 ff ff       	call   80101380 <bmap>
80101aec:	89 44 24 04          	mov    %eax,0x4(%esp)
80101af0:	8b 07                	mov    (%edi),%eax
80101af2:	89 04 24             	mov    %eax,(%esp)
80101af5:	e8 d6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101afa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101afd:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b00:	8b 55 dc             	mov    -0x24(%ebp),%edx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b03:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b05:	89 f0                	mov    %esi,%eax
80101b07:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b0c:	29 c3                	sub    %eax,%ebx
80101b0e:	39 cb                	cmp    %ecx,%ebx
80101b10:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b13:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b17:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b19:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b1d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b21:	89 04 24             	mov    %eax,(%esp)
80101b24:	e8 47 2a 00 00       	call   80104570 <memmove>
    log_write(bp);
80101b29:	89 3c 24             	mov    %edi,(%esp)
80101b2c:	e8 9f 11 00 00       	call   80102cd0 <log_write>
    brelse(bp);
80101b31:	89 3c 24             	mov    %edi,(%esp)
80101b34:	e8 a7 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b39:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b3f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b42:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b45:	77 91                	ja     80101ad8 <writei+0x58>
  }

  if(n > 0 && off > ip->size){
80101b47:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b4a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b4d:	72 39                	jb     80101b88 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b52:	83 c4 2c             	add    $0x2c,%esp
80101b55:	5b                   	pop    %ebx
80101b56:	5e                   	pop    %esi
80101b57:	5f                   	pop    %edi
80101b58:	5d                   	pop    %ebp
80101b59:	c3                   	ret    
80101b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 2e                	ja     80101b98 <writei+0x118>
80101b6a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 23                	je     80101b98 <writei+0x118>
    return devsw[ip->major].write(ip, src, n);
80101b75:	89 4d 10             	mov    %ecx,0x10(%ebp)
}
80101b78:	83 c4 2c             	add    $0x2c,%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b7f:	ff e0                	jmp    *%eax
80101b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b88:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b8b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b8e:	89 04 24             	mov    %eax,(%esp)
80101b91:	e8 7a fa ff ff       	call   80101610 <iupdate>
80101b96:	eb b7                	jmp    80101b4f <writei+0xcf>
}
80101b98:	83 c4 2c             	add    $0x2c,%esp
      return -1;
80101b9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101ba0:	5b                   	pop    %ebx
80101ba1:	5e                   	pop    %esi
80101ba2:	5f                   	pop    %edi
80101ba3:	5d                   	pop    %ebp
80101ba4:	c3                   	ret    
80101ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bb9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101bc0:	00 
80101bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bc5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc8:	89 04 24             	mov    %eax,(%esp)
80101bcb:	e8 20 2a 00 00       	call   801045f0 <strncmp>
}
80101bd0:	c9                   	leave  
80101bd1:	c3                   	ret    
80101bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101be0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	57                   	push   %edi
80101be4:	56                   	push   %esi
80101be5:	53                   	push   %ebx
80101be6:	83 ec 2c             	sub    $0x2c,%esp
80101be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bf1:	0f 85 97 00 00 00    	jne    80101c8e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bfa:	31 ff                	xor    %edi,%edi
80101bfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bff:	85 d2                	test   %edx,%edx
80101c01:	75 0d                	jne    80101c10 <dirlookup+0x30>
80101c03:	eb 73                	jmp    80101c78 <dirlookup+0x98>
80101c05:	8d 76 00             	lea    0x0(%esi),%esi
80101c08:	83 c7 10             	add    $0x10,%edi
80101c0b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101c0e:	76 68                	jbe    80101c78 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c10:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c17:	00 
80101c18:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c1c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c20:	89 1c 24             	mov    %ebx,(%esp)
80101c23:	e8 58 fd ff ff       	call   80101980 <readi>
80101c28:	83 f8 10             	cmp    $0x10,%eax
80101c2b:	75 55                	jne    80101c82 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c2d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c32:	74 d4                	je     80101c08 <dirlookup+0x28>
  return strncmp(s, t, DIRSIZ);
80101c34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c37:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c3e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c45:	00 
80101c46:	89 04 24             	mov    %eax,(%esp)
80101c49:	e8 a2 29 00 00       	call   801045f0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c4e:	85 c0                	test   %eax,%eax
80101c50:	75 b6                	jne    80101c08 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c52:	8b 45 10             	mov    0x10(%ebp),%eax
80101c55:	85 c0                	test   %eax,%eax
80101c57:	74 05                	je     80101c5e <dirlookup+0x7e>
        *poff = off;
80101c59:	8b 45 10             	mov    0x10(%ebp),%eax
80101c5c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c5e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c62:	8b 03                	mov    (%ebx),%eax
80101c64:	e8 57 f6 ff ff       	call   801012c0 <iget>
    }
  }

  return 0;
}
80101c69:	83 c4 2c             	add    $0x2c,%esp
80101c6c:	5b                   	pop    %ebx
80101c6d:	5e                   	pop    %esi
80101c6e:	5f                   	pop    %edi
80101c6f:	5d                   	pop    %ebp
80101c70:	c3                   	ret    
80101c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c78:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80101c7b:	31 c0                	xor    %eax,%eax
}
80101c7d:	5b                   	pop    %ebx
80101c7e:	5e                   	pop    %esi
80101c7f:	5f                   	pop    %edi
80101c80:	5d                   	pop    %ebp
80101c81:	c3                   	ret    
      panic("dirlookup read");
80101c82:	c7 04 24 b9 6f 10 80 	movl   $0x80106fb9,(%esp)
80101c89:	e8 d2 e6 ff ff       	call   80100360 <panic>
    panic("dirlookup not DIR");
80101c8e:	c7 04 24 a7 6f 10 80 	movl   $0x80106fa7,(%esp)
80101c95:	e8 c6 e6 ff ff       	call   80100360 <panic>
80101c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ca0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ca0:	55                   	push   %ebp
80101ca1:	89 e5                	mov    %esp,%ebp
80101ca3:	57                   	push   %edi
80101ca4:	89 cf                	mov    %ecx,%edi
80101ca6:	56                   	push   %esi
80101ca7:	53                   	push   %ebx
80101ca8:	89 c3                	mov    %eax,%ebx
80101caa:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cad:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101cb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101cb3:	0f 84 51 01 00 00    	je     80101e0a <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101cb9:	e8 22 1a 00 00       	call   801036e0 <myproc>
80101cbe:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101cc1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cc8:	e8 43 27 00 00       	call   80104410 <acquire>
  ip->ref++;
80101ccd:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cd1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cd8:	e8 a3 27 00 00       	call   80104480 <release>
80101cdd:	eb 04                	jmp    80101ce3 <namex+0x43>
80101cdf:	90                   	nop
    path++;
80101ce0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ce3:	0f b6 03             	movzbl (%ebx),%eax
80101ce6:	3c 2f                	cmp    $0x2f,%al
80101ce8:	74 f6                	je     80101ce0 <namex+0x40>
  if(*path == 0)
80101cea:	84 c0                	test   %al,%al
80101cec:	0f 84 ed 00 00 00    	je     80101ddf <namex+0x13f>
  while(*path != '/' && *path != 0)
80101cf2:	0f b6 03             	movzbl (%ebx),%eax
80101cf5:	89 da                	mov    %ebx,%edx
80101cf7:	84 c0                	test   %al,%al
80101cf9:	0f 84 b1 00 00 00    	je     80101db0 <namex+0x110>
80101cff:	3c 2f                	cmp    $0x2f,%al
80101d01:	75 0f                	jne    80101d12 <namex+0x72>
80101d03:	e9 a8 00 00 00       	jmp    80101db0 <namex+0x110>
80101d08:	3c 2f                	cmp    $0x2f,%al
80101d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d10:	74 0a                	je     80101d1c <namex+0x7c>
    path++;
80101d12:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d15:	0f b6 02             	movzbl (%edx),%eax
80101d18:	84 c0                	test   %al,%al
80101d1a:	75 ec                	jne    80101d08 <namex+0x68>
80101d1c:	89 d1                	mov    %edx,%ecx
80101d1e:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d20:	83 f9 0d             	cmp    $0xd,%ecx
80101d23:	0f 8e 8f 00 00 00    	jle    80101db8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d29:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d2d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d34:	00 
80101d35:	89 3c 24             	mov    %edi,(%esp)
80101d38:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d3b:	e8 30 28 00 00       	call   80104570 <memmove>
    path++;
80101d40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d43:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d45:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d48:	75 0e                	jne    80101d58 <namex+0xb8>
80101d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d50:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d53:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d56:	74 f8                	je     80101d50 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d58:	89 34 24             	mov    %esi,(%esp)
80101d5b:	e8 70 f9 ff ff       	call   801016d0 <ilock>
    if(ip->type != T_DIR){
80101d60:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d65:	0f 85 85 00 00 00    	jne    80101df0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d6b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d6e:	85 d2                	test   %edx,%edx
80101d70:	74 09                	je     80101d7b <namex+0xdb>
80101d72:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d75:	0f 84 a5 00 00 00    	je     80101e20 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d7b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d82:	00 
80101d83:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d87:	89 34 24             	mov    %esi,(%esp)
80101d8a:	e8 51 fe ff ff       	call   80101be0 <dirlookup>
80101d8f:	85 c0                	test   %eax,%eax
80101d91:	74 5d                	je     80101df0 <namex+0x150>
  iunlock(ip);
80101d93:	89 34 24             	mov    %esi,(%esp)
80101d96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d99:	e8 12 fa ff ff       	call   801017b0 <iunlock>
  iput(ip);
80101d9e:	89 34 24             	mov    %esi,(%esp)
80101da1:	e8 4a fa ff ff       	call   801017f0 <iput>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101da9:	89 c6                	mov    %eax,%esi
80101dab:	e9 33 ff ff ff       	jmp    80101ce3 <namex+0x43>
  while(*path != '/' && *path != 0)
80101db0:	31 c9                	xor    %ecx,%ecx
80101db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(name, s, len);
80101db8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101dbc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101dc0:	89 3c 24             	mov    %edi,(%esp)
80101dc3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dc6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101dc9:	e8 a2 27 00 00       	call   80104570 <memmove>
    name[len] = 0;
80101dce:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dd1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dd4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dd8:	89 d3                	mov    %edx,%ebx
80101dda:	e9 66 ff ff ff       	jmp    80101d45 <namex+0xa5>
  }
  if(nameiparent){
80101ddf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101de2:	85 c0                	test   %eax,%eax
80101de4:	75 4c                	jne    80101e32 <namex+0x192>
80101de6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101de8:	83 c4 2c             	add    $0x2c,%esp
80101deb:	5b                   	pop    %ebx
80101dec:	5e                   	pop    %esi
80101ded:	5f                   	pop    %edi
80101dee:	5d                   	pop    %ebp
80101def:	c3                   	ret    
  iunlock(ip);
80101df0:	89 34 24             	mov    %esi,(%esp)
80101df3:	e8 b8 f9 ff ff       	call   801017b0 <iunlock>
  iput(ip);
80101df8:	89 34 24             	mov    %esi,(%esp)
80101dfb:	e8 f0 f9 ff ff       	call   801017f0 <iput>
}
80101e00:	83 c4 2c             	add    $0x2c,%esp
      return 0;
80101e03:	31 c0                	xor    %eax,%eax
}
80101e05:	5b                   	pop    %ebx
80101e06:	5e                   	pop    %esi
80101e07:	5f                   	pop    %edi
80101e08:	5d                   	pop    %ebp
80101e09:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e0a:	ba 01 00 00 00       	mov    $0x1,%edx
80101e0f:	b8 01 00 00 00       	mov    $0x1,%eax
80101e14:	e8 a7 f4 ff ff       	call   801012c0 <iget>
80101e19:	89 c6                	mov    %eax,%esi
80101e1b:	e9 c3 fe ff ff       	jmp    80101ce3 <namex+0x43>
      iunlock(ip);
80101e20:	89 34 24             	mov    %esi,(%esp)
80101e23:	e8 88 f9 ff ff       	call   801017b0 <iunlock>
}
80101e28:	83 c4 2c             	add    $0x2c,%esp
      return ip;
80101e2b:	89 f0                	mov    %esi,%eax
}
80101e2d:	5b                   	pop    %ebx
80101e2e:	5e                   	pop    %esi
80101e2f:	5f                   	pop    %edi
80101e30:	5d                   	pop    %ebp
80101e31:	c3                   	ret    
    iput(ip);
80101e32:	89 34 24             	mov    %esi,(%esp)
80101e35:	e8 b6 f9 ff ff       	call   801017f0 <iput>
    return 0;
80101e3a:	31 c0                	xor    %eax,%eax
80101e3c:	eb aa                	jmp    80101de8 <namex+0x148>
80101e3e:	66 90                	xchg   %ax,%ax

80101e40 <dirlink>:
{
80101e40:	55                   	push   %ebp
80101e41:	89 e5                	mov    %esp,%ebp
80101e43:	57                   	push   %edi
80101e44:	56                   	push   %esi
80101e45:	53                   	push   %ebx
80101e46:	83 ec 2c             	sub    $0x2c,%esp
80101e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e4f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e56:	00 
80101e57:	89 1c 24             	mov    %ebx,(%esp)
80101e5a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e5e:	e8 7d fd ff ff       	call   80101be0 <dirlookup>
80101e63:	85 c0                	test   %eax,%eax
80101e65:	0f 85 8b 00 00 00    	jne    80101ef6 <dirlink+0xb6>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e6b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e6e:	31 ff                	xor    %edi,%edi
80101e70:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e73:	85 c0                	test   %eax,%eax
80101e75:	75 13                	jne    80101e8a <dirlink+0x4a>
80101e77:	eb 35                	jmp    80101eae <dirlink+0x6e>
80101e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e80:	8d 57 10             	lea    0x10(%edi),%edx
80101e83:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e86:	89 d7                	mov    %edx,%edi
80101e88:	76 24                	jbe    80101eae <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e91:	00 
80101e92:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e96:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e9a:	89 1c 24             	mov    %ebx,(%esp)
80101e9d:	e8 de fa ff ff       	call   80101980 <readi>
80101ea2:	83 f8 10             	cmp    $0x10,%eax
80101ea5:	75 5e                	jne    80101f05 <dirlink+0xc5>
    if(de.inum == 0)
80101ea7:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101eac:	75 d2                	jne    80101e80 <dirlink+0x40>
  strncpy(de.name, name, DIRSIZ);
80101eae:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eb1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101eb8:	00 
80101eb9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ebd:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ec0:	89 04 24             	mov    %eax,(%esp)
80101ec3:	e8 98 27 00 00       	call   80104660 <strncpy>
  de.inum = inum;
80101ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ecb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ed2:	00 
80101ed3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ed7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101edb:	89 1c 24             	mov    %ebx,(%esp)
  de.inum = inum;
80101ede:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ee2:	e8 99 fb ff ff       	call   80101a80 <writei>
80101ee7:	83 f8 10             	cmp    $0x10,%eax
80101eea:	75 25                	jne    80101f11 <dirlink+0xd1>
  return 0;
80101eec:	31 c0                	xor    %eax,%eax
}
80101eee:	83 c4 2c             	add    $0x2c,%esp
80101ef1:	5b                   	pop    %ebx
80101ef2:	5e                   	pop    %esi
80101ef3:	5f                   	pop    %edi
80101ef4:	5d                   	pop    %ebp
80101ef5:	c3                   	ret    
    iput(ip);
80101ef6:	89 04 24             	mov    %eax,(%esp)
80101ef9:	e8 f2 f8 ff ff       	call   801017f0 <iput>
    return -1;
80101efe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f03:	eb e9                	jmp    80101eee <dirlink+0xae>
      panic("dirlink read");
80101f05:	c7 04 24 c8 6f 10 80 	movl   $0x80106fc8,(%esp)
80101f0c:	e8 4f e4 ff ff       	call   80100360 <panic>
    panic("dirlink");
80101f11:	c7 04 24 26 76 10 80 	movl   $0x80107626,(%esp)
80101f18:	e8 43 e4 ff ff       	call   80100360 <panic>
80101f1d:	8d 76 00             	lea    0x0(%esi),%esi

80101f20 <namei>:

struct inode*
namei(char *path)
{
80101f20:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f21:	31 d2                	xor    %edx,%edx
{
80101f23:	89 e5                	mov    %esp,%ebp
80101f25:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f28:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f2e:	e8 6d fd ff ff       	call   80101ca0 <namex>
}
80101f33:	c9                   	leave  
80101f34:	c3                   	ret    
80101f35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f40 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f40:	55                   	push   %ebp
  return namex(path, 1, name);
80101f41:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f46:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f4e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f4f:	e9 4c fd ff ff       	jmp    80101ca0 <namex>
80101f54:	66 90                	xchg   %ax,%ax
80101f56:	66 90                	xchg   %ax,%ax
80101f58:	66 90                	xchg   %ax,%ax
80101f5a:	66 90                	xchg   %ax,%ax
80101f5c:	66 90                	xchg   %ax,%ax
80101f5e:	66 90                	xchg   %ax,%ax

80101f60 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f60:	55                   	push   %ebp
80101f61:	89 e5                	mov    %esp,%ebp
80101f63:	56                   	push   %esi
80101f64:	89 c6                	mov    %eax,%esi
80101f66:	53                   	push   %ebx
80101f67:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f6a:	85 c0                	test   %eax,%eax
80101f6c:	0f 84 99 00 00 00    	je     8010200b <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f72:	8b 48 08             	mov    0x8(%eax),%ecx
80101f75:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f7b:	0f 87 7e 00 00 00    	ja     80101fff <idestart+0x9f>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f81:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f86:	66 90                	xchg   %ax,%ax
80101f88:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f89:	83 e0 c0             	and    $0xffffffc0,%eax
80101f8c:	3c 40                	cmp    $0x40,%al
80101f8e:	75 f8                	jne    80101f88 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f90:	31 db                	xor    %ebx,%ebx
80101f92:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f97:	89 d8                	mov    %ebx,%eax
80101f99:	ee                   	out    %al,(%dx)
80101f9a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f9f:	b8 01 00 00 00       	mov    $0x1,%eax
80101fa4:	ee                   	out    %al,(%dx)
80101fa5:	0f b6 c1             	movzbl %cl,%eax
80101fa8:	b2 f3                	mov    $0xf3,%dl
80101faa:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101fab:	89 c8                	mov    %ecx,%eax
80101fad:	b2 f4                	mov    $0xf4,%dl
80101faf:	c1 f8 08             	sar    $0x8,%eax
80101fb2:	ee                   	out    %al,(%dx)
80101fb3:	b2 f5                	mov    $0xf5,%dl
80101fb5:	89 d8                	mov    %ebx,%eax
80101fb7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fb8:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fbc:	b2 f6                	mov    $0xf6,%dl
80101fbe:	83 e0 01             	and    $0x1,%eax
80101fc1:	c1 e0 04             	shl    $0x4,%eax
80101fc4:	83 c8 e0             	or     $0xffffffe0,%eax
80101fc7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fc8:	f6 06 04             	testb  $0x4,(%esi)
80101fcb:	75 13                	jne    80101fe0 <idestart+0x80>
80101fcd:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fd2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fd7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fd8:	83 c4 10             	add    $0x10,%esp
80101fdb:	5b                   	pop    %ebx
80101fdc:	5e                   	pop    %esi
80101fdd:	5d                   	pop    %ebp
80101fde:	c3                   	ret    
80101fdf:	90                   	nop
80101fe0:	b2 f7                	mov    $0xf7,%dl
80101fe2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fe7:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fe8:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fed:	83 c6 5c             	add    $0x5c,%esi
80101ff0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101ff5:	fc                   	cld    
80101ff6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101ff8:	83 c4 10             	add    $0x10,%esp
80101ffb:	5b                   	pop    %ebx
80101ffc:	5e                   	pop    %esi
80101ffd:	5d                   	pop    %ebp
80101ffe:	c3                   	ret    
    panic("incorrect blockno");
80101fff:	c7 04 24 34 70 10 80 	movl   $0x80107034,(%esp)
80102006:	e8 55 e3 ff ff       	call   80100360 <panic>
    panic("idestart");
8010200b:	c7 04 24 2b 70 10 80 	movl   $0x8010702b,(%esp)
80102012:	e8 49 e3 ff ff       	call   80100360 <panic>
80102017:	89 f6                	mov    %esi,%esi
80102019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102020 <ideinit>:
{
80102020:	55                   	push   %ebp
80102021:	89 e5                	mov    %esp,%ebp
80102023:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
80102026:	c7 44 24 04 46 70 10 	movl   $0x80107046,0x4(%esp)
8010202d:	80 
8010202e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102035:	e8 66 22 00 00       	call   801042a0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010203a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010203f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102046:	83 e8 01             	sub    $0x1,%eax
80102049:	89 44 24 04          	mov    %eax,0x4(%esp)
8010204d:	e8 7e 02 00 00       	call   801022d0 <ioapicenable>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102052:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102057:	90                   	nop
80102058:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102059:	83 e0 c0             	and    $0xffffffc0,%eax
8010205c:	3c 40                	cmp    $0x40,%al
8010205e:	75 f8                	jne    80102058 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102060:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102065:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010206a:	ee                   	out    %al,(%dx)
8010206b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102070:	b2 f7                	mov    $0xf7,%dl
80102072:	eb 09                	jmp    8010207d <ideinit+0x5d>
80102074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<1000; i++){
80102078:	83 e9 01             	sub    $0x1,%ecx
8010207b:	74 0f                	je     8010208c <ideinit+0x6c>
8010207d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010207e:	84 c0                	test   %al,%al
80102080:	74 f6                	je     80102078 <ideinit+0x58>
      havedisk1 = 1;
80102082:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102089:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010208c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102091:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102096:	ee                   	out    %al,(%dx)
}
80102097:	c9                   	leave  
80102098:	c3                   	ret    
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020a0:	55                   	push   %ebp
801020a1:	89 e5                	mov    %esp,%ebp
801020a3:	57                   	push   %edi
801020a4:	56                   	push   %esi
801020a5:	53                   	push   %ebx
801020a6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020a9:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020b0:	e8 5b 23 00 00       	call   80104410 <acquire>

  if((b = idequeue) == 0){
801020b5:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020bb:	85 db                	test   %ebx,%ebx
801020bd:	74 30                	je     801020ef <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020bf:	8b 43 58             	mov    0x58(%ebx),%eax
801020c2:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020c7:	8b 33                	mov    (%ebx),%esi
801020c9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020cf:	74 37                	je     80102108 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020d1:	83 e6 fb             	and    $0xfffffffb,%esi
801020d4:	83 ce 02             	or     $0x2,%esi
801020d7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020d9:	89 1c 24             	mov    %ebx,(%esp)
801020dc:	e8 2f 1e 00 00       	call   80103f10 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020e1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020e6:	85 c0                	test   %eax,%eax
801020e8:	74 05                	je     801020ef <ideintr+0x4f>
    idestart(idequeue);
801020ea:	e8 71 fe ff ff       	call   80101f60 <idestart>
    release(&idelock);
801020ef:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020f6:	e8 85 23 00 00       	call   80104480 <release>

  release(&idelock);
}
801020fb:	83 c4 1c             	add    $0x1c,%esp
801020fe:	5b                   	pop    %ebx
801020ff:	5e                   	pop    %esi
80102100:	5f                   	pop    %edi
80102101:	5d                   	pop    %ebp
80102102:	c3                   	ret    
80102103:	90                   	nop
80102104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102108:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010210d:	8d 76 00             	lea    0x0(%esi),%esi
80102110:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102111:	89 c1                	mov    %eax,%ecx
80102113:	83 e1 c0             	and    $0xffffffc0,%ecx
80102116:	80 f9 40             	cmp    $0x40,%cl
80102119:	75 f5                	jne    80102110 <ideintr+0x70>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010211b:	a8 21                	test   $0x21,%al
8010211d:	75 b2                	jne    801020d1 <ideintr+0x31>
    insl(0x1f0, b->data, BSIZE/4);
8010211f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102122:	b9 80 00 00 00       	mov    $0x80,%ecx
80102127:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010212c:	fc                   	cld    
8010212d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010212f:	8b 33                	mov    (%ebx),%esi
80102131:	eb 9e                	jmp    801020d1 <ideintr+0x31>
80102133:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102140 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	53                   	push   %ebx
80102144:	83 ec 14             	sub    $0x14,%esp
80102147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010214a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010214d:	89 04 24             	mov    %eax,(%esp)
80102150:	e8 fb 20 00 00       	call   80104250 <holdingsleep>
80102155:	85 c0                	test   %eax,%eax
80102157:	0f 84 9e 00 00 00    	je     801021fb <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010215d:	8b 03                	mov    (%ebx),%eax
8010215f:	83 e0 06             	and    $0x6,%eax
80102162:	83 f8 02             	cmp    $0x2,%eax
80102165:	0f 84 a8 00 00 00    	je     80102213 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010216b:	8b 53 04             	mov    0x4(%ebx),%edx
8010216e:	85 d2                	test   %edx,%edx
80102170:	74 0d                	je     8010217f <iderw+0x3f>
80102172:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102177:	85 c0                	test   %eax,%eax
80102179:	0f 84 88 00 00 00    	je     80102207 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010217f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102186:	e8 85 22 00 00       	call   80104410 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010218b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
80102190:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102197:	85 c0                	test   %eax,%eax
80102199:	75 07                	jne    801021a2 <iderw+0x62>
8010219b:	eb 4e                	jmp    801021eb <iderw+0xab>
8010219d:	8d 76 00             	lea    0x0(%esi),%esi
801021a0:	89 d0                	mov    %edx,%eax
801021a2:	8b 50 58             	mov    0x58(%eax),%edx
801021a5:	85 d2                	test   %edx,%edx
801021a7:	75 f7                	jne    801021a0 <iderw+0x60>
801021a9:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
801021ac:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801021ae:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021b4:	74 3c                	je     801021f2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021b6:	8b 03                	mov    (%ebx),%eax
801021b8:	83 e0 06             	and    $0x6,%eax
801021bb:	83 f8 02             	cmp    $0x2,%eax
801021be:	74 1a                	je     801021da <iderw+0x9a>
    sleep(b, &idelock);
801021c0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801021c7:	80 
801021c8:	89 1c 24             	mov    %ebx,(%esp)
801021cb:	e8 a0 1b 00 00       	call   80103d70 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021d0:	8b 13                	mov    (%ebx),%edx
801021d2:	83 e2 06             	and    $0x6,%edx
801021d5:	83 fa 02             	cmp    $0x2,%edx
801021d8:	75 e6                	jne    801021c0 <iderw+0x80>
  }


  release(&idelock);
801021da:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021e1:	83 c4 14             	add    $0x14,%esp
801021e4:	5b                   	pop    %ebx
801021e5:	5d                   	pop    %ebp
  release(&idelock);
801021e6:	e9 95 22 00 00       	jmp    80104480 <release>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021eb:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021f0:	eb ba                	jmp    801021ac <iderw+0x6c>
    idestart(b);
801021f2:	89 d8                	mov    %ebx,%eax
801021f4:	e8 67 fd ff ff       	call   80101f60 <idestart>
801021f9:	eb bb                	jmp    801021b6 <iderw+0x76>
    panic("iderw: buf not locked");
801021fb:	c7 04 24 4a 70 10 80 	movl   $0x8010704a,(%esp)
80102202:	e8 59 e1 ff ff       	call   80100360 <panic>
    panic("iderw: ide disk 1 not present");
80102207:	c7 04 24 75 70 10 80 	movl   $0x80107075,(%esp)
8010220e:	e8 4d e1 ff ff       	call   80100360 <panic>
    panic("iderw: nothing to do");
80102213:	c7 04 24 60 70 10 80 	movl   $0x80107060,(%esp)
8010221a:	e8 41 e1 ff ff       	call   80100360 <panic>
8010221f:	90                   	nop

80102220 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102220:	55                   	push   %ebp
80102221:	89 e5                	mov    %esp,%ebp
80102223:	56                   	push   %esi
80102224:	53                   	push   %ebx
80102225:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102228:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010222f:	00 c0 fe 
  ioapic->reg = reg;
80102232:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102239:	00 00 00 
  return ioapic->data;
8010223c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102242:	8b 42 10             	mov    0x10(%edx),%eax
  ioapic->reg = reg;
80102245:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010224b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102251:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102258:	c1 e8 10             	shr    $0x10,%eax
8010225b:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010225e:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102261:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102264:	39 c2                	cmp    %eax,%edx
80102266:	74 12                	je     8010227a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102268:	c7 04 24 94 70 10 80 	movl   $0x80107094,(%esp)
8010226f:	e8 dc e3 ff ff       	call   80100650 <cprintf>
80102274:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010227a:	ba 10 00 00 00       	mov    $0x10,%edx
8010227f:	31 c0                	xor    %eax,%eax
80102281:	eb 07                	jmp    8010228a <ioapicinit+0x6a>
80102283:	90                   	nop
80102284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102288:	89 cb                	mov    %ecx,%ebx
  ioapic->reg = reg;
8010228a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010228c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102292:	8d 48 20             	lea    0x20(%eax),%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102295:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  for(i = 0; i <= maxintr; i++){
8010229b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010229e:	89 4b 10             	mov    %ecx,0x10(%ebx)
801022a1:	8d 4a 01             	lea    0x1(%edx),%ecx
801022a4:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801022a7:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801022a9:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
801022af:	39 c6                	cmp    %eax,%esi
  ioapic->data = data;
801022b1:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022b8:	7d ce                	jge    80102288 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022ba:	83 c4 10             	add    $0x10,%esp
801022bd:	5b                   	pop    %ebx
801022be:	5e                   	pop    %esi
801022bf:	5d                   	pop    %ebp
801022c0:	c3                   	ret    
801022c1:	eb 0d                	jmp    801022d0 <ioapicenable>
801022c3:	90                   	nop
801022c4:	90                   	nop
801022c5:	90                   	nop
801022c6:	90                   	nop
801022c7:	90                   	nop
801022c8:	90                   	nop
801022c9:	90                   	nop
801022ca:	90                   	nop
801022cb:	90                   	nop
801022cc:	90                   	nop
801022cd:	90                   	nop
801022ce:	90                   	nop
801022cf:	90                   	nop

801022d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	8b 55 08             	mov    0x8(%ebp),%edx
801022d6:	53                   	push   %ebx
801022d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022da:	8d 5a 20             	lea    0x20(%edx),%ebx
801022dd:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
  ioapic->reg = reg;
801022e1:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022e7:	c1 e0 18             	shl    $0x18,%eax
  ioapic->reg = reg;
801022ea:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022ec:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f2:	83 c1 01             	add    $0x1,%ecx
  ioapic->data = data;
801022f5:	89 5a 10             	mov    %ebx,0x10(%edx)
  ioapic->reg = reg;
801022f8:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022fa:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102300:	89 42 10             	mov    %eax,0x10(%edx)
}
80102303:	5b                   	pop    %ebx
80102304:	5d                   	pop    %ebp
80102305:	c3                   	ret    
80102306:	66 90                	xchg   %ax,%ax
80102308:	66 90                	xchg   %ax,%ax
8010230a:	66 90                	xchg   %ax,%ax
8010230c:	66 90                	xchg   %ax,%ax
8010230e:	66 90                	xchg   %ax,%ax

80102310 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	53                   	push   %ebx
80102314:	83 ec 14             	sub    $0x14,%esp
80102317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010231a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102320:	75 7c                	jne    8010239e <kfree+0x8e>
80102322:	81 fb a8 59 11 80    	cmp    $0x801159a8,%ebx
80102328:	72 74                	jb     8010239e <kfree+0x8e>
8010232a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102330:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102335:	77 67                	ja     8010239e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102337:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010233e:	00 
8010233f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102346:	00 
80102347:	89 1c 24             	mov    %ebx,(%esp)
8010234a:	e8 81 21 00 00       	call   801044d0 <memset>

  if(kmem.use_lock)
8010234f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102355:	85 d2                	test   %edx,%edx
80102357:	75 37                	jne    80102390 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102359:	a1 78 26 11 80       	mov    0x80112678,%eax
8010235e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102360:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102365:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010236b:	85 c0                	test   %eax,%eax
8010236d:	75 09                	jne    80102378 <kfree+0x68>
    release(&kmem.lock);
}
8010236f:	83 c4 14             	add    $0x14,%esp
80102372:	5b                   	pop    %ebx
80102373:	5d                   	pop    %ebp
80102374:	c3                   	ret    
80102375:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102378:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010237f:	83 c4 14             	add    $0x14,%esp
80102382:	5b                   	pop    %ebx
80102383:	5d                   	pop    %ebp
    release(&kmem.lock);
80102384:	e9 f7 20 00 00       	jmp    80104480 <release>
80102389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102390:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102397:	e8 74 20 00 00       	call   80104410 <acquire>
8010239c:	eb bb                	jmp    80102359 <kfree+0x49>
    panic("kfree");
8010239e:	c7 04 24 c6 70 10 80 	movl   $0x801070c6,(%esp)
801023a5:	e8 b6 df ff ff       	call   80100360 <panic>
801023aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023b0 <freerange>:
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	56                   	push   %esi
801023b4:	53                   	push   %ebx
801023b5:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
801023b8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023be:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023c4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ca:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023d0:	39 de                	cmp    %ebx,%esi
801023d2:	73 08                	jae    801023dc <freerange+0x2c>
801023d4:	eb 18                	jmp    801023ee <freerange+0x3e>
801023d6:	66 90                	xchg   %ax,%ax
801023d8:	89 da                	mov    %ebx,%edx
801023da:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023dc:	89 14 24             	mov    %edx,(%esp)
801023df:	e8 2c ff ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023ea:	39 f0                	cmp    %esi,%eax
801023ec:	76 ea                	jbe    801023d8 <freerange+0x28>
}
801023ee:	83 c4 10             	add    $0x10,%esp
801023f1:	5b                   	pop    %ebx
801023f2:	5e                   	pop    %esi
801023f3:	5d                   	pop    %ebp
801023f4:	c3                   	ret    
801023f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102400 <kinit1>:
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	56                   	push   %esi
80102404:	53                   	push   %ebx
80102405:	83 ec 10             	sub    $0x10,%esp
80102408:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010240b:	c7 44 24 04 cc 70 10 	movl   $0x801070cc,0x4(%esp)
80102412:	80 
80102413:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010241a:	e8 81 1e 00 00       	call   801042a0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010241f:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 0;
80102422:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102429:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010242c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102432:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102438:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010243e:	39 de                	cmp    %ebx,%esi
80102440:	73 0a                	jae    8010244c <kinit1+0x4c>
80102442:	eb 1a                	jmp    8010245e <kinit1+0x5e>
80102444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102448:	89 da                	mov    %ebx,%edx
8010244a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010244c:	89 14 24             	mov    %edx,(%esp)
8010244f:	e8 bc fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102454:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010245a:	39 c6                	cmp    %eax,%esi
8010245c:	73 ea                	jae    80102448 <kinit1+0x48>
}
8010245e:	83 c4 10             	add    $0x10,%esp
80102461:	5b                   	pop    %ebx
80102462:	5e                   	pop    %esi
80102463:	5d                   	pop    %ebp
80102464:	c3                   	ret    
80102465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102470 <kinit2>:
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	56                   	push   %esi
80102474:	53                   	push   %ebx
80102475:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102478:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010247b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010247e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102484:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010248a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102490:	39 de                	cmp    %ebx,%esi
80102492:	73 08                	jae    8010249c <kinit2+0x2c>
80102494:	eb 18                	jmp    801024ae <kinit2+0x3e>
80102496:	66 90                	xchg   %ax,%ax
80102498:	89 da                	mov    %ebx,%edx
8010249a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010249c:	89 14 24             	mov    %edx,(%esp)
8010249f:	e8 6c fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801024aa:	39 c6                	cmp    %eax,%esi
801024ac:	73 ea                	jae    80102498 <kinit2+0x28>
  kmem.use_lock = 1;
801024ae:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024b5:	00 00 00 
}
801024b8:	83 c4 10             	add    $0x10,%esp
801024bb:	5b                   	pop    %ebx
801024bc:	5e                   	pop    %esi
801024bd:	5d                   	pop    %ebp
801024be:	c3                   	ret    
801024bf:	90                   	nop

801024c0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024c7:	a1 74 26 11 80       	mov    0x80112674,%eax
801024cc:	85 c0                	test   %eax,%eax
801024ce:	75 30                	jne    80102500 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024d0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024d6:	85 db                	test   %ebx,%ebx
801024d8:	74 08                	je     801024e2 <kalloc+0x22>
    kmem.freelist = r->next;
801024da:	8b 13                	mov    (%ebx),%edx
801024dc:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024e2:	85 c0                	test   %eax,%eax
801024e4:	74 0c                	je     801024f2 <kalloc+0x32>
    release(&kmem.lock);
801024e6:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024ed:	e8 8e 1f 00 00       	call   80104480 <release>
  return (char*)r;
}
801024f2:	83 c4 14             	add    $0x14,%esp
801024f5:	89 d8                	mov    %ebx,%eax
801024f7:	5b                   	pop    %ebx
801024f8:	5d                   	pop    %ebp
801024f9:	c3                   	ret    
801024fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102500:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102507:	e8 04 1f 00 00       	call   80104410 <acquire>
8010250c:	a1 74 26 11 80       	mov    0x80112674,%eax
80102511:	eb bd                	jmp    801024d0 <kalloc+0x10>
80102513:	66 90                	xchg   %ax,%ax
80102515:	66 90                	xchg   %ax,%ax
80102517:	66 90                	xchg   %ax,%ax
80102519:	66 90                	xchg   %ax,%ax
8010251b:	66 90                	xchg   %ax,%ax
8010251d:	66 90                	xchg   %ax,%ax
8010251f:	90                   	nop

80102520 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102520:	ba 64 00 00 00       	mov    $0x64,%edx
80102525:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102526:	a8 01                	test   $0x1,%al
80102528:	0f 84 ba 00 00 00    	je     801025e8 <kbdgetc+0xc8>
8010252e:	b2 60                	mov    $0x60,%dl
80102530:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102531:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102534:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010253a:	0f 84 88 00 00 00    	je     801025c8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102540:	84 c0                	test   %al,%al
80102542:	79 2c                	jns    80102570 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102544:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010254a:	f6 c2 40             	test   $0x40,%dl
8010254d:	75 05                	jne    80102554 <kbdgetc+0x34>
8010254f:	89 c1                	mov    %eax,%ecx
80102551:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102554:	0f b6 81 00 72 10 80 	movzbl -0x7fef8e00(%ecx),%eax
8010255b:	83 c8 40             	or     $0x40,%eax
8010255e:	0f b6 c0             	movzbl %al,%eax
80102561:	f7 d0                	not    %eax
80102563:	21 d0                	and    %edx,%eax
80102565:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010256a:	31 c0                	xor    %eax,%eax
8010256c:	c3                   	ret    
8010256d:	8d 76 00             	lea    0x0(%esi),%esi
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	53                   	push   %ebx
80102574:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(shift & E0ESC){
8010257a:	f6 c3 40             	test   $0x40,%bl
8010257d:	74 09                	je     80102588 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010257f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102582:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102585:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102588:	0f b6 91 00 72 10 80 	movzbl -0x7fef8e00(%ecx),%edx
  shift ^= togglecode[data];
8010258f:	0f b6 81 00 71 10 80 	movzbl -0x7fef8f00(%ecx),%eax
  shift |= shiftcode[data];
80102596:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102598:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010259a:	89 d0                	mov    %edx,%eax
8010259c:	83 e0 03             	and    $0x3,%eax
8010259f:	8b 04 85 e0 70 10 80 	mov    -0x7fef8f20(,%eax,4),%eax
  shift ^= togglecode[data];
801025a6:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  if(shift & CAPSLOCK){
801025ac:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801025af:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801025b3:	74 0b                	je     801025c0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
801025b5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025b8:	83 fa 19             	cmp    $0x19,%edx
801025bb:	77 1b                	ja     801025d8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025bd:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025c0:	5b                   	pop    %ebx
801025c1:	5d                   	pop    %ebp
801025c2:	c3                   	ret    
801025c3:	90                   	nop
801025c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025c8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801025cf:	31 c0                	xor    %eax,%eax
801025d1:	c3                   	ret    
801025d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801025d8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025db:	8d 50 20             	lea    0x20(%eax),%edx
801025de:	83 f9 19             	cmp    $0x19,%ecx
801025e1:	0f 46 c2             	cmovbe %edx,%eax
  return c;
801025e4:	eb da                	jmp    801025c0 <kbdgetc+0xa0>
801025e6:	66 90                	xchg   %ax,%ax
    return -1;
801025e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025ed:	c3                   	ret    
801025ee:	66 90                	xchg   %ax,%ax

801025f0 <kbdintr>:

void
kbdintr(void)
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025f6:	c7 04 24 20 25 10 80 	movl   $0x80102520,(%esp)
801025fd:	e8 ae e1 ff ff       	call   801007b0 <consoleintr>
}
80102602:	c9                   	leave  
80102603:	c3                   	ret    
80102604:	66 90                	xchg   %ax,%ax
80102606:	66 90                	xchg   %ax,%ax
80102608:	66 90                	xchg   %ax,%ax
8010260a:	66 90                	xchg   %ax,%ax
8010260c:	66 90                	xchg   %ax,%ax
8010260e:	66 90                	xchg   %ax,%ax

80102610 <fill_rtcdate>:
  return inb(CMOS_RETURN);
}

static void
fill_rtcdate(struct rtcdate *r)
{
80102610:	55                   	push   %ebp
80102611:	89 c1                	mov    %eax,%ecx
80102613:	89 e5                	mov    %esp,%ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102615:	ba 70 00 00 00       	mov    $0x70,%edx
8010261a:	53                   	push   %ebx
8010261b:	31 c0                	xor    %eax,%eax
8010261d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010261e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102623:	89 da                	mov    %ebx,%edx
80102625:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
80102626:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102629:	b2 70                	mov    $0x70,%dl
8010262b:	89 01                	mov    %eax,(%ecx)
8010262d:	b8 02 00 00 00       	mov    $0x2,%eax
80102632:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102633:	89 da                	mov    %ebx,%edx
80102635:	ec                   	in     (%dx),%al
80102636:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102639:	b2 70                	mov    $0x70,%dl
8010263b:	89 41 04             	mov    %eax,0x4(%ecx)
8010263e:	b8 04 00 00 00       	mov    $0x4,%eax
80102643:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102644:	89 da                	mov    %ebx,%edx
80102646:	ec                   	in     (%dx),%al
80102647:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010264a:	b2 70                	mov    $0x70,%dl
8010264c:	89 41 08             	mov    %eax,0x8(%ecx)
8010264f:	b8 07 00 00 00       	mov    $0x7,%eax
80102654:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102655:	89 da                	mov    %ebx,%edx
80102657:	ec                   	in     (%dx),%al
80102658:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010265b:	b2 70                	mov    $0x70,%dl
8010265d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102660:	b8 08 00 00 00       	mov    $0x8,%eax
80102665:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102666:	89 da                	mov    %ebx,%edx
80102668:	ec                   	in     (%dx),%al
80102669:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010266c:	b2 70                	mov    $0x70,%dl
8010266e:	89 41 10             	mov    %eax,0x10(%ecx)
80102671:	b8 09 00 00 00       	mov    $0x9,%eax
80102676:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102677:	89 da                	mov    %ebx,%edx
80102679:	ec                   	in     (%dx),%al
8010267a:	0f b6 d8             	movzbl %al,%ebx
8010267d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102680:	5b                   	pop    %ebx
80102681:	5d                   	pop    %ebp
80102682:	c3                   	ret    
80102683:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102690 <lapicinit>:
  if(!lapic)
80102690:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102695:	55                   	push   %ebp
80102696:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102698:	85 c0                	test   %eax,%eax
8010269a:	0f 84 c0 00 00 00    	je     80102760 <lapicinit+0xd0>
  lapic[index] = value;
801026a0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026a7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026aa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ad:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ba:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026c1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026c4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026ce:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026d1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026db:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026e8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026eb:	8b 50 20             	mov    0x20(%eax),%edx
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026ee:	8b 50 30             	mov    0x30(%eax),%edx
801026f1:	c1 ea 10             	shr    $0x10,%edx
801026f4:	80 fa 03             	cmp    $0x3,%dl
801026f7:	77 6f                	ja     80102768 <lapicinit+0xd8>
  lapic[index] = value;
801026f9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102700:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102703:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102706:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010270d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102710:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102713:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010271a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010271d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102720:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102727:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010272a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010272d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102734:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102737:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010273a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102741:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102744:	8b 50 20             	mov    0x20(%eax),%edx
80102747:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
80102748:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010274e:	80 e6 10             	and    $0x10,%dh
80102751:	75 f5                	jne    80102748 <lapicinit+0xb8>
  lapic[index] = value;
80102753:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010275a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010275d:	8b 40 20             	mov    0x20(%eax),%eax
}
80102760:	5d                   	pop    %ebp
80102761:	c3                   	ret    
80102762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102768:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010276f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102772:	8b 50 20             	mov    0x20(%eax),%edx
80102775:	eb 82                	jmp    801026f9 <lapicinit+0x69>
80102777:	89 f6                	mov    %esi,%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapicid>:
  if (!lapic)
80102780:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102785:	55                   	push   %ebp
80102786:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102788:	85 c0                	test   %eax,%eax
8010278a:	74 0c                	je     80102798 <lapicid+0x18>
  return lapic[ID] >> 24;
8010278c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010278f:	5d                   	pop    %ebp
  return lapic[ID] >> 24;
80102790:	c1 e8 18             	shr    $0x18,%eax
}
80102793:	c3                   	ret    
80102794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102798:	31 c0                	xor    %eax,%eax
}
8010279a:	5d                   	pop    %ebp
8010279b:	c3                   	ret    
8010279c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027a0 <lapiceoi>:
  if(lapic)
801027a0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801027a5:	55                   	push   %ebp
801027a6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027a8:	85 c0                	test   %eax,%eax
801027aa:	74 0d                	je     801027b9 <lapiceoi+0x19>
  lapic[index] = value;
801027ac:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027b3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027b6:	8b 40 20             	mov    0x20(%eax),%eax
}
801027b9:	5d                   	pop    %ebp
801027ba:	c3                   	ret    
801027bb:	90                   	nop
801027bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027c0 <microdelay>:
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
}
801027c3:	5d                   	pop    %ebp
801027c4:	c3                   	ret    
801027c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027d0 <lapicstartap>:
{
801027d0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027d1:	ba 70 00 00 00       	mov    $0x70,%edx
801027d6:	89 e5                	mov    %esp,%ebp
801027d8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027dd:	53                   	push   %ebx
801027de:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027e4:	ee                   	out    %al,(%dx)
801027e5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ea:	b2 71                	mov    $0x71,%dl
801027ec:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
801027ed:	31 c0                	xor    %eax,%eax
801027ef:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027f5:	89 d8                	mov    %ebx,%eax
801027f7:	c1 e8 04             	shr    $0x4,%eax
801027fa:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102800:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(ICRHI, apicid<<24);
80102805:	c1 e1 18             	shl    $0x18,%ecx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102808:	c1 eb 0c             	shr    $0xc,%ebx
  lapic[index] = value;
8010280b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102811:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102814:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010281b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010281e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102821:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102828:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010282b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102837:	89 da                	mov    %ebx,%edx
80102839:	80 ce 06             	or     $0x6,%dh
  lapic[index] = value;
8010283c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102842:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102845:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010284b:	8b 48 20             	mov    0x20(%eax),%ecx
  lapic[index] = value;
8010284e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102854:	8b 40 20             	mov    0x20(%eax),%eax
}
80102857:	5b                   	pop    %ebx
80102858:	5d                   	pop    %ebp
80102859:	c3                   	ret    
8010285a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102860 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102860:	55                   	push   %ebp
80102861:	ba 70 00 00 00       	mov    $0x70,%edx
80102866:	89 e5                	mov    %esp,%ebp
80102868:	b8 0b 00 00 00       	mov    $0xb,%eax
8010286d:	57                   	push   %edi
8010286e:	56                   	push   %esi
8010286f:	53                   	push   %ebx
80102870:	83 ec 4c             	sub    $0x4c,%esp
80102873:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102874:	b2 71                	mov    $0x71,%dl
80102876:	ec                   	in     (%dx),%al
80102877:	88 45 b7             	mov    %al,-0x49(%ebp)
8010287a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010287d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102881:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102888:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010288d:	89 d8                	mov    %ebx,%eax
8010288f:	e8 7c fd ff ff       	call   80102610 <fill_rtcdate>
80102894:	b8 0a 00 00 00       	mov    $0xa,%eax
80102899:	89 f2                	mov    %esi,%edx
8010289b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289c:	ba 71 00 00 00       	mov    $0x71,%edx
801028a1:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028a2:	84 c0                	test   %al,%al
801028a4:	78 e7                	js     8010288d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
801028a6:	89 f8                	mov    %edi,%eax
801028a8:	e8 63 fd ff ff       	call   80102610 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028ad:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801028b4:	00 
801028b5:	89 7c 24 04          	mov    %edi,0x4(%esp)
801028b9:	89 1c 24             	mov    %ebx,(%esp)
801028bc:	e8 5f 1c 00 00       	call   80104520 <memcmp>
801028c1:	85 c0                	test   %eax,%eax
801028c3:	75 c3                	jne    80102888 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801028c5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028c9:	75 78                	jne    80102943 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028cb:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028ce:	89 c2                	mov    %eax,%edx
801028d0:	83 e0 0f             	and    $0xf,%eax
801028d3:	c1 ea 04             	shr    $0x4,%edx
801028d6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028d9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028dc:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028df:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028e2:	89 c2                	mov    %eax,%edx
801028e4:	83 e0 0f             	and    $0xf,%eax
801028e7:	c1 ea 04             	shr    $0x4,%edx
801028ea:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028ed:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028f0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028f3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028f6:	89 c2                	mov    %eax,%edx
801028f8:	83 e0 0f             	and    $0xf,%eax
801028fb:	c1 ea 04             	shr    $0x4,%edx
801028fe:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102901:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102904:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102907:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010290a:	89 c2                	mov    %eax,%edx
8010290c:	83 e0 0f             	and    $0xf,%eax
8010290f:	c1 ea 04             	shr    $0x4,%edx
80102912:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102915:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102918:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010291b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010291e:	89 c2                	mov    %eax,%edx
80102920:	83 e0 0f             	and    $0xf,%eax
80102923:	c1 ea 04             	shr    $0x4,%edx
80102926:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102929:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010292c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010292f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102932:	89 c2                	mov    %eax,%edx
80102934:	83 e0 0f             	and    $0xf,%eax
80102937:	c1 ea 04             	shr    $0x4,%edx
8010293a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010293d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102940:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102943:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102946:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102949:	89 01                	mov    %eax,(%ecx)
8010294b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010294e:	89 41 04             	mov    %eax,0x4(%ecx)
80102951:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102954:	89 41 08             	mov    %eax,0x8(%ecx)
80102957:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010295a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010295d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102960:	89 41 10             	mov    %eax,0x10(%ecx)
80102963:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102966:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102969:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102970:	83 c4 4c             	add    $0x4c,%esp
80102973:	5b                   	pop    %ebx
80102974:	5e                   	pop    %esi
80102975:	5f                   	pop    %edi
80102976:	5d                   	pop    %ebp
80102977:	c3                   	ret    
80102978:	66 90                	xchg   %ax,%ax
8010297a:	66 90                	xchg   %ax,%ax
8010297c:	66 90                	xchg   %ax,%ax
8010297e:	66 90                	xchg   %ax,%ax

80102980 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102980:	55                   	push   %ebp
80102981:	89 e5                	mov    %esp,%ebp
80102983:	57                   	push   %edi
80102984:	56                   	push   %esi
80102985:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102986:	31 db                	xor    %ebx,%ebx
{
80102988:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010298b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102990:	85 c0                	test   %eax,%eax
80102992:	7e 78                	jle    80102a0c <install_trans+0x8c>
80102994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102998:	a1 b4 26 11 80       	mov    0x801126b4,%eax
8010299d:	01 d8                	add    %ebx,%eax
8010299f:	83 c0 01             	add    $0x1,%eax
801029a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801029a6:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029ab:	89 04 24             	mov    %eax,(%esp)
801029ae:	e8 1d d7 ff ff       	call   801000d0 <bread>
801029b3:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029b5:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
801029bc:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801029c3:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029c8:	89 04 24             	mov    %eax,(%esp)
801029cb:	e8 00 d7 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029d0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029d7:	00 
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029d8:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029da:	8d 47 5c             	lea    0x5c(%edi),%eax
801029dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801029e1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029e4:	89 04 24             	mov    %eax,(%esp)
801029e7:	e8 84 1b 00 00       	call   80104570 <memmove>
    bwrite(dbuf);  // write dst to disk
801029ec:	89 34 24             	mov    %esi,(%esp)
801029ef:	e8 ac d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801029f4:	89 3c 24             	mov    %edi,(%esp)
801029f7:	e8 e4 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801029fc:	89 34 24             	mov    %esi,(%esp)
801029ff:	e8 dc d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a04:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102a0a:	7f 8c                	jg     80102998 <install_trans+0x18>
  }
}
80102a0c:	83 c4 1c             	add    $0x1c,%esp
80102a0f:	5b                   	pop    %ebx
80102a10:	5e                   	pop    %esi
80102a11:	5f                   	pop    %edi
80102a12:	5d                   	pop    %ebp
80102a13:	c3                   	ret    
80102a14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
80102a23:	57                   	push   %edi
80102a24:	56                   	push   %esi
80102a25:	53                   	push   %ebx
80102a26:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a29:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a2e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a32:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a37:	89 04 24             	mov    %eax,(%esp)
80102a3a:	e8 91 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a3f:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a45:	31 d2                	xor    %edx,%edx
80102a47:	85 db                	test   %ebx,%ebx
  struct buf *buf = bread(log.dev, log.start);
80102a49:	89 c7                	mov    %eax,%edi
  hb->n = log.lh.n;
80102a4b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a4e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a51:	7e 17                	jle    80102a6a <write_head+0x4a>
80102a53:	90                   	nop
80102a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a58:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a5f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102a63:	83 c2 01             	add    $0x1,%edx
80102a66:	39 da                	cmp    %ebx,%edx
80102a68:	75 ee                	jne    80102a58 <write_head+0x38>
  }
  bwrite(buf);
80102a6a:	89 3c 24             	mov    %edi,(%esp)
80102a6d:	e8 2e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a72:	89 3c 24             	mov    %edi,(%esp)
80102a75:	e8 66 d7 ff ff       	call   801001e0 <brelse>
}
80102a7a:	83 c4 1c             	add    $0x1c,%esp
80102a7d:	5b                   	pop    %ebx
80102a7e:	5e                   	pop    %esi
80102a7f:	5f                   	pop    %edi
80102a80:	5d                   	pop    %ebp
80102a81:	c3                   	ret    
80102a82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a90 <initlog>:
{
80102a90:	55                   	push   %ebp
80102a91:	89 e5                	mov    %esp,%ebp
80102a93:	56                   	push   %esi
80102a94:	53                   	push   %ebx
80102a95:	83 ec 30             	sub    $0x30,%esp
80102a98:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102a9b:	c7 44 24 04 00 73 10 	movl   $0x80107300,0x4(%esp)
80102aa2:	80 
80102aa3:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102aaa:	e8 f1 17 00 00       	call   801042a0 <initlock>
  readsb(dev, &sb);
80102aaf:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ab6:	89 1c 24             	mov    %ebx,(%esp)
80102ab9:	e8 82 e9 ff ff       	call   80101440 <readsb>
  log.start = sb.logstart;
80102abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102ac1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  struct buf *buf = bread(log.dev, log.start);
80102ac4:	89 1c 24             	mov    %ebx,(%esp)
  log.dev = dev;
80102ac7:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  struct buf *buf = bread(log.dev, log.start);
80102acd:	89 44 24 04          	mov    %eax,0x4(%esp)
  log.size = sb.nlog;
80102ad1:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102ad7:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102adc:	e8 ef d5 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ae1:	31 d2                	xor    %edx,%edx
  log.lh.n = lh->n;
80102ae3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ae6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ae9:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102aeb:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102af1:	7e 17                	jle    80102b0a <initlog+0x7a>
80102af3:	90                   	nop
80102af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102af8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102afc:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102b03:	83 c2 01             	add    $0x1,%edx
80102b06:	39 da                	cmp    %ebx,%edx
80102b08:	75 ee                	jne    80102af8 <initlog+0x68>
  brelse(buf);
80102b0a:	89 04 24             	mov    %eax,(%esp)
80102b0d:	e8 ce d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b12:	e8 69 fe ff ff       	call   80102980 <install_trans>
  log.lh.n = 0;
80102b17:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b1e:	00 00 00 
  write_head(); // clear the log
80102b21:	e8 fa fe ff ff       	call   80102a20 <write_head>
}
80102b26:	83 c4 30             	add    $0x30,%esp
80102b29:	5b                   	pop    %ebx
80102b2a:	5e                   	pop    %esi
80102b2b:	5d                   	pop    %ebp
80102b2c:	c3                   	ret    
80102b2d:	8d 76 00             	lea    0x0(%esi),%esi

80102b30 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b30:	55                   	push   %ebp
80102b31:	89 e5                	mov    %esp,%ebp
80102b33:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b36:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b3d:	e8 ce 18 00 00       	call   80104410 <acquire>
80102b42:	eb 18                	jmp    80102b5c <begin_op+0x2c>
80102b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b48:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b4f:	80 
80102b50:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b57:	e8 14 12 00 00       	call   80103d70 <sleep>
    if(log.committing){
80102b5c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b61:	85 c0                	test   %eax,%eax
80102b63:	75 e3                	jne    80102b48 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b65:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b6a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b70:	83 c0 01             	add    $0x1,%eax
80102b73:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b76:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b79:	83 fa 1e             	cmp    $0x1e,%edx
80102b7c:	7f ca                	jg     80102b48 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b7e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      log.outstanding += 1;
80102b85:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b8a:	e8 f1 18 00 00       	call   80104480 <release>
      break;
    }
  }
}
80102b8f:	c9                   	leave  
80102b90:	c3                   	ret    
80102b91:	eb 0d                	jmp    80102ba0 <end_op>
80102b93:	90                   	nop
80102b94:	90                   	nop
80102b95:	90                   	nop
80102b96:	90                   	nop
80102b97:	90                   	nop
80102b98:	90                   	nop
80102b99:	90                   	nop
80102b9a:	90                   	nop
80102b9b:	90                   	nop
80102b9c:	90                   	nop
80102b9d:	90                   	nop
80102b9e:	90                   	nop
80102b9f:	90                   	nop

80102ba0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	57                   	push   %edi
80102ba4:	56                   	push   %esi
80102ba5:	53                   	push   %ebx
80102ba6:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ba9:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102bb0:	e8 5b 18 00 00       	call   80104410 <acquire>
  log.outstanding -= 1;
80102bb5:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102bba:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
  log.outstanding -= 1;
80102bc0:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102bc3:	85 d2                	test   %edx,%edx
  log.outstanding -= 1;
80102bc5:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102bca:	0f 85 f3 00 00 00    	jne    80102cc3 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102bd0:	85 c0                	test   %eax,%eax
80102bd2:	0f 85 cb 00 00 00    	jne    80102ca3 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bd8:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bdf:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
80102be1:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102be8:	00 00 00 
  release(&log.lock);
80102beb:	e8 90 18 00 00       	call   80104480 <release>
  if (log.lh.n > 0) {
80102bf0:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102bf5:	85 c0                	test   %eax,%eax
80102bf7:	0f 8e 90 00 00 00    	jle    80102c8d <end_op+0xed>
80102bfd:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c00:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c05:	01 d8                	add    %ebx,%eax
80102c07:	83 c0 01             	add    $0x1,%eax
80102c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c0e:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c13:	89 04 24             	mov    %eax,(%esp)
80102c16:	e8 b5 d4 ff ff       	call   801000d0 <bread>
80102c1b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c1d:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102c24:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c27:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c2b:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c30:	89 04 24             	mov    %eax,(%esp)
80102c33:	e8 98 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c38:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c3f:	00 
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c40:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c42:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c45:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c49:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c4c:	89 04 24             	mov    %eax,(%esp)
80102c4f:	e8 1c 19 00 00       	call   80104570 <memmove>
    bwrite(to);  // write the log
80102c54:	89 34 24             	mov    %esi,(%esp)
80102c57:	e8 44 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c5c:	89 3c 24             	mov    %edi,(%esp)
80102c5f:	e8 7c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c64:	89 34 24             	mov    %esi,(%esp)
80102c67:	e8 74 d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c6c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c72:	7c 8c                	jl     80102c00 <end_op+0x60>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c74:	e8 a7 fd ff ff       	call   80102a20 <write_head>
    install_trans(); // Now install writes to home locations
80102c79:	e8 02 fd ff ff       	call   80102980 <install_trans>
    log.lh.n = 0;
80102c7e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c85:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c88:	e8 93 fd ff ff       	call   80102a20 <write_head>
    acquire(&log.lock);
80102c8d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c94:	e8 77 17 00 00       	call   80104410 <acquire>
    log.committing = 0;
80102c99:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102ca0:	00 00 00 
    wakeup(&log);
80102ca3:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102caa:	e8 61 12 00 00       	call   80103f10 <wakeup>
    release(&log.lock);
80102caf:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cb6:	e8 c5 17 00 00       	call   80104480 <release>
}
80102cbb:	83 c4 1c             	add    $0x1c,%esp
80102cbe:	5b                   	pop    %ebx
80102cbf:	5e                   	pop    %esi
80102cc0:	5f                   	pop    %edi
80102cc1:	5d                   	pop    %ebp
80102cc2:	c3                   	ret    
    panic("log.committing");
80102cc3:	c7 04 24 04 73 10 80 	movl   $0x80107304,(%esp)
80102cca:	e8 91 d6 ff ff       	call   80100360 <panic>
80102ccf:	90                   	nop

80102cd0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	53                   	push   %ebx
80102cd4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cd7:	a1 c8 26 11 80       	mov    0x801126c8,%eax
{
80102cdc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cdf:	83 f8 1d             	cmp    $0x1d,%eax
80102ce2:	0f 8f 98 00 00 00    	jg     80102d80 <log_write+0xb0>
80102ce8:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102cee:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102cf1:	39 d0                	cmp    %edx,%eax
80102cf3:	0f 8d 87 00 00 00    	jge    80102d80 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102cf9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cfe:	85 c0                	test   %eax,%eax
80102d00:	0f 8e 86 00 00 00    	jle    80102d8c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d06:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d0d:	e8 fe 16 00 00       	call   80104410 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d12:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d18:	83 fa 00             	cmp    $0x0,%edx
80102d1b:	7e 54                	jle    80102d71 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d1d:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102d20:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d22:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102d28:	75 0f                	jne    80102d39 <log_write+0x69>
80102d2a:	eb 3c                	jmp    80102d68 <log_write+0x98>
80102d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d30:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d37:	74 2f                	je     80102d68 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102d39:	83 c0 01             	add    $0x1,%eax
80102d3c:	39 d0                	cmp    %edx,%eax
80102d3e:	75 f0                	jne    80102d30 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102d40:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d47:	83 c2 01             	add    $0x1,%edx
80102d4a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d50:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d53:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d5a:	83 c4 14             	add    $0x14,%esp
80102d5d:	5b                   	pop    %ebx
80102d5e:	5d                   	pop    %ebp
  release(&log.lock);
80102d5f:	e9 1c 17 00 00       	jmp    80104480 <release>
80102d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80102d68:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d6f:	eb df                	jmp    80102d50 <log_write+0x80>
80102d71:	8b 43 08             	mov    0x8(%ebx),%eax
80102d74:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102d79:	75 d5                	jne    80102d50 <log_write+0x80>
80102d7b:	eb ca                	jmp    80102d47 <log_write+0x77>
80102d7d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("too big a transaction");
80102d80:	c7 04 24 13 73 10 80 	movl   $0x80107313,(%esp)
80102d87:	e8 d4 d5 ff ff       	call   80100360 <panic>
    panic("log_write outside of trans");
80102d8c:	c7 04 24 29 73 10 80 	movl   $0x80107329,(%esp)
80102d93:	e8 c8 d5 ff ff       	call   80100360 <panic>
80102d98:	66 90                	xchg   %ax,%ax
80102d9a:	66 90                	xchg   %ax,%ax
80102d9c:	66 90                	xchg   %ax,%ax
80102d9e:	66 90                	xchg   %ax,%ax

80102da0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
80102da3:	53                   	push   %ebx
80102da4:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102da7:	e8 14 09 00 00       	call   801036c0 <cpuid>
80102dac:	89 c3                	mov    %eax,%ebx
80102dae:	e8 0d 09 00 00       	call   801036c0 <cpuid>
80102db3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102db7:	c7 04 24 44 73 10 80 	movl   $0x80107344,(%esp)
80102dbe:	89 44 24 04          	mov    %eax,0x4(%esp)
80102dc2:	e8 89 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102dc7:	e8 34 29 00 00       	call   80105700 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102dcc:	e8 6f 08 00 00       	call   80103640 <mycpu>
80102dd1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102dd3:	b8 01 00 00 00       	mov    $0x1,%eax
80102dd8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102ddf:	e8 bc 0b 00 00       	call   801039a0 <scheduler>
80102de4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102dea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102df0 <mpenter>:
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102df6:	e8 c5 39 00 00       	call   801067c0 <switchkvm>
  seginit();
80102dfb:	e8 00 39 00 00       	call   80106700 <seginit>
  lapicinit();
80102e00:	e8 8b f8 ff ff       	call   80102690 <lapicinit>
  mpmain();
80102e05:	e8 96 ff ff ff       	call   80102da0 <mpmain>
80102e0a:	66 90                	xchg   %ax,%ax
80102e0c:	66 90                	xchg   %ax,%ax
80102e0e:	66 90                	xchg   %ax,%ax

80102e10 <main>:
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e14:	bb 80 27 11 80       	mov    $0x80112780,%ebx
{
80102e19:	83 e4 f0             	and    $0xfffffff0,%esp
80102e1c:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e1f:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e26:	80 
80102e27:	c7 04 24 a8 59 11 80 	movl   $0x801159a8,(%esp)
80102e2e:	e8 cd f5 ff ff       	call   80102400 <kinit1>
  kvmalloc();      // kernel page table
80102e33:	e8 18 3e 00 00       	call   80106c50 <kvmalloc>
  mpinit();        // detect other processors
80102e38:	e8 73 01 00 00       	call   80102fb0 <mpinit>
80102e3d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e40:	e8 4b f8 ff ff       	call   80102690 <lapicinit>
  seginit();       // segment descriptors
80102e45:	e8 b6 38 00 00       	call   80106700 <seginit>
  picinit();       // disable pic
80102e4a:	e8 21 03 00 00       	call   80103170 <picinit>
80102e4f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e50:	e8 cb f3 ff ff       	call   80102220 <ioapicinit>
  consoleinit();   // console hardware
80102e55:	e8 f6 da ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e5a:	e8 c1 2b 00 00       	call   80105a20 <uartinit>
80102e5f:	90                   	nop
  pinit();         // process table
80102e60:	e8 bb 07 00 00       	call   80103620 <pinit>
  tvinit();        // trap vectors
80102e65:	e8 f6 27 00 00       	call   80105660 <tvinit>
  binit();         // buffer cache
80102e6a:	e8 d1 d1 ff ff       	call   80100040 <binit>
80102e6f:	90                   	nop
  fileinit();      // file table
80102e70:	e8 fb de ff ff       	call   80100d70 <fileinit>
  ideinit();       // disk 
80102e75:	e8 a6 f1 ff ff       	call   80102020 <ideinit>
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e7a:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e81:	00 
80102e82:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102e89:	80 
80102e8a:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102e91:	e8 da 16 00 00       	call   80104570 <memmove>
  for(c = cpus; c < cpus+ncpu; c++){
80102e96:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102e9d:	00 00 00 
80102ea0:	05 80 27 11 80       	add    $0x80112780,%eax
80102ea5:	39 d8                	cmp    %ebx,%eax
80102ea7:	76 6a                	jbe    80102f13 <main+0x103>
80102ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102eb0:	e8 8b 07 00 00       	call   80103640 <mycpu>
80102eb5:	39 d8                	cmp    %ebx,%eax
80102eb7:	74 41                	je     80102efa <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102eb9:	e8 02 f6 ff ff       	call   801024c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
80102ebe:	c7 05 f8 6f 00 80 f0 	movl   $0x80102df0,0x80006ff8
80102ec5:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102ec8:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102ecf:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ed2:	05 00 10 00 00       	add    $0x1000,%eax
80102ed7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102edc:	0f b6 03             	movzbl (%ebx),%eax
80102edf:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102ee6:	00 
80102ee7:	89 04 24             	mov    %eax,(%esp)
80102eea:	e8 e1 f8 ff ff       	call   801027d0 <lapicstartap>
80102eef:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ef0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ef6:	85 c0                	test   %eax,%eax
80102ef8:	74 f6                	je     80102ef0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102efa:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f01:	00 00 00 
80102f04:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f0a:	05 80 27 11 80       	add    $0x80112780,%eax
80102f0f:	39 c3                	cmp    %eax,%ebx
80102f11:	72 9d                	jb     80102eb0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f13:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f1a:	8e 
80102f1b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f22:	e8 49 f5 ff ff       	call   80102470 <kinit2>
  userinit();      // first user process
80102f27:	e8 e4 07 00 00       	call   80103710 <userinit>
  mpmain();        // finish this processor's setup
80102f2c:	e8 6f fe ff ff       	call   80102da0 <mpmain>
80102f31:	66 90                	xchg   %ax,%ax
80102f33:	66 90                	xchg   %ax,%ax
80102f35:	66 90                	xchg   %ax,%ax
80102f37:	66 90                	xchg   %ax,%ax
80102f39:	66 90                	xchg   %ax,%ax
80102f3b:	66 90                	xchg   %ax,%ax
80102f3d:	66 90                	xchg   %ax,%ax
80102f3f:	90                   	nop

80102f40 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f44:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102f4a:	53                   	push   %ebx
  e = addr+len;
80102f4b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102f4e:	83 ec 10             	sub    $0x10,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102f51:	39 de                	cmp    %ebx,%esi
80102f53:	73 3c                	jae    80102f91 <mpsearch1+0x51>
80102f55:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f58:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f5f:	00 
80102f60:	c7 44 24 04 58 73 10 	movl   $0x80107358,0x4(%esp)
80102f67:	80 
80102f68:	89 34 24             	mov    %esi,(%esp)
80102f6b:	e8 b0 15 00 00       	call   80104520 <memcmp>
80102f70:	85 c0                	test   %eax,%eax
80102f72:	75 16                	jne    80102f8a <mpsearch1+0x4a>
80102f74:	31 c9                	xor    %ecx,%ecx
80102f76:	31 d2                	xor    %edx,%edx
    sum += addr[i];
80102f78:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
  for(i=0; i<len; i++)
80102f7c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f7f:	01 c1                	add    %eax,%ecx
  for(i=0; i<len; i++)
80102f81:	83 fa 10             	cmp    $0x10,%edx
80102f84:	75 f2                	jne    80102f78 <mpsearch1+0x38>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f86:	84 c9                	test   %cl,%cl
80102f88:	74 10                	je     80102f9a <mpsearch1+0x5a>
  for(p = addr; p < e; p += sizeof(struct mp))
80102f8a:	83 c6 10             	add    $0x10,%esi
80102f8d:	39 f3                	cmp    %esi,%ebx
80102f8f:	77 c7                	ja     80102f58 <mpsearch1+0x18>
      return (struct mp*)p;
  return 0;
}
80102f91:	83 c4 10             	add    $0x10,%esp
  return 0;
80102f94:	31 c0                	xor    %eax,%eax
}
80102f96:	5b                   	pop    %ebx
80102f97:	5e                   	pop    %esi
80102f98:	5d                   	pop    %ebp
80102f99:	c3                   	ret    
80102f9a:	83 c4 10             	add    $0x10,%esp
80102f9d:	89 f0                	mov    %esi,%eax
80102f9f:	5b                   	pop    %ebx
80102fa0:	5e                   	pop    %esi
80102fa1:	5d                   	pop    %ebp
80102fa2:	c3                   	ret    
80102fa3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fb0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	57                   	push   %edi
80102fb4:	56                   	push   %esi
80102fb5:	53                   	push   %ebx
80102fb6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102fb9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102fc0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102fc7:	c1 e0 08             	shl    $0x8,%eax
80102fca:	09 d0                	or     %edx,%eax
80102fcc:	c1 e0 04             	shl    $0x4,%eax
80102fcf:	85 c0                	test   %eax,%eax
80102fd1:	75 1b                	jne    80102fee <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102fd3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102fda:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102fe1:	c1 e0 08             	shl    $0x8,%eax
80102fe4:	09 d0                	or     %edx,%eax
80102fe6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102fe9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80102fee:	ba 00 04 00 00       	mov    $0x400,%edx
80102ff3:	e8 48 ff ff ff       	call   80102f40 <mpsearch1>
80102ff8:	85 c0                	test   %eax,%eax
80102ffa:	89 c7                	mov    %eax,%edi
80102ffc:	0f 84 22 01 00 00    	je     80103124 <mpinit+0x174>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103002:	8b 77 04             	mov    0x4(%edi),%esi
80103005:	85 f6                	test   %esi,%esi
80103007:	0f 84 30 01 00 00    	je     8010313d <mpinit+0x18d>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010300d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103013:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010301a:	00 
8010301b:	c7 44 24 04 5d 73 10 	movl   $0x8010735d,0x4(%esp)
80103022:	80 
80103023:	89 04 24             	mov    %eax,(%esp)
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103026:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103029:	e8 f2 14 00 00       	call   80104520 <memcmp>
8010302e:	85 c0                	test   %eax,%eax
80103030:	0f 85 07 01 00 00    	jne    8010313d <mpinit+0x18d>
  if(conf->version != 1 && conf->version != 4)
80103036:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010303d:	3c 04                	cmp    $0x4,%al
8010303f:	0f 85 0b 01 00 00    	jne    80103150 <mpinit+0x1a0>
  if(sum((uchar*)conf, conf->length) != 0)
80103045:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
  for(i=0; i<len; i++)
8010304c:	85 c0                	test   %eax,%eax
8010304e:	74 21                	je     80103071 <mpinit+0xc1>
  sum = 0;
80103050:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103052:	31 d2                	xor    %edx,%edx
80103054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103058:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010305f:	80 
  for(i=0; i<len; i++)
80103060:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103063:	01 d9                	add    %ebx,%ecx
  for(i=0; i<len; i++)
80103065:	39 d0                	cmp    %edx,%eax
80103067:	7f ef                	jg     80103058 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103069:	84 c9                	test   %cl,%cl
8010306b:	0f 85 cc 00 00 00    	jne    8010313d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103071:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103074:	85 c0                	test   %eax,%eax
80103076:	0f 84 c1 00 00 00    	je     8010313d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010307c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  ismp = 1;
80103082:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103087:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010308c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103093:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103099:	03 55 e4             	add    -0x1c(%ebp),%edx
8010309c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030a0:	39 c2                	cmp    %eax,%edx
801030a2:	76 1b                	jbe    801030bf <mpinit+0x10f>
801030a4:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
801030a7:	80 f9 04             	cmp    $0x4,%cl
801030aa:	77 74                	ja     80103120 <mpinit+0x170>
801030ac:	ff 24 8d 9c 73 10 80 	jmp    *-0x7fef8c64(,%ecx,4)
801030b3:	90                   	nop
801030b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801030b8:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030bb:	39 c2                	cmp    %eax,%edx
801030bd:	77 e5                	ja     801030a4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801030bf:	85 db                	test   %ebx,%ebx
801030c1:	0f 84 93 00 00 00    	je     8010315a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801030c7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801030cb:	74 12                	je     801030df <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030cd:	ba 22 00 00 00       	mov    $0x22,%edx
801030d2:	b8 70 00 00 00       	mov    $0x70,%eax
801030d7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030d8:	b2 23                	mov    $0x23,%dl
801030da:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801030db:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030de:	ee                   	out    %al,(%dx)
  }
}
801030df:	83 c4 1c             	add    $0x1c,%esp
801030e2:	5b                   	pop    %ebx
801030e3:	5e                   	pop    %esi
801030e4:	5f                   	pop    %edi
801030e5:	5d                   	pop    %ebp
801030e6:	c3                   	ret    
801030e7:	90                   	nop
      if(ncpu < NCPU) {
801030e8:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801030ee:	83 fe 07             	cmp    $0x7,%esi
801030f1:	7f 17                	jg     8010310a <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030f3:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030f7:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
801030fd:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103104:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
      p += sizeof(struct mpproc);
8010310a:	83 c0 14             	add    $0x14,%eax
      continue;
8010310d:	eb 91                	jmp    801030a0 <mpinit+0xf0>
8010310f:	90                   	nop
      ioapicid = ioapic->apicno;
80103110:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103114:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103117:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
8010311d:	eb 81                	jmp    801030a0 <mpinit+0xf0>
8010311f:	90                   	nop
      ismp = 0;
80103120:	31 db                	xor    %ebx,%ebx
80103122:	eb 83                	jmp    801030a7 <mpinit+0xf7>
  return mpsearch1(0xF0000, 0x10000);
80103124:	ba 00 00 01 00       	mov    $0x10000,%edx
80103129:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010312e:	e8 0d fe ff ff       	call   80102f40 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103133:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103135:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103137:	0f 85 c5 fe ff ff    	jne    80103002 <mpinit+0x52>
    panic("Expect to run on an SMP");
8010313d:	c7 04 24 62 73 10 80 	movl   $0x80107362,(%esp)
80103144:	e8 17 d2 ff ff       	call   80100360 <panic>
80103149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(conf->version != 1 && conf->version != 4)
80103150:	3c 01                	cmp    $0x1,%al
80103152:	0f 84 ed fe ff ff    	je     80103045 <mpinit+0x95>
80103158:	eb e3                	jmp    8010313d <mpinit+0x18d>
    panic("Didn't find a suitable machine");
8010315a:	c7 04 24 7c 73 10 80 	movl   $0x8010737c,(%esp)
80103161:	e8 fa d1 ff ff       	call   80100360 <panic>
80103166:	66 90                	xchg   %ax,%ax
80103168:	66 90                	xchg   %ax,%ax
8010316a:	66 90                	xchg   %ax,%ax
8010316c:	66 90                	xchg   %ax,%ax
8010316e:	66 90                	xchg   %ax,%ax

80103170 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103170:	55                   	push   %ebp
80103171:	ba 21 00 00 00       	mov    $0x21,%edx
80103176:	89 e5                	mov    %esp,%ebp
80103178:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010317d:	ee                   	out    %al,(%dx)
8010317e:	b2 a1                	mov    $0xa1,%dl
80103180:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103181:	5d                   	pop    %ebp
80103182:	c3                   	ret    
80103183:	66 90                	xchg   %ax,%ax
80103185:	66 90                	xchg   %ax,%ax
80103187:	66 90                	xchg   %ax,%ax
80103189:	66 90                	xchg   %ax,%ax
8010318b:	66 90                	xchg   %ax,%ax
8010318d:	66 90                	xchg   %ax,%ax
8010318f:	90                   	nop

80103190 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
80103195:	53                   	push   %ebx
80103196:	83 ec 1c             	sub    $0x1c,%esp
80103199:	8b 75 08             	mov    0x8(%ebp),%esi
8010319c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010319f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801031a5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801031ab:	e8 e0 db ff ff       	call   80100d90 <filealloc>
801031b0:	85 c0                	test   %eax,%eax
801031b2:	89 06                	mov    %eax,(%esi)
801031b4:	0f 84 a4 00 00 00    	je     8010325e <pipealloc+0xce>
801031ba:	e8 d1 db ff ff       	call   80100d90 <filealloc>
801031bf:	85 c0                	test   %eax,%eax
801031c1:	89 03                	mov    %eax,(%ebx)
801031c3:	0f 84 87 00 00 00    	je     80103250 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801031c9:	e8 f2 f2 ff ff       	call   801024c0 <kalloc>
801031ce:	85 c0                	test   %eax,%eax
801031d0:	89 c7                	mov    %eax,%edi
801031d2:	74 7c                	je     80103250 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801031d4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031db:	00 00 00 
  p->writeopen = 1;
801031de:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031e5:	00 00 00 
  p->nwrite = 0;
801031e8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031ef:	00 00 00 
  p->nread = 0;
801031f2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801031f9:	00 00 00 
  initlock(&p->lock, "pipe");
801031fc:	89 04 24             	mov    %eax,(%esp)
801031ff:	c7 44 24 04 b0 73 10 	movl   $0x801073b0,0x4(%esp)
80103206:	80 
80103207:	e8 94 10 00 00       	call   801042a0 <initlock>
  (*f0)->type = FD_PIPE;
8010320c:	8b 06                	mov    (%esi),%eax
8010320e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103214:	8b 06                	mov    (%esi),%eax
80103216:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010321a:	8b 06                	mov    (%esi),%eax
8010321c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103220:	8b 06                	mov    (%esi),%eax
80103222:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103225:	8b 03                	mov    (%ebx),%eax
80103227:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010322d:	8b 03                	mov    (%ebx),%eax
8010322f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103233:	8b 03                	mov    (%ebx),%eax
80103235:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103239:	8b 03                	mov    (%ebx),%eax
  return 0;
8010323b:	31 db                	xor    %ebx,%ebx
  (*f1)->pipe = p;
8010323d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103240:	83 c4 1c             	add    $0x1c,%esp
80103243:	89 d8                	mov    %ebx,%eax
80103245:	5b                   	pop    %ebx
80103246:	5e                   	pop    %esi
80103247:	5f                   	pop    %edi
80103248:	5d                   	pop    %ebp
80103249:	c3                   	ret    
8010324a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*f0)
80103250:	8b 06                	mov    (%esi),%eax
80103252:	85 c0                	test   %eax,%eax
80103254:	74 08                	je     8010325e <pipealloc+0xce>
    fileclose(*f0);
80103256:	89 04 24             	mov    %eax,(%esp)
80103259:	e8 f2 db ff ff       	call   80100e50 <fileclose>
  if(*f1)
8010325e:	8b 03                	mov    (%ebx),%eax
  return -1;
80103260:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if(*f1)
80103265:	85 c0                	test   %eax,%eax
80103267:	74 d7                	je     80103240 <pipealloc+0xb0>
    fileclose(*f1);
80103269:	89 04 24             	mov    %eax,(%esp)
8010326c:	e8 df db ff ff       	call   80100e50 <fileclose>
}
80103271:	83 c4 1c             	add    $0x1c,%esp
80103274:	89 d8                	mov    %ebx,%eax
80103276:	5b                   	pop    %ebx
80103277:	5e                   	pop    %esi
80103278:	5f                   	pop    %edi
80103279:	5d                   	pop    %ebp
8010327a:	c3                   	ret    
8010327b:	90                   	nop
8010327c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103280 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	56                   	push   %esi
80103284:	53                   	push   %ebx
80103285:	83 ec 10             	sub    $0x10,%esp
80103288:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010328b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010328e:	89 1c 24             	mov    %ebx,(%esp)
80103291:	e8 7a 11 00 00       	call   80104410 <acquire>
  if(writable){
80103296:	85 f6                	test   %esi,%esi
80103298:	74 3e                	je     801032d8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010329a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801032a0:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801032a7:	00 00 00 
    wakeup(&p->nread);
801032aa:	89 04 24             	mov    %eax,(%esp)
801032ad:	e8 5e 0c 00 00       	call   80103f10 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801032b2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801032b8:	85 d2                	test   %edx,%edx
801032ba:	75 0a                	jne    801032c6 <pipeclose+0x46>
801032bc:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801032c2:	85 c0                	test   %eax,%eax
801032c4:	74 32                	je     801032f8 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032c6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032c9:	83 c4 10             	add    $0x10,%esp
801032cc:	5b                   	pop    %ebx
801032cd:	5e                   	pop    %esi
801032ce:	5d                   	pop    %ebp
    release(&p->lock);
801032cf:	e9 ac 11 00 00       	jmp    80104480 <release>
801032d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801032d8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801032de:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032e5:	00 00 00 
    wakeup(&p->nwrite);
801032e8:	89 04 24             	mov    %eax,(%esp)
801032eb:	e8 20 0c 00 00       	call   80103f10 <wakeup>
801032f0:	eb c0                	jmp    801032b2 <pipeclose+0x32>
801032f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&p->lock);
801032f8:	89 1c 24             	mov    %ebx,(%esp)
801032fb:	e8 80 11 00 00       	call   80104480 <release>
    kfree((char*)p);
80103300:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103303:	83 c4 10             	add    $0x10,%esp
80103306:	5b                   	pop    %ebx
80103307:	5e                   	pop    %esi
80103308:	5d                   	pop    %ebp
    kfree((char*)p);
80103309:	e9 02 f0 ff ff       	jmp    80102310 <kfree>
8010330e:	66 90                	xchg   %ax,%ax

80103310 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103310:	55                   	push   %ebp
80103311:	89 e5                	mov    %esp,%ebp
80103313:	57                   	push   %edi
80103314:	56                   	push   %esi
80103315:	53                   	push   %ebx
80103316:	83 ec 1c             	sub    $0x1c,%esp
80103319:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010331c:	89 1c 24             	mov    %ebx,(%esp)
8010331f:	e8 ec 10 00 00       	call   80104410 <acquire>
  for(i = 0; i < n; i++){
80103324:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103327:	85 c9                	test   %ecx,%ecx
80103329:	0f 8e b2 00 00 00    	jle    801033e1 <pipewrite+0xd1>
8010332f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103332:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103338:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010333e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103344:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103347:	03 4d 10             	add    0x10(%ebp),%ecx
8010334a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010334d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103353:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103359:	39 c8                	cmp    %ecx,%eax
8010335b:	74 38                	je     80103395 <pipewrite+0x85>
8010335d:	eb 55                	jmp    801033b4 <pipewrite+0xa4>
8010335f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103360:	e8 7b 03 00 00       	call   801036e0 <myproc>
80103365:	8b 40 24             	mov    0x24(%eax),%eax
80103368:	85 c0                	test   %eax,%eax
8010336a:	75 33                	jne    8010339f <pipewrite+0x8f>
      wakeup(&p->nread);
8010336c:	89 3c 24             	mov    %edi,(%esp)
8010336f:	e8 9c 0b 00 00       	call   80103f10 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103374:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103378:	89 34 24             	mov    %esi,(%esp)
8010337b:	e8 f0 09 00 00       	call   80103d70 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103380:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103386:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010338c:	05 00 02 00 00       	add    $0x200,%eax
80103391:	39 c2                	cmp    %eax,%edx
80103393:	75 23                	jne    801033b8 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80103395:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010339b:	85 d2                	test   %edx,%edx
8010339d:	75 c1                	jne    80103360 <pipewrite+0x50>
        release(&p->lock);
8010339f:	89 1c 24             	mov    %ebx,(%esp)
801033a2:	e8 d9 10 00 00       	call   80104480 <release>
        return -1;
801033a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801033ac:	83 c4 1c             	add    $0x1c,%esp
801033af:	5b                   	pop    %ebx
801033b0:	5e                   	pop    %esi
801033b1:	5f                   	pop    %edi
801033b2:	5d                   	pop    %ebp
801033b3:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033b4:	89 c2                	mov    %eax,%edx
801033b6:	66 90                	xchg   %ax,%ax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801033b8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033bb:	8d 42 01             	lea    0x1(%edx),%eax
801033be:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801033c4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801033ca:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801033ce:	0f b6 09             	movzbl (%ecx),%ecx
801033d1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801033d5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033d8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033db:	0f 85 6c ff ff ff    	jne    8010334d <pipewrite+0x3d>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801033e1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033e7:	89 04 24             	mov    %eax,(%esp)
801033ea:	e8 21 0b 00 00       	call   80103f10 <wakeup>
  release(&p->lock);
801033ef:	89 1c 24             	mov    %ebx,(%esp)
801033f2:	e8 89 10 00 00       	call   80104480 <release>
  return n;
801033f7:	8b 45 10             	mov    0x10(%ebp),%eax
801033fa:	eb b0                	jmp    801033ac <pipewrite+0x9c>
801033fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103400 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	57                   	push   %edi
80103404:	56                   	push   %esi
80103405:	53                   	push   %ebx
80103406:	83 ec 1c             	sub    $0x1c,%esp
80103409:	8b 75 08             	mov    0x8(%ebp),%esi
8010340c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010340f:	89 34 24             	mov    %esi,(%esp)
80103412:	e8 f9 0f 00 00       	call   80104410 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103417:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010341d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103423:	75 5b                	jne    80103480 <piperead+0x80>
80103425:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010342b:	85 db                	test   %ebx,%ebx
8010342d:	74 51                	je     80103480 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010342f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103435:	eb 25                	jmp    8010345c <piperead+0x5c>
80103437:	90                   	nop
80103438:	89 74 24 04          	mov    %esi,0x4(%esp)
8010343c:	89 1c 24             	mov    %ebx,(%esp)
8010343f:	e8 2c 09 00 00       	call   80103d70 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103444:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010344a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103450:	75 2e                	jne    80103480 <piperead+0x80>
80103452:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103458:	85 d2                	test   %edx,%edx
8010345a:	74 24                	je     80103480 <piperead+0x80>
    if(myproc()->killed){
8010345c:	e8 7f 02 00 00       	call   801036e0 <myproc>
80103461:	8b 48 24             	mov    0x24(%eax),%ecx
80103464:	85 c9                	test   %ecx,%ecx
80103466:	74 d0                	je     80103438 <piperead+0x38>
      release(&p->lock);
80103468:	89 34 24             	mov    %esi,(%esp)
8010346b:	e8 10 10 00 00       	call   80104480 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103470:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80103473:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103478:	5b                   	pop    %ebx
80103479:	5e                   	pop    %esi
8010347a:	5f                   	pop    %edi
8010347b:	5d                   	pop    %ebp
8010347c:	c3                   	ret    
8010347d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103480:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103483:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103485:	85 d2                	test   %edx,%edx
80103487:	7f 2b                	jg     801034b4 <piperead+0xb4>
80103489:	eb 31                	jmp    801034bc <piperead+0xbc>
8010348b:	90                   	nop
8010348c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103490:	8d 48 01             	lea    0x1(%eax),%ecx
80103493:	25 ff 01 00 00       	and    $0x1ff,%eax
80103498:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010349e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801034a3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034a6:	83 c3 01             	add    $0x1,%ebx
801034a9:	3b 5d 10             	cmp    0x10(%ebp),%ebx
801034ac:	74 0e                	je     801034bc <piperead+0xbc>
    if(p->nread == p->nwrite)
801034ae:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801034b4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801034ba:	75 d4                	jne    80103490 <piperead+0x90>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801034bc:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801034c2:	89 04 24             	mov    %eax,(%esp)
801034c5:	e8 46 0a 00 00       	call   80103f10 <wakeup>
  release(&p->lock);
801034ca:	89 34 24             	mov    %esi,(%esp)
801034cd:	e8 ae 0f 00 00       	call   80104480 <release>
}
801034d2:	83 c4 1c             	add    $0x1c,%esp
  return i;
801034d5:	89 d8                	mov    %ebx,%eax
}
801034d7:	5b                   	pop    %ebx
801034d8:	5e                   	pop    %esi
801034d9:	5f                   	pop    %edi
801034da:	5d                   	pop    %ebp
801034db:	c3                   	ret    
801034dc:	66 90                	xchg   %ax,%ax
801034de:	66 90                	xchg   %ax,%ax

801034e0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034e0:	55                   	push   %ebp
801034e1:	89 e5                	mov    %esp,%ebp
801034e3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034e4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801034e9:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801034ec:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034f3:	e8 18 0f 00 00       	call   80104410 <acquire>
801034f8:	eb 18                	jmp    80103512 <allocproc+0x32>
801034fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103500:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103506:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
8010350c:	0f 84 96 00 00 00    	je     801035a8 <allocproc+0xc8>
    if(p->state == UNUSED)
80103512:	8b 43 0c             	mov    0xc(%ebx),%eax
80103515:	85 c0                	test   %eax,%eax
80103517:	75 e7                	jne    80103500 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103519:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  // Lab2 prior value initialization with default 16
  p->prior_val = 16;
  p->burstCount = 0;
  p->selected_To_Run = 0;

  release(&ptable.lock);
8010351e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  p->state = EMBRYO;
80103525:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->prior_val = 16;
8010352c:	c7 43 7c 10 00 00 00 	movl   $0x10,0x7c(%ebx)
  p->pid = nextpid++;
80103533:	8d 50 01             	lea    0x1(%eax),%edx
80103536:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010353c:	89 43 10             	mov    %eax,0x10(%ebx)
  p->burstCount = 0;
8010353f:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103546:	00 00 00 
  p->selected_To_Run = 0;
80103549:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103550:	00 00 00 
  release(&ptable.lock);
80103553:	e8 28 0f 00 00       	call   80104480 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103558:	e8 63 ef ff ff       	call   801024c0 <kalloc>
8010355d:	85 c0                	test   %eax,%eax
8010355f:	89 43 08             	mov    %eax,0x8(%ebx)
80103562:	74 58                	je     801035bc <allocproc+0xdc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103564:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010356a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010356f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103572:	c7 40 14 51 56 10 80 	movl   $0x80105651,0x14(%eax)
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103579:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80103580:	00 
80103581:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103588:	00 
80103589:	89 04 24             	mov    %eax,(%esp)
  p->context = (struct context*)sp;
8010358c:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010358f:	e8 3c 0f 00 00       	call   801044d0 <memset>
  p->context->eip = (uint)forkret;
80103594:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103597:	c7 40 10 d0 35 10 80 	movl   $0x801035d0,0x10(%eax)

  return p;
8010359e:	89 d8                	mov    %ebx,%eax
}
801035a0:	83 c4 14             	add    $0x14,%esp
801035a3:	5b                   	pop    %ebx
801035a4:	5d                   	pop    %ebp
801035a5:	c3                   	ret    
801035a6:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
801035a8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035af:	e8 cc 0e 00 00       	call   80104480 <release>
}
801035b4:	83 c4 14             	add    $0x14,%esp
  return 0;
801035b7:	31 c0                	xor    %eax,%eax
}
801035b9:	5b                   	pop    %ebx
801035ba:	5d                   	pop    %ebp
801035bb:	c3                   	ret    
    p->state = UNUSED;
801035bc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801035c3:	eb db                	jmp    801035a0 <allocproc+0xc0>
801035c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035d0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801035d6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035dd:	e8 9e 0e 00 00       	call   80104480 <release>

  if (first) {
801035e2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801035e7:	85 c0                	test   %eax,%eax
801035e9:	75 05                	jne    801035f0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035eb:	c9                   	leave  
801035ec:	c3                   	ret    
801035ed:	8d 76 00             	lea    0x0(%esi),%esi
    iinit(ROOTDEV);
801035f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    first = 0;
801035f7:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801035fe:	00 00 00 
    iinit(ROOTDEV);
80103601:	e8 8a de ff ff       	call   80101490 <iinit>
    initlog(ROOTDEV);
80103606:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010360d:	e8 7e f4 ff ff       	call   80102a90 <initlog>
}
80103612:	c9                   	leave  
80103613:	c3                   	ret    
80103614:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010361a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103620 <pinit>:
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103626:	c7 44 24 04 b5 73 10 	movl   $0x801073b5,0x4(%esp)
8010362d:	80 
8010362e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103635:	e8 66 0c 00 00       	call   801042a0 <initlock>
}
8010363a:	c9                   	leave  
8010363b:	c3                   	ret    
8010363c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103640 <mycpu>:
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	56                   	push   %esi
80103644:	53                   	push   %ebx
80103645:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103648:	9c                   	pushf  
80103649:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010364a:	f6 c4 02             	test   $0x2,%ah
8010364d:	75 57                	jne    801036a6 <mycpu+0x66>
  apicid = lapicid();
8010364f:	e8 2c f1 ff ff       	call   80102780 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103654:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010365a:	85 f6                	test   %esi,%esi
8010365c:	7e 3c                	jle    8010369a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010365e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103665:	39 c2                	cmp    %eax,%edx
80103667:	74 2d                	je     80103696 <mycpu+0x56>
80103669:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010366e:	31 d2                	xor    %edx,%edx
80103670:	83 c2 01             	add    $0x1,%edx
80103673:	39 f2                	cmp    %esi,%edx
80103675:	74 23                	je     8010369a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103677:	0f b6 19             	movzbl (%ecx),%ebx
8010367a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103680:	39 c3                	cmp    %eax,%ebx
80103682:	75 ec                	jne    80103670 <mycpu+0x30>
      return &cpus[i];
80103684:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
}
8010368a:	83 c4 10             	add    $0x10,%esp
8010368d:	5b                   	pop    %ebx
8010368e:	5e                   	pop    %esi
8010368f:	5d                   	pop    %ebp
      return &cpus[i];
80103690:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103695:	c3                   	ret    
  for (i = 0; i < ncpu; ++i) {
80103696:	31 d2                	xor    %edx,%edx
80103698:	eb ea                	jmp    80103684 <mycpu+0x44>
  panic("unknown apicid\n");
8010369a:	c7 04 24 bc 73 10 80 	movl   $0x801073bc,(%esp)
801036a1:	e8 ba cc ff ff       	call   80100360 <panic>
    panic("mycpu called with interrupts enabled\n");
801036a6:	c7 04 24 98 74 10 80 	movl   $0x80107498,(%esp)
801036ad:	e8 ae cc ff ff       	call   80100360 <panic>
801036b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036c0 <cpuid>:
cpuid() {
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801036c6:	e8 75 ff ff ff       	call   80103640 <mycpu>
}
801036cb:	c9                   	leave  
  return mycpu()-cpus;
801036cc:	2d 80 27 11 80       	sub    $0x80112780,%eax
801036d1:	c1 f8 04             	sar    $0x4,%eax
801036d4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801036da:	c3                   	ret    
801036db:	90                   	nop
801036dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036e0 <myproc>:
myproc(void) {
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	53                   	push   %ebx
801036e4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801036e7:	e8 34 0c 00 00       	call   80104320 <pushcli>
  c = mycpu();
801036ec:	e8 4f ff ff ff       	call   80103640 <mycpu>
  p = c->proc;
801036f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036f7:	e8 64 0c 00 00       	call   80104360 <popcli>
}
801036fc:	83 c4 04             	add    $0x4,%esp
801036ff:	89 d8                	mov    %ebx,%eax
80103701:	5b                   	pop    %ebx
80103702:	5d                   	pop    %ebp
80103703:	c3                   	ret    
80103704:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010370a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103710 <userinit>:
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	53                   	push   %ebx
80103714:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
80103717:	e8 c4 fd ff ff       	call   801034e0 <allocproc>
8010371c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010371e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103723:	e8 98 34 00 00       	call   80106bc0 <setupkvm>
80103728:	85 c0                	test   %eax,%eax
8010372a:	89 43 04             	mov    %eax,0x4(%ebx)
8010372d:	0f 84 d4 00 00 00    	je     80103807 <userinit+0xf7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103733:	89 04 24             	mov    %eax,(%esp)
80103736:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010373d:	00 
8010373e:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103745:	80 
80103746:	e8 a5 31 00 00       	call   801068f0 <inituvm>
  p->sz = PGSIZE;
8010374b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103751:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103758:	00 
80103759:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103760:	00 
80103761:	8b 43 18             	mov    0x18(%ebx),%eax
80103764:	89 04 24             	mov    %eax,(%esp)
80103767:	e8 64 0d 00 00       	call   801044d0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010376c:	8b 43 18             	mov    0x18(%ebx),%eax
8010376f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103774:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103779:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010377d:	8b 43 18             	mov    0x18(%ebx),%eax
80103780:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103784:	8b 43 18             	mov    0x18(%ebx),%eax
80103787:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010378b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010378f:	8b 43 18             	mov    0x18(%ebx),%eax
80103792:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103796:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010379a:	8b 43 18             	mov    0x18(%ebx),%eax
8010379d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801037a4:	8b 43 18             	mov    0x18(%ebx),%eax
801037a7:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801037ae:	8b 43 18             	mov    0x18(%ebx),%eax
801037b1:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801037b8:	8d 43 6c             	lea    0x6c(%ebx),%eax
801037bb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801037c2:	00 
801037c3:	c7 44 24 04 e5 73 10 	movl   $0x801073e5,0x4(%esp)
801037ca:	80 
801037cb:	89 04 24             	mov    %eax,(%esp)
801037ce:	e8 dd 0e 00 00       	call   801046b0 <safestrcpy>
  p->cwd = namei("/");
801037d3:	c7 04 24 ee 73 10 80 	movl   $0x801073ee,(%esp)
801037da:	e8 41 e7 ff ff       	call   80101f20 <namei>
801037df:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801037e2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037e9:	e8 22 0c 00 00       	call   80104410 <acquire>
  p->state = RUNNABLE;
801037ee:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801037f5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037fc:	e8 7f 0c 00 00       	call   80104480 <release>
}
80103801:	83 c4 14             	add    $0x14,%esp
80103804:	5b                   	pop    %ebx
80103805:	5d                   	pop    %ebp
80103806:	c3                   	ret    
    panic("userinit: out of memory?");
80103807:	c7 04 24 cc 73 10 80 	movl   $0x801073cc,(%esp)
8010380e:	e8 4d cb ff ff       	call   80100360 <panic>
80103813:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103820 <growproc>:
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	56                   	push   %esi
80103824:	53                   	push   %ebx
80103825:	83 ec 10             	sub    $0x10,%esp
80103828:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
8010382b:	e8 b0 fe ff ff       	call   801036e0 <myproc>
  if(n > 0){
80103830:	83 fe 00             	cmp    $0x0,%esi
  struct proc *curproc = myproc();
80103833:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103835:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103837:	7e 2f                	jle    80103868 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103839:	01 c6                	add    %eax,%esi
8010383b:	89 74 24 08          	mov    %esi,0x8(%esp)
8010383f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103843:	8b 43 04             	mov    0x4(%ebx),%eax
80103846:	89 04 24             	mov    %eax,(%esp)
80103849:	e8 e2 31 00 00       	call   80106a30 <allocuvm>
8010384e:	85 c0                	test   %eax,%eax
80103850:	74 36                	je     80103888 <growproc+0x68>
  curproc->sz = sz;
80103852:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103854:	89 1c 24             	mov    %ebx,(%esp)
80103857:	e8 84 2f 00 00       	call   801067e0 <switchuvm>
  return 0;
8010385c:	31 c0                	xor    %eax,%eax
}
8010385e:	83 c4 10             	add    $0x10,%esp
80103861:	5b                   	pop    %ebx
80103862:	5e                   	pop    %esi
80103863:	5d                   	pop    %ebp
80103864:	c3                   	ret    
80103865:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(n < 0){
80103868:	74 e8                	je     80103852 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010386a:	01 c6                	add    %eax,%esi
8010386c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103870:	89 44 24 04          	mov    %eax,0x4(%esp)
80103874:	8b 43 04             	mov    0x4(%ebx),%eax
80103877:	89 04 24             	mov    %eax,(%esp)
8010387a:	e8 a1 32 00 00       	call   80106b20 <deallocuvm>
8010387f:	85 c0                	test   %eax,%eax
80103881:	75 cf                	jne    80103852 <growproc+0x32>
80103883:	90                   	nop
80103884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80103888:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010388d:	eb cf                	jmp    8010385e <growproc+0x3e>
8010388f:	90                   	nop

80103890 <fork>:
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	57                   	push   %edi
80103894:	56                   	push   %esi
80103895:	53                   	push   %ebx
80103896:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103899:	e8 42 fe ff ff       	call   801036e0 <myproc>
8010389e:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
801038a0:	e8 3b fc ff ff       	call   801034e0 <allocproc>
801038a5:	85 c0                	test   %eax,%eax
801038a7:	89 c7                	mov    %eax,%edi
801038a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038ac:	0f 84 bc 00 00 00    	je     8010396e <fork+0xde>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801038b2:	8b 03                	mov    (%ebx),%eax
801038b4:	89 44 24 04          	mov    %eax,0x4(%esp)
801038b8:	8b 43 04             	mov    0x4(%ebx),%eax
801038bb:	89 04 24             	mov    %eax,(%esp)
801038be:	e8 dd 33 00 00       	call   80106ca0 <copyuvm>
801038c3:	85 c0                	test   %eax,%eax
801038c5:	89 47 04             	mov    %eax,0x4(%edi)
801038c8:	0f 84 a7 00 00 00    	je     80103975 <fork+0xe5>
  np->sz = curproc->sz;
801038ce:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
801038d0:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
801038d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038d8:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
801038da:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
801038dd:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
801038e0:	8b 73 18             	mov    0x18(%ebx),%esi
801038e3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801038e5:	31 f6                	xor    %esi,%esi
  np->prior_val = curproc->prior_val;
801038e7:	8b 43 7c             	mov    0x7c(%ebx),%eax
801038ea:	89 42 7c             	mov    %eax,0x7c(%edx)
  np->tf->eax = 0;
801038ed:	8b 42 18             	mov    0x18(%edx),%eax
801038f0:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801038f7:	90                   	nop
    if(curproc->ofile[i])
801038f8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801038fc:	85 c0                	test   %eax,%eax
801038fe:	74 0f                	je     8010390f <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103900:	89 04 24             	mov    %eax,(%esp)
80103903:	e8 f8 d4 ff ff       	call   80100e00 <filedup>
80103908:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010390b:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010390f:	83 c6 01             	add    $0x1,%esi
80103912:	83 fe 10             	cmp    $0x10,%esi
80103915:	75 e1                	jne    801038f8 <fork+0x68>
  np->cwd = idup(curproc->cwd);
80103917:	8b 43 68             	mov    0x68(%ebx),%eax
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010391a:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010391d:	89 04 24             	mov    %eax,(%esp)
80103920:	e8 7b dd ff ff       	call   801016a0 <idup>
80103925:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103928:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010392b:	8d 47 6c             	lea    0x6c(%edi),%eax
8010392e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103932:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103939:	00 
8010393a:	89 04 24             	mov    %eax,(%esp)
8010393d:	e8 6e 0d 00 00       	call   801046b0 <safestrcpy>
  pid = np->pid;
80103942:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103945:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010394c:	e8 bf 0a 00 00       	call   80104410 <acquire>
  np->state = RUNNABLE;
80103951:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103958:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010395f:	e8 1c 0b 00 00       	call   80104480 <release>
  return pid;
80103964:	89 d8                	mov    %ebx,%eax
}
80103966:	83 c4 1c             	add    $0x1c,%esp
80103969:	5b                   	pop    %ebx
8010396a:	5e                   	pop    %esi
8010396b:	5f                   	pop    %edi
8010396c:	5d                   	pop    %ebp
8010396d:	c3                   	ret    
    return -1;
8010396e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103973:	eb f1                	jmp    80103966 <fork+0xd6>
    kfree(np->kstack);
80103975:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103978:	8b 47 08             	mov    0x8(%edi),%eax
8010397b:	89 04 24             	mov    %eax,(%esp)
8010397e:	e8 8d e9 ff ff       	call   80102310 <kfree>
    return -1;
80103983:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    np->kstack = 0;
80103988:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
8010398f:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103996:	eb ce                	jmp    80103966 <fork+0xd6>
80103998:	90                   	nop
80103999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039a0 <scheduler>:
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	57                   	push   %edi
          p->prior_val = (p->prior_val > 0) ? p->prior_val - 1 : 0;
801039a4:	31 ff                	xor    %edi,%edi
{
801039a6:	56                   	push   %esi
801039a7:	53                   	push   %ebx
801039a8:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
801039ab:	e8 90 fc ff ff       	call   80103640 <mycpu>
  c->proc = 0;
801039b0:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801039b7:	00 00 00 
  struct cpu *c = mycpu();
801039ba:	89 c6                	mov    %eax,%esi
801039bc:	8d 40 04             	lea    0x4(%eax),%eax
801039bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801039c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  asm volatile("sti");
801039c8:	fb                   	sti    
      temp = ptable.proc;
801039c9:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
801039ce:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039d5:	e8 36 0a 00 00       	call   80104410 <acquire>
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801039da:	89 d8                	mov    %ebx,%eax
801039dc:	eb 0e                	jmp    801039ec <scheduler+0x4c>
801039de:	66 90                	xchg   %ax,%ax
801039e0:	05 90 00 00 00       	add    $0x90,%eax
801039e5:	3d 54 51 11 80       	cmp    $0x80115154,%eax
801039ea:	74 54                	je     80103a40 <scheduler+0xa0>
          if (p->state != RUNNABLE) {
801039ec:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801039f0:	75 ee                	jne    801039e0 <scheduler+0x40>
          if(temp->selected_To_Run == p->selected_To_Run){
801039f2:	8b 88 8c 00 00 00    	mov    0x8c(%eax),%ecx
801039f8:	39 8b 8c 00 00 00    	cmp    %ecx,0x8c(%ebx)
801039fe:	74 23                	je     80103a23 <scheduler+0x83>
          if (temp->prior_val > p->prior_val){
80103a00:	8b 4b 7c             	mov    0x7c(%ebx),%ecx
80103a03:	8b 50 7c             	mov    0x7c(%eax),%edx
80103a06:	39 d1                	cmp    %edx,%ecx
80103a08:	0f 8e a2 00 00 00    	jle    80103ab0 <scheduler+0x110>
              temp->prior_val = (temp->prior_val > 0) ? temp->prior_val - 1 : 0;
80103a0e:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103a11:	85 c9                	test   %ecx,%ecx
80103a13:	0f 4e d7             	cmovle %edi,%edx
80103a16:	89 53 7c             	mov    %edx,0x7c(%ebx)
              temp->selected_To_Run = 0;
80103a19:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103a20:	00 00 00 
              temp->selected_To_Run = 1;
80103a23:	c7 80 8c 00 00 00 01 	movl   $0x1,0x8c(%eax)
80103a2a:	00 00 00 
              continue;
80103a2d:	89 c3                	mov    %eax,%ebx
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103a2f:	05 90 00 00 00       	add    $0x90,%eax
80103a34:	3d 54 51 11 80       	cmp    $0x80115154,%eax
80103a39:	75 b1                	jne    801039ec <scheduler+0x4c>
80103a3b:	90                   	nop
80103a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          c->proc = temp;
80103a40:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
          switchuvm(temp);
80103a46:	89 1c 24             	mov    %ebx,(%esp)
80103a49:	e8 92 2d 00 00       	call   801067e0 <switchuvm>
          temp->prior_val = (temp->prior_val < 31) ? temp->prior_val + 1 : 31; // Decreases the priority of currently running process
80103a4e:	8b 43 7c             	mov    0x7c(%ebx),%eax
          temp->state = RUNNING;
80103a51:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
          temp->selected_To_Run = 0; // sets flag back to 0 for next loop for priority check
80103a58:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103a5f:	00 00 00 
          temp->prior_val = (temp->prior_val < 31) ? temp->prior_val + 1 : 31; // Decreases the priority of currently running process
80103a62:	83 f8 1e             	cmp    $0x1e,%eax
80103a65:	8d 50 01             	lea    0x1(%eax),%edx
80103a68:	b8 1f 00 00 00       	mov    $0x1f,%eax
80103a6d:	0f 4e c2             	cmovle %edx,%eax
80103a70:	89 43 7c             	mov    %eax,0x7c(%ebx)
          swtch(&(c->scheduler), temp->context);
80103a73:	8b 43 1c             	mov    0x1c(%ebx),%eax
          temp->burstCount++; // Increments the burst count for each time a process is scheduled
80103a76:	83 83 88 00 00 00 01 	addl   $0x1,0x88(%ebx)
          swtch(&(c->scheduler), temp->context);
80103a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103a84:	89 04 24             	mov    %eax,(%esp)
80103a87:	e8 7f 0c 00 00       	call   8010470b <swtch>
          switchkvm();
80103a8c:	e8 2f 2d 00 00       	call   801067c0 <switchkvm>
          c->proc = 0;
80103a91:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103a98:	00 00 00 
    release(&ptable.lock);
80103a9b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103aa2:	e8 d9 09 00 00       	call   80104480 <release>
  }
80103aa7:	e9 1c ff ff ff       	jmp    801039c8 <scheduler+0x28>
80103aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          p->prior_val = (p->prior_val > 0) ? p->prior_val - 1 : 0;
80103ab0:	8d 4a ff             	lea    -0x1(%edx),%ecx
80103ab3:	85 d2                	test   %edx,%edx
80103ab5:	89 ca                	mov    %ecx,%edx
80103ab7:	0f 4e d7             	cmovle %edi,%edx
80103aba:	89 50 7c             	mov    %edx,0x7c(%eax)
80103abd:	e9 1e ff ff ff       	jmp    801039e0 <scheduler+0x40>
80103ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ad0 <sched>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	56                   	push   %esi
80103ad4:	53                   	push   %ebx
80103ad5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = myproc();
80103ad8:	e8 03 fc ff ff       	call   801036e0 <myproc>
  if(!holding(&ptable.lock))
80103add:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *p = myproc();
80103ae4:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103ae6:	e8 e5 08 00 00       	call   801043d0 <holding>
80103aeb:	85 c0                	test   %eax,%eax
80103aed:	74 4f                	je     80103b3e <sched+0x6e>
  if(mycpu()->ncli != 1)
80103aef:	e8 4c fb ff ff       	call   80103640 <mycpu>
80103af4:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103afb:	75 65                	jne    80103b62 <sched+0x92>
  if(p->state == RUNNING)
80103afd:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103b01:	74 53                	je     80103b56 <sched+0x86>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b03:	9c                   	pushf  
80103b04:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b05:	f6 c4 02             	test   $0x2,%ah
80103b08:	75 40                	jne    80103b4a <sched+0x7a>
  intena = mycpu()->intena;
80103b0a:	e8 31 fb ff ff       	call   80103640 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103b0f:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103b12:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103b18:	e8 23 fb ff ff       	call   80103640 <mycpu>
80103b1d:	8b 40 04             	mov    0x4(%eax),%eax
80103b20:	89 1c 24             	mov    %ebx,(%esp)
80103b23:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b27:	e8 df 0b 00 00       	call   8010470b <swtch>
  mycpu()->intena = intena;
80103b2c:	e8 0f fb ff ff       	call   80103640 <mycpu>
80103b31:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b37:	83 c4 10             	add    $0x10,%esp
80103b3a:	5b                   	pop    %ebx
80103b3b:	5e                   	pop    %esi
80103b3c:	5d                   	pop    %ebp
80103b3d:	c3                   	ret    
    panic("sched ptable.lock");
80103b3e:	c7 04 24 f0 73 10 80 	movl   $0x801073f0,(%esp)
80103b45:	e8 16 c8 ff ff       	call   80100360 <panic>
    panic("sched interruptible");
80103b4a:	c7 04 24 1c 74 10 80 	movl   $0x8010741c,(%esp)
80103b51:	e8 0a c8 ff ff       	call   80100360 <panic>
    panic("sched running");
80103b56:	c7 04 24 0e 74 10 80 	movl   $0x8010740e,(%esp)
80103b5d:	e8 fe c7 ff ff       	call   80100360 <panic>
    panic("sched locks");
80103b62:	c7 04 24 02 74 10 80 	movl   $0x80107402,(%esp)
80103b69:	e8 f2 c7 ff ff       	call   80100360 <panic>
80103b6e:	66 90                	xchg   %ax,%ax

80103b70 <exit>:
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	56                   	push   %esi
80103b74:	53                   	push   %ebx
80103b75:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103b78:	e8 63 fb ff ff       	call   801036e0 <myproc>
  if(curproc == initproc)
80103b7d:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
  struct proc *curproc = myproc();
80103b83:	89 c3                	mov    %eax,%ebx
  if(curproc == initproc)
80103b85:	0f 84 8f 01 00 00    	je     80103d1a <exit+0x1aa>
  acquire(&tickslock);
80103b8b:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
  for(fd = 0; fd < NOFILE; fd++){
80103b92:	31 f6                	xor    %esi,%esi
  acquire(&tickslock);
80103b94:	e8 77 08 00 00       	call   80104410 <acquire>
  curproc->T_finish = ticks;
80103b99:	a1 a0 59 11 80       	mov    0x801159a0,%eax
80103b9e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  release(&tickslock);
80103ba4:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
80103bab:	e8 d0 08 00 00       	call   80104480 <release>
  cprintf("Turnaround time for PID: %d is %d\n",curproc->pid, (curproc->T_finish - curproc->T_start));
80103bb0:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80103bb6:	2b 83 80 00 00 00    	sub    0x80(%ebx),%eax
80103bbc:	89 44 24 08          	mov    %eax,0x8(%esp)
80103bc0:	8b 43 10             	mov    0x10(%ebx),%eax
80103bc3:	c7 04 24 c0 74 10 80 	movl   $0x801074c0,(%esp)
80103bca:	89 44 24 04          	mov    %eax,0x4(%esp)
80103bce:	e8 7d ca ff ff       	call   80100650 <cprintf>
  cprintf("Burst time time for PID: %d is %d\n",curproc->pid, curproc->burstCount);
80103bd3:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80103bd9:	89 44 24 08          	mov    %eax,0x8(%esp)
80103bdd:	8b 43 10             	mov    0x10(%ebx),%eax
80103be0:	c7 04 24 e4 74 10 80 	movl   $0x801074e4,(%esp)
80103be7:	89 44 24 04          	mov    %eax,0x4(%esp)
80103beb:	e8 60 ca ff ff       	call   80100650 <cprintf>
  cprintf("Waiting time for PID: %d is %d\n",curproc->pid, ((curproc->T_finish - curproc->T_start) - curproc->burstCount));
80103bf0:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80103bf6:	2b 83 80 00 00 00    	sub    0x80(%ebx),%eax
80103bfc:	2b 83 88 00 00 00    	sub    0x88(%ebx),%eax
80103c02:	89 44 24 08          	mov    %eax,0x8(%esp)
80103c06:	8b 43 10             	mov    0x10(%ebx),%eax
80103c09:	c7 04 24 08 75 10 80 	movl   $0x80107508,(%esp)
80103c10:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c14:	e8 37 ca ff ff       	call   80100650 <cprintf>
80103c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103c20:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c24:	85 c0                	test   %eax,%eax
80103c26:	74 10                	je     80103c38 <exit+0xc8>
      fileclose(curproc->ofile[fd]);
80103c28:	89 04 24             	mov    %eax,(%esp)
80103c2b:	e8 20 d2 ff ff       	call   80100e50 <fileclose>
      curproc->ofile[fd] = 0;
80103c30:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103c37:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103c38:	83 c6 01             	add    $0x1,%esi
80103c3b:	83 fe 10             	cmp    $0x10,%esi
80103c3e:	75 e0                	jne    80103c20 <exit+0xb0>
  begin_op();
80103c40:	e8 eb ee ff ff       	call   80102b30 <begin_op>
  iput(curproc->cwd);
80103c45:	8b 43 68             	mov    0x68(%ebx),%eax
80103c48:	89 04 24             	mov    %eax,(%esp)
80103c4b:	e8 a0 db ff ff       	call   801017f0 <iput>
  end_op();
80103c50:	e8 4b ef ff ff       	call   80102ba0 <end_op>
  curproc->cwd = 0;
80103c55:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103c5c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c63:	e8 a8 07 00 00       	call   80104410 <acquire>
  wakeup1(curproc->parent);
80103c68:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c6b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103c70:	eb 14                	jmp    80103c86 <exit+0x116>
80103c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c78:	81 c2 90 00 00 00    	add    $0x90,%edx
80103c7e:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
80103c84:	74 20                	je     80103ca6 <exit+0x136>
    if(p->state == SLEEPING && p->chan == chan)
80103c86:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103c8a:	75 ec                	jne    80103c78 <exit+0x108>
80103c8c:	3b 42 20             	cmp    0x20(%edx),%eax
80103c8f:	75 e7                	jne    80103c78 <exit+0x108>
      p->state = RUNNABLE;
80103c91:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c98:	81 c2 90 00 00 00    	add    $0x90,%edx
80103c9e:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
80103ca4:	75 e0                	jne    80103c86 <exit+0x116>
      p->parent = initproc;
80103ca6:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103cab:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103cb0:	eb 14                	jmp    80103cc6 <exit+0x156>
80103cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cb8:	81 c1 90 00 00 00    	add    $0x90,%ecx
80103cbe:	81 f9 54 51 11 80    	cmp    $0x80115154,%ecx
80103cc4:	74 3c                	je     80103d02 <exit+0x192>
    if(p->parent == curproc){
80103cc6:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103cc9:	75 ed                	jne    80103cb8 <exit+0x148>
      if(p->state == ZOMBIE)
80103ccb:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
      p->parent = initproc;
80103ccf:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103cd2:	75 e4                	jne    80103cb8 <exit+0x148>
80103cd4:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103cd9:	eb 13                	jmp    80103cee <exit+0x17e>
80103cdb:	90                   	nop
80103cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ce0:	81 c2 90 00 00 00    	add    $0x90,%edx
80103ce6:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
80103cec:	74 ca                	je     80103cb8 <exit+0x148>
    if(p->state == SLEEPING && p->chan == chan)
80103cee:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103cf2:	75 ec                	jne    80103ce0 <exit+0x170>
80103cf4:	3b 42 20             	cmp    0x20(%edx),%eax
80103cf7:	75 e7                	jne    80103ce0 <exit+0x170>
      p->state = RUNNABLE;
80103cf9:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103d00:	eb de                	jmp    80103ce0 <exit+0x170>
  curproc->state = ZOMBIE;
80103d02:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103d09:	e8 c2 fd ff ff       	call   80103ad0 <sched>
  panic("zombie exit");
80103d0e:	c7 04 24 3d 74 10 80 	movl   $0x8010743d,(%esp)
80103d15:	e8 46 c6 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103d1a:	c7 04 24 30 74 10 80 	movl   $0x80107430,(%esp)
80103d21:	e8 3a c6 ff ff       	call   80100360 <panic>
80103d26:	8d 76 00             	lea    0x0(%esi),%esi
80103d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d30 <yield>:
{
80103d30:	55                   	push   %ebp
80103d31:	89 e5                	mov    %esp,%ebp
80103d33:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103d36:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d3d:	e8 ce 06 00 00       	call   80104410 <acquire>
  myproc()->state = RUNNABLE;
80103d42:	e8 99 f9 ff ff       	call   801036e0 <myproc>
80103d47:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103d4e:	e8 7d fd ff ff       	call   80103ad0 <sched>
  release(&ptable.lock);
80103d53:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d5a:	e8 21 07 00 00       	call   80104480 <release>
}
80103d5f:	c9                   	leave  
80103d60:	c3                   	ret    
80103d61:	eb 0d                	jmp    80103d70 <sleep>
80103d63:	90                   	nop
80103d64:	90                   	nop
80103d65:	90                   	nop
80103d66:	90                   	nop
80103d67:	90                   	nop
80103d68:	90                   	nop
80103d69:	90                   	nop
80103d6a:	90                   	nop
80103d6b:	90                   	nop
80103d6c:	90                   	nop
80103d6d:	90                   	nop
80103d6e:	90                   	nop
80103d6f:	90                   	nop

80103d70 <sleep>:
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	57                   	push   %edi
80103d74:	56                   	push   %esi
80103d75:	53                   	push   %ebx
80103d76:	83 ec 1c             	sub    $0x1c,%esp
80103d79:	8b 7d 08             	mov    0x8(%ebp),%edi
80103d7c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103d7f:	e8 5c f9 ff ff       	call   801036e0 <myproc>
  if(p == 0)
80103d84:	85 c0                	test   %eax,%eax
  struct proc *p = myproc();
80103d86:	89 c3                	mov    %eax,%ebx
  if(p == 0)
80103d88:	0f 84 7c 00 00 00    	je     80103e0a <sleep+0x9a>
  if(lk == 0)
80103d8e:	85 f6                	test   %esi,%esi
80103d90:	74 6c                	je     80103dfe <sleep+0x8e>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d92:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103d98:	74 46                	je     80103de0 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d9a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103da1:	e8 6a 06 00 00       	call   80104410 <acquire>
    release(lk);
80103da6:	89 34 24             	mov    %esi,(%esp)
80103da9:	e8 d2 06 00 00       	call   80104480 <release>
  p->chan = chan;
80103dae:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103db1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103db8:	e8 13 fd ff ff       	call   80103ad0 <sched>
  p->chan = 0;
80103dbd:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103dc4:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103dcb:	e8 b0 06 00 00       	call   80104480 <release>
    acquire(lk);
80103dd0:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103dd3:	83 c4 1c             	add    $0x1c,%esp
80103dd6:	5b                   	pop    %ebx
80103dd7:	5e                   	pop    %esi
80103dd8:	5f                   	pop    %edi
80103dd9:	5d                   	pop    %ebp
    acquire(lk);
80103dda:	e9 31 06 00 00       	jmp    80104410 <acquire>
80103ddf:	90                   	nop
  p->chan = chan;
80103de0:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103de3:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103dea:	e8 e1 fc ff ff       	call   80103ad0 <sched>
  p->chan = 0;
80103def:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103df6:	83 c4 1c             	add    $0x1c,%esp
80103df9:	5b                   	pop    %ebx
80103dfa:	5e                   	pop    %esi
80103dfb:	5f                   	pop    %edi
80103dfc:	5d                   	pop    %ebp
80103dfd:	c3                   	ret    
    panic("sleep without lk");
80103dfe:	c7 04 24 4f 74 10 80 	movl   $0x8010744f,(%esp)
80103e05:	e8 56 c5 ff ff       	call   80100360 <panic>
    panic("sleep");
80103e0a:	c7 04 24 49 74 10 80 	movl   $0x80107449,(%esp)
80103e11:	e8 4a c5 ff ff       	call   80100360 <panic>
80103e16:	8d 76 00             	lea    0x0(%esi),%esi
80103e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e20 <wait>:
{
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	56                   	push   %esi
80103e24:	53                   	push   %ebx
80103e25:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103e28:	e8 b3 f8 ff ff       	call   801036e0 <myproc>
  acquire(&ptable.lock);
80103e2d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *curproc = myproc();
80103e34:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103e36:	e8 d5 05 00 00       	call   80104410 <acquire>
    havekids = 0;
80103e3b:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e3d:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103e42:	eb 12                	jmp    80103e56 <wait+0x36>
80103e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e48:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103e4e:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
80103e54:	74 22                	je     80103e78 <wait+0x58>
      if(p->parent != curproc)
80103e56:	39 73 14             	cmp    %esi,0x14(%ebx)
80103e59:	75 ed                	jne    80103e48 <wait+0x28>
      if(p->state == ZOMBIE){
80103e5b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103e5f:	74 34                	je     80103e95 <wait+0x75>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e61:	81 c3 90 00 00 00    	add    $0x90,%ebx
      havekids = 1;
80103e67:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e6c:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
80103e72:	75 e2                	jne    80103e56 <wait+0x36>
80103e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(!havekids || curproc->killed){
80103e78:	85 c0                	test   %eax,%eax
80103e7a:	74 6e                	je     80103eea <wait+0xca>
80103e7c:	8b 46 24             	mov    0x24(%esi),%eax
80103e7f:	85 c0                	test   %eax,%eax
80103e81:	75 67                	jne    80103eea <wait+0xca>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103e83:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103e8a:	80 
80103e8b:	89 34 24             	mov    %esi,(%esp)
80103e8e:	e8 dd fe ff ff       	call   80103d70 <sleep>
  }
80103e93:	eb a6                	jmp    80103e3b <wait+0x1b>
        kfree(p->kstack);
80103e95:	8b 43 08             	mov    0x8(%ebx),%eax
        pid = p->pid;
80103e98:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103e9b:	89 04 24             	mov    %eax,(%esp)
80103e9e:	e8 6d e4 ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
80103ea3:	8b 43 04             	mov    0x4(%ebx),%eax
        p->kstack = 0;
80103ea6:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103ead:	89 04 24             	mov    %eax,(%esp)
80103eb0:	e8 8b 2c 00 00       	call   80106b40 <freevm>
        release(&ptable.lock);
80103eb5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103ebc:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103ec3:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103eca:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103ece:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103ed5:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103edc:	e8 9f 05 00 00       	call   80104480 <release>
}
80103ee1:	83 c4 10             	add    $0x10,%esp
        return pid;
80103ee4:	89 f0                	mov    %esi,%eax
}
80103ee6:	5b                   	pop    %ebx
80103ee7:	5e                   	pop    %esi
80103ee8:	5d                   	pop    %ebp
80103ee9:	c3                   	ret    
      release(&ptable.lock);
80103eea:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ef1:	e8 8a 05 00 00       	call   80104480 <release>
}
80103ef6:	83 c4 10             	add    $0x10,%esp
      return -1;
80103ef9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103efe:	5b                   	pop    %ebx
80103eff:	5e                   	pop    %esi
80103f00:	5d                   	pop    %ebp
80103f01:	c3                   	ret    
80103f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f10 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	53                   	push   %ebx
80103f14:	83 ec 14             	sub    $0x14,%esp
80103f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103f1a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f21:	e8 ea 04 00 00       	call   80104410 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f26:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f2b:	eb 0f                	jmp    80103f3c <wakeup+0x2c>
80103f2d:	8d 76 00             	lea    0x0(%esi),%esi
80103f30:	05 90 00 00 00       	add    $0x90,%eax
80103f35:	3d 54 51 11 80       	cmp    $0x80115154,%eax
80103f3a:	74 24                	je     80103f60 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
80103f3c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f40:	75 ee                	jne    80103f30 <wakeup+0x20>
80103f42:	3b 58 20             	cmp    0x20(%eax),%ebx
80103f45:	75 e9                	jne    80103f30 <wakeup+0x20>
      p->state = RUNNABLE;
80103f47:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f4e:	05 90 00 00 00       	add    $0x90,%eax
80103f53:	3d 54 51 11 80       	cmp    $0x80115154,%eax
80103f58:	75 e2                	jne    80103f3c <wakeup+0x2c>
80103f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  wakeup1(chan);
  release(&ptable.lock);
80103f60:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103f67:	83 c4 14             	add    $0x14,%esp
80103f6a:	5b                   	pop    %ebx
80103f6b:	5d                   	pop    %ebp
  release(&ptable.lock);
80103f6c:	e9 0f 05 00 00       	jmp    80104480 <release>
80103f71:	eb 0d                	jmp    80103f80 <kill>
80103f73:	90                   	nop
80103f74:	90                   	nop
80103f75:	90                   	nop
80103f76:	90                   	nop
80103f77:	90                   	nop
80103f78:	90                   	nop
80103f79:	90                   	nop
80103f7a:	90                   	nop
80103f7b:	90                   	nop
80103f7c:	90                   	nop
80103f7d:	90                   	nop
80103f7e:	90                   	nop
80103f7f:	90                   	nop

80103f80 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	53                   	push   %ebx
80103f84:	83 ec 14             	sub    $0x14,%esp
80103f87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103f8a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f91:	e8 7a 04 00 00       	call   80104410 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f96:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f9b:	eb 0f                	jmp    80103fac <kill+0x2c>
80103f9d:	8d 76 00             	lea    0x0(%esi),%esi
80103fa0:	05 90 00 00 00       	add    $0x90,%eax
80103fa5:	3d 54 51 11 80       	cmp    $0x80115154,%eax
80103faa:	74 3c                	je     80103fe8 <kill+0x68>
    if(p->pid == pid){
80103fac:	39 58 10             	cmp    %ebx,0x10(%eax)
80103faf:	75 ef                	jne    80103fa0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103fb1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103fb5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103fbc:	74 1a                	je     80103fd8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103fbe:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fc5:	e8 b6 04 00 00       	call   80104480 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103fca:	83 c4 14             	add    $0x14,%esp
      return 0;
80103fcd:	31 c0                	xor    %eax,%eax
}
80103fcf:	5b                   	pop    %ebx
80103fd0:	5d                   	pop    %ebp
80103fd1:	c3                   	ret    
80103fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        p->state = RUNNABLE;
80103fd8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fdf:	eb dd                	jmp    80103fbe <kill+0x3e>
80103fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103fe8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fef:	e8 8c 04 00 00       	call   80104480 <release>
}
80103ff4:	83 c4 14             	add    $0x14,%esp
  return -1;
80103ff7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103ffc:	5b                   	pop    %ebx
80103ffd:	5d                   	pop    %ebp
80103ffe:	c3                   	ret    
80103fff:	90                   	nop

80104000 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	57                   	push   %edi
80104004:	56                   	push   %esi
80104005:	53                   	push   %ebx
80104006:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010400b:	83 ec 4c             	sub    $0x4c,%esp
8010400e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104011:	eb 23                	jmp    80104036 <procdump+0x36>
80104013:	90                   	nop
80104014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104018:	c7 04 24 3f 78 10 80 	movl   $0x8010783f,(%esp)
8010401f:	e8 2c c6 ff ff       	call   80100650 <cprintf>
80104024:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010402a:	81 fb c0 51 11 80    	cmp    $0x801151c0,%ebx
80104030:	0f 84 8a 00 00 00    	je     801040c0 <procdump+0xc0>
    if(p->state == UNUSED)
80104036:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104039:	85 c0                	test   %eax,%eax
8010403b:	74 e7                	je     80104024 <procdump+0x24>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010403d:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104040:	ba 60 74 10 80       	mov    $0x80107460,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104045:	77 11                	ja     80104058 <procdump+0x58>
80104047:	8b 14 85 28 75 10 80 	mov    -0x7fef8ad8(,%eax,4),%edx
      state = "???";
8010404e:	b8 60 74 10 80       	mov    $0x80107460,%eax
80104053:	85 d2                	test   %edx,%edx
80104055:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104058:	8b 43 a4             	mov    -0x5c(%ebx),%eax
8010405b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010405f:	89 54 24 08          	mov    %edx,0x8(%esp)
80104063:	c7 04 24 64 74 10 80 	movl   $0x80107464,(%esp)
8010406a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010406e:	e8 dd c5 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80104073:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104077:	75 9f                	jne    80104018 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104079:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010407c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104080:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104083:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104086:	8b 40 0c             	mov    0xc(%eax),%eax
80104089:	83 c0 08             	add    $0x8,%eax
8010408c:	89 04 24             	mov    %eax,(%esp)
8010408f:	e8 2c 02 00 00       	call   801042c0 <getcallerpcs>
80104094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104098:	8b 17                	mov    (%edi),%edx
8010409a:	85 d2                	test   %edx,%edx
8010409c:	0f 84 76 ff ff ff    	je     80104018 <procdump+0x18>
        cprintf(" %p", pc[i]);
801040a2:	89 54 24 04          	mov    %edx,0x4(%esp)
801040a6:	83 c7 04             	add    $0x4,%edi
801040a9:	c7 04 24 a1 6e 10 80 	movl   $0x80106ea1,(%esp)
801040b0:	e8 9b c5 ff ff       	call   80100650 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801040b5:	39 f7                	cmp    %esi,%edi
801040b7:	75 df                	jne    80104098 <procdump+0x98>
801040b9:	e9 5a ff ff ff       	jmp    80104018 <procdump+0x18>
801040be:	66 90                	xchg   %ax,%ax
  }
}
801040c0:	83 c4 4c             	add    $0x4c,%esp
801040c3:	5b                   	pop    %ebx
801040c4:	5e                   	pop    %esi
801040c5:	5f                   	pop    %edi
801040c6:	5d                   	pop    %ebp
801040c7:	c3                   	ret    
801040c8:	90                   	nop
801040c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040d0 <set_prior>:

// sets priority for current process
void
set_prior(int priority) {
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	56                   	push   %esi
801040d4:	53                   	push   %ebx
801040d5:	83 ec 10             	sub    $0x10,%esp
801040d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *curproc = myproc(); // gets current process
801040db:	e8 00 f6 ff ff       	call   801036e0 <myproc>
    acquire(&ptable.lock);
801040e0:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    struct proc *curproc = myproc(); // gets current process
801040e7:	89 c6                	mov    %eax,%esi
    acquire(&ptable.lock);
801040e9:	e8 22 03 00 00       	call   80104410 <acquire>
    if (priority > 31) {
801040ee:	83 fb 1f             	cmp    $0x1f,%ebx
801040f1:	7f 25                	jg     80104118 <set_prior+0x48>
        curproc->prior_val = 31; // sets priority for current process
    } else if (priority < 0) {
        curproc->prior_val = 0; // sets priority for current process
801040f3:	31 d2                	xor    %edx,%edx
801040f5:	85 db                	test   %ebx,%ebx
801040f7:	0f 49 d3             	cmovns %ebx,%edx
801040fa:	89 56 7c             	mov    %edx,0x7c(%esi)
    }else{
        curproc->prior_val = priority;
    }
    release(&ptable.lock);
801040fd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104104:	e8 77 03 00 00       	call   80104480 <release>
    yield(); // yields to scheduler
}
80104109:	83 c4 10             	add    $0x10,%esp
8010410c:	5b                   	pop    %ebx
8010410d:	5e                   	pop    %esi
8010410e:	5d                   	pop    %ebp
    yield(); // yields to scheduler
8010410f:	e9 1c fc ff ff       	jmp    80103d30 <yield>
80104114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        curproc->prior_val = 31; // sets priority for current process
80104118:	c7 46 7c 1f 00 00 00 	movl   $0x1f,0x7c(%esi)
8010411f:	eb dc                	jmp    801040fd <set_prior+0x2d>
80104121:	eb 0d                	jmp    80104130 <get_prior>
80104123:	90                   	nop
80104124:	90                   	nop
80104125:	90                   	nop
80104126:	90                   	nop
80104127:	90                   	nop
80104128:	90                   	nop
80104129:	90                   	nop
8010412a:	90                   	nop
8010412b:	90                   	nop
8010412c:	90                   	nop
8010412d:	90                   	nop
8010412e:	90                   	nop
8010412f:	90                   	nop

80104130 <get_prior>:

// gets priority from current process
int
get_prior(void)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	53                   	push   %ebx
80104134:	83 ec 14             	sub    $0x14,%esp
    int priority;
    struct proc *curproc = myproc(); // gets current process
80104137:	e8 a4 f5 ff ff       	call   801036e0 <myproc>
    acquire(&ptable.lock);
8010413c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    struct proc *curproc = myproc(); // gets current process
80104143:	89 c3                	mov    %eax,%ebx
    acquire(&ptable.lock);
80104145:	e8 c6 02 00 00       	call   80104410 <acquire>
    priority = curproc->prior_val; // sets priority for current process
8010414a:	8b 5b 7c             	mov    0x7c(%ebx),%ebx
    release(&ptable.lock);
8010414d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104154:	e8 27 03 00 00       	call   80104480 <release>
    yield(); // yields to scheduler
80104159:	e8 d2 fb ff ff       	call   80103d30 <yield>
    return priority;
8010415e:	83 c4 14             	add    $0x14,%esp
80104161:	89 d8                	mov    %ebx,%eax
80104163:	5b                   	pop    %ebx
80104164:	5d                   	pop    %ebp
80104165:	c3                   	ret    
80104166:	66 90                	xchg   %ax,%ax
80104168:	66 90                	xchg   %ax,%ax
8010416a:	66 90                	xchg   %ax,%ax
8010416c:	66 90                	xchg   %ax,%ax
8010416e:	66 90                	xchg   %ax,%ax

80104170 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	53                   	push   %ebx
80104174:	83 ec 14             	sub    $0x14,%esp
80104177:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010417a:	c7 44 24 04 40 75 10 	movl   $0x80107540,0x4(%esp)
80104181:	80 
80104182:	8d 43 04             	lea    0x4(%ebx),%eax
80104185:	89 04 24             	mov    %eax,(%esp)
80104188:	e8 13 01 00 00       	call   801042a0 <initlock>
  lk->name = name;
8010418d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104190:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104196:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010419d:	89 43 38             	mov    %eax,0x38(%ebx)
}
801041a0:	83 c4 14             	add    $0x14,%esp
801041a3:	5b                   	pop    %ebx
801041a4:	5d                   	pop    %ebp
801041a5:	c3                   	ret    
801041a6:	8d 76 00             	lea    0x0(%esi),%esi
801041a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	56                   	push   %esi
801041b4:	53                   	push   %ebx
801041b5:	83 ec 10             	sub    $0x10,%esp
801041b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801041bb:	8d 73 04             	lea    0x4(%ebx),%esi
801041be:	89 34 24             	mov    %esi,(%esp)
801041c1:	e8 4a 02 00 00       	call   80104410 <acquire>
  while (lk->locked) {
801041c6:	8b 13                	mov    (%ebx),%edx
801041c8:	85 d2                	test   %edx,%edx
801041ca:	74 16                	je     801041e2 <acquiresleep+0x32>
801041cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801041d0:	89 74 24 04          	mov    %esi,0x4(%esp)
801041d4:	89 1c 24             	mov    %ebx,(%esp)
801041d7:	e8 94 fb ff ff       	call   80103d70 <sleep>
  while (lk->locked) {
801041dc:	8b 03                	mov    (%ebx),%eax
801041de:	85 c0                	test   %eax,%eax
801041e0:	75 ee                	jne    801041d0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801041e2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801041e8:	e8 f3 f4 ff ff       	call   801036e0 <myproc>
801041ed:	8b 40 10             	mov    0x10(%eax),%eax
801041f0:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801041f3:	89 75 08             	mov    %esi,0x8(%ebp)
}
801041f6:	83 c4 10             	add    $0x10,%esp
801041f9:	5b                   	pop    %ebx
801041fa:	5e                   	pop    %esi
801041fb:	5d                   	pop    %ebp
  release(&lk->lk);
801041fc:	e9 7f 02 00 00       	jmp    80104480 <release>
80104201:	eb 0d                	jmp    80104210 <releasesleep>
80104203:	90                   	nop
80104204:	90                   	nop
80104205:	90                   	nop
80104206:	90                   	nop
80104207:	90                   	nop
80104208:	90                   	nop
80104209:	90                   	nop
8010420a:	90                   	nop
8010420b:	90                   	nop
8010420c:	90                   	nop
8010420d:	90                   	nop
8010420e:	90                   	nop
8010420f:	90                   	nop

80104210 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	56                   	push   %esi
80104214:	53                   	push   %ebx
80104215:	83 ec 10             	sub    $0x10,%esp
80104218:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010421b:	8d 73 04             	lea    0x4(%ebx),%esi
8010421e:	89 34 24             	mov    %esi,(%esp)
80104221:	e8 ea 01 00 00       	call   80104410 <acquire>
  lk->locked = 0;
80104226:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010422c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104233:	89 1c 24             	mov    %ebx,(%esp)
80104236:	e8 d5 fc ff ff       	call   80103f10 <wakeup>
  release(&lk->lk);
8010423b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010423e:	83 c4 10             	add    $0x10,%esp
80104241:	5b                   	pop    %ebx
80104242:	5e                   	pop    %esi
80104243:	5d                   	pop    %ebp
  release(&lk->lk);
80104244:	e9 37 02 00 00       	jmp    80104480 <release>
80104249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104250 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	57                   	push   %edi
  int r;
  
  acquire(&lk->lk);
  r = lk->locked && (lk->pid == myproc()->pid);
80104254:	31 ff                	xor    %edi,%edi
{
80104256:	56                   	push   %esi
80104257:	53                   	push   %ebx
80104258:	83 ec 1c             	sub    $0x1c,%esp
8010425b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010425e:	8d 73 04             	lea    0x4(%ebx),%esi
80104261:	89 34 24             	mov    %esi,(%esp)
80104264:	e8 a7 01 00 00       	call   80104410 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104269:	8b 03                	mov    (%ebx),%eax
8010426b:	85 c0                	test   %eax,%eax
8010426d:	74 13                	je     80104282 <holdingsleep+0x32>
8010426f:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104272:	e8 69 f4 ff ff       	call   801036e0 <myproc>
80104277:	3b 58 10             	cmp    0x10(%eax),%ebx
8010427a:	0f 94 c0             	sete   %al
8010427d:	0f b6 c0             	movzbl %al,%eax
80104280:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104282:	89 34 24             	mov    %esi,(%esp)
80104285:	e8 f6 01 00 00       	call   80104480 <release>
  return r;
}
8010428a:	83 c4 1c             	add    $0x1c,%esp
8010428d:	89 f8                	mov    %edi,%eax
8010428f:	5b                   	pop    %ebx
80104290:	5e                   	pop    %esi
80104291:	5f                   	pop    %edi
80104292:	5d                   	pop    %ebp
80104293:	c3                   	ret    
80104294:	66 90                	xchg   %ax,%ax
80104296:	66 90                	xchg   %ax,%ax
80104298:	66 90                	xchg   %ax,%ax
8010429a:	66 90                	xchg   %ax,%ax
8010429c:	66 90                	xchg   %ax,%ax
8010429e:	66 90                	xchg   %ax,%ax

801042a0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801042a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801042a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801042af:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801042b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801042b9:	5d                   	pop    %ebp
801042ba:	c3                   	ret    
801042bb:	90                   	nop
801042bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042c0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801042c3:	8b 45 08             	mov    0x8(%ebp),%eax
{
801042c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801042c9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801042ca:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801042cd:	31 c0                	xor    %eax,%eax
801042cf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801042d0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801042d6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801042dc:	77 1a                	ja     801042f8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801042de:	8b 5a 04             	mov    0x4(%edx),%ebx
801042e1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801042e4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801042e7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801042e9:	83 f8 0a             	cmp    $0xa,%eax
801042ec:	75 e2                	jne    801042d0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801042ee:	5b                   	pop    %ebx
801042ef:	5d                   	pop    %ebp
801042f0:	c3                   	ret    
801042f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801042f8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801042ff:	83 c0 01             	add    $0x1,%eax
80104302:	83 f8 0a             	cmp    $0xa,%eax
80104305:	74 e7                	je     801042ee <getcallerpcs+0x2e>
    pcs[i] = 0;
80104307:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
8010430e:	83 c0 01             	add    $0x1,%eax
80104311:	83 f8 0a             	cmp    $0xa,%eax
80104314:	75 e2                	jne    801042f8 <getcallerpcs+0x38>
80104316:	eb d6                	jmp    801042ee <getcallerpcs+0x2e>
80104318:	90                   	nop
80104319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104320 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	53                   	push   %ebx
80104324:	83 ec 04             	sub    $0x4,%esp
80104327:	9c                   	pushf  
80104328:	5b                   	pop    %ebx
  asm volatile("cli");
80104329:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010432a:	e8 11 f3 ff ff       	call   80103640 <mycpu>
8010432f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104335:	85 c0                	test   %eax,%eax
80104337:	75 11                	jne    8010434a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104339:	e8 02 f3 ff ff       	call   80103640 <mycpu>
8010433e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104344:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010434a:	e8 f1 f2 ff ff       	call   80103640 <mycpu>
8010434f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104356:	83 c4 04             	add    $0x4,%esp
80104359:	5b                   	pop    %ebx
8010435a:	5d                   	pop    %ebp
8010435b:	c3                   	ret    
8010435c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104360 <popcli>:

void
popcli(void)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104366:	9c                   	pushf  
80104367:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104368:	f6 c4 02             	test   $0x2,%ah
8010436b:	75 49                	jne    801043b6 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010436d:	e8 ce f2 ff ff       	call   80103640 <mycpu>
80104372:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104378:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010437b:	85 d2                	test   %edx,%edx
8010437d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104383:	78 25                	js     801043aa <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104385:	e8 b6 f2 ff ff       	call   80103640 <mycpu>
8010438a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104390:	85 d2                	test   %edx,%edx
80104392:	74 04                	je     80104398 <popcli+0x38>
    sti();
}
80104394:	c9                   	leave  
80104395:	c3                   	ret    
80104396:	66 90                	xchg   %ax,%ax
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104398:	e8 a3 f2 ff ff       	call   80103640 <mycpu>
8010439d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801043a3:	85 c0                	test   %eax,%eax
801043a5:	74 ed                	je     80104394 <popcli+0x34>
  asm volatile("sti");
801043a7:	fb                   	sti    
}
801043a8:	c9                   	leave  
801043a9:	c3                   	ret    
    panic("popcli");
801043aa:	c7 04 24 62 75 10 80 	movl   $0x80107562,(%esp)
801043b1:	e8 aa bf ff ff       	call   80100360 <panic>
    panic("popcli - interruptible");
801043b6:	c7 04 24 4b 75 10 80 	movl   $0x8010754b,(%esp)
801043bd:	e8 9e bf ff ff       	call   80100360 <panic>
801043c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043d0 <holding>:
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	56                   	push   %esi
  r = lock->locked && lock->cpu == mycpu();
801043d4:	31 f6                	xor    %esi,%esi
{
801043d6:	53                   	push   %ebx
801043d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801043da:	e8 41 ff ff ff       	call   80104320 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801043df:	8b 03                	mov    (%ebx),%eax
801043e1:	85 c0                	test   %eax,%eax
801043e3:	74 12                	je     801043f7 <holding+0x27>
801043e5:	8b 5b 08             	mov    0x8(%ebx),%ebx
801043e8:	e8 53 f2 ff ff       	call   80103640 <mycpu>
801043ed:	39 c3                	cmp    %eax,%ebx
801043ef:	0f 94 c0             	sete   %al
801043f2:	0f b6 c0             	movzbl %al,%eax
801043f5:	89 c6                	mov    %eax,%esi
  popcli();
801043f7:	e8 64 ff ff ff       	call   80104360 <popcli>
}
801043fc:	89 f0                	mov    %esi,%eax
801043fe:	5b                   	pop    %ebx
801043ff:	5e                   	pop    %esi
80104400:	5d                   	pop    %ebp
80104401:	c3                   	ret    
80104402:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104410 <acquire>:
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	53                   	push   %ebx
80104414:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104417:	e8 04 ff ff ff       	call   80104320 <pushcli>
  if(holding(lk))
8010441c:	8b 45 08             	mov    0x8(%ebp),%eax
8010441f:	89 04 24             	mov    %eax,(%esp)
80104422:	e8 a9 ff ff ff       	call   801043d0 <holding>
80104427:	85 c0                	test   %eax,%eax
80104429:	75 3a                	jne    80104465 <acquire+0x55>
  asm volatile("lock; xchgl %0, %1" :
8010442b:	b9 01 00 00 00       	mov    $0x1,%ecx
  while(xchg(&lk->locked, 1) != 0)
80104430:	8b 55 08             	mov    0x8(%ebp),%edx
80104433:	89 c8                	mov    %ecx,%eax
80104435:	f0 87 02             	lock xchg %eax,(%edx)
80104438:	85 c0                	test   %eax,%eax
8010443a:	75 f4                	jne    80104430 <acquire+0x20>
  __sync_synchronize();
8010443c:	0f ae f0             	mfence 
  lk->cpu = mycpu();
8010443f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104442:	e8 f9 f1 ff ff       	call   80103640 <mycpu>
80104447:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010444a:	8b 45 08             	mov    0x8(%ebp),%eax
8010444d:	83 c0 0c             	add    $0xc,%eax
80104450:	89 44 24 04          	mov    %eax,0x4(%esp)
80104454:	8d 45 08             	lea    0x8(%ebp),%eax
80104457:	89 04 24             	mov    %eax,(%esp)
8010445a:	e8 61 fe ff ff       	call   801042c0 <getcallerpcs>
}
8010445f:	83 c4 14             	add    $0x14,%esp
80104462:	5b                   	pop    %ebx
80104463:	5d                   	pop    %ebp
80104464:	c3                   	ret    
    panic("acquire");
80104465:	c7 04 24 69 75 10 80 	movl   $0x80107569,(%esp)
8010446c:	e8 ef be ff ff       	call   80100360 <panic>
80104471:	eb 0d                	jmp    80104480 <release>
80104473:	90                   	nop
80104474:	90                   	nop
80104475:	90                   	nop
80104476:	90                   	nop
80104477:	90                   	nop
80104478:	90                   	nop
80104479:	90                   	nop
8010447a:	90                   	nop
8010447b:	90                   	nop
8010447c:	90                   	nop
8010447d:	90                   	nop
8010447e:	90                   	nop
8010447f:	90                   	nop

80104480 <release>:
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	53                   	push   %ebx
80104484:	83 ec 14             	sub    $0x14,%esp
80104487:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010448a:	89 1c 24             	mov    %ebx,(%esp)
8010448d:	e8 3e ff ff ff       	call   801043d0 <holding>
80104492:	85 c0                	test   %eax,%eax
80104494:	74 21                	je     801044b7 <release+0x37>
  lk->pcs[0] = 0;
80104496:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010449d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801044a4:	0f ae f0             	mfence 
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801044a7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801044ad:	83 c4 14             	add    $0x14,%esp
801044b0:	5b                   	pop    %ebx
801044b1:	5d                   	pop    %ebp
  popcli();
801044b2:	e9 a9 fe ff ff       	jmp    80104360 <popcli>
    panic("release");
801044b7:	c7 04 24 71 75 10 80 	movl   $0x80107571,(%esp)
801044be:	e8 9d be ff ff       	call   80100360 <panic>
801044c3:	66 90                	xchg   %ax,%ax
801044c5:	66 90                	xchg   %ax,%ax
801044c7:	66 90                	xchg   %ax,%ax
801044c9:	66 90                	xchg   %ax,%ax
801044cb:	66 90                	xchg   %ax,%ax
801044cd:	66 90                	xchg   %ax,%ax
801044cf:	90                   	nop

801044d0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	8b 55 08             	mov    0x8(%ebp),%edx
801044d6:	57                   	push   %edi
801044d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801044da:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801044db:	f6 c2 03             	test   $0x3,%dl
801044de:	75 05                	jne    801044e5 <memset+0x15>
801044e0:	f6 c1 03             	test   $0x3,%cl
801044e3:	74 13                	je     801044f8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801044e5:	89 d7                	mov    %edx,%edi
801044e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801044ea:	fc                   	cld    
801044eb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801044ed:	5b                   	pop    %ebx
801044ee:	89 d0                	mov    %edx,%eax
801044f0:	5f                   	pop    %edi
801044f1:	5d                   	pop    %ebp
801044f2:	c3                   	ret    
801044f3:	90                   	nop
801044f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801044f8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801044fc:	c1 e9 02             	shr    $0x2,%ecx
801044ff:	89 f8                	mov    %edi,%eax
80104501:	89 fb                	mov    %edi,%ebx
80104503:	c1 e0 18             	shl    $0x18,%eax
80104506:	c1 e3 10             	shl    $0x10,%ebx
80104509:	09 d8                	or     %ebx,%eax
8010450b:	09 f8                	or     %edi,%eax
8010450d:	c1 e7 08             	shl    $0x8,%edi
80104510:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104512:	89 d7                	mov    %edx,%edi
80104514:	fc                   	cld    
80104515:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104517:	5b                   	pop    %ebx
80104518:	89 d0                	mov    %edx,%eax
8010451a:	5f                   	pop    %edi
8010451b:	5d                   	pop    %ebp
8010451c:	c3                   	ret    
8010451d:	8d 76 00             	lea    0x0(%esi),%esi

80104520 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	8b 45 10             	mov    0x10(%ebp),%eax
80104526:	57                   	push   %edi
80104527:	56                   	push   %esi
80104528:	8b 75 0c             	mov    0xc(%ebp),%esi
8010452b:	53                   	push   %ebx
8010452c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010452f:	85 c0                	test   %eax,%eax
80104531:	8d 78 ff             	lea    -0x1(%eax),%edi
80104534:	74 26                	je     8010455c <memcmp+0x3c>
    if(*s1 != *s2)
80104536:	0f b6 03             	movzbl (%ebx),%eax
80104539:	31 d2                	xor    %edx,%edx
8010453b:	0f b6 0e             	movzbl (%esi),%ecx
8010453e:	38 c8                	cmp    %cl,%al
80104540:	74 16                	je     80104558 <memcmp+0x38>
80104542:	eb 24                	jmp    80104568 <memcmp+0x48>
80104544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104548:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010454d:	83 c2 01             	add    $0x1,%edx
80104550:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104554:	38 c8                	cmp    %cl,%al
80104556:	75 10                	jne    80104568 <memcmp+0x48>
  while(n-- > 0){
80104558:	39 fa                	cmp    %edi,%edx
8010455a:	75 ec                	jne    80104548 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010455c:	5b                   	pop    %ebx
  return 0;
8010455d:	31 c0                	xor    %eax,%eax
}
8010455f:	5e                   	pop    %esi
80104560:	5f                   	pop    %edi
80104561:	5d                   	pop    %ebp
80104562:	c3                   	ret    
80104563:	90                   	nop
80104564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104568:	5b                   	pop    %ebx
      return *s1 - *s2;
80104569:	29 c8                	sub    %ecx,%eax
}
8010456b:	5e                   	pop    %esi
8010456c:	5f                   	pop    %edi
8010456d:	5d                   	pop    %ebp
8010456e:	c3                   	ret    
8010456f:	90                   	nop

80104570 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	57                   	push   %edi
80104574:	8b 45 08             	mov    0x8(%ebp),%eax
80104577:	56                   	push   %esi
80104578:	8b 75 0c             	mov    0xc(%ebp),%esi
8010457b:	53                   	push   %ebx
8010457c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010457f:	39 c6                	cmp    %eax,%esi
80104581:	73 35                	jae    801045b8 <memmove+0x48>
80104583:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104586:	39 c8                	cmp    %ecx,%eax
80104588:	73 2e                	jae    801045b8 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010458a:	85 db                	test   %ebx,%ebx
    d += n;
8010458c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010458f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104592:	74 1b                	je     801045af <memmove+0x3f>
80104594:	f7 db                	neg    %ebx
80104596:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104599:	01 fb                	add    %edi,%ebx
8010459b:	90                   	nop
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801045a0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801045a4:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    while(n-- > 0)
801045a7:	83 ea 01             	sub    $0x1,%edx
801045aa:	83 fa ff             	cmp    $0xffffffff,%edx
801045ad:	75 f1                	jne    801045a0 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801045af:	5b                   	pop    %ebx
801045b0:	5e                   	pop    %esi
801045b1:	5f                   	pop    %edi
801045b2:	5d                   	pop    %ebp
801045b3:	c3                   	ret    
801045b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801045b8:	31 d2                	xor    %edx,%edx
801045ba:	85 db                	test   %ebx,%ebx
801045bc:	74 f1                	je     801045af <memmove+0x3f>
801045be:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801045c0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801045c4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801045c7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801045ca:	39 da                	cmp    %ebx,%edx
801045cc:	75 f2                	jne    801045c0 <memmove+0x50>
}
801045ce:	5b                   	pop    %ebx
801045cf:	5e                   	pop    %esi
801045d0:	5f                   	pop    %edi
801045d1:	5d                   	pop    %ebp
801045d2:	c3                   	ret    
801045d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045e0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801045e3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801045e4:	eb 8a                	jmp    80104570 <memmove>
801045e6:	8d 76 00             	lea    0x0(%esi),%esi
801045e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045f0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	56                   	push   %esi
801045f4:	8b 75 10             	mov    0x10(%ebp),%esi
801045f7:	53                   	push   %ebx
801045f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801045fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801045fe:	85 f6                	test   %esi,%esi
80104600:	74 30                	je     80104632 <strncmp+0x42>
80104602:	0f b6 01             	movzbl (%ecx),%eax
80104605:	84 c0                	test   %al,%al
80104607:	74 2f                	je     80104638 <strncmp+0x48>
80104609:	0f b6 13             	movzbl (%ebx),%edx
8010460c:	38 d0                	cmp    %dl,%al
8010460e:	75 46                	jne    80104656 <strncmp+0x66>
80104610:	8d 51 01             	lea    0x1(%ecx),%edx
80104613:	01 ce                	add    %ecx,%esi
80104615:	eb 14                	jmp    8010462b <strncmp+0x3b>
80104617:	90                   	nop
80104618:	0f b6 02             	movzbl (%edx),%eax
8010461b:	84 c0                	test   %al,%al
8010461d:	74 31                	je     80104650 <strncmp+0x60>
8010461f:	0f b6 19             	movzbl (%ecx),%ebx
80104622:	83 c2 01             	add    $0x1,%edx
80104625:	38 d8                	cmp    %bl,%al
80104627:	75 17                	jne    80104640 <strncmp+0x50>
    n--, p++, q++;
80104629:	89 cb                	mov    %ecx,%ebx
  while(n > 0 && *p && *p == *q)
8010462b:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
8010462d:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(n > 0 && *p && *p == *q)
80104630:	75 e6                	jne    80104618 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104632:	5b                   	pop    %ebx
    return 0;
80104633:	31 c0                	xor    %eax,%eax
}
80104635:	5e                   	pop    %esi
80104636:	5d                   	pop    %ebp
80104637:	c3                   	ret    
80104638:	0f b6 1b             	movzbl (%ebx),%ebx
  while(n > 0 && *p && *p == *q)
8010463b:	31 c0                	xor    %eax,%eax
8010463d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
80104640:	0f b6 d3             	movzbl %bl,%edx
80104643:	29 d0                	sub    %edx,%eax
}
80104645:	5b                   	pop    %ebx
80104646:	5e                   	pop    %esi
80104647:	5d                   	pop    %ebp
80104648:	c3                   	ret    
80104649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104650:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104654:	eb ea                	jmp    80104640 <strncmp+0x50>
  while(n > 0 && *p && *p == *q)
80104656:	89 d3                	mov    %edx,%ebx
80104658:	eb e6                	jmp    80104640 <strncmp+0x50>
8010465a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104660 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	8b 45 08             	mov    0x8(%ebp),%eax
80104666:	56                   	push   %esi
80104667:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010466a:	53                   	push   %ebx
8010466b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010466e:	89 c2                	mov    %eax,%edx
80104670:	eb 19                	jmp    8010468b <strncpy+0x2b>
80104672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104678:	83 c3 01             	add    $0x1,%ebx
8010467b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010467f:	83 c2 01             	add    $0x1,%edx
80104682:	84 c9                	test   %cl,%cl
80104684:	88 4a ff             	mov    %cl,-0x1(%edx)
80104687:	74 09                	je     80104692 <strncpy+0x32>
80104689:	89 f1                	mov    %esi,%ecx
8010468b:	85 c9                	test   %ecx,%ecx
8010468d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104690:	7f e6                	jg     80104678 <strncpy+0x18>
    ;
  while(n-- > 0)
80104692:	31 c9                	xor    %ecx,%ecx
80104694:	85 f6                	test   %esi,%esi
80104696:	7e 0f                	jle    801046a7 <strncpy+0x47>
    *s++ = 0;
80104698:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010469c:	89 f3                	mov    %esi,%ebx
8010469e:	83 c1 01             	add    $0x1,%ecx
801046a1:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801046a3:	85 db                	test   %ebx,%ebx
801046a5:	7f f1                	jg     80104698 <strncpy+0x38>
  return os;
}
801046a7:	5b                   	pop    %ebx
801046a8:	5e                   	pop    %esi
801046a9:	5d                   	pop    %ebp
801046aa:	c3                   	ret    
801046ab:	90                   	nop
801046ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046b0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046b6:	56                   	push   %esi
801046b7:	8b 45 08             	mov    0x8(%ebp),%eax
801046ba:	53                   	push   %ebx
801046bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801046be:	85 c9                	test   %ecx,%ecx
801046c0:	7e 26                	jle    801046e8 <safestrcpy+0x38>
801046c2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801046c6:	89 c1                	mov    %eax,%ecx
801046c8:	eb 17                	jmp    801046e1 <safestrcpy+0x31>
801046ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801046d0:	83 c2 01             	add    $0x1,%edx
801046d3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801046d7:	83 c1 01             	add    $0x1,%ecx
801046da:	84 db                	test   %bl,%bl
801046dc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801046df:	74 04                	je     801046e5 <safestrcpy+0x35>
801046e1:	39 f2                	cmp    %esi,%edx
801046e3:	75 eb                	jne    801046d0 <safestrcpy+0x20>
    ;
  *s = 0;
801046e5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801046e8:	5b                   	pop    %ebx
801046e9:	5e                   	pop    %esi
801046ea:	5d                   	pop    %ebp
801046eb:	c3                   	ret    
801046ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046f0 <strlen>:

int
strlen(const char *s)
{
801046f0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801046f1:	31 c0                	xor    %eax,%eax
{
801046f3:	89 e5                	mov    %esp,%ebp
801046f5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801046f8:	80 3a 00             	cmpb   $0x0,(%edx)
801046fb:	74 0c                	je     80104709 <strlen+0x19>
801046fd:	8d 76 00             	lea    0x0(%esi),%esi
80104700:	83 c0 01             	add    $0x1,%eax
80104703:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104707:	75 f7                	jne    80104700 <strlen+0x10>
    ;
  return n;
}
80104709:	5d                   	pop    %ebp
8010470a:	c3                   	ret    

8010470b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010470b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010470f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104713:	55                   	push   %ebp
  pushl %ebx
80104714:	53                   	push   %ebx
  pushl %esi
80104715:	56                   	push   %esi
  pushl %edi
80104716:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104717:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104719:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010471b:	5f                   	pop    %edi
  popl %esi
8010471c:	5e                   	pop    %esi
  popl %ebx
8010471d:	5b                   	pop    %ebx
  popl %ebp
8010471e:	5d                   	pop    %ebp
  ret
8010471f:	c3                   	ret    

80104720 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	53                   	push   %ebx
80104724:	83 ec 04             	sub    $0x4,%esp
80104727:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010472a:	e8 b1 ef ff ff       	call   801036e0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010472f:	8b 00                	mov    (%eax),%eax
80104731:	39 d8                	cmp    %ebx,%eax
80104733:	76 1b                	jbe    80104750 <fetchint+0x30>
80104735:	8d 53 04             	lea    0x4(%ebx),%edx
80104738:	39 d0                	cmp    %edx,%eax
8010473a:	72 14                	jb     80104750 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010473c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010473f:	8b 13                	mov    (%ebx),%edx
80104741:	89 10                	mov    %edx,(%eax)
  return 0;
80104743:	31 c0                	xor    %eax,%eax
}
80104745:	83 c4 04             	add    $0x4,%esp
80104748:	5b                   	pop    %ebx
80104749:	5d                   	pop    %ebp
8010474a:	c3                   	ret    
8010474b:	90                   	nop
8010474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104750:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104755:	eb ee                	jmp    80104745 <fetchint+0x25>
80104757:	89 f6                	mov    %esi,%esi
80104759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104760 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	53                   	push   %ebx
80104764:	83 ec 04             	sub    $0x4,%esp
80104767:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010476a:	e8 71 ef ff ff       	call   801036e0 <myproc>

  if(addr >= curproc->sz)
8010476f:	39 18                	cmp    %ebx,(%eax)
80104771:	76 26                	jbe    80104799 <fetchstr+0x39>
    return -1;
  *pp = (char*)addr;
80104773:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104776:	89 da                	mov    %ebx,%edx
80104778:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010477a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010477c:	39 c3                	cmp    %eax,%ebx
8010477e:	73 19                	jae    80104799 <fetchstr+0x39>
    if(*s == 0)
80104780:	80 3b 00             	cmpb   $0x0,(%ebx)
80104783:	75 0d                	jne    80104792 <fetchstr+0x32>
80104785:	eb 21                	jmp    801047a8 <fetchstr+0x48>
80104787:	90                   	nop
80104788:	80 3a 00             	cmpb   $0x0,(%edx)
8010478b:	90                   	nop
8010478c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104790:	74 16                	je     801047a8 <fetchstr+0x48>
  for(s = *pp; s < ep; s++){
80104792:	83 c2 01             	add    $0x1,%edx
80104795:	39 d0                	cmp    %edx,%eax
80104797:	77 ef                	ja     80104788 <fetchstr+0x28>
      return s - *pp;
  }
  return -1;
}
80104799:	83 c4 04             	add    $0x4,%esp
    return -1;
8010479c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801047a1:	5b                   	pop    %ebx
801047a2:	5d                   	pop    %ebp
801047a3:	c3                   	ret    
801047a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047a8:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801047ab:	89 d0                	mov    %edx,%eax
801047ad:	29 d8                	sub    %ebx,%eax
}
801047af:	5b                   	pop    %ebx
801047b0:	5d                   	pop    %ebp
801047b1:	c3                   	ret    
801047b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047c0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	56                   	push   %esi
801047c4:	8b 75 0c             	mov    0xc(%ebp),%esi
801047c7:	53                   	push   %ebx
801047c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801047cb:	e8 10 ef ff ff       	call   801036e0 <myproc>
801047d0:	89 75 0c             	mov    %esi,0xc(%ebp)
801047d3:	8b 40 18             	mov    0x18(%eax),%eax
801047d6:	8b 40 44             	mov    0x44(%eax),%eax
801047d9:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
801047dd:	89 45 08             	mov    %eax,0x8(%ebp)
}
801047e0:	5b                   	pop    %ebx
801047e1:	5e                   	pop    %esi
801047e2:	5d                   	pop    %ebp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801047e3:	e9 38 ff ff ff       	jmp    80104720 <fetchint>
801047e8:	90                   	nop
801047e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047f0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	56                   	push   %esi
801047f4:	53                   	push   %ebx
801047f5:	83 ec 20             	sub    $0x20,%esp
801047f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801047fb:	e8 e0 ee ff ff       	call   801036e0 <myproc>
80104800:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104802:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104805:	89 44 24 04          	mov    %eax,0x4(%esp)
80104809:	8b 45 08             	mov    0x8(%ebp),%eax
8010480c:	89 04 24             	mov    %eax,(%esp)
8010480f:	e8 ac ff ff ff       	call   801047c0 <argint>
80104814:	85 c0                	test   %eax,%eax
80104816:	78 28                	js     80104840 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104818:	85 db                	test   %ebx,%ebx
8010481a:	78 24                	js     80104840 <argptr+0x50>
8010481c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010481f:	8b 06                	mov    (%esi),%eax
80104821:	39 c2                	cmp    %eax,%edx
80104823:	73 1b                	jae    80104840 <argptr+0x50>
80104825:	01 d3                	add    %edx,%ebx
80104827:	39 d8                	cmp    %ebx,%eax
80104829:	72 15                	jb     80104840 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010482b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010482e:	89 10                	mov    %edx,(%eax)
  return 0;
}
80104830:	83 c4 20             	add    $0x20,%esp
  return 0;
80104833:	31 c0                	xor    %eax,%eax
}
80104835:	5b                   	pop    %ebx
80104836:	5e                   	pop    %esi
80104837:	5d                   	pop    %ebp
80104838:	c3                   	ret    
80104839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104840:	83 c4 20             	add    $0x20,%esp
    return -1;
80104843:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104848:	5b                   	pop    %ebx
80104849:	5e                   	pop    %esi
8010484a:	5d                   	pop    %ebp
8010484b:	c3                   	ret    
8010484c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104850 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104856:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104859:	89 44 24 04          	mov    %eax,0x4(%esp)
8010485d:	8b 45 08             	mov    0x8(%ebp),%eax
80104860:	89 04 24             	mov    %eax,(%esp)
80104863:	e8 58 ff ff ff       	call   801047c0 <argint>
80104868:	85 c0                	test   %eax,%eax
8010486a:	78 14                	js     80104880 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010486c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010486f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104873:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104876:	89 04 24             	mov    %eax,(%esp)
80104879:	e8 e2 fe ff ff       	call   80104760 <fetchstr>
}
8010487e:	c9                   	leave  
8010487f:	c3                   	ret    
    return -1;
80104880:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104885:	c9                   	leave  
80104886:	c3                   	ret    
80104887:	89 f6                	mov    %esi,%esi
80104889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104890 <syscall>:
[SYS_get_prior]   sys_get_prior, // lab 2
};

void
syscall(void)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	53                   	push   %ebx
80104895:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104898:	e8 43 ee ff ff       	call   801036e0 <myproc>

  num = curproc->tf->eax;
8010489d:	8b 70 18             	mov    0x18(%eax),%esi
  struct proc *curproc = myproc();
801048a0:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
801048a2:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801048a5:	8d 50 ff             	lea    -0x1(%eax),%edx
801048a8:	83 fa 16             	cmp    $0x16,%edx
801048ab:	77 1b                	ja     801048c8 <syscall+0x38>
801048ad:	8b 14 85 a0 75 10 80 	mov    -0x7fef8a60(,%eax,4),%edx
801048b4:	85 d2                	test   %edx,%edx
801048b6:	74 10                	je     801048c8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801048b8:	ff d2                	call   *%edx
801048ba:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801048bd:	83 c4 10             	add    $0x10,%esp
801048c0:	5b                   	pop    %ebx
801048c1:	5e                   	pop    %esi
801048c2:	5d                   	pop    %ebp
801048c3:	c3                   	ret    
801048c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801048c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
801048cc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801048cf:	89 44 24 08          	mov    %eax,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
801048d3:	8b 43 10             	mov    0x10(%ebx),%eax
801048d6:	c7 04 24 79 75 10 80 	movl   $0x80107579,(%esp)
801048dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801048e1:	e8 6a bd ff ff       	call   80100650 <cprintf>
    curproc->tf->eax = -1;
801048e6:	8b 43 18             	mov    0x18(%ebx),%eax
801048e9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801048f0:	83 c4 10             	add    $0x10,%esp
801048f3:	5b                   	pop    %ebx
801048f4:	5e                   	pop    %esi
801048f5:	5d                   	pop    %ebp
801048f6:	c3                   	ret    
801048f7:	66 90                	xchg   %ax,%ax
801048f9:	66 90                	xchg   %ax,%ax
801048fb:	66 90                	xchg   %ax,%ax
801048fd:	66 90                	xchg   %ax,%ax
801048ff:	90                   	nop

80104900 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	53                   	push   %ebx
80104904:	89 c3                	mov    %eax,%ebx
80104906:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
80104909:	e8 d2 ed ff ff       	call   801036e0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
8010490e:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
80104910:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104914:	85 c9                	test   %ecx,%ecx
80104916:	74 18                	je     80104930 <fdalloc+0x30>
  for(fd = 0; fd < NOFILE; fd++){
80104918:	83 c2 01             	add    $0x1,%edx
8010491b:	83 fa 10             	cmp    $0x10,%edx
8010491e:	75 f0                	jne    80104910 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
80104920:	83 c4 04             	add    $0x4,%esp
  return -1;
80104923:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104928:	5b                   	pop    %ebx
80104929:	5d                   	pop    %ebp
8010492a:	c3                   	ret    
8010492b:	90                   	nop
8010492c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80104930:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
}
80104934:	83 c4 04             	add    $0x4,%esp
      return fd;
80104937:	89 d0                	mov    %edx,%eax
}
80104939:	5b                   	pop    %ebx
8010493a:	5d                   	pop    %ebp
8010493b:	c3                   	ret    
8010493c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104940 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	57                   	push   %edi
80104944:	56                   	push   %esi
80104945:	53                   	push   %ebx
80104946:	83 ec 3c             	sub    $0x3c,%esp
80104949:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010494c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010494f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104952:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104956:	89 04 24             	mov    %eax,(%esp)
{
80104959:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010495c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010495f:	e8 dc d5 ff ff       	call   80101f40 <nameiparent>
80104964:	85 c0                	test   %eax,%eax
80104966:	89 c7                	mov    %eax,%edi
80104968:	0f 84 da 00 00 00    	je     80104a48 <create+0x108>
    return 0;
  ilock(dp);
8010496e:	89 04 24             	mov    %eax,(%esp)
80104971:	e8 5a cd ff ff       	call   801016d0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104976:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010497d:	00 
8010497e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104982:	89 3c 24             	mov    %edi,(%esp)
80104985:	e8 56 d2 ff ff       	call   80101be0 <dirlookup>
8010498a:	85 c0                	test   %eax,%eax
8010498c:	89 c6                	mov    %eax,%esi
8010498e:	74 40                	je     801049d0 <create+0x90>
    iunlockput(dp);
80104990:	89 3c 24             	mov    %edi,(%esp)
80104993:	e8 98 cf ff ff       	call   80101930 <iunlockput>
    ilock(ip);
80104998:	89 34 24             	mov    %esi,(%esp)
8010499b:	e8 30 cd ff ff       	call   801016d0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801049a0:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801049a5:	75 11                	jne    801049b8 <create+0x78>
801049a7:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801049ac:	89 f0                	mov    %esi,%eax
801049ae:	75 08                	jne    801049b8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801049b0:	83 c4 3c             	add    $0x3c,%esp
801049b3:	5b                   	pop    %ebx
801049b4:	5e                   	pop    %esi
801049b5:	5f                   	pop    %edi
801049b6:	5d                   	pop    %ebp
801049b7:	c3                   	ret    
    iunlockput(ip);
801049b8:	89 34 24             	mov    %esi,(%esp)
801049bb:	e8 70 cf ff ff       	call   80101930 <iunlockput>
}
801049c0:	83 c4 3c             	add    $0x3c,%esp
    return 0;
801049c3:	31 c0                	xor    %eax,%eax
}
801049c5:	5b                   	pop    %ebx
801049c6:	5e                   	pop    %esi
801049c7:	5f                   	pop    %edi
801049c8:	5d                   	pop    %ebp
801049c9:	c3                   	ret    
801049ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
801049d0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801049d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801049d8:	8b 07                	mov    (%edi),%eax
801049da:	89 04 24             	mov    %eax,(%esp)
801049dd:	e8 5e cb ff ff       	call   80101540 <ialloc>
801049e2:	85 c0                	test   %eax,%eax
801049e4:	89 c6                	mov    %eax,%esi
801049e6:	0f 84 bf 00 00 00    	je     80104aab <create+0x16b>
  ilock(ip);
801049ec:	89 04 24             	mov    %eax,(%esp)
801049ef:	e8 dc cc ff ff       	call   801016d0 <ilock>
  ip->major = major;
801049f4:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801049f8:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801049fc:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104a00:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104a04:	b8 01 00 00 00       	mov    $0x1,%eax
80104a09:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104a0d:	89 34 24             	mov    %esi,(%esp)
80104a10:	e8 fb cb ff ff       	call   80101610 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104a15:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104a1a:	74 34                	je     80104a50 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104a1c:	8b 46 04             	mov    0x4(%esi),%eax
80104a1f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104a23:	89 3c 24             	mov    %edi,(%esp)
80104a26:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a2a:	e8 11 d4 ff ff       	call   80101e40 <dirlink>
80104a2f:	85 c0                	test   %eax,%eax
80104a31:	78 6c                	js     80104a9f <create+0x15f>
  iunlockput(dp);
80104a33:	89 3c 24             	mov    %edi,(%esp)
80104a36:	e8 f5 ce ff ff       	call   80101930 <iunlockput>
}
80104a3b:	83 c4 3c             	add    $0x3c,%esp
  return ip;
80104a3e:	89 f0                	mov    %esi,%eax
}
80104a40:	5b                   	pop    %ebx
80104a41:	5e                   	pop    %esi
80104a42:	5f                   	pop    %edi
80104a43:	5d                   	pop    %ebp
80104a44:	c3                   	ret    
80104a45:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
80104a48:	31 c0                	xor    %eax,%eax
80104a4a:	e9 61 ff ff ff       	jmp    801049b0 <create+0x70>
80104a4f:	90                   	nop
    dp->nlink++;  // for ".."
80104a50:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104a55:	89 3c 24             	mov    %edi,(%esp)
80104a58:	e8 b3 cb ff ff       	call   80101610 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104a5d:	8b 46 04             	mov    0x4(%esi),%eax
80104a60:	c7 44 24 04 1c 76 10 	movl   $0x8010761c,0x4(%esp)
80104a67:	80 
80104a68:	89 34 24             	mov    %esi,(%esp)
80104a6b:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a6f:	e8 cc d3 ff ff       	call   80101e40 <dirlink>
80104a74:	85 c0                	test   %eax,%eax
80104a76:	78 1b                	js     80104a93 <create+0x153>
80104a78:	8b 47 04             	mov    0x4(%edi),%eax
80104a7b:	c7 44 24 04 1b 76 10 	movl   $0x8010761b,0x4(%esp)
80104a82:	80 
80104a83:	89 34 24             	mov    %esi,(%esp)
80104a86:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a8a:	e8 b1 d3 ff ff       	call   80101e40 <dirlink>
80104a8f:	85 c0                	test   %eax,%eax
80104a91:	79 89                	jns    80104a1c <create+0xdc>
      panic("create dots");
80104a93:	c7 04 24 0f 76 10 80 	movl   $0x8010760f,(%esp)
80104a9a:	e8 c1 b8 ff ff       	call   80100360 <panic>
    panic("create: dirlink");
80104a9f:	c7 04 24 1e 76 10 80 	movl   $0x8010761e,(%esp)
80104aa6:	e8 b5 b8 ff ff       	call   80100360 <panic>
    panic("create: ialloc");
80104aab:	c7 04 24 00 76 10 80 	movl   $0x80107600,(%esp)
80104ab2:	e8 a9 b8 ff ff       	call   80100360 <panic>
80104ab7:	89 f6                	mov    %esi,%esi
80104ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ac0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	56                   	push   %esi
80104ac4:	89 c6                	mov    %eax,%esi
80104ac6:	53                   	push   %ebx
80104ac7:	89 d3                	mov    %edx,%ebx
80104ac9:	83 ec 20             	sub    $0x20,%esp
  if(argint(n, &fd) < 0)
80104acc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104acf:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ad3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ada:	e8 e1 fc ff ff       	call   801047c0 <argint>
80104adf:	85 c0                	test   %eax,%eax
80104ae1:	78 2d                	js     80104b10 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104ae3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ae7:	77 27                	ja     80104b10 <argfd.constprop.0+0x50>
80104ae9:	e8 f2 eb ff ff       	call   801036e0 <myproc>
80104aee:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104af1:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104af5:	85 c0                	test   %eax,%eax
80104af7:	74 17                	je     80104b10 <argfd.constprop.0+0x50>
  if(pfd)
80104af9:	85 f6                	test   %esi,%esi
80104afb:	74 02                	je     80104aff <argfd.constprop.0+0x3f>
    *pfd = fd;
80104afd:	89 16                	mov    %edx,(%esi)
  if(pf)
80104aff:	85 db                	test   %ebx,%ebx
80104b01:	74 1d                	je     80104b20 <argfd.constprop.0+0x60>
    *pf = f;
80104b03:	89 03                	mov    %eax,(%ebx)
  return 0;
80104b05:	31 c0                	xor    %eax,%eax
}
80104b07:	83 c4 20             	add    $0x20,%esp
80104b0a:	5b                   	pop    %ebx
80104b0b:	5e                   	pop    %esi
80104b0c:	5d                   	pop    %ebp
80104b0d:	c3                   	ret    
80104b0e:	66 90                	xchg   %ax,%ax
80104b10:	83 c4 20             	add    $0x20,%esp
    return -1;
80104b13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b18:	5b                   	pop    %ebx
80104b19:	5e                   	pop    %esi
80104b1a:	5d                   	pop    %ebp
80104b1b:	c3                   	ret    
80104b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
80104b20:	31 c0                	xor    %eax,%eax
80104b22:	eb e3                	jmp    80104b07 <argfd.constprop.0+0x47>
80104b24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104b30 <sys_dup>:
{
80104b30:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104b31:	31 c0                	xor    %eax,%eax
{
80104b33:	89 e5                	mov    %esp,%ebp
80104b35:	53                   	push   %ebx
80104b36:	83 ec 24             	sub    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
80104b39:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104b3c:	e8 7f ff ff ff       	call   80104ac0 <argfd.constprop.0>
80104b41:	85 c0                	test   %eax,%eax
80104b43:	78 23                	js     80104b68 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b48:	e8 b3 fd ff ff       	call   80104900 <fdalloc>
80104b4d:	85 c0                	test   %eax,%eax
80104b4f:	89 c3                	mov    %eax,%ebx
80104b51:	78 15                	js     80104b68 <sys_dup+0x38>
  filedup(f);
80104b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b56:	89 04 24             	mov    %eax,(%esp)
80104b59:	e8 a2 c2 ff ff       	call   80100e00 <filedup>
  return fd;
80104b5e:	89 d8                	mov    %ebx,%eax
}
80104b60:	83 c4 24             	add    $0x24,%esp
80104b63:	5b                   	pop    %ebx
80104b64:	5d                   	pop    %ebp
80104b65:	c3                   	ret    
80104b66:	66 90                	xchg   %ax,%ax
    return -1;
80104b68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b6d:	eb f1                	jmp    80104b60 <sys_dup+0x30>
80104b6f:	90                   	nop

80104b70 <sys_read>:
{
80104b70:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b71:	31 c0                	xor    %eax,%eax
{
80104b73:	89 e5                	mov    %esp,%ebp
80104b75:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b78:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b7b:	e8 40 ff ff ff       	call   80104ac0 <argfd.constprop.0>
80104b80:	85 c0                	test   %eax,%eax
80104b82:	78 54                	js     80104bd8 <sys_read+0x68>
80104b84:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b87:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b8b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104b92:	e8 29 fc ff ff       	call   801047c0 <argint>
80104b97:	85 c0                	test   %eax,%eax
80104b99:	78 3d                	js     80104bd8 <sys_read+0x68>
80104b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b9e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104ba5:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ba9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bac:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bb0:	e8 3b fc ff ff       	call   801047f0 <argptr>
80104bb5:	85 c0                	test   %eax,%eax
80104bb7:	78 1f                	js     80104bd8 <sys_read+0x68>
  return fileread(f, p, n);
80104bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bbc:	89 44 24 08          	mov    %eax,0x8(%esp)
80104bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104bca:	89 04 24             	mov    %eax,(%esp)
80104bcd:	e8 8e c3 ff ff       	call   80100f60 <fileread>
}
80104bd2:	c9                   	leave  
80104bd3:	c3                   	ret    
80104bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104bd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bdd:	c9                   	leave  
80104bde:	c3                   	ret    
80104bdf:	90                   	nop

80104be0 <sys_write>:
{
80104be0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104be1:	31 c0                	xor    %eax,%eax
{
80104be3:	89 e5                	mov    %esp,%ebp
80104be5:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104be8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104beb:	e8 d0 fe ff ff       	call   80104ac0 <argfd.constprop.0>
80104bf0:	85 c0                	test   %eax,%eax
80104bf2:	78 54                	js     80104c48 <sys_write+0x68>
80104bf4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bfb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104c02:	e8 b9 fb ff ff       	call   801047c0 <argint>
80104c07:	85 c0                	test   %eax,%eax
80104c09:	78 3d                	js     80104c48 <sys_write+0x68>
80104c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c15:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c1c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c20:	e8 cb fb ff ff       	call   801047f0 <argptr>
80104c25:	85 c0                	test   %eax,%eax
80104c27:	78 1f                	js     80104c48 <sys_write+0x68>
  return filewrite(f, p, n);
80104c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c2c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c33:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c37:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c3a:	89 04 24             	mov    %eax,(%esp)
80104c3d:	e8 be c3 ff ff       	call   80101000 <filewrite>
}
80104c42:	c9                   	leave  
80104c43:	c3                   	ret    
80104c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c4d:	c9                   	leave  
80104c4e:	c3                   	ret    
80104c4f:	90                   	nop

80104c50 <sys_close>:
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
80104c56:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104c59:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c5c:	e8 5f fe ff ff       	call   80104ac0 <argfd.constprop.0>
80104c61:	85 c0                	test   %eax,%eax
80104c63:	78 23                	js     80104c88 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
80104c65:	e8 76 ea ff ff       	call   801036e0 <myproc>
80104c6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c6d:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104c74:	00 
  fileclose(f);
80104c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c78:	89 04 24             	mov    %eax,(%esp)
80104c7b:	e8 d0 c1 ff ff       	call   80100e50 <fileclose>
  return 0;
80104c80:	31 c0                	xor    %eax,%eax
}
80104c82:	c9                   	leave  
80104c83:	c3                   	ret    
80104c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c8d:	c9                   	leave  
80104c8e:	c3                   	ret    
80104c8f:	90                   	nop

80104c90 <sys_fstat>:
{
80104c90:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c91:	31 c0                	xor    %eax,%eax
{
80104c93:	89 e5                	mov    %esp,%ebp
80104c95:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c98:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104c9b:	e8 20 fe ff ff       	call   80104ac0 <argfd.constprop.0>
80104ca0:	85 c0                	test   %eax,%eax
80104ca2:	78 34                	js     80104cd8 <sys_fstat+0x48>
80104ca4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ca7:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104cae:	00 
80104caf:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cb3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104cba:	e8 31 fb ff ff       	call   801047f0 <argptr>
80104cbf:	85 c0                	test   %eax,%eax
80104cc1:	78 15                	js     80104cd8 <sys_fstat+0x48>
  return filestat(f, st);
80104cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cc6:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ccd:	89 04 24             	mov    %eax,(%esp)
80104cd0:	e8 3b c2 ff ff       	call   80100f10 <filestat>
}
80104cd5:	c9                   	leave  
80104cd6:	c3                   	ret    
80104cd7:	90                   	nop
    return -1;
80104cd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cdd:	c9                   	leave  
80104cde:	c3                   	ret    
80104cdf:	90                   	nop

80104ce0 <sys_link>:
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	57                   	push   %edi
80104ce4:	56                   	push   %esi
80104ce5:	53                   	push   %ebx
80104ce6:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ce9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104cec:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cf0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104cf7:	e8 54 fb ff ff       	call   80104850 <argstr>
80104cfc:	85 c0                	test   %eax,%eax
80104cfe:	0f 88 e6 00 00 00    	js     80104dea <sys_link+0x10a>
80104d04:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104d07:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104d12:	e8 39 fb ff ff       	call   80104850 <argstr>
80104d17:	85 c0                	test   %eax,%eax
80104d19:	0f 88 cb 00 00 00    	js     80104dea <sys_link+0x10a>
  begin_op();
80104d1f:	e8 0c de ff ff       	call   80102b30 <begin_op>
  if((ip = namei(old)) == 0){
80104d24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104d27:	89 04 24             	mov    %eax,(%esp)
80104d2a:	e8 f1 d1 ff ff       	call   80101f20 <namei>
80104d2f:	85 c0                	test   %eax,%eax
80104d31:	89 c3                	mov    %eax,%ebx
80104d33:	0f 84 ac 00 00 00    	je     80104de5 <sys_link+0x105>
  ilock(ip);
80104d39:	89 04 24             	mov    %eax,(%esp)
80104d3c:	e8 8f c9 ff ff       	call   801016d0 <ilock>
  if(ip->type == T_DIR){
80104d41:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d46:	0f 84 91 00 00 00    	je     80104ddd <sys_link+0xfd>
  ip->nlink++;
80104d4c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104d51:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104d54:	89 1c 24             	mov    %ebx,(%esp)
80104d57:	e8 b4 c8 ff ff       	call   80101610 <iupdate>
  iunlock(ip);
80104d5c:	89 1c 24             	mov    %ebx,(%esp)
80104d5f:	e8 4c ca ff ff       	call   801017b0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104d64:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104d67:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104d6b:	89 04 24             	mov    %eax,(%esp)
80104d6e:	e8 cd d1 ff ff       	call   80101f40 <nameiparent>
80104d73:	85 c0                	test   %eax,%eax
80104d75:	89 c6                	mov    %eax,%esi
80104d77:	74 4f                	je     80104dc8 <sys_link+0xe8>
  ilock(dp);
80104d79:	89 04 24             	mov    %eax,(%esp)
80104d7c:	e8 4f c9 ff ff       	call   801016d0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104d81:	8b 03                	mov    (%ebx),%eax
80104d83:	39 06                	cmp    %eax,(%esi)
80104d85:	75 39                	jne    80104dc0 <sys_link+0xe0>
80104d87:	8b 43 04             	mov    0x4(%ebx),%eax
80104d8a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104d8e:	89 34 24             	mov    %esi,(%esp)
80104d91:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d95:	e8 a6 d0 ff ff       	call   80101e40 <dirlink>
80104d9a:	85 c0                	test   %eax,%eax
80104d9c:	78 22                	js     80104dc0 <sys_link+0xe0>
  iunlockput(dp);
80104d9e:	89 34 24             	mov    %esi,(%esp)
80104da1:	e8 8a cb ff ff       	call   80101930 <iunlockput>
  iput(ip);
80104da6:	89 1c 24             	mov    %ebx,(%esp)
80104da9:	e8 42 ca ff ff       	call   801017f0 <iput>
  end_op();
80104dae:	e8 ed dd ff ff       	call   80102ba0 <end_op>
}
80104db3:	83 c4 3c             	add    $0x3c,%esp
  return 0;
80104db6:	31 c0                	xor    %eax,%eax
}
80104db8:	5b                   	pop    %ebx
80104db9:	5e                   	pop    %esi
80104dba:	5f                   	pop    %edi
80104dbb:	5d                   	pop    %ebp
80104dbc:	c3                   	ret    
80104dbd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104dc0:	89 34 24             	mov    %esi,(%esp)
80104dc3:	e8 68 cb ff ff       	call   80101930 <iunlockput>
  ilock(ip);
80104dc8:	89 1c 24             	mov    %ebx,(%esp)
80104dcb:	e8 00 c9 ff ff       	call   801016d0 <ilock>
  ip->nlink--;
80104dd0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104dd5:	89 1c 24             	mov    %ebx,(%esp)
80104dd8:	e8 33 c8 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
80104ddd:	89 1c 24             	mov    %ebx,(%esp)
80104de0:	e8 4b cb ff ff       	call   80101930 <iunlockput>
  end_op();
80104de5:	e8 b6 dd ff ff       	call   80102ba0 <end_op>
}
80104dea:	83 c4 3c             	add    $0x3c,%esp
  return -1;
80104ded:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104df2:	5b                   	pop    %ebx
80104df3:	5e                   	pop    %esi
80104df4:	5f                   	pop    %edi
80104df5:	5d                   	pop    %ebp
80104df6:	c3                   	ret    
80104df7:	89 f6                	mov    %esi,%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e00 <sys_unlink>:
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	57                   	push   %edi
80104e04:	56                   	push   %esi
80104e05:	53                   	push   %ebx
80104e06:	83 ec 5c             	sub    $0x5c,%esp
  if(argstr(0, &path) < 0)
80104e09:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104e0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104e17:	e8 34 fa ff ff       	call   80104850 <argstr>
80104e1c:	85 c0                	test   %eax,%eax
80104e1e:	0f 88 76 01 00 00    	js     80104f9a <sys_unlink+0x19a>
  begin_op();
80104e24:	e8 07 dd ff ff       	call   80102b30 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104e29:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104e2c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104e2f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104e33:	89 04 24             	mov    %eax,(%esp)
80104e36:	e8 05 d1 ff ff       	call   80101f40 <nameiparent>
80104e3b:	85 c0                	test   %eax,%eax
80104e3d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104e40:	0f 84 4f 01 00 00    	je     80104f95 <sys_unlink+0x195>
  ilock(dp);
80104e46:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104e49:	89 34 24             	mov    %esi,(%esp)
80104e4c:	e8 7f c8 ff ff       	call   801016d0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104e51:	c7 44 24 04 1c 76 10 	movl   $0x8010761c,0x4(%esp)
80104e58:	80 
80104e59:	89 1c 24             	mov    %ebx,(%esp)
80104e5c:	e8 4f cd ff ff       	call   80101bb0 <namecmp>
80104e61:	85 c0                	test   %eax,%eax
80104e63:	0f 84 21 01 00 00    	je     80104f8a <sys_unlink+0x18a>
80104e69:	c7 44 24 04 1b 76 10 	movl   $0x8010761b,0x4(%esp)
80104e70:	80 
80104e71:	89 1c 24             	mov    %ebx,(%esp)
80104e74:	e8 37 cd ff ff       	call   80101bb0 <namecmp>
80104e79:	85 c0                	test   %eax,%eax
80104e7b:	0f 84 09 01 00 00    	je     80104f8a <sys_unlink+0x18a>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104e81:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104e84:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104e88:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e8c:	89 34 24             	mov    %esi,(%esp)
80104e8f:	e8 4c cd ff ff       	call   80101be0 <dirlookup>
80104e94:	85 c0                	test   %eax,%eax
80104e96:	89 c3                	mov    %eax,%ebx
80104e98:	0f 84 ec 00 00 00    	je     80104f8a <sys_unlink+0x18a>
  ilock(ip);
80104e9e:	89 04 24             	mov    %eax,(%esp)
80104ea1:	e8 2a c8 ff ff       	call   801016d0 <ilock>
  if(ip->nlink < 1)
80104ea6:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104eab:	0f 8e 24 01 00 00    	jle    80104fd5 <sys_unlink+0x1d5>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104eb1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104eb6:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104eb9:	74 7d                	je     80104f38 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
80104ebb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104ec2:	00 
80104ec3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104eca:	00 
80104ecb:	89 34 24             	mov    %esi,(%esp)
80104ece:	e8 fd f5 ff ff       	call   801044d0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104ed3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104ed6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104edd:	00 
80104ede:	89 74 24 04          	mov    %esi,0x4(%esp)
80104ee2:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ee6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104ee9:	89 04 24             	mov    %eax,(%esp)
80104eec:	e8 8f cb ff ff       	call   80101a80 <writei>
80104ef1:	83 f8 10             	cmp    $0x10,%eax
80104ef4:	0f 85 cf 00 00 00    	jne    80104fc9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80104efa:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104eff:	0f 84 a3 00 00 00    	je     80104fa8 <sys_unlink+0x1a8>
  iunlockput(dp);
80104f05:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104f08:	89 04 24             	mov    %eax,(%esp)
80104f0b:	e8 20 ca ff ff       	call   80101930 <iunlockput>
  ip->nlink--;
80104f10:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f15:	89 1c 24             	mov    %ebx,(%esp)
80104f18:	e8 f3 c6 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
80104f1d:	89 1c 24             	mov    %ebx,(%esp)
80104f20:	e8 0b ca ff ff       	call   80101930 <iunlockput>
  end_op();
80104f25:	e8 76 dc ff ff       	call   80102ba0 <end_op>
}
80104f2a:	83 c4 5c             	add    $0x5c,%esp
  return 0;
80104f2d:	31 c0                	xor    %eax,%eax
}
80104f2f:	5b                   	pop    %ebx
80104f30:	5e                   	pop    %esi
80104f31:	5f                   	pop    %edi
80104f32:	5d                   	pop    %ebp
80104f33:	c3                   	ret    
80104f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104f38:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104f3c:	0f 86 79 ff ff ff    	jbe    80104ebb <sys_unlink+0xbb>
80104f42:	bf 20 00 00 00       	mov    $0x20,%edi
80104f47:	eb 15                	jmp    80104f5e <sys_unlink+0x15e>
80104f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f50:	8d 57 10             	lea    0x10(%edi),%edx
80104f53:	3b 53 58             	cmp    0x58(%ebx),%edx
80104f56:	0f 83 5f ff ff ff    	jae    80104ebb <sys_unlink+0xbb>
80104f5c:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f5e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104f65:	00 
80104f66:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104f6a:	89 74 24 04          	mov    %esi,0x4(%esp)
80104f6e:	89 1c 24             	mov    %ebx,(%esp)
80104f71:	e8 0a ca ff ff       	call   80101980 <readi>
80104f76:	83 f8 10             	cmp    $0x10,%eax
80104f79:	75 42                	jne    80104fbd <sys_unlink+0x1bd>
    if(de.inum != 0)
80104f7b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104f80:	74 ce                	je     80104f50 <sys_unlink+0x150>
    iunlockput(ip);
80104f82:	89 1c 24             	mov    %ebx,(%esp)
80104f85:	e8 a6 c9 ff ff       	call   80101930 <iunlockput>
  iunlockput(dp);
80104f8a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104f8d:	89 04 24             	mov    %eax,(%esp)
80104f90:	e8 9b c9 ff ff       	call   80101930 <iunlockput>
  end_op();
80104f95:	e8 06 dc ff ff       	call   80102ba0 <end_op>
}
80104f9a:	83 c4 5c             	add    $0x5c,%esp
  return -1;
80104f9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fa2:	5b                   	pop    %ebx
80104fa3:	5e                   	pop    %esi
80104fa4:	5f                   	pop    %edi
80104fa5:	5d                   	pop    %ebp
80104fa6:	c3                   	ret    
80104fa7:	90                   	nop
    dp->nlink--;
80104fa8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104fab:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104fb0:	89 04 24             	mov    %eax,(%esp)
80104fb3:	e8 58 c6 ff ff       	call   80101610 <iupdate>
80104fb8:	e9 48 ff ff ff       	jmp    80104f05 <sys_unlink+0x105>
      panic("isdirempty: readi");
80104fbd:	c7 04 24 40 76 10 80 	movl   $0x80107640,(%esp)
80104fc4:	e8 97 b3 ff ff       	call   80100360 <panic>
    panic("unlink: writei");
80104fc9:	c7 04 24 52 76 10 80 	movl   $0x80107652,(%esp)
80104fd0:	e8 8b b3 ff ff       	call   80100360 <panic>
    panic("unlink: nlink < 1");
80104fd5:	c7 04 24 2e 76 10 80 	movl   $0x8010762e,(%esp)
80104fdc:	e8 7f b3 ff ff       	call   80100360 <panic>
80104fe1:	eb 0d                	jmp    80104ff0 <sys_open>
80104fe3:	90                   	nop
80104fe4:	90                   	nop
80104fe5:	90                   	nop
80104fe6:	90                   	nop
80104fe7:	90                   	nop
80104fe8:	90                   	nop
80104fe9:	90                   	nop
80104fea:	90                   	nop
80104feb:	90                   	nop
80104fec:	90                   	nop
80104fed:	90                   	nop
80104fee:	90                   	nop
80104fef:	90                   	nop

80104ff0 <sys_open>:

int
sys_open(void)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	57                   	push   %edi
80104ff4:	56                   	push   %esi
80104ff5:	53                   	push   %ebx
80104ff6:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104ff9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104ffc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105000:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105007:	e8 44 f8 ff ff       	call   80104850 <argstr>
8010500c:	85 c0                	test   %eax,%eax
8010500e:	0f 88 d1 00 00 00    	js     801050e5 <sys_open+0xf5>
80105014:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105017:	89 44 24 04          	mov    %eax,0x4(%esp)
8010501b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105022:	e8 99 f7 ff ff       	call   801047c0 <argint>
80105027:	85 c0                	test   %eax,%eax
80105029:	0f 88 b6 00 00 00    	js     801050e5 <sys_open+0xf5>
    return -1;

  begin_op();
8010502f:	e8 fc da ff ff       	call   80102b30 <begin_op>

  if(omode & O_CREATE){
80105034:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105038:	0f 85 82 00 00 00    	jne    801050c0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010503e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105041:	89 04 24             	mov    %eax,(%esp)
80105044:	e8 d7 ce ff ff       	call   80101f20 <namei>
80105049:	85 c0                	test   %eax,%eax
8010504b:	89 c6                	mov    %eax,%esi
8010504d:	0f 84 8d 00 00 00    	je     801050e0 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80105053:	89 04 24             	mov    %eax,(%esp)
80105056:	e8 75 c6 ff ff       	call   801016d0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
8010505b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105060:	0f 84 92 00 00 00    	je     801050f8 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105066:	e8 25 bd ff ff       	call   80100d90 <filealloc>
8010506b:	85 c0                	test   %eax,%eax
8010506d:	89 c3                	mov    %eax,%ebx
8010506f:	0f 84 93 00 00 00    	je     80105108 <sys_open+0x118>
80105075:	e8 86 f8 ff ff       	call   80104900 <fdalloc>
8010507a:	85 c0                	test   %eax,%eax
8010507c:	89 c7                	mov    %eax,%edi
8010507e:	0f 88 94 00 00 00    	js     80105118 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105084:	89 34 24             	mov    %esi,(%esp)
80105087:	e8 24 c7 ff ff       	call   801017b0 <iunlock>
  end_op();
8010508c:	e8 0f db ff ff       	call   80102ba0 <end_op>

  f->type = FD_INODE;
80105091:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105097:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f->ip = ip;
8010509a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
8010509d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
801050a4:	89 c2                	mov    %eax,%edx
801050a6:	83 e2 01             	and    $0x1,%edx
801050a9:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801050ac:	a8 03                	test   $0x3,%al
  f->readable = !(omode & O_WRONLY);
801050ae:	88 53 08             	mov    %dl,0x8(%ebx)
  return fd;
801050b1:	89 f8                	mov    %edi,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801050b3:	0f 95 43 09          	setne  0x9(%ebx)
}
801050b7:	83 c4 2c             	add    $0x2c,%esp
801050ba:	5b                   	pop    %ebx
801050bb:	5e                   	pop    %esi
801050bc:	5f                   	pop    %edi
801050bd:	5d                   	pop    %ebp
801050be:	c3                   	ret    
801050bf:	90                   	nop
    ip = create(path, T_FILE, 0, 0);
801050c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050c3:	31 c9                	xor    %ecx,%ecx
801050c5:	ba 02 00 00 00       	mov    $0x2,%edx
801050ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050d1:	e8 6a f8 ff ff       	call   80104940 <create>
    if(ip == 0){
801050d6:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801050d8:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801050da:	75 8a                	jne    80105066 <sys_open+0x76>
801050dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801050e0:	e8 bb da ff ff       	call   80102ba0 <end_op>
}
801050e5:	83 c4 2c             	add    $0x2c,%esp
    return -1;
801050e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050ed:	5b                   	pop    %ebx
801050ee:	5e                   	pop    %esi
801050ef:	5f                   	pop    %edi
801050f0:	5d                   	pop    %ebp
801050f1:	c3                   	ret    
801050f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801050f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801050fb:	85 c0                	test   %eax,%eax
801050fd:	0f 84 63 ff ff ff    	je     80105066 <sys_open+0x76>
80105103:	90                   	nop
80105104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80105108:	89 34 24             	mov    %esi,(%esp)
8010510b:	e8 20 c8 ff ff       	call   80101930 <iunlockput>
80105110:	eb ce                	jmp    801050e0 <sys_open+0xf0>
80105112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      fileclose(f);
80105118:	89 1c 24             	mov    %ebx,(%esp)
8010511b:	e8 30 bd ff ff       	call   80100e50 <fileclose>
80105120:	eb e6                	jmp    80105108 <sys_open+0x118>
80105122:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105130 <sys_mkdir>:

int
sys_mkdir(void)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105136:	e8 f5 d9 ff ff       	call   80102b30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010513b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010513e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105142:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105149:	e8 02 f7 ff ff       	call   80104850 <argstr>
8010514e:	85 c0                	test   %eax,%eax
80105150:	78 2e                	js     80105180 <sys_mkdir+0x50>
80105152:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105155:	31 c9                	xor    %ecx,%ecx
80105157:	ba 01 00 00 00       	mov    $0x1,%edx
8010515c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105163:	e8 d8 f7 ff ff       	call   80104940 <create>
80105168:	85 c0                	test   %eax,%eax
8010516a:	74 14                	je     80105180 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010516c:	89 04 24             	mov    %eax,(%esp)
8010516f:	e8 bc c7 ff ff       	call   80101930 <iunlockput>
  end_op();
80105174:	e8 27 da ff ff       	call   80102ba0 <end_op>
  return 0;
80105179:	31 c0                	xor    %eax,%eax
}
8010517b:	c9                   	leave  
8010517c:	c3                   	ret    
8010517d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80105180:	e8 1b da ff ff       	call   80102ba0 <end_op>
    return -1;
80105185:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010518a:	c9                   	leave  
8010518b:	c3                   	ret    
8010518c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105190 <sys_mknod>:

int
sys_mknod(void)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105196:	e8 95 d9 ff ff       	call   80102b30 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010519b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010519e:	89 44 24 04          	mov    %eax,0x4(%esp)
801051a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051a9:	e8 a2 f6 ff ff       	call   80104850 <argstr>
801051ae:	85 c0                	test   %eax,%eax
801051b0:	78 5e                	js     80105210 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801051b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801051b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801051c0:	e8 fb f5 ff ff       	call   801047c0 <argint>
  if((argstr(0, &path)) < 0 ||
801051c5:	85 c0                	test   %eax,%eax
801051c7:	78 47                	js     80105210 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801051c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801051d0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801051d7:	e8 e4 f5 ff ff       	call   801047c0 <argint>
     argint(1, &major) < 0 ||
801051dc:	85 c0                	test   %eax,%eax
801051de:	78 30                	js     80105210 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801051e0:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801051e4:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
801051e9:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801051ed:	89 04 24             	mov    %eax,(%esp)
     argint(2, &minor) < 0 ||
801051f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801051f3:	e8 48 f7 ff ff       	call   80104940 <create>
801051f8:	85 c0                	test   %eax,%eax
801051fa:	74 14                	je     80105210 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801051fc:	89 04 24             	mov    %eax,(%esp)
801051ff:	e8 2c c7 ff ff       	call   80101930 <iunlockput>
  end_op();
80105204:	e8 97 d9 ff ff       	call   80102ba0 <end_op>
  return 0;
80105209:	31 c0                	xor    %eax,%eax
}
8010520b:	c9                   	leave  
8010520c:	c3                   	ret    
8010520d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80105210:	e8 8b d9 ff ff       	call   80102ba0 <end_op>
    return -1;
80105215:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010521a:	c9                   	leave  
8010521b:	c3                   	ret    
8010521c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105220 <sys_chdir>:

int
sys_chdir(void)
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	56                   	push   %esi
80105224:	53                   	push   %ebx
80105225:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105228:	e8 b3 e4 ff ff       	call   801036e0 <myproc>
8010522d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010522f:	e8 fc d8 ff ff       	call   80102b30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105234:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105237:	89 44 24 04          	mov    %eax,0x4(%esp)
8010523b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105242:	e8 09 f6 ff ff       	call   80104850 <argstr>
80105247:	85 c0                	test   %eax,%eax
80105249:	78 4a                	js     80105295 <sys_chdir+0x75>
8010524b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010524e:	89 04 24             	mov    %eax,(%esp)
80105251:	e8 ca cc ff ff       	call   80101f20 <namei>
80105256:	85 c0                	test   %eax,%eax
80105258:	89 c3                	mov    %eax,%ebx
8010525a:	74 39                	je     80105295 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
8010525c:	89 04 24             	mov    %eax,(%esp)
8010525f:	e8 6c c4 ff ff       	call   801016d0 <ilock>
  if(ip->type != T_DIR){
80105264:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105269:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
8010526c:	75 22                	jne    80105290 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
8010526e:	e8 3d c5 ff ff       	call   801017b0 <iunlock>
  iput(curproc->cwd);
80105273:	8b 46 68             	mov    0x68(%esi),%eax
80105276:	89 04 24             	mov    %eax,(%esp)
80105279:	e8 72 c5 ff ff       	call   801017f0 <iput>
  end_op();
8010527e:	e8 1d d9 ff ff       	call   80102ba0 <end_op>
  curproc->cwd = ip;
  return 0;
80105283:	31 c0                	xor    %eax,%eax
  curproc->cwd = ip;
80105285:	89 5e 68             	mov    %ebx,0x68(%esi)
}
80105288:	83 c4 20             	add    $0x20,%esp
8010528b:	5b                   	pop    %ebx
8010528c:	5e                   	pop    %esi
8010528d:	5d                   	pop    %ebp
8010528e:	c3                   	ret    
8010528f:	90                   	nop
    iunlockput(ip);
80105290:	e8 9b c6 ff ff       	call   80101930 <iunlockput>
    end_op();
80105295:	e8 06 d9 ff ff       	call   80102ba0 <end_op>
}
8010529a:	83 c4 20             	add    $0x20,%esp
    return -1;
8010529d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052a2:	5b                   	pop    %ebx
801052a3:	5e                   	pop    %esi
801052a4:	5d                   	pop    %ebp
801052a5:	c3                   	ret    
801052a6:	8d 76 00             	lea    0x0(%esi),%esi
801052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052b0 <sys_exec>:

int
sys_exec(void)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	57                   	push   %edi
801052b4:	56                   	push   %esi
801052b5:	53                   	push   %ebx
801052b6:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801052bc:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801052c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801052c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052cd:	e8 7e f5 ff ff       	call   80104850 <argstr>
801052d2:	85 c0                	test   %eax,%eax
801052d4:	0f 88 84 00 00 00    	js     8010535e <sys_exec+0xae>
801052da:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801052e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801052e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801052eb:	e8 d0 f4 ff ff       	call   801047c0 <argint>
801052f0:	85 c0                	test   %eax,%eax
801052f2:	78 6a                	js     8010535e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801052f4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801052fa:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801052fc:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105303:	00 
80105304:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010530a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105311:	00 
80105312:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105318:	89 04 24             	mov    %eax,(%esp)
8010531b:	e8 b0 f1 ff ff       	call   801044d0 <memset>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105320:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105326:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010532a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010532d:	89 04 24             	mov    %eax,(%esp)
80105330:	e8 eb f3 ff ff       	call   80104720 <fetchint>
80105335:	85 c0                	test   %eax,%eax
80105337:	78 25                	js     8010535e <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80105339:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010533f:	85 c0                	test   %eax,%eax
80105341:	74 2d                	je     80105370 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105343:	89 74 24 04          	mov    %esi,0x4(%esp)
80105347:	89 04 24             	mov    %eax,(%esp)
8010534a:	e8 11 f4 ff ff       	call   80104760 <fetchstr>
8010534f:	85 c0                	test   %eax,%eax
80105351:	78 0b                	js     8010535e <sys_exec+0xae>
  for(i=0;; i++){
80105353:	83 c3 01             	add    $0x1,%ebx
80105356:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105359:	83 fb 20             	cmp    $0x20,%ebx
8010535c:	75 c2                	jne    80105320 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
8010535e:	81 c4 ac 00 00 00    	add    $0xac,%esp
    return -1;
80105364:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105369:	5b                   	pop    %ebx
8010536a:	5e                   	pop    %esi
8010536b:	5f                   	pop    %edi
8010536c:	5d                   	pop    %ebp
8010536d:	c3                   	ret    
8010536e:	66 90                	xchg   %ax,%ax
  return exec(path, argv);
80105370:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105376:	89 44 24 04          	mov    %eax,0x4(%esp)
8010537a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
      argv[i] = 0;
80105380:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105387:	00 00 00 00 
  return exec(path, argv);
8010538b:	89 04 24             	mov    %eax,(%esp)
8010538e:	e8 0d b6 ff ff       	call   801009a0 <exec>
}
80105393:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105399:	5b                   	pop    %ebx
8010539a:	5e                   	pop    %esi
8010539b:	5f                   	pop    %edi
8010539c:	5d                   	pop    %ebp
8010539d:	c3                   	ret    
8010539e:	66 90                	xchg   %ax,%ax

801053a0 <sys_pipe>:

int
sys_pipe(void)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	53                   	push   %ebx
801053a4:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801053a7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053aa:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801053b1:	00 
801053b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801053b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053bd:	e8 2e f4 ff ff       	call   801047f0 <argptr>
801053c2:	85 c0                	test   %eax,%eax
801053c4:	78 6d                	js     80105433 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801053c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801053cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053d0:	89 04 24             	mov    %eax,(%esp)
801053d3:	e8 b8 dd ff ff       	call   80103190 <pipealloc>
801053d8:	85 c0                	test   %eax,%eax
801053da:	78 57                	js     80105433 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801053dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053df:	e8 1c f5 ff ff       	call   80104900 <fdalloc>
801053e4:	85 c0                	test   %eax,%eax
801053e6:	89 c3                	mov    %eax,%ebx
801053e8:	78 33                	js     8010541d <sys_pipe+0x7d>
801053ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053ed:	e8 0e f5 ff ff       	call   80104900 <fdalloc>
801053f2:	85 c0                	test   %eax,%eax
801053f4:	78 1a                	js     80105410 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801053f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801053f9:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
801053fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
801053fe:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
80105401:	83 c4 24             	add    $0x24,%esp
  return 0;
80105404:	31 c0                	xor    %eax,%eax
}
80105406:	5b                   	pop    %ebx
80105407:	5d                   	pop    %ebp
80105408:	c3                   	ret    
80105409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105410:	e8 cb e2 ff ff       	call   801036e0 <myproc>
80105415:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010541c:	00 
    fileclose(rf);
8010541d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105420:	89 04 24             	mov    %eax,(%esp)
80105423:	e8 28 ba ff ff       	call   80100e50 <fileclose>
    fileclose(wf);
80105428:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010542b:	89 04 24             	mov    %eax,(%esp)
8010542e:	e8 1d ba ff ff       	call   80100e50 <fileclose>
}
80105433:	83 c4 24             	add    $0x24,%esp
    return -1;
80105436:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010543b:	5b                   	pop    %ebx
8010543c:	5d                   	pop    %ebp
8010543d:	c3                   	ret    
8010543e:	66 90                	xchg   %ax,%ax

80105440 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105443:	5d                   	pop    %ebp
  return fork();
80105444:	e9 47 e4 ff ff       	jmp    80103890 <fork>
80105449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105450 <sys_exit>:

int
sys_exit(void)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	83 ec 08             	sub    $0x8,%esp
  exit();
80105456:	e8 15 e7 ff ff       	call   80103b70 <exit>
  return 0;  // not reached
}
8010545b:	31 c0                	xor    %eax,%eax
8010545d:	c9                   	leave  
8010545e:	c3                   	ret    
8010545f:	90                   	nop

80105460 <sys_wait>:

int
sys_wait(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105463:	5d                   	pop    %ebp
  return wait();
80105464:	e9 b7 e9 ff ff       	jmp    80103e20 <wait>
80105469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105470 <sys_kill>:

int
sys_kill(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105476:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105479:	89 44 24 04          	mov    %eax,0x4(%esp)
8010547d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105484:	e8 37 f3 ff ff       	call   801047c0 <argint>
80105489:	85 c0                	test   %eax,%eax
8010548b:	78 13                	js     801054a0 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010548d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105490:	89 04 24             	mov    %eax,(%esp)
80105493:	e8 e8 ea ff ff       	call   80103f80 <kill>
}
80105498:	c9                   	leave  
80105499:	c3                   	ret    
8010549a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801054a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054a5:	c9                   	leave  
801054a6:	c3                   	ret    
801054a7:	89 f6                	mov    %esi,%esi
801054a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054b0 <sys_getpid>:

int
sys_getpid(void)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801054b6:	e8 25 e2 ff ff       	call   801036e0 <myproc>
801054bb:	8b 40 10             	mov    0x10(%eax),%eax
}
801054be:	c9                   	leave  
801054bf:	c3                   	ret    

801054c0 <sys_sbrk>:

int
sys_sbrk(void)
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	53                   	push   %ebx
801054c4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801054c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801054ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054d5:	e8 e6 f2 ff ff       	call   801047c0 <argint>
801054da:	85 c0                	test   %eax,%eax
801054dc:	78 22                	js     80105500 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801054de:	e8 fd e1 ff ff       	call   801036e0 <myproc>
  if(growproc(n) < 0)
801054e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  addr = myproc()->sz;
801054e6:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801054e8:	89 14 24             	mov    %edx,(%esp)
801054eb:	e8 30 e3 ff ff       	call   80103820 <growproc>
801054f0:	85 c0                	test   %eax,%eax
801054f2:	78 0c                	js     80105500 <sys_sbrk+0x40>
    return -1;
  return addr;
801054f4:	89 d8                	mov    %ebx,%eax
}
801054f6:	83 c4 24             	add    $0x24,%esp
801054f9:	5b                   	pop    %ebx
801054fa:	5d                   	pop    %ebp
801054fb:	c3                   	ret    
801054fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105505:	eb ef                	jmp    801054f6 <sys_sbrk+0x36>
80105507:	89 f6                	mov    %esi,%esi
80105509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105510 <sys_sleep>:

int
sys_sleep(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	53                   	push   %ebx
80105514:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105517:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010551a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010551e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105525:	e8 96 f2 ff ff       	call   801047c0 <argint>
8010552a:	85 c0                	test   %eax,%eax
8010552c:	78 7e                	js     801055ac <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010552e:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
80105535:	e8 d6 ee ff ff       	call   80104410 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010553a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010553d:	8b 1d a0 59 11 80    	mov    0x801159a0,%ebx
  while(ticks - ticks0 < n){
80105543:	85 d2                	test   %edx,%edx
80105545:	75 29                	jne    80105570 <sys_sleep+0x60>
80105547:	eb 4f                	jmp    80105598 <sys_sleep+0x88>
80105549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105550:	c7 44 24 04 60 51 11 	movl   $0x80115160,0x4(%esp)
80105557:	80 
80105558:	c7 04 24 a0 59 11 80 	movl   $0x801159a0,(%esp)
8010555f:	e8 0c e8 ff ff       	call   80103d70 <sleep>
  while(ticks - ticks0 < n){
80105564:	a1 a0 59 11 80       	mov    0x801159a0,%eax
80105569:	29 d8                	sub    %ebx,%eax
8010556b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010556e:	73 28                	jae    80105598 <sys_sleep+0x88>
    if(myproc()->killed){
80105570:	e8 6b e1 ff ff       	call   801036e0 <myproc>
80105575:	8b 40 24             	mov    0x24(%eax),%eax
80105578:	85 c0                	test   %eax,%eax
8010557a:	74 d4                	je     80105550 <sys_sleep+0x40>
      release(&tickslock);
8010557c:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
80105583:	e8 f8 ee ff ff       	call   80104480 <release>
      return -1;
80105588:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
8010558d:	83 c4 24             	add    $0x24,%esp
80105590:	5b                   	pop    %ebx
80105591:	5d                   	pop    %ebp
80105592:	c3                   	ret    
80105593:	90                   	nop
80105594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
80105598:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
8010559f:	e8 dc ee ff ff       	call   80104480 <release>
}
801055a4:	83 c4 24             	add    $0x24,%esp
  return 0;
801055a7:	31 c0                	xor    %eax,%eax
}
801055a9:	5b                   	pop    %ebx
801055aa:	5d                   	pop    %ebp
801055ab:	c3                   	ret    
    return -1;
801055ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055b1:	eb da                	jmp    8010558d <sys_sleep+0x7d>
801055b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055c0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	53                   	push   %ebx
801055c4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
801055c7:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
801055ce:	e8 3d ee ff ff       	call   80104410 <acquire>
  xticks = ticks;
801055d3:	8b 1d a0 59 11 80    	mov    0x801159a0,%ebx
  release(&tickslock);
801055d9:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
801055e0:	e8 9b ee ff ff       	call   80104480 <release>
  return xticks;
}
801055e5:	83 c4 14             	add    $0x14,%esp
801055e8:	89 d8                	mov    %ebx,%eax
801055ea:	5b                   	pop    %ebx
801055eb:	5d                   	pop    %ebp
801055ec:	c3                   	ret    
801055ed:	8d 76 00             	lea    0x0(%esi),%esi

801055f0 <sys_set_prior>:

// sets priority for current process
int
sys_set_prior(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	83 ec 28             	sub    $0x28,%esp
    int priority;
    if(argint(0, &priority) < 0)
801055f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801055fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105604:	e8 b7 f1 ff ff       	call   801047c0 <argint>
80105609:	85 c0                	test   %eax,%eax
8010560b:	78 13                	js     80105620 <sys_set_prior+0x30>
        return -1;
    set_prior(priority);
8010560d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105610:	89 04 24             	mov    %eax,(%esp)
80105613:	e8 b8 ea ff ff       	call   801040d0 <set_prior>
    return 0;
80105618:	31 c0                	xor    %eax,%eax
}
8010561a:	c9                   	leave  
8010561b:	c3                   	ret    
8010561c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105625:	c9                   	leave  
80105626:	c3                   	ret    
80105627:	89 f6                	mov    %esi,%esi
80105629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105630 <sys_get_prior>:

// gets priority from current process
int
sys_get_prior(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
    return get_prior();
}
80105633:	5d                   	pop    %ebp
    return get_prior();
80105634:	e9 f7 ea ff ff       	jmp    80104130 <get_prior>

80105639 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105639:	1e                   	push   %ds
  pushl %es
8010563a:	06                   	push   %es
  pushl %fs
8010563b:	0f a0                	push   %fs
  pushl %gs
8010563d:	0f a8                	push   %gs
  pushal
8010563f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105640:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105644:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105646:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105648:	54                   	push   %esp
  call trap
80105649:	e8 e2 00 00 00       	call   80105730 <trap>
  addl $4, %esp
8010564e:	83 c4 04             	add    $0x4,%esp

80105651 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105651:	61                   	popa   
  popl %gs
80105652:	0f a9                	pop    %gs
  popl %fs
80105654:	0f a1                	pop    %fs
  popl %es
80105656:	07                   	pop    %es
  popl %ds
80105657:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105658:	83 c4 08             	add    $0x8,%esp
  iret
8010565b:	cf                   	iret   
8010565c:	66 90                	xchg   %ax,%ax
8010565e:	66 90                	xchg   %ax,%ax

80105660 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105660:	31 c0                	xor    %eax,%eax
80105662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105668:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010566f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105674:	66 89 0c c5 a2 51 11 	mov    %cx,-0x7feeae5e(,%eax,8)
8010567b:	80 
8010567c:	c6 04 c5 a4 51 11 80 	movb   $0x0,-0x7feeae5c(,%eax,8)
80105683:	00 
80105684:	c6 04 c5 a5 51 11 80 	movb   $0x8e,-0x7feeae5b(,%eax,8)
8010568b:	8e 
8010568c:	66 89 14 c5 a0 51 11 	mov    %dx,-0x7feeae60(,%eax,8)
80105693:	80 
80105694:	c1 ea 10             	shr    $0x10,%edx
80105697:	66 89 14 c5 a6 51 11 	mov    %dx,-0x7feeae5a(,%eax,8)
8010569e:	80 
  for(i = 0; i < 256; i++)
8010569f:	83 c0 01             	add    $0x1,%eax
801056a2:	3d 00 01 00 00       	cmp    $0x100,%eax
801056a7:	75 bf                	jne    80105668 <tvinit+0x8>
{
801056a9:	55                   	push   %ebp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801056aa:	ba 08 00 00 00       	mov    $0x8,%edx
{
801056af:	89 e5                	mov    %esp,%ebp
801056b1:	83 ec 18             	sub    $0x18,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801056b4:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
801056b9:	c7 44 24 04 61 76 10 	movl   $0x80107661,0x4(%esp)
801056c0:	80 
801056c1:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801056c8:	66 89 15 a2 53 11 80 	mov    %dx,0x801153a2
801056cf:	66 a3 a0 53 11 80    	mov    %ax,0x801153a0
801056d5:	c1 e8 10             	shr    $0x10,%eax
801056d8:	c6 05 a4 53 11 80 00 	movb   $0x0,0x801153a4
801056df:	c6 05 a5 53 11 80 ef 	movb   $0xef,0x801153a5
801056e6:	66 a3 a6 53 11 80    	mov    %ax,0x801153a6
  initlock(&tickslock, "time");
801056ec:	e8 af eb ff ff       	call   801042a0 <initlock>
}
801056f1:	c9                   	leave  
801056f2:	c3                   	ret    
801056f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801056f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105700 <idtinit>:

void
idtinit(void)
{
80105700:	55                   	push   %ebp
  pd[0] = size-1;
80105701:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105706:	89 e5                	mov    %esp,%ebp
80105708:	83 ec 10             	sub    $0x10,%esp
8010570b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010570f:	b8 a0 51 11 80       	mov    $0x801151a0,%eax
80105714:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105718:	c1 e8 10             	shr    $0x10,%eax
8010571b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010571f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105722:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105725:	c9                   	leave  
80105726:	c3                   	ret    
80105727:	89 f6                	mov    %esi,%esi
80105729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105730 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	57                   	push   %edi
80105734:	56                   	push   %esi
80105735:	53                   	push   %ebx
80105736:	83 ec 3c             	sub    $0x3c,%esp
80105739:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010573c:	8b 43 30             	mov    0x30(%ebx),%eax
8010573f:	83 f8 40             	cmp    $0x40,%eax
80105742:	0f 84 a0 01 00 00    	je     801058e8 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105748:	83 e8 20             	sub    $0x20,%eax
8010574b:	83 f8 1f             	cmp    $0x1f,%eax
8010574e:	77 08                	ja     80105758 <trap+0x28>
80105750:	ff 24 85 08 77 10 80 	jmp    *-0x7fef88f8(,%eax,4)
80105757:	90                   	nop
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105758:	e8 83 df ff ff       	call   801036e0 <myproc>
8010575d:	85 c0                	test   %eax,%eax
8010575f:	90                   	nop
80105760:	0f 84 fa 01 00 00    	je     80105960 <trap+0x230>
80105766:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010576a:	0f 84 f0 01 00 00    	je     80105960 <trap+0x230>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105770:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105773:	8b 53 38             	mov    0x38(%ebx),%edx
80105776:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105779:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010577c:	e8 3f df ff ff       	call   801036c0 <cpuid>
80105781:	8b 73 30             	mov    0x30(%ebx),%esi
80105784:	89 c7                	mov    %eax,%edi
80105786:	8b 43 34             	mov    0x34(%ebx),%eax
80105789:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010578c:	e8 4f df ff ff       	call   801036e0 <myproc>
80105791:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105794:	e8 47 df ff ff       	call   801036e0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105799:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010579c:	89 74 24 0c          	mov    %esi,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
801057a0:	8b 75 e0             	mov    -0x20(%ebp),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057a3:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801057a6:	89 7c 24 14          	mov    %edi,0x14(%esp)
801057aa:	89 54 24 18          	mov    %edx,0x18(%esp)
801057ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            myproc()->pid, myproc()->name, tf->trapno,
801057b1:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057b4:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
801057b8:	89 74 24 08          	mov    %esi,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057bc:	89 54 24 10          	mov    %edx,0x10(%esp)
801057c0:	8b 40 10             	mov    0x10(%eax),%eax
801057c3:	c7 04 24 c4 76 10 80 	movl   $0x801076c4,(%esp)
801057ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801057ce:	e8 7d ae ff ff       	call   80100650 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801057d3:	e8 08 df ff ff       	call   801036e0 <myproc>
801057d8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801057df:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801057e0:	e8 fb de ff ff       	call   801036e0 <myproc>
801057e5:	85 c0                	test   %eax,%eax
801057e7:	74 0c                	je     801057f5 <trap+0xc5>
801057e9:	e8 f2 de ff ff       	call   801036e0 <myproc>
801057ee:	8b 50 24             	mov    0x24(%eax),%edx
801057f1:	85 d2                	test   %edx,%edx
801057f3:	75 4b                	jne    80105840 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801057f5:	e8 e6 de ff ff       	call   801036e0 <myproc>
801057fa:	85 c0                	test   %eax,%eax
801057fc:	74 0d                	je     8010580b <trap+0xdb>
801057fe:	66 90                	xchg   %ax,%ax
80105800:	e8 db de ff ff       	call   801036e0 <myproc>
80105805:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105809:	74 4d                	je     80105858 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010580b:	e8 d0 de ff ff       	call   801036e0 <myproc>
80105810:	85 c0                	test   %eax,%eax
80105812:	74 1d                	je     80105831 <trap+0x101>
80105814:	e8 c7 de ff ff       	call   801036e0 <myproc>
80105819:	8b 40 24             	mov    0x24(%eax),%eax
8010581c:	85 c0                	test   %eax,%eax
8010581e:	74 11                	je     80105831 <trap+0x101>
80105820:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105824:	83 e0 03             	and    $0x3,%eax
80105827:	66 83 f8 03          	cmp    $0x3,%ax
8010582b:	0f 84 e8 00 00 00    	je     80105919 <trap+0x1e9>
    exit();
}
80105831:	83 c4 3c             	add    $0x3c,%esp
80105834:	5b                   	pop    %ebx
80105835:	5e                   	pop    %esi
80105836:	5f                   	pop    %edi
80105837:	5d                   	pop    %ebp
80105838:	c3                   	ret    
80105839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105840:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105844:	83 e0 03             	and    $0x3,%eax
80105847:	66 83 f8 03          	cmp    $0x3,%ax
8010584b:	75 a8                	jne    801057f5 <trap+0xc5>
    exit();
8010584d:	e8 1e e3 ff ff       	call   80103b70 <exit>
80105852:	eb a1                	jmp    801057f5 <trap+0xc5>
80105854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105858:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010585c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105860:	75 a9                	jne    8010580b <trap+0xdb>
    yield();
80105862:	e8 c9 e4 ff ff       	call   80103d30 <yield>
80105867:	eb a2                	jmp    8010580b <trap+0xdb>
80105869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105870:	e8 4b de ff ff       	call   801036c0 <cpuid>
80105875:	85 c0                	test   %eax,%eax
80105877:	0f 84 b3 00 00 00    	je     80105930 <trap+0x200>
8010587d:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
80105880:	e8 1b cf ff ff       	call   801027a0 <lapiceoi>
    break;
80105885:	e9 56 ff ff ff       	jmp    801057e0 <trap+0xb0>
8010588a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kbdintr();
80105890:	e8 5b cd ff ff       	call   801025f0 <kbdintr>
    lapiceoi();
80105895:	e8 06 cf ff ff       	call   801027a0 <lapiceoi>
    break;
8010589a:	e9 41 ff ff ff       	jmp    801057e0 <trap+0xb0>
8010589f:	90                   	nop
    uartintr();
801058a0:	e8 1b 02 00 00       	call   80105ac0 <uartintr>
    lapiceoi();
801058a5:	e8 f6 ce ff ff       	call   801027a0 <lapiceoi>
    break;
801058aa:	e9 31 ff ff ff       	jmp    801057e0 <trap+0xb0>
801058af:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801058b0:	8b 7b 38             	mov    0x38(%ebx),%edi
801058b3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801058b7:	e8 04 de ff ff       	call   801036c0 <cpuid>
801058bc:	c7 04 24 6c 76 10 80 	movl   $0x8010766c,(%esp)
801058c3:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801058c7:	89 74 24 08          	mov    %esi,0x8(%esp)
801058cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801058cf:	e8 7c ad ff ff       	call   80100650 <cprintf>
    lapiceoi();
801058d4:	e8 c7 ce ff ff       	call   801027a0 <lapiceoi>
    break;
801058d9:	e9 02 ff ff ff       	jmp    801057e0 <trap+0xb0>
801058de:	66 90                	xchg   %ax,%ax
    ideintr();
801058e0:	e8 bb c7 ff ff       	call   801020a0 <ideintr>
801058e5:	eb 96                	jmp    8010587d <trap+0x14d>
801058e7:	90                   	nop
801058e8:	90                   	nop
801058e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801058f0:	e8 eb dd ff ff       	call   801036e0 <myproc>
801058f5:	8b 70 24             	mov    0x24(%eax),%esi
801058f8:	85 f6                	test   %esi,%esi
801058fa:	75 2c                	jne    80105928 <trap+0x1f8>
    myproc()->tf = tf;
801058fc:	e8 df dd ff ff       	call   801036e0 <myproc>
80105901:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105904:	e8 87 ef ff ff       	call   80104890 <syscall>
    if(myproc()->killed)
80105909:	e8 d2 dd ff ff       	call   801036e0 <myproc>
8010590e:	8b 48 24             	mov    0x24(%eax),%ecx
80105911:	85 c9                	test   %ecx,%ecx
80105913:	0f 84 18 ff ff ff    	je     80105831 <trap+0x101>
}
80105919:	83 c4 3c             	add    $0x3c,%esp
8010591c:	5b                   	pop    %ebx
8010591d:	5e                   	pop    %esi
8010591e:	5f                   	pop    %edi
8010591f:	5d                   	pop    %ebp
      exit();
80105920:	e9 4b e2 ff ff       	jmp    80103b70 <exit>
80105925:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
80105928:	e8 43 e2 ff ff       	call   80103b70 <exit>
8010592d:	eb cd                	jmp    801058fc <trap+0x1cc>
8010592f:	90                   	nop
      acquire(&tickslock);
80105930:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
80105937:	e8 d4 ea ff ff       	call   80104410 <acquire>
      wakeup(&ticks);
8010593c:	c7 04 24 a0 59 11 80 	movl   $0x801159a0,(%esp)
      ticks++;
80105943:	83 05 a0 59 11 80 01 	addl   $0x1,0x801159a0
      wakeup(&ticks);
8010594a:	e8 c1 e5 ff ff       	call   80103f10 <wakeup>
      release(&tickslock);
8010594f:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
80105956:	e8 25 eb ff ff       	call   80104480 <release>
8010595b:	e9 1d ff ff ff       	jmp    8010587d <trap+0x14d>
80105960:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105963:	8b 73 38             	mov    0x38(%ebx),%esi
80105966:	e8 55 dd ff ff       	call   801036c0 <cpuid>
8010596b:	89 7c 24 10          	mov    %edi,0x10(%esp)
8010596f:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105973:	89 44 24 08          	mov    %eax,0x8(%esp)
80105977:	8b 43 30             	mov    0x30(%ebx),%eax
8010597a:	c7 04 24 90 76 10 80 	movl   $0x80107690,(%esp)
80105981:	89 44 24 04          	mov    %eax,0x4(%esp)
80105985:	e8 c6 ac ff ff       	call   80100650 <cprintf>
      panic("trap");
8010598a:	c7 04 24 66 76 10 80 	movl   $0x80107666,(%esp)
80105991:	e8 ca a9 ff ff       	call   80100360 <panic>
80105996:	66 90                	xchg   %ax,%ax
80105998:	66 90                	xchg   %ax,%ax
8010599a:	66 90                	xchg   %ax,%ax
8010599c:	66 90                	xchg   %ax,%ax
8010599e:	66 90                	xchg   %ax,%ax

801059a0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801059a0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
801059a5:	55                   	push   %ebp
801059a6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801059a8:	85 c0                	test   %eax,%eax
801059aa:	74 14                	je     801059c0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801059ac:	ba fd 03 00 00       	mov    $0x3fd,%edx
801059b1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801059b2:	a8 01                	test   $0x1,%al
801059b4:	74 0a                	je     801059c0 <uartgetc+0x20>
801059b6:	b2 f8                	mov    $0xf8,%dl
801059b8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801059b9:	0f b6 c0             	movzbl %al,%eax
}
801059bc:	5d                   	pop    %ebp
801059bd:	c3                   	ret    
801059be:	66 90                	xchg   %ax,%ax
    return -1;
801059c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059c5:	5d                   	pop    %ebp
801059c6:	c3                   	ret    
801059c7:	89 f6                	mov    %esi,%esi
801059c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059d0 <uartputc>:
  if(!uart)
801059d0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
801059d5:	85 c0                	test   %eax,%eax
801059d7:	74 3f                	je     80105a18 <uartputc+0x48>
{
801059d9:	55                   	push   %ebp
801059da:	89 e5                	mov    %esp,%ebp
801059dc:	56                   	push   %esi
801059dd:	be fd 03 00 00       	mov    $0x3fd,%esi
801059e2:	53                   	push   %ebx
  if(!uart)
801059e3:	bb 80 00 00 00       	mov    $0x80,%ebx
{
801059e8:	83 ec 10             	sub    $0x10,%esp
801059eb:	eb 14                	jmp    80105a01 <uartputc+0x31>
801059ed:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
801059f0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801059f7:	e8 c4 cd ff ff       	call   801027c0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801059fc:	83 eb 01             	sub    $0x1,%ebx
801059ff:	74 07                	je     80105a08 <uartputc+0x38>
80105a01:	89 f2                	mov    %esi,%edx
80105a03:	ec                   	in     (%dx),%al
80105a04:	a8 20                	test   $0x20,%al
80105a06:	74 e8                	je     801059f0 <uartputc+0x20>
  outb(COM1+0, c);
80105a08:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105a0c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a11:	ee                   	out    %al,(%dx)
}
80105a12:	83 c4 10             	add    $0x10,%esp
80105a15:	5b                   	pop    %ebx
80105a16:	5e                   	pop    %esi
80105a17:	5d                   	pop    %ebp
80105a18:	f3 c3                	repz ret 
80105a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a20 <uartinit>:
{
80105a20:	55                   	push   %ebp
80105a21:	31 c9                	xor    %ecx,%ecx
80105a23:	89 e5                	mov    %esp,%ebp
80105a25:	89 c8                	mov    %ecx,%eax
80105a27:	57                   	push   %edi
80105a28:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105a2d:	56                   	push   %esi
80105a2e:	89 fa                	mov    %edi,%edx
80105a30:	53                   	push   %ebx
80105a31:	83 ec 1c             	sub    $0x1c,%esp
80105a34:	ee                   	out    %al,(%dx)
80105a35:	be fb 03 00 00       	mov    $0x3fb,%esi
80105a3a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105a3f:	89 f2                	mov    %esi,%edx
80105a41:	ee                   	out    %al,(%dx)
80105a42:	b8 0c 00 00 00       	mov    $0xc,%eax
80105a47:	b2 f8                	mov    $0xf8,%dl
80105a49:	ee                   	out    %al,(%dx)
80105a4a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105a4f:	89 c8                	mov    %ecx,%eax
80105a51:	89 da                	mov    %ebx,%edx
80105a53:	ee                   	out    %al,(%dx)
80105a54:	b8 03 00 00 00       	mov    $0x3,%eax
80105a59:	89 f2                	mov    %esi,%edx
80105a5b:	ee                   	out    %al,(%dx)
80105a5c:	b2 fc                	mov    $0xfc,%dl
80105a5e:	89 c8                	mov    %ecx,%eax
80105a60:	ee                   	out    %al,(%dx)
80105a61:	b8 01 00 00 00       	mov    $0x1,%eax
80105a66:	89 da                	mov    %ebx,%edx
80105a68:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105a69:	b2 fd                	mov    $0xfd,%dl
80105a6b:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105a6c:	3c ff                	cmp    $0xff,%al
80105a6e:	74 42                	je     80105ab2 <uartinit+0x92>
  uart = 1;
80105a70:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105a77:	00 00 00 
80105a7a:	89 fa                	mov    %edi,%edx
80105a7c:	ec                   	in     (%dx),%al
80105a7d:	b2 f8                	mov    $0xf8,%dl
80105a7f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105a80:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105a87:	00 
  for(p="xv6...\n"; *p; p++)
80105a88:	bb 88 77 10 80       	mov    $0x80107788,%ebx
  ioapicenable(IRQ_COM1, 0);
80105a8d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105a94:	e8 37 c8 ff ff       	call   801022d0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105a99:	b8 78 00 00 00       	mov    $0x78,%eax
80105a9e:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105aa0:	89 04 24             	mov    %eax,(%esp)
  for(p="xv6...\n"; *p; p++)
80105aa3:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105aa6:	e8 25 ff ff ff       	call   801059d0 <uartputc>
  for(p="xv6...\n"; *p; p++)
80105aab:	0f be 03             	movsbl (%ebx),%eax
80105aae:	84 c0                	test   %al,%al
80105ab0:	75 ee                	jne    80105aa0 <uartinit+0x80>
}
80105ab2:	83 c4 1c             	add    $0x1c,%esp
80105ab5:	5b                   	pop    %ebx
80105ab6:	5e                   	pop    %esi
80105ab7:	5f                   	pop    %edi
80105ab8:	5d                   	pop    %ebp
80105ab9:	c3                   	ret    
80105aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ac0 <uartintr>:

void
uartintr(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105ac6:	c7 04 24 a0 59 10 80 	movl   $0x801059a0,(%esp)
80105acd:	e8 de ac ff ff       	call   801007b0 <consoleintr>
}
80105ad2:	c9                   	leave  
80105ad3:	c3                   	ret    

80105ad4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105ad4:	6a 00                	push   $0x0
  pushl $0
80105ad6:	6a 00                	push   $0x0
  jmp alltraps
80105ad8:	e9 5c fb ff ff       	jmp    80105639 <alltraps>

80105add <vector1>:
.globl vector1
vector1:
  pushl $0
80105add:	6a 00                	push   $0x0
  pushl $1
80105adf:	6a 01                	push   $0x1
  jmp alltraps
80105ae1:	e9 53 fb ff ff       	jmp    80105639 <alltraps>

80105ae6 <vector2>:
.globl vector2
vector2:
  pushl $0
80105ae6:	6a 00                	push   $0x0
  pushl $2
80105ae8:	6a 02                	push   $0x2
  jmp alltraps
80105aea:	e9 4a fb ff ff       	jmp    80105639 <alltraps>

80105aef <vector3>:
.globl vector3
vector3:
  pushl $0
80105aef:	6a 00                	push   $0x0
  pushl $3
80105af1:	6a 03                	push   $0x3
  jmp alltraps
80105af3:	e9 41 fb ff ff       	jmp    80105639 <alltraps>

80105af8 <vector4>:
.globl vector4
vector4:
  pushl $0
80105af8:	6a 00                	push   $0x0
  pushl $4
80105afa:	6a 04                	push   $0x4
  jmp alltraps
80105afc:	e9 38 fb ff ff       	jmp    80105639 <alltraps>

80105b01 <vector5>:
.globl vector5
vector5:
  pushl $0
80105b01:	6a 00                	push   $0x0
  pushl $5
80105b03:	6a 05                	push   $0x5
  jmp alltraps
80105b05:	e9 2f fb ff ff       	jmp    80105639 <alltraps>

80105b0a <vector6>:
.globl vector6
vector6:
  pushl $0
80105b0a:	6a 00                	push   $0x0
  pushl $6
80105b0c:	6a 06                	push   $0x6
  jmp alltraps
80105b0e:	e9 26 fb ff ff       	jmp    80105639 <alltraps>

80105b13 <vector7>:
.globl vector7
vector7:
  pushl $0
80105b13:	6a 00                	push   $0x0
  pushl $7
80105b15:	6a 07                	push   $0x7
  jmp alltraps
80105b17:	e9 1d fb ff ff       	jmp    80105639 <alltraps>

80105b1c <vector8>:
.globl vector8
vector8:
  pushl $8
80105b1c:	6a 08                	push   $0x8
  jmp alltraps
80105b1e:	e9 16 fb ff ff       	jmp    80105639 <alltraps>

80105b23 <vector9>:
.globl vector9
vector9:
  pushl $0
80105b23:	6a 00                	push   $0x0
  pushl $9
80105b25:	6a 09                	push   $0x9
  jmp alltraps
80105b27:	e9 0d fb ff ff       	jmp    80105639 <alltraps>

80105b2c <vector10>:
.globl vector10
vector10:
  pushl $10
80105b2c:	6a 0a                	push   $0xa
  jmp alltraps
80105b2e:	e9 06 fb ff ff       	jmp    80105639 <alltraps>

80105b33 <vector11>:
.globl vector11
vector11:
  pushl $11
80105b33:	6a 0b                	push   $0xb
  jmp alltraps
80105b35:	e9 ff fa ff ff       	jmp    80105639 <alltraps>

80105b3a <vector12>:
.globl vector12
vector12:
  pushl $12
80105b3a:	6a 0c                	push   $0xc
  jmp alltraps
80105b3c:	e9 f8 fa ff ff       	jmp    80105639 <alltraps>

80105b41 <vector13>:
.globl vector13
vector13:
  pushl $13
80105b41:	6a 0d                	push   $0xd
  jmp alltraps
80105b43:	e9 f1 fa ff ff       	jmp    80105639 <alltraps>

80105b48 <vector14>:
.globl vector14
vector14:
  pushl $14
80105b48:	6a 0e                	push   $0xe
  jmp alltraps
80105b4a:	e9 ea fa ff ff       	jmp    80105639 <alltraps>

80105b4f <vector15>:
.globl vector15
vector15:
  pushl $0
80105b4f:	6a 00                	push   $0x0
  pushl $15
80105b51:	6a 0f                	push   $0xf
  jmp alltraps
80105b53:	e9 e1 fa ff ff       	jmp    80105639 <alltraps>

80105b58 <vector16>:
.globl vector16
vector16:
  pushl $0
80105b58:	6a 00                	push   $0x0
  pushl $16
80105b5a:	6a 10                	push   $0x10
  jmp alltraps
80105b5c:	e9 d8 fa ff ff       	jmp    80105639 <alltraps>

80105b61 <vector17>:
.globl vector17
vector17:
  pushl $17
80105b61:	6a 11                	push   $0x11
  jmp alltraps
80105b63:	e9 d1 fa ff ff       	jmp    80105639 <alltraps>

80105b68 <vector18>:
.globl vector18
vector18:
  pushl $0
80105b68:	6a 00                	push   $0x0
  pushl $18
80105b6a:	6a 12                	push   $0x12
  jmp alltraps
80105b6c:	e9 c8 fa ff ff       	jmp    80105639 <alltraps>

80105b71 <vector19>:
.globl vector19
vector19:
  pushl $0
80105b71:	6a 00                	push   $0x0
  pushl $19
80105b73:	6a 13                	push   $0x13
  jmp alltraps
80105b75:	e9 bf fa ff ff       	jmp    80105639 <alltraps>

80105b7a <vector20>:
.globl vector20
vector20:
  pushl $0
80105b7a:	6a 00                	push   $0x0
  pushl $20
80105b7c:	6a 14                	push   $0x14
  jmp alltraps
80105b7e:	e9 b6 fa ff ff       	jmp    80105639 <alltraps>

80105b83 <vector21>:
.globl vector21
vector21:
  pushl $0
80105b83:	6a 00                	push   $0x0
  pushl $21
80105b85:	6a 15                	push   $0x15
  jmp alltraps
80105b87:	e9 ad fa ff ff       	jmp    80105639 <alltraps>

80105b8c <vector22>:
.globl vector22
vector22:
  pushl $0
80105b8c:	6a 00                	push   $0x0
  pushl $22
80105b8e:	6a 16                	push   $0x16
  jmp alltraps
80105b90:	e9 a4 fa ff ff       	jmp    80105639 <alltraps>

80105b95 <vector23>:
.globl vector23
vector23:
  pushl $0
80105b95:	6a 00                	push   $0x0
  pushl $23
80105b97:	6a 17                	push   $0x17
  jmp alltraps
80105b99:	e9 9b fa ff ff       	jmp    80105639 <alltraps>

80105b9e <vector24>:
.globl vector24
vector24:
  pushl $0
80105b9e:	6a 00                	push   $0x0
  pushl $24
80105ba0:	6a 18                	push   $0x18
  jmp alltraps
80105ba2:	e9 92 fa ff ff       	jmp    80105639 <alltraps>

80105ba7 <vector25>:
.globl vector25
vector25:
  pushl $0
80105ba7:	6a 00                	push   $0x0
  pushl $25
80105ba9:	6a 19                	push   $0x19
  jmp alltraps
80105bab:	e9 89 fa ff ff       	jmp    80105639 <alltraps>

80105bb0 <vector26>:
.globl vector26
vector26:
  pushl $0
80105bb0:	6a 00                	push   $0x0
  pushl $26
80105bb2:	6a 1a                	push   $0x1a
  jmp alltraps
80105bb4:	e9 80 fa ff ff       	jmp    80105639 <alltraps>

80105bb9 <vector27>:
.globl vector27
vector27:
  pushl $0
80105bb9:	6a 00                	push   $0x0
  pushl $27
80105bbb:	6a 1b                	push   $0x1b
  jmp alltraps
80105bbd:	e9 77 fa ff ff       	jmp    80105639 <alltraps>

80105bc2 <vector28>:
.globl vector28
vector28:
  pushl $0
80105bc2:	6a 00                	push   $0x0
  pushl $28
80105bc4:	6a 1c                	push   $0x1c
  jmp alltraps
80105bc6:	e9 6e fa ff ff       	jmp    80105639 <alltraps>

80105bcb <vector29>:
.globl vector29
vector29:
  pushl $0
80105bcb:	6a 00                	push   $0x0
  pushl $29
80105bcd:	6a 1d                	push   $0x1d
  jmp alltraps
80105bcf:	e9 65 fa ff ff       	jmp    80105639 <alltraps>

80105bd4 <vector30>:
.globl vector30
vector30:
  pushl $0
80105bd4:	6a 00                	push   $0x0
  pushl $30
80105bd6:	6a 1e                	push   $0x1e
  jmp alltraps
80105bd8:	e9 5c fa ff ff       	jmp    80105639 <alltraps>

80105bdd <vector31>:
.globl vector31
vector31:
  pushl $0
80105bdd:	6a 00                	push   $0x0
  pushl $31
80105bdf:	6a 1f                	push   $0x1f
  jmp alltraps
80105be1:	e9 53 fa ff ff       	jmp    80105639 <alltraps>

80105be6 <vector32>:
.globl vector32
vector32:
  pushl $0
80105be6:	6a 00                	push   $0x0
  pushl $32
80105be8:	6a 20                	push   $0x20
  jmp alltraps
80105bea:	e9 4a fa ff ff       	jmp    80105639 <alltraps>

80105bef <vector33>:
.globl vector33
vector33:
  pushl $0
80105bef:	6a 00                	push   $0x0
  pushl $33
80105bf1:	6a 21                	push   $0x21
  jmp alltraps
80105bf3:	e9 41 fa ff ff       	jmp    80105639 <alltraps>

80105bf8 <vector34>:
.globl vector34
vector34:
  pushl $0
80105bf8:	6a 00                	push   $0x0
  pushl $34
80105bfa:	6a 22                	push   $0x22
  jmp alltraps
80105bfc:	e9 38 fa ff ff       	jmp    80105639 <alltraps>

80105c01 <vector35>:
.globl vector35
vector35:
  pushl $0
80105c01:	6a 00                	push   $0x0
  pushl $35
80105c03:	6a 23                	push   $0x23
  jmp alltraps
80105c05:	e9 2f fa ff ff       	jmp    80105639 <alltraps>

80105c0a <vector36>:
.globl vector36
vector36:
  pushl $0
80105c0a:	6a 00                	push   $0x0
  pushl $36
80105c0c:	6a 24                	push   $0x24
  jmp alltraps
80105c0e:	e9 26 fa ff ff       	jmp    80105639 <alltraps>

80105c13 <vector37>:
.globl vector37
vector37:
  pushl $0
80105c13:	6a 00                	push   $0x0
  pushl $37
80105c15:	6a 25                	push   $0x25
  jmp alltraps
80105c17:	e9 1d fa ff ff       	jmp    80105639 <alltraps>

80105c1c <vector38>:
.globl vector38
vector38:
  pushl $0
80105c1c:	6a 00                	push   $0x0
  pushl $38
80105c1e:	6a 26                	push   $0x26
  jmp alltraps
80105c20:	e9 14 fa ff ff       	jmp    80105639 <alltraps>

80105c25 <vector39>:
.globl vector39
vector39:
  pushl $0
80105c25:	6a 00                	push   $0x0
  pushl $39
80105c27:	6a 27                	push   $0x27
  jmp alltraps
80105c29:	e9 0b fa ff ff       	jmp    80105639 <alltraps>

80105c2e <vector40>:
.globl vector40
vector40:
  pushl $0
80105c2e:	6a 00                	push   $0x0
  pushl $40
80105c30:	6a 28                	push   $0x28
  jmp alltraps
80105c32:	e9 02 fa ff ff       	jmp    80105639 <alltraps>

80105c37 <vector41>:
.globl vector41
vector41:
  pushl $0
80105c37:	6a 00                	push   $0x0
  pushl $41
80105c39:	6a 29                	push   $0x29
  jmp alltraps
80105c3b:	e9 f9 f9 ff ff       	jmp    80105639 <alltraps>

80105c40 <vector42>:
.globl vector42
vector42:
  pushl $0
80105c40:	6a 00                	push   $0x0
  pushl $42
80105c42:	6a 2a                	push   $0x2a
  jmp alltraps
80105c44:	e9 f0 f9 ff ff       	jmp    80105639 <alltraps>

80105c49 <vector43>:
.globl vector43
vector43:
  pushl $0
80105c49:	6a 00                	push   $0x0
  pushl $43
80105c4b:	6a 2b                	push   $0x2b
  jmp alltraps
80105c4d:	e9 e7 f9 ff ff       	jmp    80105639 <alltraps>

80105c52 <vector44>:
.globl vector44
vector44:
  pushl $0
80105c52:	6a 00                	push   $0x0
  pushl $44
80105c54:	6a 2c                	push   $0x2c
  jmp alltraps
80105c56:	e9 de f9 ff ff       	jmp    80105639 <alltraps>

80105c5b <vector45>:
.globl vector45
vector45:
  pushl $0
80105c5b:	6a 00                	push   $0x0
  pushl $45
80105c5d:	6a 2d                	push   $0x2d
  jmp alltraps
80105c5f:	e9 d5 f9 ff ff       	jmp    80105639 <alltraps>

80105c64 <vector46>:
.globl vector46
vector46:
  pushl $0
80105c64:	6a 00                	push   $0x0
  pushl $46
80105c66:	6a 2e                	push   $0x2e
  jmp alltraps
80105c68:	e9 cc f9 ff ff       	jmp    80105639 <alltraps>

80105c6d <vector47>:
.globl vector47
vector47:
  pushl $0
80105c6d:	6a 00                	push   $0x0
  pushl $47
80105c6f:	6a 2f                	push   $0x2f
  jmp alltraps
80105c71:	e9 c3 f9 ff ff       	jmp    80105639 <alltraps>

80105c76 <vector48>:
.globl vector48
vector48:
  pushl $0
80105c76:	6a 00                	push   $0x0
  pushl $48
80105c78:	6a 30                	push   $0x30
  jmp alltraps
80105c7a:	e9 ba f9 ff ff       	jmp    80105639 <alltraps>

80105c7f <vector49>:
.globl vector49
vector49:
  pushl $0
80105c7f:	6a 00                	push   $0x0
  pushl $49
80105c81:	6a 31                	push   $0x31
  jmp alltraps
80105c83:	e9 b1 f9 ff ff       	jmp    80105639 <alltraps>

80105c88 <vector50>:
.globl vector50
vector50:
  pushl $0
80105c88:	6a 00                	push   $0x0
  pushl $50
80105c8a:	6a 32                	push   $0x32
  jmp alltraps
80105c8c:	e9 a8 f9 ff ff       	jmp    80105639 <alltraps>

80105c91 <vector51>:
.globl vector51
vector51:
  pushl $0
80105c91:	6a 00                	push   $0x0
  pushl $51
80105c93:	6a 33                	push   $0x33
  jmp alltraps
80105c95:	e9 9f f9 ff ff       	jmp    80105639 <alltraps>

80105c9a <vector52>:
.globl vector52
vector52:
  pushl $0
80105c9a:	6a 00                	push   $0x0
  pushl $52
80105c9c:	6a 34                	push   $0x34
  jmp alltraps
80105c9e:	e9 96 f9 ff ff       	jmp    80105639 <alltraps>

80105ca3 <vector53>:
.globl vector53
vector53:
  pushl $0
80105ca3:	6a 00                	push   $0x0
  pushl $53
80105ca5:	6a 35                	push   $0x35
  jmp alltraps
80105ca7:	e9 8d f9 ff ff       	jmp    80105639 <alltraps>

80105cac <vector54>:
.globl vector54
vector54:
  pushl $0
80105cac:	6a 00                	push   $0x0
  pushl $54
80105cae:	6a 36                	push   $0x36
  jmp alltraps
80105cb0:	e9 84 f9 ff ff       	jmp    80105639 <alltraps>

80105cb5 <vector55>:
.globl vector55
vector55:
  pushl $0
80105cb5:	6a 00                	push   $0x0
  pushl $55
80105cb7:	6a 37                	push   $0x37
  jmp alltraps
80105cb9:	e9 7b f9 ff ff       	jmp    80105639 <alltraps>

80105cbe <vector56>:
.globl vector56
vector56:
  pushl $0
80105cbe:	6a 00                	push   $0x0
  pushl $56
80105cc0:	6a 38                	push   $0x38
  jmp alltraps
80105cc2:	e9 72 f9 ff ff       	jmp    80105639 <alltraps>

80105cc7 <vector57>:
.globl vector57
vector57:
  pushl $0
80105cc7:	6a 00                	push   $0x0
  pushl $57
80105cc9:	6a 39                	push   $0x39
  jmp alltraps
80105ccb:	e9 69 f9 ff ff       	jmp    80105639 <alltraps>

80105cd0 <vector58>:
.globl vector58
vector58:
  pushl $0
80105cd0:	6a 00                	push   $0x0
  pushl $58
80105cd2:	6a 3a                	push   $0x3a
  jmp alltraps
80105cd4:	e9 60 f9 ff ff       	jmp    80105639 <alltraps>

80105cd9 <vector59>:
.globl vector59
vector59:
  pushl $0
80105cd9:	6a 00                	push   $0x0
  pushl $59
80105cdb:	6a 3b                	push   $0x3b
  jmp alltraps
80105cdd:	e9 57 f9 ff ff       	jmp    80105639 <alltraps>

80105ce2 <vector60>:
.globl vector60
vector60:
  pushl $0
80105ce2:	6a 00                	push   $0x0
  pushl $60
80105ce4:	6a 3c                	push   $0x3c
  jmp alltraps
80105ce6:	e9 4e f9 ff ff       	jmp    80105639 <alltraps>

80105ceb <vector61>:
.globl vector61
vector61:
  pushl $0
80105ceb:	6a 00                	push   $0x0
  pushl $61
80105ced:	6a 3d                	push   $0x3d
  jmp alltraps
80105cef:	e9 45 f9 ff ff       	jmp    80105639 <alltraps>

80105cf4 <vector62>:
.globl vector62
vector62:
  pushl $0
80105cf4:	6a 00                	push   $0x0
  pushl $62
80105cf6:	6a 3e                	push   $0x3e
  jmp alltraps
80105cf8:	e9 3c f9 ff ff       	jmp    80105639 <alltraps>

80105cfd <vector63>:
.globl vector63
vector63:
  pushl $0
80105cfd:	6a 00                	push   $0x0
  pushl $63
80105cff:	6a 3f                	push   $0x3f
  jmp alltraps
80105d01:	e9 33 f9 ff ff       	jmp    80105639 <alltraps>

80105d06 <vector64>:
.globl vector64
vector64:
  pushl $0
80105d06:	6a 00                	push   $0x0
  pushl $64
80105d08:	6a 40                	push   $0x40
  jmp alltraps
80105d0a:	e9 2a f9 ff ff       	jmp    80105639 <alltraps>

80105d0f <vector65>:
.globl vector65
vector65:
  pushl $0
80105d0f:	6a 00                	push   $0x0
  pushl $65
80105d11:	6a 41                	push   $0x41
  jmp alltraps
80105d13:	e9 21 f9 ff ff       	jmp    80105639 <alltraps>

80105d18 <vector66>:
.globl vector66
vector66:
  pushl $0
80105d18:	6a 00                	push   $0x0
  pushl $66
80105d1a:	6a 42                	push   $0x42
  jmp alltraps
80105d1c:	e9 18 f9 ff ff       	jmp    80105639 <alltraps>

80105d21 <vector67>:
.globl vector67
vector67:
  pushl $0
80105d21:	6a 00                	push   $0x0
  pushl $67
80105d23:	6a 43                	push   $0x43
  jmp alltraps
80105d25:	e9 0f f9 ff ff       	jmp    80105639 <alltraps>

80105d2a <vector68>:
.globl vector68
vector68:
  pushl $0
80105d2a:	6a 00                	push   $0x0
  pushl $68
80105d2c:	6a 44                	push   $0x44
  jmp alltraps
80105d2e:	e9 06 f9 ff ff       	jmp    80105639 <alltraps>

80105d33 <vector69>:
.globl vector69
vector69:
  pushl $0
80105d33:	6a 00                	push   $0x0
  pushl $69
80105d35:	6a 45                	push   $0x45
  jmp alltraps
80105d37:	e9 fd f8 ff ff       	jmp    80105639 <alltraps>

80105d3c <vector70>:
.globl vector70
vector70:
  pushl $0
80105d3c:	6a 00                	push   $0x0
  pushl $70
80105d3e:	6a 46                	push   $0x46
  jmp alltraps
80105d40:	e9 f4 f8 ff ff       	jmp    80105639 <alltraps>

80105d45 <vector71>:
.globl vector71
vector71:
  pushl $0
80105d45:	6a 00                	push   $0x0
  pushl $71
80105d47:	6a 47                	push   $0x47
  jmp alltraps
80105d49:	e9 eb f8 ff ff       	jmp    80105639 <alltraps>

80105d4e <vector72>:
.globl vector72
vector72:
  pushl $0
80105d4e:	6a 00                	push   $0x0
  pushl $72
80105d50:	6a 48                	push   $0x48
  jmp alltraps
80105d52:	e9 e2 f8 ff ff       	jmp    80105639 <alltraps>

80105d57 <vector73>:
.globl vector73
vector73:
  pushl $0
80105d57:	6a 00                	push   $0x0
  pushl $73
80105d59:	6a 49                	push   $0x49
  jmp alltraps
80105d5b:	e9 d9 f8 ff ff       	jmp    80105639 <alltraps>

80105d60 <vector74>:
.globl vector74
vector74:
  pushl $0
80105d60:	6a 00                	push   $0x0
  pushl $74
80105d62:	6a 4a                	push   $0x4a
  jmp alltraps
80105d64:	e9 d0 f8 ff ff       	jmp    80105639 <alltraps>

80105d69 <vector75>:
.globl vector75
vector75:
  pushl $0
80105d69:	6a 00                	push   $0x0
  pushl $75
80105d6b:	6a 4b                	push   $0x4b
  jmp alltraps
80105d6d:	e9 c7 f8 ff ff       	jmp    80105639 <alltraps>

80105d72 <vector76>:
.globl vector76
vector76:
  pushl $0
80105d72:	6a 00                	push   $0x0
  pushl $76
80105d74:	6a 4c                	push   $0x4c
  jmp alltraps
80105d76:	e9 be f8 ff ff       	jmp    80105639 <alltraps>

80105d7b <vector77>:
.globl vector77
vector77:
  pushl $0
80105d7b:	6a 00                	push   $0x0
  pushl $77
80105d7d:	6a 4d                	push   $0x4d
  jmp alltraps
80105d7f:	e9 b5 f8 ff ff       	jmp    80105639 <alltraps>

80105d84 <vector78>:
.globl vector78
vector78:
  pushl $0
80105d84:	6a 00                	push   $0x0
  pushl $78
80105d86:	6a 4e                	push   $0x4e
  jmp alltraps
80105d88:	e9 ac f8 ff ff       	jmp    80105639 <alltraps>

80105d8d <vector79>:
.globl vector79
vector79:
  pushl $0
80105d8d:	6a 00                	push   $0x0
  pushl $79
80105d8f:	6a 4f                	push   $0x4f
  jmp alltraps
80105d91:	e9 a3 f8 ff ff       	jmp    80105639 <alltraps>

80105d96 <vector80>:
.globl vector80
vector80:
  pushl $0
80105d96:	6a 00                	push   $0x0
  pushl $80
80105d98:	6a 50                	push   $0x50
  jmp alltraps
80105d9a:	e9 9a f8 ff ff       	jmp    80105639 <alltraps>

80105d9f <vector81>:
.globl vector81
vector81:
  pushl $0
80105d9f:	6a 00                	push   $0x0
  pushl $81
80105da1:	6a 51                	push   $0x51
  jmp alltraps
80105da3:	e9 91 f8 ff ff       	jmp    80105639 <alltraps>

80105da8 <vector82>:
.globl vector82
vector82:
  pushl $0
80105da8:	6a 00                	push   $0x0
  pushl $82
80105daa:	6a 52                	push   $0x52
  jmp alltraps
80105dac:	e9 88 f8 ff ff       	jmp    80105639 <alltraps>

80105db1 <vector83>:
.globl vector83
vector83:
  pushl $0
80105db1:	6a 00                	push   $0x0
  pushl $83
80105db3:	6a 53                	push   $0x53
  jmp alltraps
80105db5:	e9 7f f8 ff ff       	jmp    80105639 <alltraps>

80105dba <vector84>:
.globl vector84
vector84:
  pushl $0
80105dba:	6a 00                	push   $0x0
  pushl $84
80105dbc:	6a 54                	push   $0x54
  jmp alltraps
80105dbe:	e9 76 f8 ff ff       	jmp    80105639 <alltraps>

80105dc3 <vector85>:
.globl vector85
vector85:
  pushl $0
80105dc3:	6a 00                	push   $0x0
  pushl $85
80105dc5:	6a 55                	push   $0x55
  jmp alltraps
80105dc7:	e9 6d f8 ff ff       	jmp    80105639 <alltraps>

80105dcc <vector86>:
.globl vector86
vector86:
  pushl $0
80105dcc:	6a 00                	push   $0x0
  pushl $86
80105dce:	6a 56                	push   $0x56
  jmp alltraps
80105dd0:	e9 64 f8 ff ff       	jmp    80105639 <alltraps>

80105dd5 <vector87>:
.globl vector87
vector87:
  pushl $0
80105dd5:	6a 00                	push   $0x0
  pushl $87
80105dd7:	6a 57                	push   $0x57
  jmp alltraps
80105dd9:	e9 5b f8 ff ff       	jmp    80105639 <alltraps>

80105dde <vector88>:
.globl vector88
vector88:
  pushl $0
80105dde:	6a 00                	push   $0x0
  pushl $88
80105de0:	6a 58                	push   $0x58
  jmp alltraps
80105de2:	e9 52 f8 ff ff       	jmp    80105639 <alltraps>

80105de7 <vector89>:
.globl vector89
vector89:
  pushl $0
80105de7:	6a 00                	push   $0x0
  pushl $89
80105de9:	6a 59                	push   $0x59
  jmp alltraps
80105deb:	e9 49 f8 ff ff       	jmp    80105639 <alltraps>

80105df0 <vector90>:
.globl vector90
vector90:
  pushl $0
80105df0:	6a 00                	push   $0x0
  pushl $90
80105df2:	6a 5a                	push   $0x5a
  jmp alltraps
80105df4:	e9 40 f8 ff ff       	jmp    80105639 <alltraps>

80105df9 <vector91>:
.globl vector91
vector91:
  pushl $0
80105df9:	6a 00                	push   $0x0
  pushl $91
80105dfb:	6a 5b                	push   $0x5b
  jmp alltraps
80105dfd:	e9 37 f8 ff ff       	jmp    80105639 <alltraps>

80105e02 <vector92>:
.globl vector92
vector92:
  pushl $0
80105e02:	6a 00                	push   $0x0
  pushl $92
80105e04:	6a 5c                	push   $0x5c
  jmp alltraps
80105e06:	e9 2e f8 ff ff       	jmp    80105639 <alltraps>

80105e0b <vector93>:
.globl vector93
vector93:
  pushl $0
80105e0b:	6a 00                	push   $0x0
  pushl $93
80105e0d:	6a 5d                	push   $0x5d
  jmp alltraps
80105e0f:	e9 25 f8 ff ff       	jmp    80105639 <alltraps>

80105e14 <vector94>:
.globl vector94
vector94:
  pushl $0
80105e14:	6a 00                	push   $0x0
  pushl $94
80105e16:	6a 5e                	push   $0x5e
  jmp alltraps
80105e18:	e9 1c f8 ff ff       	jmp    80105639 <alltraps>

80105e1d <vector95>:
.globl vector95
vector95:
  pushl $0
80105e1d:	6a 00                	push   $0x0
  pushl $95
80105e1f:	6a 5f                	push   $0x5f
  jmp alltraps
80105e21:	e9 13 f8 ff ff       	jmp    80105639 <alltraps>

80105e26 <vector96>:
.globl vector96
vector96:
  pushl $0
80105e26:	6a 00                	push   $0x0
  pushl $96
80105e28:	6a 60                	push   $0x60
  jmp alltraps
80105e2a:	e9 0a f8 ff ff       	jmp    80105639 <alltraps>

80105e2f <vector97>:
.globl vector97
vector97:
  pushl $0
80105e2f:	6a 00                	push   $0x0
  pushl $97
80105e31:	6a 61                	push   $0x61
  jmp alltraps
80105e33:	e9 01 f8 ff ff       	jmp    80105639 <alltraps>

80105e38 <vector98>:
.globl vector98
vector98:
  pushl $0
80105e38:	6a 00                	push   $0x0
  pushl $98
80105e3a:	6a 62                	push   $0x62
  jmp alltraps
80105e3c:	e9 f8 f7 ff ff       	jmp    80105639 <alltraps>

80105e41 <vector99>:
.globl vector99
vector99:
  pushl $0
80105e41:	6a 00                	push   $0x0
  pushl $99
80105e43:	6a 63                	push   $0x63
  jmp alltraps
80105e45:	e9 ef f7 ff ff       	jmp    80105639 <alltraps>

80105e4a <vector100>:
.globl vector100
vector100:
  pushl $0
80105e4a:	6a 00                	push   $0x0
  pushl $100
80105e4c:	6a 64                	push   $0x64
  jmp alltraps
80105e4e:	e9 e6 f7 ff ff       	jmp    80105639 <alltraps>

80105e53 <vector101>:
.globl vector101
vector101:
  pushl $0
80105e53:	6a 00                	push   $0x0
  pushl $101
80105e55:	6a 65                	push   $0x65
  jmp alltraps
80105e57:	e9 dd f7 ff ff       	jmp    80105639 <alltraps>

80105e5c <vector102>:
.globl vector102
vector102:
  pushl $0
80105e5c:	6a 00                	push   $0x0
  pushl $102
80105e5e:	6a 66                	push   $0x66
  jmp alltraps
80105e60:	e9 d4 f7 ff ff       	jmp    80105639 <alltraps>

80105e65 <vector103>:
.globl vector103
vector103:
  pushl $0
80105e65:	6a 00                	push   $0x0
  pushl $103
80105e67:	6a 67                	push   $0x67
  jmp alltraps
80105e69:	e9 cb f7 ff ff       	jmp    80105639 <alltraps>

80105e6e <vector104>:
.globl vector104
vector104:
  pushl $0
80105e6e:	6a 00                	push   $0x0
  pushl $104
80105e70:	6a 68                	push   $0x68
  jmp alltraps
80105e72:	e9 c2 f7 ff ff       	jmp    80105639 <alltraps>

80105e77 <vector105>:
.globl vector105
vector105:
  pushl $0
80105e77:	6a 00                	push   $0x0
  pushl $105
80105e79:	6a 69                	push   $0x69
  jmp alltraps
80105e7b:	e9 b9 f7 ff ff       	jmp    80105639 <alltraps>

80105e80 <vector106>:
.globl vector106
vector106:
  pushl $0
80105e80:	6a 00                	push   $0x0
  pushl $106
80105e82:	6a 6a                	push   $0x6a
  jmp alltraps
80105e84:	e9 b0 f7 ff ff       	jmp    80105639 <alltraps>

80105e89 <vector107>:
.globl vector107
vector107:
  pushl $0
80105e89:	6a 00                	push   $0x0
  pushl $107
80105e8b:	6a 6b                	push   $0x6b
  jmp alltraps
80105e8d:	e9 a7 f7 ff ff       	jmp    80105639 <alltraps>

80105e92 <vector108>:
.globl vector108
vector108:
  pushl $0
80105e92:	6a 00                	push   $0x0
  pushl $108
80105e94:	6a 6c                	push   $0x6c
  jmp alltraps
80105e96:	e9 9e f7 ff ff       	jmp    80105639 <alltraps>

80105e9b <vector109>:
.globl vector109
vector109:
  pushl $0
80105e9b:	6a 00                	push   $0x0
  pushl $109
80105e9d:	6a 6d                	push   $0x6d
  jmp alltraps
80105e9f:	e9 95 f7 ff ff       	jmp    80105639 <alltraps>

80105ea4 <vector110>:
.globl vector110
vector110:
  pushl $0
80105ea4:	6a 00                	push   $0x0
  pushl $110
80105ea6:	6a 6e                	push   $0x6e
  jmp alltraps
80105ea8:	e9 8c f7 ff ff       	jmp    80105639 <alltraps>

80105ead <vector111>:
.globl vector111
vector111:
  pushl $0
80105ead:	6a 00                	push   $0x0
  pushl $111
80105eaf:	6a 6f                	push   $0x6f
  jmp alltraps
80105eb1:	e9 83 f7 ff ff       	jmp    80105639 <alltraps>

80105eb6 <vector112>:
.globl vector112
vector112:
  pushl $0
80105eb6:	6a 00                	push   $0x0
  pushl $112
80105eb8:	6a 70                	push   $0x70
  jmp alltraps
80105eba:	e9 7a f7 ff ff       	jmp    80105639 <alltraps>

80105ebf <vector113>:
.globl vector113
vector113:
  pushl $0
80105ebf:	6a 00                	push   $0x0
  pushl $113
80105ec1:	6a 71                	push   $0x71
  jmp alltraps
80105ec3:	e9 71 f7 ff ff       	jmp    80105639 <alltraps>

80105ec8 <vector114>:
.globl vector114
vector114:
  pushl $0
80105ec8:	6a 00                	push   $0x0
  pushl $114
80105eca:	6a 72                	push   $0x72
  jmp alltraps
80105ecc:	e9 68 f7 ff ff       	jmp    80105639 <alltraps>

80105ed1 <vector115>:
.globl vector115
vector115:
  pushl $0
80105ed1:	6a 00                	push   $0x0
  pushl $115
80105ed3:	6a 73                	push   $0x73
  jmp alltraps
80105ed5:	e9 5f f7 ff ff       	jmp    80105639 <alltraps>

80105eda <vector116>:
.globl vector116
vector116:
  pushl $0
80105eda:	6a 00                	push   $0x0
  pushl $116
80105edc:	6a 74                	push   $0x74
  jmp alltraps
80105ede:	e9 56 f7 ff ff       	jmp    80105639 <alltraps>

80105ee3 <vector117>:
.globl vector117
vector117:
  pushl $0
80105ee3:	6a 00                	push   $0x0
  pushl $117
80105ee5:	6a 75                	push   $0x75
  jmp alltraps
80105ee7:	e9 4d f7 ff ff       	jmp    80105639 <alltraps>

80105eec <vector118>:
.globl vector118
vector118:
  pushl $0
80105eec:	6a 00                	push   $0x0
  pushl $118
80105eee:	6a 76                	push   $0x76
  jmp alltraps
80105ef0:	e9 44 f7 ff ff       	jmp    80105639 <alltraps>

80105ef5 <vector119>:
.globl vector119
vector119:
  pushl $0
80105ef5:	6a 00                	push   $0x0
  pushl $119
80105ef7:	6a 77                	push   $0x77
  jmp alltraps
80105ef9:	e9 3b f7 ff ff       	jmp    80105639 <alltraps>

80105efe <vector120>:
.globl vector120
vector120:
  pushl $0
80105efe:	6a 00                	push   $0x0
  pushl $120
80105f00:	6a 78                	push   $0x78
  jmp alltraps
80105f02:	e9 32 f7 ff ff       	jmp    80105639 <alltraps>

80105f07 <vector121>:
.globl vector121
vector121:
  pushl $0
80105f07:	6a 00                	push   $0x0
  pushl $121
80105f09:	6a 79                	push   $0x79
  jmp alltraps
80105f0b:	e9 29 f7 ff ff       	jmp    80105639 <alltraps>

80105f10 <vector122>:
.globl vector122
vector122:
  pushl $0
80105f10:	6a 00                	push   $0x0
  pushl $122
80105f12:	6a 7a                	push   $0x7a
  jmp alltraps
80105f14:	e9 20 f7 ff ff       	jmp    80105639 <alltraps>

80105f19 <vector123>:
.globl vector123
vector123:
  pushl $0
80105f19:	6a 00                	push   $0x0
  pushl $123
80105f1b:	6a 7b                	push   $0x7b
  jmp alltraps
80105f1d:	e9 17 f7 ff ff       	jmp    80105639 <alltraps>

80105f22 <vector124>:
.globl vector124
vector124:
  pushl $0
80105f22:	6a 00                	push   $0x0
  pushl $124
80105f24:	6a 7c                	push   $0x7c
  jmp alltraps
80105f26:	e9 0e f7 ff ff       	jmp    80105639 <alltraps>

80105f2b <vector125>:
.globl vector125
vector125:
  pushl $0
80105f2b:	6a 00                	push   $0x0
  pushl $125
80105f2d:	6a 7d                	push   $0x7d
  jmp alltraps
80105f2f:	e9 05 f7 ff ff       	jmp    80105639 <alltraps>

80105f34 <vector126>:
.globl vector126
vector126:
  pushl $0
80105f34:	6a 00                	push   $0x0
  pushl $126
80105f36:	6a 7e                	push   $0x7e
  jmp alltraps
80105f38:	e9 fc f6 ff ff       	jmp    80105639 <alltraps>

80105f3d <vector127>:
.globl vector127
vector127:
  pushl $0
80105f3d:	6a 00                	push   $0x0
  pushl $127
80105f3f:	6a 7f                	push   $0x7f
  jmp alltraps
80105f41:	e9 f3 f6 ff ff       	jmp    80105639 <alltraps>

80105f46 <vector128>:
.globl vector128
vector128:
  pushl $0
80105f46:	6a 00                	push   $0x0
  pushl $128
80105f48:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105f4d:	e9 e7 f6 ff ff       	jmp    80105639 <alltraps>

80105f52 <vector129>:
.globl vector129
vector129:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $129
80105f54:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105f59:	e9 db f6 ff ff       	jmp    80105639 <alltraps>

80105f5e <vector130>:
.globl vector130
vector130:
  pushl $0
80105f5e:	6a 00                	push   $0x0
  pushl $130
80105f60:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105f65:	e9 cf f6 ff ff       	jmp    80105639 <alltraps>

80105f6a <vector131>:
.globl vector131
vector131:
  pushl $0
80105f6a:	6a 00                	push   $0x0
  pushl $131
80105f6c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105f71:	e9 c3 f6 ff ff       	jmp    80105639 <alltraps>

80105f76 <vector132>:
.globl vector132
vector132:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $132
80105f78:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105f7d:	e9 b7 f6 ff ff       	jmp    80105639 <alltraps>

80105f82 <vector133>:
.globl vector133
vector133:
  pushl $0
80105f82:	6a 00                	push   $0x0
  pushl $133
80105f84:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105f89:	e9 ab f6 ff ff       	jmp    80105639 <alltraps>

80105f8e <vector134>:
.globl vector134
vector134:
  pushl $0
80105f8e:	6a 00                	push   $0x0
  pushl $134
80105f90:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105f95:	e9 9f f6 ff ff       	jmp    80105639 <alltraps>

80105f9a <vector135>:
.globl vector135
vector135:
  pushl $0
80105f9a:	6a 00                	push   $0x0
  pushl $135
80105f9c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105fa1:	e9 93 f6 ff ff       	jmp    80105639 <alltraps>

80105fa6 <vector136>:
.globl vector136
vector136:
  pushl $0
80105fa6:	6a 00                	push   $0x0
  pushl $136
80105fa8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105fad:	e9 87 f6 ff ff       	jmp    80105639 <alltraps>

80105fb2 <vector137>:
.globl vector137
vector137:
  pushl $0
80105fb2:	6a 00                	push   $0x0
  pushl $137
80105fb4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105fb9:	e9 7b f6 ff ff       	jmp    80105639 <alltraps>

80105fbe <vector138>:
.globl vector138
vector138:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $138
80105fc0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105fc5:	e9 6f f6 ff ff       	jmp    80105639 <alltraps>

80105fca <vector139>:
.globl vector139
vector139:
  pushl $0
80105fca:	6a 00                	push   $0x0
  pushl $139
80105fcc:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105fd1:	e9 63 f6 ff ff       	jmp    80105639 <alltraps>

80105fd6 <vector140>:
.globl vector140
vector140:
  pushl $0
80105fd6:	6a 00                	push   $0x0
  pushl $140
80105fd8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105fdd:	e9 57 f6 ff ff       	jmp    80105639 <alltraps>

80105fe2 <vector141>:
.globl vector141
vector141:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $141
80105fe4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105fe9:	e9 4b f6 ff ff       	jmp    80105639 <alltraps>

80105fee <vector142>:
.globl vector142
vector142:
  pushl $0
80105fee:	6a 00                	push   $0x0
  pushl $142
80105ff0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105ff5:	e9 3f f6 ff ff       	jmp    80105639 <alltraps>

80105ffa <vector143>:
.globl vector143
vector143:
  pushl $0
80105ffa:	6a 00                	push   $0x0
  pushl $143
80105ffc:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106001:	e9 33 f6 ff ff       	jmp    80105639 <alltraps>

80106006 <vector144>:
.globl vector144
vector144:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $144
80106008:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010600d:	e9 27 f6 ff ff       	jmp    80105639 <alltraps>

80106012 <vector145>:
.globl vector145
vector145:
  pushl $0
80106012:	6a 00                	push   $0x0
  pushl $145
80106014:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106019:	e9 1b f6 ff ff       	jmp    80105639 <alltraps>

8010601e <vector146>:
.globl vector146
vector146:
  pushl $0
8010601e:	6a 00                	push   $0x0
  pushl $146
80106020:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106025:	e9 0f f6 ff ff       	jmp    80105639 <alltraps>

8010602a <vector147>:
.globl vector147
vector147:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $147
8010602c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106031:	e9 03 f6 ff ff       	jmp    80105639 <alltraps>

80106036 <vector148>:
.globl vector148
vector148:
  pushl $0
80106036:	6a 00                	push   $0x0
  pushl $148
80106038:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010603d:	e9 f7 f5 ff ff       	jmp    80105639 <alltraps>

80106042 <vector149>:
.globl vector149
vector149:
  pushl $0
80106042:	6a 00                	push   $0x0
  pushl $149
80106044:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106049:	e9 eb f5 ff ff       	jmp    80105639 <alltraps>

8010604e <vector150>:
.globl vector150
vector150:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $150
80106050:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106055:	e9 df f5 ff ff       	jmp    80105639 <alltraps>

8010605a <vector151>:
.globl vector151
vector151:
  pushl $0
8010605a:	6a 00                	push   $0x0
  pushl $151
8010605c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106061:	e9 d3 f5 ff ff       	jmp    80105639 <alltraps>

80106066 <vector152>:
.globl vector152
vector152:
  pushl $0
80106066:	6a 00                	push   $0x0
  pushl $152
80106068:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010606d:	e9 c7 f5 ff ff       	jmp    80105639 <alltraps>

80106072 <vector153>:
.globl vector153
vector153:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $153
80106074:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106079:	e9 bb f5 ff ff       	jmp    80105639 <alltraps>

8010607e <vector154>:
.globl vector154
vector154:
  pushl $0
8010607e:	6a 00                	push   $0x0
  pushl $154
80106080:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106085:	e9 af f5 ff ff       	jmp    80105639 <alltraps>

8010608a <vector155>:
.globl vector155
vector155:
  pushl $0
8010608a:	6a 00                	push   $0x0
  pushl $155
8010608c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106091:	e9 a3 f5 ff ff       	jmp    80105639 <alltraps>

80106096 <vector156>:
.globl vector156
vector156:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $156
80106098:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010609d:	e9 97 f5 ff ff       	jmp    80105639 <alltraps>

801060a2 <vector157>:
.globl vector157
vector157:
  pushl $0
801060a2:	6a 00                	push   $0x0
  pushl $157
801060a4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801060a9:	e9 8b f5 ff ff       	jmp    80105639 <alltraps>

801060ae <vector158>:
.globl vector158
vector158:
  pushl $0
801060ae:	6a 00                	push   $0x0
  pushl $158
801060b0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801060b5:	e9 7f f5 ff ff       	jmp    80105639 <alltraps>

801060ba <vector159>:
.globl vector159
vector159:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $159
801060bc:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801060c1:	e9 73 f5 ff ff       	jmp    80105639 <alltraps>

801060c6 <vector160>:
.globl vector160
vector160:
  pushl $0
801060c6:	6a 00                	push   $0x0
  pushl $160
801060c8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801060cd:	e9 67 f5 ff ff       	jmp    80105639 <alltraps>

801060d2 <vector161>:
.globl vector161
vector161:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $161
801060d4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801060d9:	e9 5b f5 ff ff       	jmp    80105639 <alltraps>

801060de <vector162>:
.globl vector162
vector162:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $162
801060e0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801060e5:	e9 4f f5 ff ff       	jmp    80105639 <alltraps>

801060ea <vector163>:
.globl vector163
vector163:
  pushl $0
801060ea:	6a 00                	push   $0x0
  pushl $163
801060ec:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801060f1:	e9 43 f5 ff ff       	jmp    80105639 <alltraps>

801060f6 <vector164>:
.globl vector164
vector164:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $164
801060f8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801060fd:	e9 37 f5 ff ff       	jmp    80105639 <alltraps>

80106102 <vector165>:
.globl vector165
vector165:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $165
80106104:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106109:	e9 2b f5 ff ff       	jmp    80105639 <alltraps>

8010610e <vector166>:
.globl vector166
vector166:
  pushl $0
8010610e:	6a 00                	push   $0x0
  pushl $166
80106110:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106115:	e9 1f f5 ff ff       	jmp    80105639 <alltraps>

8010611a <vector167>:
.globl vector167
vector167:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $167
8010611c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106121:	e9 13 f5 ff ff       	jmp    80105639 <alltraps>

80106126 <vector168>:
.globl vector168
vector168:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $168
80106128:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010612d:	e9 07 f5 ff ff       	jmp    80105639 <alltraps>

80106132 <vector169>:
.globl vector169
vector169:
  pushl $0
80106132:	6a 00                	push   $0x0
  pushl $169
80106134:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106139:	e9 fb f4 ff ff       	jmp    80105639 <alltraps>

8010613e <vector170>:
.globl vector170
vector170:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $170
80106140:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106145:	e9 ef f4 ff ff       	jmp    80105639 <alltraps>

8010614a <vector171>:
.globl vector171
vector171:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $171
8010614c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106151:	e9 e3 f4 ff ff       	jmp    80105639 <alltraps>

80106156 <vector172>:
.globl vector172
vector172:
  pushl $0
80106156:	6a 00                	push   $0x0
  pushl $172
80106158:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010615d:	e9 d7 f4 ff ff       	jmp    80105639 <alltraps>

80106162 <vector173>:
.globl vector173
vector173:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $173
80106164:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106169:	e9 cb f4 ff ff       	jmp    80105639 <alltraps>

8010616e <vector174>:
.globl vector174
vector174:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $174
80106170:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106175:	e9 bf f4 ff ff       	jmp    80105639 <alltraps>

8010617a <vector175>:
.globl vector175
vector175:
  pushl $0
8010617a:	6a 00                	push   $0x0
  pushl $175
8010617c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106181:	e9 b3 f4 ff ff       	jmp    80105639 <alltraps>

80106186 <vector176>:
.globl vector176
vector176:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $176
80106188:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010618d:	e9 a7 f4 ff ff       	jmp    80105639 <alltraps>

80106192 <vector177>:
.globl vector177
vector177:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $177
80106194:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106199:	e9 9b f4 ff ff       	jmp    80105639 <alltraps>

8010619e <vector178>:
.globl vector178
vector178:
  pushl $0
8010619e:	6a 00                	push   $0x0
  pushl $178
801061a0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801061a5:	e9 8f f4 ff ff       	jmp    80105639 <alltraps>

801061aa <vector179>:
.globl vector179
vector179:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $179
801061ac:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801061b1:	e9 83 f4 ff ff       	jmp    80105639 <alltraps>

801061b6 <vector180>:
.globl vector180
vector180:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $180
801061b8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801061bd:	e9 77 f4 ff ff       	jmp    80105639 <alltraps>

801061c2 <vector181>:
.globl vector181
vector181:
  pushl $0
801061c2:	6a 00                	push   $0x0
  pushl $181
801061c4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801061c9:	e9 6b f4 ff ff       	jmp    80105639 <alltraps>

801061ce <vector182>:
.globl vector182
vector182:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $182
801061d0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801061d5:	e9 5f f4 ff ff       	jmp    80105639 <alltraps>

801061da <vector183>:
.globl vector183
vector183:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $183
801061dc:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801061e1:	e9 53 f4 ff ff       	jmp    80105639 <alltraps>

801061e6 <vector184>:
.globl vector184
vector184:
  pushl $0
801061e6:	6a 00                	push   $0x0
  pushl $184
801061e8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801061ed:	e9 47 f4 ff ff       	jmp    80105639 <alltraps>

801061f2 <vector185>:
.globl vector185
vector185:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $185
801061f4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801061f9:	e9 3b f4 ff ff       	jmp    80105639 <alltraps>

801061fe <vector186>:
.globl vector186
vector186:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $186
80106200:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106205:	e9 2f f4 ff ff       	jmp    80105639 <alltraps>

8010620a <vector187>:
.globl vector187
vector187:
  pushl $0
8010620a:	6a 00                	push   $0x0
  pushl $187
8010620c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106211:	e9 23 f4 ff ff       	jmp    80105639 <alltraps>

80106216 <vector188>:
.globl vector188
vector188:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $188
80106218:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010621d:	e9 17 f4 ff ff       	jmp    80105639 <alltraps>

80106222 <vector189>:
.globl vector189
vector189:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $189
80106224:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106229:	e9 0b f4 ff ff       	jmp    80105639 <alltraps>

8010622e <vector190>:
.globl vector190
vector190:
  pushl $0
8010622e:	6a 00                	push   $0x0
  pushl $190
80106230:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106235:	e9 ff f3 ff ff       	jmp    80105639 <alltraps>

8010623a <vector191>:
.globl vector191
vector191:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $191
8010623c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106241:	e9 f3 f3 ff ff       	jmp    80105639 <alltraps>

80106246 <vector192>:
.globl vector192
vector192:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $192
80106248:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010624d:	e9 e7 f3 ff ff       	jmp    80105639 <alltraps>

80106252 <vector193>:
.globl vector193
vector193:
  pushl $0
80106252:	6a 00                	push   $0x0
  pushl $193
80106254:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106259:	e9 db f3 ff ff       	jmp    80105639 <alltraps>

8010625e <vector194>:
.globl vector194
vector194:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $194
80106260:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106265:	e9 cf f3 ff ff       	jmp    80105639 <alltraps>

8010626a <vector195>:
.globl vector195
vector195:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $195
8010626c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106271:	e9 c3 f3 ff ff       	jmp    80105639 <alltraps>

80106276 <vector196>:
.globl vector196
vector196:
  pushl $0
80106276:	6a 00                	push   $0x0
  pushl $196
80106278:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010627d:	e9 b7 f3 ff ff       	jmp    80105639 <alltraps>

80106282 <vector197>:
.globl vector197
vector197:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $197
80106284:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106289:	e9 ab f3 ff ff       	jmp    80105639 <alltraps>

8010628e <vector198>:
.globl vector198
vector198:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $198
80106290:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106295:	e9 9f f3 ff ff       	jmp    80105639 <alltraps>

8010629a <vector199>:
.globl vector199
vector199:
  pushl $0
8010629a:	6a 00                	push   $0x0
  pushl $199
8010629c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801062a1:	e9 93 f3 ff ff       	jmp    80105639 <alltraps>

801062a6 <vector200>:
.globl vector200
vector200:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $200
801062a8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801062ad:	e9 87 f3 ff ff       	jmp    80105639 <alltraps>

801062b2 <vector201>:
.globl vector201
vector201:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $201
801062b4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801062b9:	e9 7b f3 ff ff       	jmp    80105639 <alltraps>

801062be <vector202>:
.globl vector202
vector202:
  pushl $0
801062be:	6a 00                	push   $0x0
  pushl $202
801062c0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801062c5:	e9 6f f3 ff ff       	jmp    80105639 <alltraps>

801062ca <vector203>:
.globl vector203
vector203:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $203
801062cc:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801062d1:	e9 63 f3 ff ff       	jmp    80105639 <alltraps>

801062d6 <vector204>:
.globl vector204
vector204:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $204
801062d8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801062dd:	e9 57 f3 ff ff       	jmp    80105639 <alltraps>

801062e2 <vector205>:
.globl vector205
vector205:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $205
801062e4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801062e9:	e9 4b f3 ff ff       	jmp    80105639 <alltraps>

801062ee <vector206>:
.globl vector206
vector206:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $206
801062f0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801062f5:	e9 3f f3 ff ff       	jmp    80105639 <alltraps>

801062fa <vector207>:
.globl vector207
vector207:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $207
801062fc:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106301:	e9 33 f3 ff ff       	jmp    80105639 <alltraps>

80106306 <vector208>:
.globl vector208
vector208:
  pushl $0
80106306:	6a 00                	push   $0x0
  pushl $208
80106308:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010630d:	e9 27 f3 ff ff       	jmp    80105639 <alltraps>

80106312 <vector209>:
.globl vector209
vector209:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $209
80106314:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106319:	e9 1b f3 ff ff       	jmp    80105639 <alltraps>

8010631e <vector210>:
.globl vector210
vector210:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $210
80106320:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106325:	e9 0f f3 ff ff       	jmp    80105639 <alltraps>

8010632a <vector211>:
.globl vector211
vector211:
  pushl $0
8010632a:	6a 00                	push   $0x0
  pushl $211
8010632c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106331:	e9 03 f3 ff ff       	jmp    80105639 <alltraps>

80106336 <vector212>:
.globl vector212
vector212:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $212
80106338:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010633d:	e9 f7 f2 ff ff       	jmp    80105639 <alltraps>

80106342 <vector213>:
.globl vector213
vector213:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $213
80106344:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106349:	e9 eb f2 ff ff       	jmp    80105639 <alltraps>

8010634e <vector214>:
.globl vector214
vector214:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $214
80106350:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106355:	e9 df f2 ff ff       	jmp    80105639 <alltraps>

8010635a <vector215>:
.globl vector215
vector215:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $215
8010635c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106361:	e9 d3 f2 ff ff       	jmp    80105639 <alltraps>

80106366 <vector216>:
.globl vector216
vector216:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $216
80106368:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010636d:	e9 c7 f2 ff ff       	jmp    80105639 <alltraps>

80106372 <vector217>:
.globl vector217
vector217:
  pushl $0
80106372:	6a 00                	push   $0x0
  pushl $217
80106374:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106379:	e9 bb f2 ff ff       	jmp    80105639 <alltraps>

8010637e <vector218>:
.globl vector218
vector218:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $218
80106380:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106385:	e9 af f2 ff ff       	jmp    80105639 <alltraps>

8010638a <vector219>:
.globl vector219
vector219:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $219
8010638c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106391:	e9 a3 f2 ff ff       	jmp    80105639 <alltraps>

80106396 <vector220>:
.globl vector220
vector220:
  pushl $0
80106396:	6a 00                	push   $0x0
  pushl $220
80106398:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010639d:	e9 97 f2 ff ff       	jmp    80105639 <alltraps>

801063a2 <vector221>:
.globl vector221
vector221:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $221
801063a4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801063a9:	e9 8b f2 ff ff       	jmp    80105639 <alltraps>

801063ae <vector222>:
.globl vector222
vector222:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $222
801063b0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801063b5:	e9 7f f2 ff ff       	jmp    80105639 <alltraps>

801063ba <vector223>:
.globl vector223
vector223:
  pushl $0
801063ba:	6a 00                	push   $0x0
  pushl $223
801063bc:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801063c1:	e9 73 f2 ff ff       	jmp    80105639 <alltraps>

801063c6 <vector224>:
.globl vector224
vector224:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $224
801063c8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801063cd:	e9 67 f2 ff ff       	jmp    80105639 <alltraps>

801063d2 <vector225>:
.globl vector225
vector225:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $225
801063d4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801063d9:	e9 5b f2 ff ff       	jmp    80105639 <alltraps>

801063de <vector226>:
.globl vector226
vector226:
  pushl $0
801063de:	6a 00                	push   $0x0
  pushl $226
801063e0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801063e5:	e9 4f f2 ff ff       	jmp    80105639 <alltraps>

801063ea <vector227>:
.globl vector227
vector227:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $227
801063ec:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801063f1:	e9 43 f2 ff ff       	jmp    80105639 <alltraps>

801063f6 <vector228>:
.globl vector228
vector228:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $228
801063f8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801063fd:	e9 37 f2 ff ff       	jmp    80105639 <alltraps>

80106402 <vector229>:
.globl vector229
vector229:
  pushl $0
80106402:	6a 00                	push   $0x0
  pushl $229
80106404:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106409:	e9 2b f2 ff ff       	jmp    80105639 <alltraps>

8010640e <vector230>:
.globl vector230
vector230:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $230
80106410:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106415:	e9 1f f2 ff ff       	jmp    80105639 <alltraps>

8010641a <vector231>:
.globl vector231
vector231:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $231
8010641c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106421:	e9 13 f2 ff ff       	jmp    80105639 <alltraps>

80106426 <vector232>:
.globl vector232
vector232:
  pushl $0
80106426:	6a 00                	push   $0x0
  pushl $232
80106428:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010642d:	e9 07 f2 ff ff       	jmp    80105639 <alltraps>

80106432 <vector233>:
.globl vector233
vector233:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $233
80106434:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106439:	e9 fb f1 ff ff       	jmp    80105639 <alltraps>

8010643e <vector234>:
.globl vector234
vector234:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $234
80106440:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106445:	e9 ef f1 ff ff       	jmp    80105639 <alltraps>

8010644a <vector235>:
.globl vector235
vector235:
  pushl $0
8010644a:	6a 00                	push   $0x0
  pushl $235
8010644c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106451:	e9 e3 f1 ff ff       	jmp    80105639 <alltraps>

80106456 <vector236>:
.globl vector236
vector236:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $236
80106458:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010645d:	e9 d7 f1 ff ff       	jmp    80105639 <alltraps>

80106462 <vector237>:
.globl vector237
vector237:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $237
80106464:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106469:	e9 cb f1 ff ff       	jmp    80105639 <alltraps>

8010646e <vector238>:
.globl vector238
vector238:
  pushl $0
8010646e:	6a 00                	push   $0x0
  pushl $238
80106470:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106475:	e9 bf f1 ff ff       	jmp    80105639 <alltraps>

8010647a <vector239>:
.globl vector239
vector239:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $239
8010647c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106481:	e9 b3 f1 ff ff       	jmp    80105639 <alltraps>

80106486 <vector240>:
.globl vector240
vector240:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $240
80106488:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010648d:	e9 a7 f1 ff ff       	jmp    80105639 <alltraps>

80106492 <vector241>:
.globl vector241
vector241:
  pushl $0
80106492:	6a 00                	push   $0x0
  pushl $241
80106494:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106499:	e9 9b f1 ff ff       	jmp    80105639 <alltraps>

8010649e <vector242>:
.globl vector242
vector242:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $242
801064a0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801064a5:	e9 8f f1 ff ff       	jmp    80105639 <alltraps>

801064aa <vector243>:
.globl vector243
vector243:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $243
801064ac:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801064b1:	e9 83 f1 ff ff       	jmp    80105639 <alltraps>

801064b6 <vector244>:
.globl vector244
vector244:
  pushl $0
801064b6:	6a 00                	push   $0x0
  pushl $244
801064b8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801064bd:	e9 77 f1 ff ff       	jmp    80105639 <alltraps>

801064c2 <vector245>:
.globl vector245
vector245:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $245
801064c4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801064c9:	e9 6b f1 ff ff       	jmp    80105639 <alltraps>

801064ce <vector246>:
.globl vector246
vector246:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $246
801064d0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801064d5:	e9 5f f1 ff ff       	jmp    80105639 <alltraps>

801064da <vector247>:
.globl vector247
vector247:
  pushl $0
801064da:	6a 00                	push   $0x0
  pushl $247
801064dc:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801064e1:	e9 53 f1 ff ff       	jmp    80105639 <alltraps>

801064e6 <vector248>:
.globl vector248
vector248:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $248
801064e8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801064ed:	e9 47 f1 ff ff       	jmp    80105639 <alltraps>

801064f2 <vector249>:
.globl vector249
vector249:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $249
801064f4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801064f9:	e9 3b f1 ff ff       	jmp    80105639 <alltraps>

801064fe <vector250>:
.globl vector250
vector250:
  pushl $0
801064fe:	6a 00                	push   $0x0
  pushl $250
80106500:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106505:	e9 2f f1 ff ff       	jmp    80105639 <alltraps>

8010650a <vector251>:
.globl vector251
vector251:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $251
8010650c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106511:	e9 23 f1 ff ff       	jmp    80105639 <alltraps>

80106516 <vector252>:
.globl vector252
vector252:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $252
80106518:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010651d:	e9 17 f1 ff ff       	jmp    80105639 <alltraps>

80106522 <vector253>:
.globl vector253
vector253:
  pushl $0
80106522:	6a 00                	push   $0x0
  pushl $253
80106524:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106529:	e9 0b f1 ff ff       	jmp    80105639 <alltraps>

8010652e <vector254>:
.globl vector254
vector254:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $254
80106530:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106535:	e9 ff f0 ff ff       	jmp    80105639 <alltraps>

8010653a <vector255>:
.globl vector255
vector255:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $255
8010653c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106541:	e9 f3 f0 ff ff       	jmp    80105639 <alltraps>
80106546:	66 90                	xchg   %ax,%ax
80106548:	66 90                	xchg   %ax,%ax
8010654a:	66 90                	xchg   %ax,%ax
8010654c:	66 90                	xchg   %ax,%ax
8010654e:	66 90                	xchg   %ax,%ax

80106550 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
80106553:	57                   	push   %edi
80106554:	56                   	push   %esi
80106555:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106557:	c1 ea 16             	shr    $0x16,%edx
{
8010655a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010655b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010655e:	83 ec 1c             	sub    $0x1c,%esp
  if(*pde & PTE_P){
80106561:	8b 1f                	mov    (%edi),%ebx
80106563:	f6 c3 01             	test   $0x1,%bl
80106566:	74 28                	je     80106590 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106568:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010656e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106574:	c1 ee 0a             	shr    $0xa,%esi
}
80106577:	83 c4 1c             	add    $0x1c,%esp
  return &pgtab[PTX(va)];
8010657a:	89 f2                	mov    %esi,%edx
8010657c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106582:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106585:	5b                   	pop    %ebx
80106586:	5e                   	pop    %esi
80106587:	5f                   	pop    %edi
80106588:	5d                   	pop    %ebp
80106589:	c3                   	ret    
8010658a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106590:	85 c9                	test   %ecx,%ecx
80106592:	74 34                	je     801065c8 <walkpgdir+0x78>
80106594:	e8 27 bf ff ff       	call   801024c0 <kalloc>
80106599:	85 c0                	test   %eax,%eax
8010659b:	89 c3                	mov    %eax,%ebx
8010659d:	74 29                	je     801065c8 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
8010659f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801065a6:	00 
801065a7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801065ae:	00 
801065af:	89 04 24             	mov    %eax,(%esp)
801065b2:	e8 19 df ff ff       	call   801044d0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801065b7:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801065bd:	83 c8 07             	or     $0x7,%eax
801065c0:	89 07                	mov    %eax,(%edi)
801065c2:	eb b0                	jmp    80106574 <walkpgdir+0x24>
801065c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
801065c8:	83 c4 1c             	add    $0x1c,%esp
      return 0;
801065cb:	31 c0                	xor    %eax,%eax
}
801065cd:	5b                   	pop    %ebx
801065ce:	5e                   	pop    %esi
801065cf:	5f                   	pop    %edi
801065d0:	5d                   	pop    %ebp
801065d1:	c3                   	ret    
801065d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065e0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801065e0:	55                   	push   %ebp
801065e1:	89 e5                	mov    %esp,%ebp
801065e3:	57                   	push   %edi
801065e4:	56                   	push   %esi
801065e5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801065e6:	89 d3                	mov    %edx,%ebx
{
801065e8:	83 ec 1c             	sub    $0x1c,%esp
801065eb:	8b 7d 08             	mov    0x8(%ebp),%edi
  a = (char*)PGROUNDDOWN((uint)va);
801065ee:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801065f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801065f7:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801065fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801065fe:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106602:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
80106609:	29 df                	sub    %ebx,%edi
8010660b:	eb 18                	jmp    80106625 <mappages+0x45>
8010660d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*pte & PTE_P)
80106610:	f6 00 01             	testb  $0x1,(%eax)
80106613:	75 3d                	jne    80106652 <mappages+0x72>
    *pte = pa | perm | PTE_P;
80106615:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
80106618:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010661b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010661d:	74 29                	je     80106648 <mappages+0x68>
      break;
    a += PGSIZE;
8010661f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106625:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106628:	b9 01 00 00 00       	mov    $0x1,%ecx
8010662d:	89 da                	mov    %ebx,%edx
8010662f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106632:	e8 19 ff ff ff       	call   80106550 <walkpgdir>
80106637:	85 c0                	test   %eax,%eax
80106639:	75 d5                	jne    80106610 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010663b:	83 c4 1c             	add    $0x1c,%esp
      return -1;
8010663e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106643:	5b                   	pop    %ebx
80106644:	5e                   	pop    %esi
80106645:	5f                   	pop    %edi
80106646:	5d                   	pop    %ebp
80106647:	c3                   	ret    
80106648:	83 c4 1c             	add    $0x1c,%esp
  return 0;
8010664b:	31 c0                	xor    %eax,%eax
}
8010664d:	5b                   	pop    %ebx
8010664e:	5e                   	pop    %esi
8010664f:	5f                   	pop    %edi
80106650:	5d                   	pop    %ebp
80106651:	c3                   	ret    
      panic("remap");
80106652:	c7 04 24 90 77 10 80 	movl   $0x80107790,(%esp)
80106659:	e8 02 9d ff ff       	call   80100360 <panic>
8010665e:	66 90                	xchg   %ax,%ax

80106660 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106660:	55                   	push   %ebp
80106661:	89 e5                	mov    %esp,%ebp
80106663:	57                   	push   %edi
80106664:	89 c7                	mov    %eax,%edi
80106666:	56                   	push   %esi
80106667:	89 d6                	mov    %edx,%esi
80106669:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010666a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106670:	83 ec 1c             	sub    $0x1c,%esp
  a = PGROUNDUP(newsz);
80106673:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106679:	39 d3                	cmp    %edx,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010667b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010667e:	72 3b                	jb     801066bb <deallocuvm.part.0+0x5b>
80106680:	eb 5e                	jmp    801066e0 <deallocuvm.part.0+0x80>
80106682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106688:	8b 10                	mov    (%eax),%edx
8010668a:	f6 c2 01             	test   $0x1,%dl
8010668d:	74 22                	je     801066b1 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010668f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106695:	74 54                	je     801066eb <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106697:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010669d:	89 14 24             	mov    %edx,(%esp)
801066a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066a3:	e8 68 bc ff ff       	call   80102310 <kfree>
      *pte = 0;
801066a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801066b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801066b7:	39 f3                	cmp    %esi,%ebx
801066b9:	73 25                	jae    801066e0 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
801066bb:	31 c9                	xor    %ecx,%ecx
801066bd:	89 da                	mov    %ebx,%edx
801066bf:	89 f8                	mov    %edi,%eax
801066c1:	e8 8a fe ff ff       	call   80106550 <walkpgdir>
    if(!pte)
801066c6:	85 c0                	test   %eax,%eax
801066c8:	75 be                	jne    80106688 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801066ca:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801066d0:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801066d6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801066dc:	39 f3                	cmp    %esi,%ebx
801066de:	72 db                	jb     801066bb <deallocuvm.part.0+0x5b>
    }
  }
  return newsz;
}
801066e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801066e3:	83 c4 1c             	add    $0x1c,%esp
801066e6:	5b                   	pop    %ebx
801066e7:	5e                   	pop    %esi
801066e8:	5f                   	pop    %edi
801066e9:	5d                   	pop    %ebp
801066ea:	c3                   	ret    
        panic("kfree");
801066eb:	c7 04 24 c6 70 10 80 	movl   $0x801070c6,(%esp)
801066f2:	e8 69 9c ff ff       	call   80100360 <panic>
801066f7:	89 f6                	mov    %esi,%esi
801066f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106700 <seginit>:
{
80106700:	55                   	push   %ebp
80106701:	89 e5                	mov    %esp,%ebp
80106703:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106706:	e8 b5 cf ff ff       	call   801036c0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010670b:	31 c9                	xor    %ecx,%ecx
8010670d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c = &cpus[cpuid()];
80106712:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106718:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010671d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106721:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  lgdt(c->gdt, sizeof(c->gdt));
80106726:	83 c0 70             	add    $0x70,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106729:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010672d:	31 c9                	xor    %ecx,%ecx
8010672f:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106733:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106738:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010673c:	31 c9                	xor    %ecx,%ecx
8010673e:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106742:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106747:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010674b:	31 c9                	xor    %ecx,%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010674d:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106751:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106755:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106759:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010675d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106761:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106765:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106769:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
8010676d:	66 89 50 20          	mov    %dx,0x20(%eax)
  pd[0] = size-1;
80106771:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106776:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
8010677a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010677e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106782:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106786:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
8010678a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010678e:	66 89 48 22          	mov    %cx,0x22(%eax)
80106792:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106796:	c6 40 27 00          	movb   $0x0,0x27(%eax)
8010679a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
8010679e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801067a2:	c1 e8 10             	shr    $0x10,%eax
801067a5:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801067a9:	8d 45 f2             	lea    -0xe(%ebp),%eax
801067ac:	0f 01 10             	lgdtl  (%eax)
}
801067af:	c9                   	leave  
801067b0:	c3                   	ret    
801067b1:	eb 0d                	jmp    801067c0 <switchkvm>
801067b3:	90                   	nop
801067b4:	90                   	nop
801067b5:	90                   	nop
801067b6:	90                   	nop
801067b7:	90                   	nop
801067b8:	90                   	nop
801067b9:	90                   	nop
801067ba:	90                   	nop
801067bb:	90                   	nop
801067bc:	90                   	nop
801067bd:	90                   	nop
801067be:	90                   	nop
801067bf:	90                   	nop

801067c0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801067c0:	a1 a4 59 11 80       	mov    0x801159a4,%eax
{
801067c5:	55                   	push   %ebp
801067c6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801067c8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801067cd:	0f 22 d8             	mov    %eax,%cr3
}
801067d0:	5d                   	pop    %ebp
801067d1:	c3                   	ret    
801067d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067e0 <switchuvm>:
{
801067e0:	55                   	push   %ebp
801067e1:	89 e5                	mov    %esp,%ebp
801067e3:	57                   	push   %edi
801067e4:	56                   	push   %esi
801067e5:	53                   	push   %ebx
801067e6:	83 ec 1c             	sub    $0x1c,%esp
801067e9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801067ec:	85 f6                	test   %esi,%esi
801067ee:	0f 84 cd 00 00 00    	je     801068c1 <switchuvm+0xe1>
  if(p->kstack == 0)
801067f4:	8b 46 08             	mov    0x8(%esi),%eax
801067f7:	85 c0                	test   %eax,%eax
801067f9:	0f 84 da 00 00 00    	je     801068d9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801067ff:	8b 7e 04             	mov    0x4(%esi),%edi
80106802:	85 ff                	test   %edi,%edi
80106804:	0f 84 c3 00 00 00    	je     801068cd <switchuvm+0xed>
  pushcli();
8010680a:	e8 11 db ff ff       	call   80104320 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010680f:	e8 2c ce ff ff       	call   80103640 <mycpu>
80106814:	89 c3                	mov    %eax,%ebx
80106816:	e8 25 ce ff ff       	call   80103640 <mycpu>
8010681b:	89 c7                	mov    %eax,%edi
8010681d:	e8 1e ce ff ff       	call   80103640 <mycpu>
80106822:	83 c7 08             	add    $0x8,%edi
80106825:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106828:	e8 13 ce ff ff       	call   80103640 <mycpu>
8010682d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106830:	ba 67 00 00 00       	mov    $0x67,%edx
80106835:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
8010683c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106843:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
8010684a:	83 c1 08             	add    $0x8,%ecx
8010684d:	c1 e9 10             	shr    $0x10,%ecx
80106850:	83 c0 08             	add    $0x8,%eax
80106853:	c1 e8 18             	shr    $0x18,%eax
80106856:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010685c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106863:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106869:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
8010686e:	e8 cd cd ff ff       	call   80103640 <mycpu>
80106873:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010687a:	e8 c1 cd ff ff       	call   80103640 <mycpu>
8010687f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106884:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106888:	e8 b3 cd ff ff       	call   80103640 <mycpu>
8010688d:	8b 56 08             	mov    0x8(%esi),%edx
80106890:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106896:	89 48 0c             	mov    %ecx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106899:	e8 a2 cd ff ff       	call   80103640 <mycpu>
8010689e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801068a2:	b8 28 00 00 00       	mov    $0x28,%eax
801068a7:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801068aa:	8b 46 04             	mov    0x4(%esi),%eax
801068ad:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801068b2:	0f 22 d8             	mov    %eax,%cr3
}
801068b5:	83 c4 1c             	add    $0x1c,%esp
801068b8:	5b                   	pop    %ebx
801068b9:	5e                   	pop    %esi
801068ba:	5f                   	pop    %edi
801068bb:	5d                   	pop    %ebp
  popcli();
801068bc:	e9 9f da ff ff       	jmp    80104360 <popcli>
    panic("switchuvm: no process");
801068c1:	c7 04 24 96 77 10 80 	movl   $0x80107796,(%esp)
801068c8:	e8 93 9a ff ff       	call   80100360 <panic>
    panic("switchuvm: no pgdir");
801068cd:	c7 04 24 c1 77 10 80 	movl   $0x801077c1,(%esp)
801068d4:	e8 87 9a ff ff       	call   80100360 <panic>
    panic("switchuvm: no kstack");
801068d9:	c7 04 24 ac 77 10 80 	movl   $0x801077ac,(%esp)
801068e0:	e8 7b 9a ff ff       	call   80100360 <panic>
801068e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801068e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068f0 <inituvm>:
{
801068f0:	55                   	push   %ebp
801068f1:	89 e5                	mov    %esp,%ebp
801068f3:	57                   	push   %edi
801068f4:	56                   	push   %esi
801068f5:	53                   	push   %ebx
801068f6:	83 ec 1c             	sub    $0x1c,%esp
801068f9:	8b 75 10             	mov    0x10(%ebp),%esi
801068fc:	8b 45 08             	mov    0x8(%ebp),%eax
801068ff:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106902:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106908:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010690b:	77 54                	ja     80106961 <inituvm+0x71>
  mem = kalloc();
8010690d:	e8 ae bb ff ff       	call   801024c0 <kalloc>
  memset(mem, 0, PGSIZE);
80106912:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106919:	00 
8010691a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106921:	00 
  mem = kalloc();
80106922:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106924:	89 04 24             	mov    %eax,(%esp)
80106927:	e8 a4 db ff ff       	call   801044d0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010692c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106932:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106937:	89 04 24             	mov    %eax,(%esp)
8010693a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010693d:	31 d2                	xor    %edx,%edx
8010693f:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106946:	00 
80106947:	e8 94 fc ff ff       	call   801065e0 <mappages>
  memmove(mem, init, sz);
8010694c:	89 75 10             	mov    %esi,0x10(%ebp)
8010694f:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106952:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106955:	83 c4 1c             	add    $0x1c,%esp
80106958:	5b                   	pop    %ebx
80106959:	5e                   	pop    %esi
8010695a:	5f                   	pop    %edi
8010695b:	5d                   	pop    %ebp
  memmove(mem, init, sz);
8010695c:	e9 0f dc ff ff       	jmp    80104570 <memmove>
    panic("inituvm: more than a page");
80106961:	c7 04 24 d5 77 10 80 	movl   $0x801077d5,(%esp)
80106968:	e8 f3 99 ff ff       	call   80100360 <panic>
8010696d:	8d 76 00             	lea    0x0(%esi),%esi

80106970 <loaduvm>:
{
80106970:	55                   	push   %ebp
80106971:	89 e5                	mov    %esp,%ebp
80106973:	57                   	push   %edi
80106974:	56                   	push   %esi
80106975:	53                   	push   %ebx
80106976:	83 ec 1c             	sub    $0x1c,%esp
  if((uint) addr % PGSIZE != 0)
80106979:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106980:	0f 85 98 00 00 00    	jne    80106a1e <loaduvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
80106986:	8b 75 18             	mov    0x18(%ebp),%esi
80106989:	31 db                	xor    %ebx,%ebx
8010698b:	85 f6                	test   %esi,%esi
8010698d:	75 1a                	jne    801069a9 <loaduvm+0x39>
8010698f:	eb 77                	jmp    80106a08 <loaduvm+0x98>
80106991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106998:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010699e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801069a4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801069a7:	76 5f                	jbe    80106a08 <loaduvm+0x98>
801069a9:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801069ac:	31 c9                	xor    %ecx,%ecx
801069ae:	8b 45 08             	mov    0x8(%ebp),%eax
801069b1:	01 da                	add    %ebx,%edx
801069b3:	e8 98 fb ff ff       	call   80106550 <walkpgdir>
801069b8:	85 c0                	test   %eax,%eax
801069ba:	74 56                	je     80106a12 <loaduvm+0xa2>
    pa = PTE_ADDR(*pte);
801069bc:	8b 00                	mov    (%eax),%eax
      n = PGSIZE;
801069be:	bf 00 10 00 00       	mov    $0x1000,%edi
801069c3:	8b 4d 14             	mov    0x14(%ebp),%ecx
    pa = PTE_ADDR(*pte);
801069c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = PGSIZE;
801069cb:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
801069d1:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801069d4:	05 00 00 00 80       	add    $0x80000000,%eax
801069d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801069dd:	8b 45 10             	mov    0x10(%ebp),%eax
801069e0:	01 d9                	add    %ebx,%ecx
801069e2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801069e6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801069ea:	89 04 24             	mov    %eax,(%esp)
801069ed:	e8 8e af ff ff       	call   80101980 <readi>
801069f2:	39 f8                	cmp    %edi,%eax
801069f4:	74 a2                	je     80106998 <loaduvm+0x28>
}
801069f6:	83 c4 1c             	add    $0x1c,%esp
      return -1;
801069f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069fe:	5b                   	pop    %ebx
801069ff:	5e                   	pop    %esi
80106a00:	5f                   	pop    %edi
80106a01:	5d                   	pop    %ebp
80106a02:	c3                   	ret    
80106a03:	90                   	nop
80106a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a08:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106a0b:	31 c0                	xor    %eax,%eax
}
80106a0d:	5b                   	pop    %ebx
80106a0e:	5e                   	pop    %esi
80106a0f:	5f                   	pop    %edi
80106a10:	5d                   	pop    %ebp
80106a11:	c3                   	ret    
      panic("loaduvm: address should exist");
80106a12:	c7 04 24 ef 77 10 80 	movl   $0x801077ef,(%esp)
80106a19:	e8 42 99 ff ff       	call   80100360 <panic>
    panic("loaduvm: addr must be page aligned");
80106a1e:	c7 04 24 90 78 10 80 	movl   $0x80107890,(%esp)
80106a25:	e8 36 99 ff ff       	call   80100360 <panic>
80106a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a30 <allocuvm>:
{
80106a30:	55                   	push   %ebp
80106a31:	89 e5                	mov    %esp,%ebp
80106a33:	57                   	push   %edi
80106a34:	56                   	push   %esi
80106a35:	53                   	push   %ebx
80106a36:	83 ec 1c             	sub    $0x1c,%esp
80106a39:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
80106a3c:	85 ff                	test   %edi,%edi
80106a3e:	0f 88 7e 00 00 00    	js     80106ac2 <allocuvm+0x92>
  if(newsz < oldsz)
80106a44:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106a47:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106a4a:	72 78                	jb     80106ac4 <allocuvm+0x94>
  a = PGROUNDUP(oldsz);
80106a4c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106a52:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106a58:	39 df                	cmp    %ebx,%edi
80106a5a:	77 4a                	ja     80106aa6 <allocuvm+0x76>
80106a5c:	eb 72                	jmp    80106ad0 <allocuvm+0xa0>
80106a5e:	66 90                	xchg   %ax,%ax
    memset(mem, 0, PGSIZE);
80106a60:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106a67:	00 
80106a68:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a6f:	00 
80106a70:	89 04 24             	mov    %eax,(%esp)
80106a73:	e8 58 da ff ff       	call   801044d0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106a78:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106a7e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a83:	89 04 24             	mov    %eax,(%esp)
80106a86:	8b 45 08             	mov    0x8(%ebp),%eax
80106a89:	89 da                	mov    %ebx,%edx
80106a8b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106a92:	00 
80106a93:	e8 48 fb ff ff       	call   801065e0 <mappages>
80106a98:	85 c0                	test   %eax,%eax
80106a9a:	78 44                	js     80106ae0 <allocuvm+0xb0>
  for(; a < newsz; a += PGSIZE){
80106a9c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106aa2:	39 df                	cmp    %ebx,%edi
80106aa4:	76 2a                	jbe    80106ad0 <allocuvm+0xa0>
    mem = kalloc();
80106aa6:	e8 15 ba ff ff       	call   801024c0 <kalloc>
    if(mem == 0){
80106aab:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106aad:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106aaf:	75 af                	jne    80106a60 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106ab1:	c7 04 24 0d 78 10 80 	movl   $0x8010780d,(%esp)
80106ab8:	e8 93 9b ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
80106abd:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106ac0:	77 48                	ja     80106b0a <allocuvm+0xda>
      return 0;
80106ac2:	31 c0                	xor    %eax,%eax
}
80106ac4:	83 c4 1c             	add    $0x1c,%esp
80106ac7:	5b                   	pop    %ebx
80106ac8:	5e                   	pop    %esi
80106ac9:	5f                   	pop    %edi
80106aca:	5d                   	pop    %ebp
80106acb:	c3                   	ret    
80106acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ad0:	83 c4 1c             	add    $0x1c,%esp
80106ad3:	89 f8                	mov    %edi,%eax
80106ad5:	5b                   	pop    %ebx
80106ad6:	5e                   	pop    %esi
80106ad7:	5f                   	pop    %edi
80106ad8:	5d                   	pop    %ebp
80106ad9:	c3                   	ret    
80106ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106ae0:	c7 04 24 25 78 10 80 	movl   $0x80107825,(%esp)
80106ae7:	e8 64 9b ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
80106aec:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106aef:	76 0d                	jbe    80106afe <allocuvm+0xce>
80106af1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106af4:	89 fa                	mov    %edi,%edx
80106af6:	8b 45 08             	mov    0x8(%ebp),%eax
80106af9:	e8 62 fb ff ff       	call   80106660 <deallocuvm.part.0>
      kfree(mem);
80106afe:	89 34 24             	mov    %esi,(%esp)
80106b01:	e8 0a b8 ff ff       	call   80102310 <kfree>
      return 0;
80106b06:	31 c0                	xor    %eax,%eax
80106b08:	eb ba                	jmp    80106ac4 <allocuvm+0x94>
80106b0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106b0d:	89 fa                	mov    %edi,%edx
80106b0f:	8b 45 08             	mov    0x8(%ebp),%eax
80106b12:	e8 49 fb ff ff       	call   80106660 <deallocuvm.part.0>
      return 0;
80106b17:	31 c0                	xor    %eax,%eax
80106b19:	eb a9                	jmp    80106ac4 <allocuvm+0x94>
80106b1b:	90                   	nop
80106b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b20 <deallocuvm>:
{
80106b20:	55                   	push   %ebp
80106b21:	89 e5                	mov    %esp,%ebp
80106b23:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b26:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106b29:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106b2c:	39 d1                	cmp    %edx,%ecx
80106b2e:	73 08                	jae    80106b38 <deallocuvm+0x18>
}
80106b30:	5d                   	pop    %ebp
80106b31:	e9 2a fb ff ff       	jmp    80106660 <deallocuvm.part.0>
80106b36:	66 90                	xchg   %ax,%ax
80106b38:	89 d0                	mov    %edx,%eax
80106b3a:	5d                   	pop    %ebp
80106b3b:	c3                   	ret    
80106b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b40 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106b40:	55                   	push   %ebp
80106b41:	89 e5                	mov    %esp,%ebp
80106b43:	56                   	push   %esi
80106b44:	53                   	push   %ebx
80106b45:	83 ec 10             	sub    $0x10,%esp
80106b48:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106b4b:	85 f6                	test   %esi,%esi
80106b4d:	74 59                	je     80106ba8 <freevm+0x68>
80106b4f:	31 c9                	xor    %ecx,%ecx
80106b51:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106b56:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106b58:	31 db                	xor    %ebx,%ebx
80106b5a:	e8 01 fb ff ff       	call   80106660 <deallocuvm.part.0>
80106b5f:	eb 12                	jmp    80106b73 <freevm+0x33>
80106b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b68:	83 c3 01             	add    $0x1,%ebx
80106b6b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106b71:	74 27                	je     80106b9a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106b73:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106b76:	f6 c2 01             	test   $0x1,%dl
80106b79:	74 ed                	je     80106b68 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106b7b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(i = 0; i < NPDENTRIES; i++){
80106b81:	83 c3 01             	add    $0x1,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106b84:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106b8a:	89 14 24             	mov    %edx,(%esp)
80106b8d:	e8 7e b7 ff ff       	call   80102310 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80106b92:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106b98:	75 d9                	jne    80106b73 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
80106b9a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106b9d:	83 c4 10             	add    $0x10,%esp
80106ba0:	5b                   	pop    %ebx
80106ba1:	5e                   	pop    %esi
80106ba2:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106ba3:	e9 68 b7 ff ff       	jmp    80102310 <kfree>
    panic("freevm: no pgdir");
80106ba8:	c7 04 24 41 78 10 80 	movl   $0x80107841,(%esp)
80106baf:	e8 ac 97 ff ff       	call   80100360 <panic>
80106bb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106bc0 <setupkvm>:
{
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	56                   	push   %esi
80106bc4:	53                   	push   %ebx
80106bc5:	83 ec 10             	sub    $0x10,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
80106bc8:	e8 f3 b8 ff ff       	call   801024c0 <kalloc>
80106bcd:	85 c0                	test   %eax,%eax
80106bcf:	89 c6                	mov    %eax,%esi
80106bd1:	74 6d                	je     80106c40 <setupkvm+0x80>
  memset(pgdir, 0, PGSIZE);
80106bd3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106bda:	00 
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106bdb:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106be0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106be7:	00 
80106be8:	89 04 24             	mov    %eax,(%esp)
80106beb:	e8 e0 d8 ff ff       	call   801044d0 <memset>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106bf0:	8b 53 0c             	mov    0xc(%ebx),%edx
80106bf3:	8b 43 04             	mov    0x4(%ebx),%eax
80106bf6:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106bf9:	89 54 24 04          	mov    %edx,0x4(%esp)
80106bfd:	8b 13                	mov    (%ebx),%edx
80106bff:	89 04 24             	mov    %eax,(%esp)
80106c02:	29 c1                	sub    %eax,%ecx
80106c04:	89 f0                	mov    %esi,%eax
80106c06:	e8 d5 f9 ff ff       	call   801065e0 <mappages>
80106c0b:	85 c0                	test   %eax,%eax
80106c0d:	78 19                	js     80106c28 <setupkvm+0x68>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106c0f:	83 c3 10             	add    $0x10,%ebx
80106c12:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106c18:	72 d6                	jb     80106bf0 <setupkvm+0x30>
80106c1a:	89 f0                	mov    %esi,%eax
}
80106c1c:	83 c4 10             	add    $0x10,%esp
80106c1f:	5b                   	pop    %ebx
80106c20:	5e                   	pop    %esi
80106c21:	5d                   	pop    %ebp
80106c22:	c3                   	ret    
80106c23:	90                   	nop
80106c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106c28:	89 34 24             	mov    %esi,(%esp)
80106c2b:	e8 10 ff ff ff       	call   80106b40 <freevm>
}
80106c30:	83 c4 10             	add    $0x10,%esp
      return 0;
80106c33:	31 c0                	xor    %eax,%eax
}
80106c35:	5b                   	pop    %ebx
80106c36:	5e                   	pop    %esi
80106c37:	5d                   	pop    %ebp
80106c38:	c3                   	ret    
80106c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106c40:	31 c0                	xor    %eax,%eax
80106c42:	eb d8                	jmp    80106c1c <setupkvm+0x5c>
80106c44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c50 <kvmalloc>:
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106c56:	e8 65 ff ff ff       	call   80106bc0 <setupkvm>
80106c5b:	a3 a4 59 11 80       	mov    %eax,0x801159a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c60:	05 00 00 00 80       	add    $0x80000000,%eax
80106c65:	0f 22 d8             	mov    %eax,%cr3
}
80106c68:	c9                   	leave  
80106c69:	c3                   	ret    
80106c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c70 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106c70:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c71:	31 c9                	xor    %ecx,%ecx
{
80106c73:	89 e5                	mov    %esp,%ebp
80106c75:	83 ec 18             	sub    $0x18,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106c78:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c7b:	8b 45 08             	mov    0x8(%ebp),%eax
80106c7e:	e8 cd f8 ff ff       	call   80106550 <walkpgdir>
  if(pte == 0)
80106c83:	85 c0                	test   %eax,%eax
80106c85:	74 05                	je     80106c8c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106c87:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106c8a:	c9                   	leave  
80106c8b:	c3                   	ret    
    panic("clearpteu");
80106c8c:	c7 04 24 52 78 10 80 	movl   $0x80107852,(%esp)
80106c93:	e8 c8 96 ff ff       	call   80100360 <panic>
80106c98:	90                   	nop
80106c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ca0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	57                   	push   %edi
80106ca4:	56                   	push   %esi
80106ca5:	53                   	push   %ebx
80106ca6:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106ca9:	e8 12 ff ff ff       	call   80106bc0 <setupkvm>
80106cae:	85 c0                	test   %eax,%eax
80106cb0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106cb3:	0f 84 b9 00 00 00    	je     80106d72 <copyuvm+0xd2>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cbc:	85 c0                	test   %eax,%eax
80106cbe:	0f 84 94 00 00 00    	je     80106d58 <copyuvm+0xb8>
80106cc4:	31 ff                	xor    %edi,%edi
80106cc6:	eb 48                	jmp    80106d10 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106cc8:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106cce:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106cd5:	00 
80106cd6:	89 74 24 04          	mov    %esi,0x4(%esp)
80106cda:	89 04 24             	mov    %eax,(%esp)
80106cdd:	e8 8e d8 ff ff       	call   80104570 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106ce2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ce5:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106cea:	89 fa                	mov    %edi,%edx
80106cec:	89 44 24 04          	mov    %eax,0x4(%esp)
80106cf0:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106cf6:	89 04 24             	mov    %eax,(%esp)
80106cf9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106cfc:	e8 df f8 ff ff       	call   801065e0 <mappages>
80106d01:	85 c0                	test   %eax,%eax
80106d03:	78 63                	js     80106d68 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106d05:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106d0b:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106d0e:	76 48                	jbe    80106d58 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106d10:	8b 45 08             	mov    0x8(%ebp),%eax
80106d13:	31 c9                	xor    %ecx,%ecx
80106d15:	89 fa                	mov    %edi,%edx
80106d17:	e8 34 f8 ff ff       	call   80106550 <walkpgdir>
80106d1c:	85 c0                	test   %eax,%eax
80106d1e:	74 62                	je     80106d82 <copyuvm+0xe2>
    if(!(*pte & PTE_P))
80106d20:	8b 00                	mov    (%eax),%eax
80106d22:	a8 01                	test   $0x1,%al
80106d24:	74 50                	je     80106d76 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80106d26:	89 c6                	mov    %eax,%esi
    flags = PTE_FLAGS(*pte);
80106d28:	25 ff 0f 00 00       	and    $0xfff,%eax
80106d2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106d30:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    if((mem = kalloc()) == 0)
80106d36:	e8 85 b7 ff ff       	call   801024c0 <kalloc>
80106d3b:	85 c0                	test   %eax,%eax
80106d3d:	89 c3                	mov    %eax,%ebx
80106d3f:	75 87                	jne    80106cc8 <copyuvm+0x28>
    }
  }
  return d;

bad:
  freevm(d);
80106d41:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d44:	89 04 24             	mov    %eax,(%esp)
80106d47:	e8 f4 fd ff ff       	call   80106b40 <freevm>
  return 0;
80106d4c:	31 c0                	xor    %eax,%eax
}
80106d4e:	83 c4 2c             	add    $0x2c,%esp
80106d51:	5b                   	pop    %ebx
80106d52:	5e                   	pop    %esi
80106d53:	5f                   	pop    %edi
80106d54:	5d                   	pop    %ebp
80106d55:	c3                   	ret    
80106d56:	66 90                	xchg   %ax,%ax
80106d58:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d5b:	83 c4 2c             	add    $0x2c,%esp
80106d5e:	5b                   	pop    %ebx
80106d5f:	5e                   	pop    %esi
80106d60:	5f                   	pop    %edi
80106d61:	5d                   	pop    %ebp
80106d62:	c3                   	ret    
80106d63:	90                   	nop
80106d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80106d68:	89 1c 24             	mov    %ebx,(%esp)
80106d6b:	e8 a0 b5 ff ff       	call   80102310 <kfree>
      goto bad;
80106d70:	eb cf                	jmp    80106d41 <copyuvm+0xa1>
    return 0;
80106d72:	31 c0                	xor    %eax,%eax
80106d74:	eb d8                	jmp    80106d4e <copyuvm+0xae>
      panic("copyuvm: page not present");
80106d76:	c7 04 24 76 78 10 80 	movl   $0x80107876,(%esp)
80106d7d:	e8 de 95 ff ff       	call   80100360 <panic>
      panic("copyuvm: pte should exist");
80106d82:	c7 04 24 5c 78 10 80 	movl   $0x8010785c,(%esp)
80106d89:	e8 d2 95 ff ff       	call   80100360 <panic>
80106d8e:	66 90                	xchg   %ax,%ax

80106d90 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106d90:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d91:	31 c9                	xor    %ecx,%ecx
{
80106d93:	89 e5                	mov    %esp,%ebp
80106d95:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106d98:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d9b:	8b 45 08             	mov    0x8(%ebp),%eax
80106d9e:	e8 ad f7 ff ff       	call   80106550 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106da3:	8b 00                	mov    (%eax),%eax
80106da5:	89 c2                	mov    %eax,%edx
80106da7:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106daa:	83 fa 05             	cmp    $0x5,%edx
80106dad:	75 11                	jne    80106dc0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106daf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106db4:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106db9:	c9                   	leave  
80106dba:	c3                   	ret    
80106dbb:	90                   	nop
80106dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106dc0:	31 c0                	xor    %eax,%eax
}
80106dc2:	c9                   	leave  
80106dc3:	c3                   	ret    
80106dc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106dca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106dd0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	57                   	push   %edi
80106dd4:	56                   	push   %esi
80106dd5:	53                   	push   %ebx
80106dd6:	83 ec 1c             	sub    $0x1c,%esp
80106dd9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106ddc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106ddf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106de2:	85 db                	test   %ebx,%ebx
80106de4:	75 3a                	jne    80106e20 <copyout+0x50>
80106de6:	eb 68                	jmp    80106e50 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106de8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106deb:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106ded:	89 7c 24 04          	mov    %edi,0x4(%esp)
    n = PGSIZE - (va - va0);
80106df1:	29 ca                	sub    %ecx,%edx
80106df3:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106df9:	39 da                	cmp    %ebx,%edx
80106dfb:	0f 47 d3             	cmova  %ebx,%edx
    memmove(pa0 + (va - va0), buf, n);
80106dfe:	29 f1                	sub    %esi,%ecx
80106e00:	01 c8                	add    %ecx,%eax
80106e02:	89 54 24 08          	mov    %edx,0x8(%esp)
80106e06:	89 04 24             	mov    %eax,(%esp)
80106e09:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106e0c:	e8 5f d7 ff ff       	call   80104570 <memmove>
    len -= n;
    buf += n;
80106e11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106e14:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    buf += n;
80106e1a:	01 d7                	add    %edx,%edi
  while(len > 0){
80106e1c:	29 d3                	sub    %edx,%ebx
80106e1e:	74 30                	je     80106e50 <copyout+0x80>
    pa0 = uva2ka(pgdir, (char*)va0);
80106e20:	8b 45 08             	mov    0x8(%ebp),%eax
    va0 = (uint)PGROUNDDOWN(va);
80106e23:	89 ce                	mov    %ecx,%esi
80106e25:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106e2b:	89 74 24 04          	mov    %esi,0x4(%esp)
    va0 = (uint)PGROUNDDOWN(va);
80106e2f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106e32:	89 04 24             	mov    %eax,(%esp)
80106e35:	e8 56 ff ff ff       	call   80106d90 <uva2ka>
    if(pa0 == 0)
80106e3a:	85 c0                	test   %eax,%eax
80106e3c:	75 aa                	jne    80106de8 <copyout+0x18>
  }
  return 0;
}
80106e3e:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106e41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e46:	5b                   	pop    %ebx
80106e47:	5e                   	pop    %esi
80106e48:	5f                   	pop    %edi
80106e49:	5d                   	pop    %ebp
80106e4a:	c3                   	ret    
80106e4b:	90                   	nop
80106e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e50:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106e53:	31 c0                	xor    %eax,%eax
}
80106e55:	5b                   	pop    %ebx
80106e56:	5e                   	pop    %esi
80106e57:	5f                   	pop    %edi
80106e58:	5d                   	pop    %ebp
80106e59:	c3                   	ret    
