
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
8010002d:	b8 20 2e 10 80       	mov    $0x80102e20,%eax
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
8010004c:	c7 44 24 04 a0 6f 10 	movl   $0x80106fa0,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 50 40 00 00       	call   801040b0 <initlock>
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
80100094:	c7 44 24 04 a7 6f 10 	movl   $0x80106fa7,0x4(%esp)
8010009b:	80 
8010009c:	e8 ff 3e 00 00       	call   80103fa0 <initsleeplock>
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
801000e6:	e8 b5 40 00 00       	call   801041a0 <acquire>
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
80100161:	e8 2a 41 00 00       	call   80104290 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 6f 3e 00 00       	call   80103fe0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 d2 1f 00 00       	call   80102150 <iderw>
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
80100188:	c7 04 24 ae 6f 10 80 	movl   $0x80106fae,(%esp)
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
801001b0:	e8 cb 3e 00 00       	call   80104080 <holdingsleep>
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
801001c4:	e9 87 1f 00 00       	jmp    80102150 <iderw>
    panic("bwrite");
801001c9:	c7 04 24 bf 6f 10 80 	movl   $0x80106fbf,(%esp)
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
801001f1:	e8 8a 3e 00 00       	call   80104080 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 3e 3e 00 00       	call   80104040 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 92 3f 00 00       	call   801041a0 <acquire>
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
80100250:	e9 3b 40 00 00       	jmp    80104290 <release>
    panic("brelse");
80100255:	c7 04 24 c6 6f 10 80 	movl   $0x80106fc6,(%esp)
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
80100282:	e8 39 15 00 00       	call   801017c0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 0d 3f 00 00       	call   801041a0 <acquire>
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
801002a8:	e8 23 34 00 00       	call   801036d0 <myproc>
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
801002c3:	e8 78 39 00 00       	call   80103c40 <sleep>
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
80100311:	e8 7a 3f 00 00       	call   80104290 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 c2 13 00 00       	call   801016e0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 5c 3f 00 00       	call   80104290 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 a4 13 00 00       	call   801016e0 <ilock>
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
80100376:	e8 15 24 00 00       	call   80102790 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 cd 6f 10 80 	movl   $0x80106fcd,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 ff 79 10 80 	movl   $0x801079ff,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 1c 3d 00 00       	call   801040d0 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 e1 6f 10 80 	movl   $0x80106fe1,(%esp)
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
80100409:	e8 e2 54 00 00       	call   801058f0 <uartputc>
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
801004b9:	e8 32 54 00 00       	call   801058f0 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 26 54 00 00       	call   801058f0 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 1a 54 00 00       	call   801058f0 <uartputc>
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
801004fc:	e8 7f 3e 00 00       	call   80104380 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 c2 3d 00 00       	call   801042e0 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    panic("pos under/overflow");
8010052a:	c7 04 24 e5 6f 10 80 	movl   $0x80106fe5,(%esp)
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
80100599:	0f b6 92 10 70 10 80 	movzbl -0x7fef8ff0(%edx),%edx
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
80100602:	e8 b9 11 00 00       	call   801017c0 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 8d 3b 00 00       	call   801041a0 <acquire>
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
80100636:	e8 55 3c 00 00       	call   80104290 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 9a 10 00 00       	call   801016e0 <ilock>

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
801006f3:	e8 98 3b 00 00       	call   80104290 <release>
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
80100760:	b8 f8 6f 10 80       	mov    $0x80106ff8,%eax
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
80100797:	e8 04 3a 00 00       	call   801041a0 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
    panic("null fmt");
801007a1:	c7 04 24 ff 6f 10 80 	movl   $0x80106fff,(%esp)
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
801007c5:	e8 d6 39 00 00       	call   801041a0 <acquire>
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
80100827:	e8 64 3a 00 00       	call   80104290 <release>
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
801008b2:	e8 29 35 00 00       	call   80103de0 <wakeup>
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
80100927:	e9 a4 35 00 00       	jmp    80103ed0 <procdump>
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
80100956:	c7 44 24 04 08 70 10 	movl   $0x80107008,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 46 37 00 00       	call   801040b0 <initlock>

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
80100997:	e8 44 19 00 00       	call   801022e0 <ioapicenable>
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
801009ac:	e8 1f 2d 00 00       	call   801036d0 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 84 21 00 00       	call   80102b40 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 69 15 00 00       	call   80101f30 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 ae 01 00 00    	je     80100b7f <exec+0x1df>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 07 0d 00 00       	call   801016e0 <ilock>
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
801009f6:	e8 95 0f 00 00       	call   80101990 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 38 0f 00 00       	call   80101940 <iunlockput>
    end_op();
80100a08:	e8 a3 21 00 00       	call   80102bb0 <end_op>
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
80100a2c:	e8 ff 60 00 00       	call   80106b30 <setupkvm>
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
80100a8e:	e8 fd 0e 00 00       	call   80101990 <readi>
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
80100ad2:	e8 b9 5e 00 00       	call   80106990 <allocuvm>
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
80100b13:	e8 a8 5d 00 00       	call   801068c0 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 82 5f 00 00       	call   80106ab0 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 05 0e 00 00       	call   80101940 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 6b 20 00 00       	call   80102bb0 <end_op>
  if(allocuvm(pgdir, sp - 2*PGSIZE, sp) == 0)
80100b45:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b4b:	c7 44 24 08 ff ff ff 	movl   $0x7fffffff,0x8(%esp)
80100b52:	7f 
80100b53:	c7 44 24 04 ff df ff 	movl   $0x7fffdfff,0x4(%esp)
80100b5a:	7f 
80100b5b:	89 04 24             	mov    %eax,(%esp)
80100b5e:	e8 2d 5e 00 00       	call   80106990 <allocuvm>
80100b63:	85 c0                	test   %eax,%eax
80100b65:	75 33                	jne    80100b9a <exec+0x1fa>
    freevm(pgdir);
80100b67:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b6d:	89 04 24             	mov    %eax,(%esp)
80100b70:	e8 3b 5f 00 00       	call   80106ab0 <freevm>
  return -1;
80100b75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b7a:	e9 93 fe ff ff       	jmp    80100a12 <exec+0x72>
    end_op();
80100b7f:	e8 2c 20 00 00       	call   80102bb0 <end_op>
    cprintf("exec: fail\n");
80100b84:	c7 04 24 21 70 10 80 	movl   $0x80107021,(%esp)
80100b8b:	e8 c0 fa ff ff       	call   80100650 <cprintf>
    return -1;
80100b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b95:	e9 78 fe ff ff       	jmp    80100a12 <exec+0x72>
  clearpteu(pgdir, (char *)(sp - 2*PGSIZE) );
80100b9a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ba0:	c7 44 24 04 ff df ff 	movl   $0x7fffdfff,0x4(%esp)
80100ba7:	7f 
80100ba8:	89 04 24             	mov    %eax,(%esp)
80100bab:	e8 30 60 00 00       	call   80106be0 <clearpteu>
  curproc->stack_pages = 1;
80100bb0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100bb6:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
  cprintf("Initial number of stack pages: %d\n", curproc->stack_pages);
80100bbd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80100bc4:	00 
80100bc5:	c7 04 24 30 70 10 80 	movl   $0x80107030,(%esp)
80100bcc:	e8 7f fa ff ff       	call   80100650 <cprintf>
  for(argc = 0; argv[argc]; argc++) {
80100bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bd4:	8b 00                	mov    (%eax),%eax
80100bd6:	85 c0                	test   %eax,%eax
80100bd8:	0f 84 71 01 00 00    	je     80100d4f <exec+0x3af>
80100bde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100be1:	31 d2                	xor    %edx,%edx
  sp = KERNBASE - 1;
80100be3:	bb ff ff ff 7f       	mov    $0x7fffffff,%ebx
80100be8:	8d 71 04             	lea    0x4(%ecx),%esi
  for(argc = 0; argv[argc]; argc++) {
80100beb:	89 cf                	mov    %ecx,%edi
80100bed:	89 d1                	mov    %edx,%ecx
80100bef:	89 f2                	mov    %esi,%edx
80100bf1:	89 fe                	mov    %edi,%esi
80100bf3:	89 cf                	mov    %ecx,%edi
80100bf5:	eb 0d                	jmp    80100c04 <exec+0x264>
80100bf7:	90                   	nop
80100bf8:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bfb:	83 ff 20             	cmp    $0x20,%edi
80100bfe:	0f 84 63 ff ff ff    	je     80100b67 <exec+0x1c7>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c04:	89 04 24             	mov    %eax,(%esp)
80100c07:	89 95 e8 fe ff ff    	mov    %edx,-0x118(%ebp)
80100c0d:	e8 ee 38 00 00       	call   80104500 <strlen>
80100c12:	f7 d0                	not    %eax
80100c14:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c16:	8b 06                	mov    (%esi),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c18:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c1b:	89 04 24             	mov    %eax,(%esp)
80100c1e:	e8 dd 38 00 00       	call   80104500 <strlen>
80100c23:	83 c0 01             	add    $0x1,%eax
80100c26:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c2a:	8b 06                	mov    (%esi),%eax
80100c2c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c30:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c34:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c3a:	89 04 24             	mov    %eax,(%esp)
80100c3d:	e8 3e 62 00 00       	call   80106e80 <copyout>
80100c42:	85 c0                	test   %eax,%eax
80100c44:	0f 88 1d ff ff ff    	js     80100b67 <exec+0x1c7>
  for(argc = 0; argv[argc]; argc++) {
80100c4a:	8b 95 e8 fe ff ff    	mov    -0x118(%ebp),%edx
    ustack[3+argc] = sp;
80100c50:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100c56:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c5d:	83 c7 01             	add    $0x1,%edi
80100c60:	8b 02                	mov    (%edx),%eax
80100c62:	89 d6                	mov    %edx,%esi
80100c64:	85 c0                	test   %eax,%eax
80100c66:	75 90                	jne    80100bf8 <exec+0x258>
80100c68:	89 fa                	mov    %edi,%edx
  ustack[3+argc] = 0;
80100c6a:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c71:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c75:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
  ustack[1] = argc;
80100c7c:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c82:	89 da                	mov    %ebx,%edx
80100c84:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100c86:	83 c0 0c             	add    $0xc,%eax
80100c89:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c8b:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c8f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c95:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c99:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  ustack[0] = 0xffffffff;  // fake return PC
80100c9d:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca4:	ff ff ff 
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ca7:	89 04 24             	mov    %eax,(%esp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100caa:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb0:	e8 cb 61 00 00       	call   80106e80 <copyout>
80100cb5:	85 c0                	test   %eax,%eax
80100cb7:	0f 88 aa fe ff ff    	js     80100b67 <exec+0x1c7>
  for(last=s=path; *s; s++)
80100cbd:	8b 45 08             	mov    0x8(%ebp),%eax
80100cc0:	0f b6 10             	movzbl (%eax),%edx
80100cc3:	84 d2                	test   %dl,%dl
80100cc5:	74 19                	je     80100ce0 <exec+0x340>
80100cc7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cca:	83 c0 01             	add    $0x1,%eax
      last = s+1;
80100ccd:	80 fa 2f             	cmp    $0x2f,%dl
  for(last=s=path; *s; s++)
80100cd0:	0f b6 10             	movzbl (%eax),%edx
      last = s+1;
80100cd3:	0f 44 c8             	cmove  %eax,%ecx
80100cd6:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100cd9:	84 d2                	test   %dl,%dl
80100cdb:	75 f0                	jne    80100ccd <exec+0x32d>
80100cdd:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100ce0:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100ce6:	8b 45 08             	mov    0x8(%ebp),%eax
80100ce9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100cf0:	00 
80100cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cf5:	89 f8                	mov    %edi,%eax
80100cf7:	83 c0 6c             	add    $0x6c,%eax
80100cfa:	89 04 24             	mov    %eax,(%esp)
80100cfd:	e8 be 37 00 00       	call   801044c0 <safestrcpy>
  sz = PGROUNDUP(sz);
80100d02:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  curproc->pgdir = pgdir;
80100d08:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d0e:	8b 77 04             	mov    0x4(%edi),%esi
  sz = PGROUNDUP(sz);
80100d11:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d1b:	89 07                	mov    %eax,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d1d:	8b 47 18             	mov    0x18(%edi),%eax
  curproc->pgdir = pgdir;
80100d20:	89 57 04             	mov    %edx,0x4(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d23:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d29:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2c:	8b 47 18             	mov    0x18(%edi),%eax
80100d2f:	89 58 44             	mov    %ebx,0x44(%eax)
  curproc->my_sp = sp;
80100d32:	89 9f 80 00 00 00    	mov    %ebx,0x80(%edi)
  switchuvm(curproc);
80100d38:	89 3c 24             	mov    %edi,(%esp)
80100d3b:	e8 e0 59 00 00       	call   80106720 <switchuvm>
  freevm(oldpgdir);
80100d40:	89 34 24             	mov    %esi,(%esp)
80100d43:	e8 68 5d 00 00       	call   80106ab0 <freevm>
  return 0;
80100d48:	31 c0                	xor    %eax,%eax
80100d4a:	e9 c3 fc ff ff       	jmp    80100a12 <exec+0x72>
  sp = KERNBASE - 1;
80100d4f:	bb ff ff ff 7f       	mov    $0x7fffffff,%ebx
  for(argc = 0; argv[argc]; argc++) {
80100d54:	31 d2                	xor    %edx,%edx
80100d56:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d5c:	e9 09 ff ff ff       	jmp    80100c6a <exec+0x2ca>
80100d61:	66 90                	xchg   %ax,%ax
80100d63:	66 90                	xchg   %ax,%ax
80100d65:	66 90                	xchg   %ax,%ax
80100d67:	66 90                	xchg   %ax,%ax
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
80100d76:	c7 44 24 04 53 70 10 	movl   $0x80107053,0x4(%esp)
80100d7d:	80 
80100d7e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d85:	e8 26 33 00 00       	call   801040b0 <initlock>
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
80100da3:	e8 f8 33 00 00       	call   801041a0 <acquire>
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
80100dd0:	e8 bb 34 00 00       	call   80104290 <release>
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
80100de7:	e8 a4 34 00 00       	call   80104290 <release>
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
80100e11:	e8 8a 33 00 00       	call   801041a0 <acquire>
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
80100e2a:	e8 61 34 00 00       	call   80104290 <release>
  return f;
}
80100e2f:	83 c4 14             	add    $0x14,%esp
80100e32:	89 d8                	mov    %ebx,%eax
80100e34:	5b                   	pop    %ebx
80100e35:	5d                   	pop    %ebp
80100e36:	c3                   	ret    
    panic("filedup");
80100e37:	c7 04 24 5a 70 10 80 	movl   $0x8010705a,(%esp)
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
80100e63:	e8 38 33 00 00       	call   801041a0 <acquire>
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
80100e8b:	e9 00 34 00 00       	jmp    80104290 <release>
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
80100eaf:	e8 dc 33 00 00       	call   80104290 <release>
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
80100ed3:	e8 b8 23 00 00       	call   80103290 <pipeclose>
80100ed8:	eb e4                	jmp    80100ebe <fileclose+0x6e>
80100eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    begin_op();
80100ee0:	e8 5b 1c 00 00       	call   80102b40 <begin_op>
    iput(ff.ip);
80100ee5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ee8:	89 04 24             	mov    %eax,(%esp)
80100eeb:	e8 10 09 00 00       	call   80101800 <iput>
}
80100ef0:	83 c4 1c             	add    $0x1c,%esp
80100ef3:	5b                   	pop    %ebx
80100ef4:	5e                   	pop    %esi
80100ef5:	5f                   	pop    %edi
80100ef6:	5d                   	pop    %ebp
    end_op();
80100ef7:	e9 b4 1c 00 00       	jmp    80102bb0 <end_op>
    panic("fileclose");
80100efc:	c7 04 24 62 70 10 80 	movl   $0x80107062,(%esp)
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
80100f25:	e8 b6 07 00 00       	call   801016e0 <ilock>
    stati(f->ip, st);
80100f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f2d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
80100f34:	89 04 24             	mov    %eax,(%esp)
80100f37:	e8 24 0a 00 00       	call   80101960 <stati>
    iunlock(f->ip);
80100f3c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f3f:	89 04 24             	mov    %eax,(%esp)
80100f42:	e8 79 08 00 00       	call   801017c0 <iunlock>
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
80100f8a:	e8 51 07 00 00       	call   801016e0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f93:	8b 43 14             	mov    0x14(%ebx),%eax
80100f96:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f9a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f9e:	8b 43 10             	mov    0x10(%ebx),%eax
80100fa1:	89 04 24             	mov    %eax,(%esp)
80100fa4:	e8 e7 09 00 00       	call   80101990 <readi>
80100fa9:	85 c0                	test   %eax,%eax
80100fab:	89 c6                	mov    %eax,%esi
80100fad:	7e 03                	jle    80100fb2 <fileread+0x52>
      f->off += r;
80100faf:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fb2:	8b 43 10             	mov    0x10(%ebx),%eax
80100fb5:	89 04 24             	mov    %eax,(%esp)
80100fb8:	e8 03 08 00 00       	call   801017c0 <iunlock>
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
80100fd5:	e9 36 24 00 00       	jmp    80103410 <piperead>
80100fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fe5:	eb d8                	jmp    80100fbf <fileread+0x5f>
  panic("fileread");
80100fe7:	c7 04 24 6c 70 10 80 	movl   $0x8010706c,(%esp)
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
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
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
80101054:	e8 67 07 00 00       	call   801017c0 <iunlock>
      end_op();
80101059:	e8 52 1b 00 00       	call   80102bb0 <end_op>
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
80101073:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101078:	29 de                	sub    %ebx,%esi
8010107a:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
80101080:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
80101083:	e8 b8 1a 00 00       	call   80102b40 <begin_op>
      ilock(f->ip);
80101088:	8b 47 10             	mov    0x10(%edi),%eax
8010108b:	89 04 24             	mov    %eax,(%esp)
8010108e:	e8 4d 06 00 00       	call   801016e0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101093:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101097:	8b 47 14             	mov    0x14(%edi),%eax
8010109a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010109e:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010a1:	01 d8                	add    %ebx,%eax
801010a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801010a7:	8b 47 10             	mov    0x10(%edi),%eax
801010aa:	89 04 24             	mov    %eax,(%esp)
801010ad:	e8 de 09 00 00       	call   80101a90 <writei>
801010b2:	85 c0                	test   %eax,%eax
801010b4:	7f 92                	jg     80101048 <filewrite+0x48>
      iunlock(f->ip);
801010b6:	8b 4f 10             	mov    0x10(%edi),%ecx
801010b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010bc:	89 0c 24             	mov    %ecx,(%esp)
801010bf:	e8 fc 06 00 00       	call   801017c0 <iunlock>
      end_op();
801010c4:	e8 e7 1a 00 00       	call   80102bb0 <end_op>
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
801010fc:	e9 1f 22 00 00       	jmp    80103320 <pipewrite>
        panic("short filewrite");
80101101:	c7 04 24 75 70 10 80 	movl   $0x80107075,(%esp)
80101108:	e8 53 f2 ff ff       	call   80100360 <panic>
  panic("filewrite");
8010110d:	c7 04 24 7b 70 10 80 	movl   $0x8010707b,(%esp)
80101114:	e8 47 f2 ff ff       	call   80100360 <panic>
80101119:	66 90                	xchg   %ax,%ax
8010111b:	66 90                	xchg   %ax,%ax
8010111d:	66 90                	xchg   %ax,%ax
8010111f:	90                   	nop

80101120 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	57                   	push   %edi
80101124:	56                   	push   %esi
80101125:	53                   	push   %ebx
80101126:	83 ec 2c             	sub    $0x2c,%esp
80101129:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010112c:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101131:	85 c0                	test   %eax,%eax
80101133:	0f 84 8c 00 00 00    	je     801011c5 <balloc+0xa5>
80101139:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101140:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101143:	89 f0                	mov    %esi,%eax
80101145:	c1 f8 0c             	sar    $0xc,%eax
80101148:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010114e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101152:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101155:	89 04 24             	mov    %eax,(%esp)
80101158:	e8 73 ef ff ff       	call   801000d0 <bread>
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101165:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101168:	31 c0                	xor    %eax,%eax
8010116a:	eb 33                	jmp    8010119f <balloc+0x7f>
8010116c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101170:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101173:	89 c2                	mov    %eax,%edx
      m = 1 << (bi % 8);
80101175:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101177:	c1 fa 03             	sar    $0x3,%edx
      m = 1 << (bi % 8);
8010117a:	83 e1 07             	and    $0x7,%ecx
8010117d:	bf 01 00 00 00       	mov    $0x1,%edi
80101182:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101184:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx
      m = 1 << (bi % 8);
80101189:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010118b:	0f b6 fb             	movzbl %bl,%edi
8010118e:	85 cf                	test   %ecx,%edi
80101190:	74 46                	je     801011d8 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101192:	83 c0 01             	add    $0x1,%eax
80101195:	83 c6 01             	add    $0x1,%esi
80101198:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010119d:	74 05                	je     801011a4 <balloc+0x84>
8010119f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801011a2:	72 cc                	jb     80101170 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011a7:	89 04 24             	mov    %eax,(%esp)
801011aa:	e8 31 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801011af:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011b9:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
801011bf:	0f 82 7b ff ff ff    	jb     80101140 <balloc+0x20>
  }
  panic("balloc: out of blocks");
801011c5:	c7 04 24 85 70 10 80 	movl   $0x80107085,(%esp)
801011cc:	e8 8f f1 ff ff       	call   80100360 <panic>
801011d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
801011d8:	09 d9                	or     %ebx,%ecx
801011da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011dd:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011e1:	89 1c 24             	mov    %ebx,(%esp)
801011e4:	e8 f7 1a 00 00       	call   80102ce0 <log_write>
        brelse(bp);
801011e9:	89 1c 24             	mov    %ebx,(%esp)
801011ec:	e8 ef ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011f4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011f8:	89 04 24             	mov    %eax,(%esp)
801011fb:	e8 d0 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101200:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101207:	00 
80101208:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010120f:	00 
  bp = bread(dev, bno);
80101210:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101212:	8d 40 5c             	lea    0x5c(%eax),%eax
80101215:	89 04 24             	mov    %eax,(%esp)
80101218:	e8 c3 30 00 00       	call   801042e0 <memset>
  log_write(bp);
8010121d:	89 1c 24             	mov    %ebx,(%esp)
80101220:	e8 bb 1a 00 00       	call   80102ce0 <log_write>
  brelse(bp);
80101225:	89 1c 24             	mov    %ebx,(%esp)
80101228:	e8 b3 ef ff ff       	call   801001e0 <brelse>
}
8010122d:	83 c4 2c             	add    $0x2c,%esp
80101230:	89 f0                	mov    %esi,%eax
80101232:	5b                   	pop    %ebx
80101233:	5e                   	pop    %esi
80101234:	5f                   	pop    %edi
80101235:	5d                   	pop    %ebp
80101236:	c3                   	ret    
80101237:	89 f6                	mov    %esi,%esi
80101239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101240 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	89 c7                	mov    %eax,%edi
80101246:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101247:	31 f6                	xor    %esi,%esi
{
80101249:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010124a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010124f:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&icache.lock);
80101252:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
{
80101259:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
8010125c:	e8 3f 2f 00 00       	call   801041a0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101261:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101264:	eb 14                	jmp    8010127a <iget+0x3a>
80101266:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101268:	85 f6                	test   %esi,%esi
8010126a:	74 3c                	je     801012a8 <iget+0x68>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010126c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101272:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101278:	74 46                	je     801012c0 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010127a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010127d:	85 c9                	test   %ecx,%ecx
8010127f:	7e e7                	jle    80101268 <iget+0x28>
80101281:	39 3b                	cmp    %edi,(%ebx)
80101283:	75 e3                	jne    80101268 <iget+0x28>
80101285:	39 53 04             	cmp    %edx,0x4(%ebx)
80101288:	75 de                	jne    80101268 <iget+0x28>
      ip->ref++;
8010128a:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010128d:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010128f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
      ip->ref++;
80101296:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101299:	e8 f2 2f 00 00       	call   80104290 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010129e:	83 c4 1c             	add    $0x1c,%esp
801012a1:	89 f0                	mov    %esi,%eax
801012a3:	5b                   	pop    %ebx
801012a4:	5e                   	pop    %esi
801012a5:	5f                   	pop    %edi
801012a6:	5d                   	pop    %ebp
801012a7:	c3                   	ret    
801012a8:	85 c9                	test   %ecx,%ecx
801012aa:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ad:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012b3:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012b9:	75 bf                	jne    8010127a <iget+0x3a>
801012bb:	90                   	nop
801012bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(empty == 0)
801012c0:	85 f6                	test   %esi,%esi
801012c2:	74 29                	je     801012ed <iget+0xad>
  ip->dev = dev;
801012c4:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012c6:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012c9:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012d0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012d7:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801012de:	e8 ad 2f 00 00       	call   80104290 <release>
}
801012e3:	83 c4 1c             	add    $0x1c,%esp
801012e6:	89 f0                	mov    %esi,%eax
801012e8:	5b                   	pop    %ebx
801012e9:	5e                   	pop    %esi
801012ea:	5f                   	pop    %edi
801012eb:	5d                   	pop    %ebp
801012ec:	c3                   	ret    
    panic("iget: no inodes");
801012ed:	c7 04 24 9b 70 10 80 	movl   $0x8010709b,(%esp)
801012f4:	e8 67 f0 ff ff       	call   80100360 <panic>
801012f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101300 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101300:	55                   	push   %ebp
80101301:	89 e5                	mov    %esp,%ebp
80101303:	57                   	push   %edi
80101304:	56                   	push   %esi
80101305:	53                   	push   %ebx
80101306:	89 c3                	mov    %eax,%ebx
80101308:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010130b:	83 fa 0b             	cmp    $0xb,%edx
8010130e:	77 18                	ja     80101328 <bmap+0x28>
80101310:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
80101313:	8b 46 5c             	mov    0x5c(%esi),%eax
80101316:	85 c0                	test   %eax,%eax
80101318:	74 66                	je     80101380 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010131a:	83 c4 1c             	add    $0x1c,%esp
8010131d:	5b                   	pop    %ebx
8010131e:	5e                   	pop    %esi
8010131f:	5f                   	pop    %edi
80101320:	5d                   	pop    %ebp
80101321:	c3                   	ret    
80101322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;
80101328:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
8010132b:	83 fe 7f             	cmp    $0x7f,%esi
8010132e:	77 77                	ja     801013a7 <bmap+0xa7>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101330:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101336:	85 c0                	test   %eax,%eax
80101338:	74 5e                	je     80101398 <bmap+0x98>
    bp = bread(ip->dev, addr);
8010133a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010133e:	8b 03                	mov    (%ebx),%eax
80101340:	89 04 24             	mov    %eax,(%esp)
80101343:	e8 88 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
80101348:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
    bp = bread(ip->dev, addr);
8010134c:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010134e:	8b 32                	mov    (%edx),%esi
80101350:	85 f6                	test   %esi,%esi
80101352:	75 19                	jne    8010136d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101354:	8b 03                	mov    (%ebx),%eax
80101356:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101359:	e8 c2 fd ff ff       	call   80101120 <balloc>
8010135e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101361:	89 02                	mov    %eax,(%edx)
80101363:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101365:	89 3c 24             	mov    %edi,(%esp)
80101368:	e8 73 19 00 00       	call   80102ce0 <log_write>
    brelse(bp);
8010136d:	89 3c 24             	mov    %edi,(%esp)
80101370:	e8 6b ee ff ff       	call   801001e0 <brelse>
}
80101375:	83 c4 1c             	add    $0x1c,%esp
    brelse(bp);
80101378:	89 f0                	mov    %esi,%eax
}
8010137a:	5b                   	pop    %ebx
8010137b:	5e                   	pop    %esi
8010137c:	5f                   	pop    %edi
8010137d:	5d                   	pop    %ebp
8010137e:	c3                   	ret    
8010137f:	90                   	nop
      ip->addrs[bn] = addr = balloc(ip->dev);
80101380:	8b 03                	mov    (%ebx),%eax
80101382:	e8 99 fd ff ff       	call   80101120 <balloc>
80101387:	89 46 5c             	mov    %eax,0x5c(%esi)
}
8010138a:	83 c4 1c             	add    $0x1c,%esp
8010138d:	5b                   	pop    %ebx
8010138e:	5e                   	pop    %esi
8010138f:	5f                   	pop    %edi
80101390:	5d                   	pop    %ebp
80101391:	c3                   	ret    
80101392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101398:	8b 03                	mov    (%ebx),%eax
8010139a:	e8 81 fd ff ff       	call   80101120 <balloc>
8010139f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
801013a5:	eb 93                	jmp    8010133a <bmap+0x3a>
  panic("bmap: out of range");
801013a7:	c7 04 24 ab 70 10 80 	movl   $0x801070ab,(%esp)
801013ae:	e8 ad ef ff ff       	call   80100360 <panic>
801013b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013c0 <readsb>:
{
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	56                   	push   %esi
801013c4:	53                   	push   %ebx
801013c5:	83 ec 10             	sub    $0x10,%esp
  bp = bread(dev, 1);
801013c8:	8b 45 08             	mov    0x8(%ebp),%eax
801013cb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013d2:	00 
{
801013d3:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013d6:	89 04 24             	mov    %eax,(%esp)
801013d9:	e8 f2 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801013de:	89 34 24             	mov    %esi,(%esp)
801013e1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013e8:	00 
  bp = bread(dev, 1);
801013e9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013eb:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801013f2:	e8 89 2f 00 00       	call   80104380 <memmove>
  brelse(bp);
801013f7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013fa:	83 c4 10             	add    $0x10,%esp
801013fd:	5b                   	pop    %ebx
801013fe:	5e                   	pop    %esi
801013ff:	5d                   	pop    %ebp
  brelse(bp);
80101400:	e9 db ed ff ff       	jmp    801001e0 <brelse>
80101405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101410 <bfree>:
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	57                   	push   %edi
80101414:	89 d7                	mov    %edx,%edi
80101416:	56                   	push   %esi
80101417:	53                   	push   %ebx
80101418:	89 c3                	mov    %eax,%ebx
8010141a:	83 ec 1c             	sub    $0x1c,%esp
  readsb(dev, &sb);
8010141d:	89 04 24             	mov    %eax,(%esp)
80101420:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
80101427:	80 
80101428:	e8 93 ff ff ff       	call   801013c0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010142d:	89 fa                	mov    %edi,%edx
8010142f:	c1 ea 0c             	shr    $0xc,%edx
80101432:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101438:	89 1c 24             	mov    %ebx,(%esp)
  m = 1 << (bi % 8);
8010143b:	bb 01 00 00 00       	mov    $0x1,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101440:	89 54 24 04          	mov    %edx,0x4(%esp)
80101444:	e8 87 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80101449:	89 f9                	mov    %edi,%ecx
  bi = b % BPB;
8010144b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101451:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101453:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101456:	c1 fa 03             	sar    $0x3,%edx
  m = 1 << (bi % 8);
80101459:	d3 e3                	shl    %cl,%ebx
  bp = bread(dev, BBLOCK(b, sb));
8010145b:	89 c6                	mov    %eax,%esi
  if((bp->data[bi/8] & m) == 0)
8010145d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101462:	0f b6 c8             	movzbl %al,%ecx
80101465:	85 d9                	test   %ebx,%ecx
80101467:	74 20                	je     80101489 <bfree+0x79>
  bp->data[bi/8] &= ~m;
80101469:	f7 d3                	not    %ebx
8010146b:	21 c3                	and    %eax,%ebx
8010146d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101471:	89 34 24             	mov    %esi,(%esp)
80101474:	e8 67 18 00 00       	call   80102ce0 <log_write>
  brelse(bp);
80101479:	89 34 24             	mov    %esi,(%esp)
8010147c:	e8 5f ed ff ff       	call   801001e0 <brelse>
}
80101481:	83 c4 1c             	add    $0x1c,%esp
80101484:	5b                   	pop    %ebx
80101485:	5e                   	pop    %esi
80101486:	5f                   	pop    %edi
80101487:	5d                   	pop    %ebp
80101488:	c3                   	ret    
    panic("freeing free block");
80101489:	c7 04 24 be 70 10 80 	movl   $0x801070be,(%esp)
80101490:	e8 cb ee ff ff       	call   80100360 <panic>
80101495:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014a0 <iinit>:
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	53                   	push   %ebx
801014a4:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
801014a9:	83 ec 24             	sub    $0x24,%esp
  initlock(&icache.lock, "icache");
801014ac:	c7 44 24 04 d1 70 10 	movl   $0x801070d1,0x4(%esp)
801014b3:	80 
801014b4:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801014bb:	e8 f0 2b 00 00       	call   801040b0 <initlock>
    initsleeplock(&icache.inode[i].lock, "inode");
801014c0:	89 1c 24             	mov    %ebx,(%esp)
801014c3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014c9:	c7 44 24 04 d8 70 10 	movl   $0x801070d8,0x4(%esp)
801014d0:	80 
801014d1:	e8 ca 2a 00 00       	call   80103fa0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014d6:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014dc:	75 e2                	jne    801014c0 <iinit+0x20>
  readsb(dev, &sb);
801014de:	8b 45 08             	mov    0x8(%ebp),%eax
801014e1:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014e8:	80 
801014e9:	89 04 24             	mov    %eax,(%esp)
801014ec:	e8 cf fe ff ff       	call   801013c0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014f1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014f6:	c7 04 24 3c 71 10 80 	movl   $0x8010713c,(%esp)
801014fd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101501:	a1 d4 09 11 80       	mov    0x801109d4,%eax
80101506:	89 44 24 18          	mov    %eax,0x18(%esp)
8010150a:	a1 d0 09 11 80       	mov    0x801109d0,%eax
8010150f:	89 44 24 14          	mov    %eax,0x14(%esp)
80101513:	a1 cc 09 11 80       	mov    0x801109cc,%eax
80101518:	89 44 24 10          	mov    %eax,0x10(%esp)
8010151c:	a1 c8 09 11 80       	mov    0x801109c8,%eax
80101521:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101525:	a1 c4 09 11 80       	mov    0x801109c4,%eax
8010152a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010152e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101533:	89 44 24 04          	mov    %eax,0x4(%esp)
80101537:	e8 14 f1 ff ff       	call   80100650 <cprintf>
}
8010153c:	83 c4 24             	add    $0x24,%esp
8010153f:	5b                   	pop    %ebx
80101540:	5d                   	pop    %ebp
80101541:	c3                   	ret    
80101542:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101550 <ialloc>:
{
80101550:	55                   	push   %ebp
80101551:	89 e5                	mov    %esp,%ebp
80101553:	57                   	push   %edi
80101554:	56                   	push   %esi
80101555:	53                   	push   %ebx
80101556:	83 ec 2c             	sub    $0x2c,%esp
80101559:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010155c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101563:	8b 7d 08             	mov    0x8(%ebp),%edi
80101566:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101569:	0f 86 a2 00 00 00    	jbe    80101611 <ialloc+0xc1>
8010156f:	be 01 00 00 00       	mov    $0x1,%esi
80101574:	bb 01 00 00 00       	mov    $0x1,%ebx
80101579:	eb 1a                	jmp    80101595 <ialloc+0x45>
8010157b:	90                   	nop
8010157c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    brelse(bp);
80101580:	89 14 24             	mov    %edx,(%esp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101583:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101586:	e8 55 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010158b:	89 de                	mov    %ebx,%esi
8010158d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101593:	73 7c                	jae    80101611 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101595:	89 f0                	mov    %esi,%eax
80101597:	c1 e8 03             	shr    $0x3,%eax
8010159a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015a0:	89 3c 24             	mov    %edi,(%esp)
801015a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
801015ac:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
801015ae:	89 f0                	mov    %esi,%eax
801015b0:	83 e0 07             	and    $0x7,%eax
801015b3:	c1 e0 06             	shl    $0x6,%eax
801015b6:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015ba:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015be:	75 c0                	jne    80101580 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015c0:	89 0c 24             	mov    %ecx,(%esp)
801015c3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801015ca:	00 
801015cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015d2:	00 
801015d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015d6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015d9:	e8 02 2d 00 00       	call   801042e0 <memset>
      dip->type = type;
801015de:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
      dip->type = type;
801015e5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015e8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      dip->type = type;
801015eb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ee:	89 14 24             	mov    %edx,(%esp)
801015f1:	e8 ea 16 00 00       	call   80102ce0 <log_write>
      brelse(bp);
801015f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015f9:	89 14 24             	mov    %edx,(%esp)
801015fc:	e8 df eb ff ff       	call   801001e0 <brelse>
}
80101601:	83 c4 2c             	add    $0x2c,%esp
      return iget(dev, inum);
80101604:	89 f2                	mov    %esi,%edx
}
80101606:	5b                   	pop    %ebx
      return iget(dev, inum);
80101607:	89 f8                	mov    %edi,%eax
}
80101609:	5e                   	pop    %esi
8010160a:	5f                   	pop    %edi
8010160b:	5d                   	pop    %ebp
      return iget(dev, inum);
8010160c:	e9 2f fc ff ff       	jmp    80101240 <iget>
  panic("ialloc: no inodes");
80101611:	c7 04 24 de 70 10 80 	movl   $0x801070de,(%esp)
80101618:	e8 43 ed ff ff       	call   80100360 <panic>
8010161d:	8d 76 00             	lea    0x0(%esi),%esi

80101620 <iupdate>:
{
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	56                   	push   %esi
80101624:	53                   	push   %ebx
80101625:	83 ec 10             	sub    $0x10,%esp
80101628:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010162b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101631:	c1 e8 03             	shr    $0x3,%eax
80101634:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010163a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010163e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101641:	89 04 24             	mov    %eax,(%esp)
80101644:	e8 87 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101649:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010164c:	83 e2 07             	and    $0x7,%edx
8010164f:	c1 e2 06             	shl    $0x6,%edx
80101652:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101656:	89 c6                	mov    %eax,%esi
  dip->type = ip->type;
80101658:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010165c:	83 c2 0c             	add    $0xc,%edx
  dip->type = ip->type;
8010165f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101663:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101667:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010166b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010166f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101673:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101677:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010167b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010167e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101681:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101685:	89 14 24             	mov    %edx,(%esp)
80101688:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010168f:	00 
80101690:	e8 eb 2c 00 00       	call   80104380 <memmove>
  log_write(bp);
80101695:	89 34 24             	mov    %esi,(%esp)
80101698:	e8 43 16 00 00       	call   80102ce0 <log_write>
  brelse(bp);
8010169d:	89 75 08             	mov    %esi,0x8(%ebp)
}
801016a0:	83 c4 10             	add    $0x10,%esp
801016a3:	5b                   	pop    %ebx
801016a4:	5e                   	pop    %esi
801016a5:	5d                   	pop    %ebp
  brelse(bp);
801016a6:	e9 35 eb ff ff       	jmp    801001e0 <brelse>
801016ab:	90                   	nop
801016ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016b0 <idup>:
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	53                   	push   %ebx
801016b4:	83 ec 14             	sub    $0x14,%esp
801016b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016ba:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016c1:	e8 da 2a 00 00       	call   801041a0 <acquire>
  ip->ref++;
801016c6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016ca:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016d1:	e8 ba 2b 00 00       	call   80104290 <release>
}
801016d6:	83 c4 14             	add    $0x14,%esp
801016d9:	89 d8                	mov    %ebx,%eax
801016db:	5b                   	pop    %ebx
801016dc:	5d                   	pop    %ebp
801016dd:	c3                   	ret    
801016de:	66 90                	xchg   %ax,%ax

801016e0 <ilock>:
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	56                   	push   %esi
801016e4:	53                   	push   %ebx
801016e5:	83 ec 10             	sub    $0x10,%esp
801016e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016eb:	85 db                	test   %ebx,%ebx
801016ed:	0f 84 b3 00 00 00    	je     801017a6 <ilock+0xc6>
801016f3:	8b 53 08             	mov    0x8(%ebx),%edx
801016f6:	85 d2                	test   %edx,%edx
801016f8:	0f 8e a8 00 00 00    	jle    801017a6 <ilock+0xc6>
  acquiresleep(&ip->lock);
801016fe:	8d 43 0c             	lea    0xc(%ebx),%eax
80101701:	89 04 24             	mov    %eax,(%esp)
80101704:	e8 d7 28 00 00       	call   80103fe0 <acquiresleep>
  if(ip->valid == 0){
80101709:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010170c:	85 c0                	test   %eax,%eax
8010170e:	74 08                	je     80101718 <ilock+0x38>
}
80101710:	83 c4 10             	add    $0x10,%esp
80101713:	5b                   	pop    %ebx
80101714:	5e                   	pop    %esi
80101715:	5d                   	pop    %ebp
80101716:	c3                   	ret    
80101717:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101718:	8b 43 04             	mov    0x4(%ebx),%eax
8010171b:	c1 e8 03             	shr    $0x3,%eax
8010171e:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101724:	89 44 24 04          	mov    %eax,0x4(%esp)
80101728:	8b 03                	mov    (%ebx),%eax
8010172a:	89 04 24             	mov    %eax,(%esp)
8010172d:	e8 9e e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101732:	8b 53 04             	mov    0x4(%ebx),%edx
80101735:	83 e2 07             	and    $0x7,%edx
80101738:	c1 e2 06             	shl    $0x6,%edx
8010173b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010173f:	89 c6                	mov    %eax,%esi
    ip->type = dip->type;
80101741:	0f b7 02             	movzwl (%edx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101744:	83 c2 0c             	add    $0xc,%edx
    ip->type = dip->type;
80101747:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010174b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010174f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101753:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101757:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010175b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010175f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101763:	8b 42 fc             	mov    -0x4(%edx),%eax
80101766:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101769:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010176c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101770:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101777:	00 
80101778:	89 04 24             	mov    %eax,(%esp)
8010177b:	e8 00 2c 00 00       	call   80104380 <memmove>
    brelse(bp);
80101780:	89 34 24             	mov    %esi,(%esp)
80101783:	e8 58 ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101788:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010178d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101794:	0f 85 76 ff ff ff    	jne    80101710 <ilock+0x30>
      panic("ilock: no type");
8010179a:	c7 04 24 f6 70 10 80 	movl   $0x801070f6,(%esp)
801017a1:	e8 ba eb ff ff       	call   80100360 <panic>
    panic("ilock");
801017a6:	c7 04 24 f0 70 10 80 	movl   $0x801070f0,(%esp)
801017ad:	e8 ae eb ff ff       	call   80100360 <panic>
801017b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801017c0 <iunlock>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	56                   	push   %esi
801017c4:	53                   	push   %ebx
801017c5:	83 ec 10             	sub    $0x10,%esp
801017c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017cb:	85 db                	test   %ebx,%ebx
801017cd:	74 24                	je     801017f3 <iunlock+0x33>
801017cf:	8d 73 0c             	lea    0xc(%ebx),%esi
801017d2:	89 34 24             	mov    %esi,(%esp)
801017d5:	e8 a6 28 00 00       	call   80104080 <holdingsleep>
801017da:	85 c0                	test   %eax,%eax
801017dc:	74 15                	je     801017f3 <iunlock+0x33>
801017de:	8b 43 08             	mov    0x8(%ebx),%eax
801017e1:	85 c0                	test   %eax,%eax
801017e3:	7e 0e                	jle    801017f3 <iunlock+0x33>
  releasesleep(&ip->lock);
801017e5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017e8:	83 c4 10             	add    $0x10,%esp
801017eb:	5b                   	pop    %ebx
801017ec:	5e                   	pop    %esi
801017ed:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017ee:	e9 4d 28 00 00       	jmp    80104040 <releasesleep>
    panic("iunlock");
801017f3:	c7 04 24 05 71 10 80 	movl   $0x80107105,(%esp)
801017fa:	e8 61 eb ff ff       	call   80100360 <panic>
801017ff:	90                   	nop

80101800 <iput>:
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	57                   	push   %edi
80101804:	56                   	push   %esi
80101805:	53                   	push   %ebx
80101806:	83 ec 1c             	sub    $0x1c,%esp
80101809:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010180c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010180f:	89 3c 24             	mov    %edi,(%esp)
80101812:	e8 c9 27 00 00       	call   80103fe0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101817:	8b 56 4c             	mov    0x4c(%esi),%edx
8010181a:	85 d2                	test   %edx,%edx
8010181c:	74 07                	je     80101825 <iput+0x25>
8010181e:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101823:	74 2b                	je     80101850 <iput+0x50>
  releasesleep(&ip->lock);
80101825:	89 3c 24             	mov    %edi,(%esp)
80101828:	e8 13 28 00 00       	call   80104040 <releasesleep>
  acquire(&icache.lock);
8010182d:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101834:	e8 67 29 00 00       	call   801041a0 <acquire>
  ip->ref--;
80101839:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010183d:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101844:	83 c4 1c             	add    $0x1c,%esp
80101847:	5b                   	pop    %ebx
80101848:	5e                   	pop    %esi
80101849:	5f                   	pop    %edi
8010184a:	5d                   	pop    %ebp
  release(&icache.lock);
8010184b:	e9 40 2a 00 00       	jmp    80104290 <release>
    acquire(&icache.lock);
80101850:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101857:	e8 44 29 00 00       	call   801041a0 <acquire>
    int r = ip->ref;
8010185c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010185f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101866:	e8 25 2a 00 00       	call   80104290 <release>
    if(r == 1){
8010186b:	83 fb 01             	cmp    $0x1,%ebx
8010186e:	75 b5                	jne    80101825 <iput+0x25>
80101870:	8d 4e 30             	lea    0x30(%esi),%ecx
80101873:	89 f3                	mov    %esi,%ebx
80101875:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101878:	89 cf                	mov    %ecx,%edi
8010187a:	eb 0b                	jmp    80101887 <iput+0x87>
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101880:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101883:	39 fb                	cmp    %edi,%ebx
80101885:	74 19                	je     801018a0 <iput+0xa0>
    if(ip->addrs[i]){
80101887:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010188a:	85 d2                	test   %edx,%edx
8010188c:	74 f2                	je     80101880 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010188e:	8b 06                	mov    (%esi),%eax
80101890:	e8 7b fb ff ff       	call   80101410 <bfree>
      ip->addrs[i] = 0;
80101895:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010189c:	eb e2                	jmp    80101880 <iput+0x80>
8010189e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
801018a0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801018a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018a9:	85 c0                	test   %eax,%eax
801018ab:	75 2b                	jne    801018d8 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801018ad:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801018b4:	89 34 24             	mov    %esi,(%esp)
801018b7:	e8 64 fd ff ff       	call   80101620 <iupdate>
      ip->type = 0;
801018bc:	31 c0                	xor    %eax,%eax
801018be:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
801018c2:	89 34 24             	mov    %esi,(%esp)
801018c5:	e8 56 fd ff ff       	call   80101620 <iupdate>
      ip->valid = 0;
801018ca:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018d1:	e9 4f ff ff ff       	jmp    80101825 <iput+0x25>
801018d6:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018dc:	8b 06                	mov    (%esi),%eax
    for(j = 0; j < NINDIRECT; j++){
801018de:	31 db                	xor    %ebx,%ebx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018e0:	89 04 24             	mov    %eax,(%esp)
801018e3:	e8 e8 e7 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801018e8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    a = (uint*)bp->data;
801018eb:	8d 48 5c             	lea    0x5c(%eax),%ecx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801018f1:	89 cf                	mov    %ecx,%edi
801018f3:	31 c0                	xor    %eax,%eax
801018f5:	eb 0e                	jmp    80101905 <iput+0x105>
801018f7:	90                   	nop
801018f8:	83 c3 01             	add    $0x1,%ebx
801018fb:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80101901:	89 d8                	mov    %ebx,%eax
80101903:	74 10                	je     80101915 <iput+0x115>
      if(a[j])
80101905:	8b 14 87             	mov    (%edi,%eax,4),%edx
80101908:	85 d2                	test   %edx,%edx
8010190a:	74 ec                	je     801018f8 <iput+0xf8>
        bfree(ip->dev, a[j]);
8010190c:	8b 06                	mov    (%esi),%eax
8010190e:	e8 fd fa ff ff       	call   80101410 <bfree>
80101913:	eb e3                	jmp    801018f8 <iput+0xf8>
    brelse(bp);
80101915:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101918:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010191b:	89 04 24             	mov    %eax,(%esp)
8010191e:	e8 bd e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101923:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101929:	8b 06                	mov    (%esi),%eax
8010192b:	e8 e0 fa ff ff       	call   80101410 <bfree>
    ip->addrs[NDIRECT] = 0;
80101930:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101937:	00 00 00 
8010193a:	e9 6e ff ff ff       	jmp    801018ad <iput+0xad>
8010193f:	90                   	nop

80101940 <iunlockput>:
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	53                   	push   %ebx
80101944:	83 ec 14             	sub    $0x14,%esp
80101947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010194a:	89 1c 24             	mov    %ebx,(%esp)
8010194d:	e8 6e fe ff ff       	call   801017c0 <iunlock>
  iput(ip);
80101952:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101955:	83 c4 14             	add    $0x14,%esp
80101958:	5b                   	pop    %ebx
80101959:	5d                   	pop    %ebp
  iput(ip);
8010195a:	e9 a1 fe ff ff       	jmp    80101800 <iput>
8010195f:	90                   	nop

80101960 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	8b 55 08             	mov    0x8(%ebp),%edx
80101966:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101969:	8b 0a                	mov    (%edx),%ecx
8010196b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010196e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101971:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101974:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101978:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010197b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010197f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101983:	8b 52 58             	mov    0x58(%edx),%edx
80101986:	89 50 10             	mov    %edx,0x10(%eax)
}
80101989:	5d                   	pop    %ebp
8010198a:	c3                   	ret    
8010198b:	90                   	nop
8010198c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101990 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	57                   	push   %edi
80101994:	56                   	push   %esi
80101995:	53                   	push   %ebx
80101996:	83 ec 2c             	sub    $0x2c,%esp
80101999:	8b 45 0c             	mov    0xc(%ebp),%eax
8010199c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010199f:	8b 75 10             	mov    0x10(%ebp),%esi
801019a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019a5:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019a8:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
801019ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(ip->type == T_DEV){
801019b0:	0f 84 aa 00 00 00    	je     80101a60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019b6:	8b 47 58             	mov    0x58(%edi),%eax
801019b9:	39 f0                	cmp    %esi,%eax
801019bb:	0f 82 c7 00 00 00    	jb     80101a88 <readi+0xf8>
801019c1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019c4:	89 da                	mov    %ebx,%edx
801019c6:	01 f2                	add    %esi,%edx
801019c8:	0f 82 ba 00 00 00    	jb     80101a88 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019ce:	89 c1                	mov    %eax,%ecx
801019d0:	29 f1                	sub    %esi,%ecx
801019d2:	39 d0                	cmp    %edx,%eax
801019d4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019d7:	31 c0                	xor    %eax,%eax
801019d9:	85 c9                	test   %ecx,%ecx
    n = ip->size - off;
801019db:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019de:	74 70                	je     80101a50 <readi+0xc0>
801019e0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019e3:	89 c7                	mov    %eax,%edi
801019e5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019e8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019eb:	89 f2                	mov    %esi,%edx
801019ed:	c1 ea 09             	shr    $0x9,%edx
801019f0:	89 d8                	mov    %ebx,%eax
801019f2:	e8 09 f9 ff ff       	call   80101300 <bmap>
801019f7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019fb:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019fd:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a02:	89 04 24             	mov    %eax,(%esp)
80101a05:	e8 c6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a0a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101a0d:	29 f9                	sub    %edi,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a0f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a11:	89 f0                	mov    %esi,%eax
80101a13:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a18:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a1a:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a1e:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a20:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a24:	8b 45 e0             	mov    -0x20(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a27:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a2a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a2e:	01 df                	add    %ebx,%edi
80101a30:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a32:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a35:	89 04 24             	mov    %eax,(%esp)
80101a38:	e8 43 29 00 00       	call   80104380 <memmove>
    brelse(bp);
80101a3d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a40:	89 14 24             	mov    %edx,(%esp)
80101a43:	e8 98 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a48:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a4b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a4e:	77 98                	ja     801019e8 <readi+0x58>
  }
  return n;
80101a50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a53:	83 c4 2c             	add    $0x2c,%esp
80101a56:	5b                   	pop    %ebx
80101a57:	5e                   	pop    %esi
80101a58:	5f                   	pop    %edi
80101a59:	5d                   	pop    %ebp
80101a5a:	c3                   	ret    
80101a5b:	90                   	nop
80101a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a60:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a64:	66 83 f8 09          	cmp    $0x9,%ax
80101a68:	77 1e                	ja     80101a88 <readi+0xf8>
80101a6a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a71:	85 c0                	test   %eax,%eax
80101a73:	74 13                	je     80101a88 <readi+0xf8>
    return devsw[ip->major].read(ip, dst, n);
80101a75:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a78:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101a7b:	83 c4 2c             	add    $0x2c,%esp
80101a7e:	5b                   	pop    %ebx
80101a7f:	5e                   	pop    %esi
80101a80:	5f                   	pop    %edi
80101a81:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a82:	ff e0                	jmp    *%eax
80101a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101a88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a8d:	eb c4                	jmp    80101a53 <readi+0xc3>
80101a8f:	90                   	nop

80101a90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 2c             	sub    $0x2c,%esp
80101a99:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a9f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aa7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aaa:	8b 75 10             	mov    0x10(%ebp),%esi
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 b7 00 00 00    	je     80101b70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	39 70 58             	cmp    %esi,0x58(%eax)
80101abf:	0f 82 e3 00 00 00    	jb     80101ba8 <writei+0x118>
80101ac5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ac8:	89 c8                	mov    %ecx,%eax
80101aca:	01 f0                	add    %esi,%eax
80101acc:	0f 82 d6 00 00 00    	jb     80101ba8 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ad2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ad7:	0f 87 cb 00 00 00    	ja     80101ba8 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101add:	85 c9                	test   %ecx,%ecx
80101adf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ae6:	74 77                	je     80101b5f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101aeb:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101aed:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af2:	c1 ea 09             	shr    $0x9,%edx
80101af5:	89 f8                	mov    %edi,%eax
80101af7:	e8 04 f8 ff ff       	call   80101300 <bmap>
80101afc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b00:	8b 07                	mov    (%edi),%eax
80101b02:	89 04 24             	mov    %eax,(%esp)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b0d:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b10:	8b 55 dc             	mov    -0x24(%ebp),%edx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b13:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b15:	89 f0                	mov    %esi,%eax
80101b17:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1c:	29 c3                	sub    %eax,%ebx
80101b1e:	39 cb                	cmp    %ecx,%ebx
80101b20:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b23:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b27:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b29:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b2d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b31:	89 04 24             	mov    %eax,(%esp)
80101b34:	e8 47 28 00 00       	call   80104380 <memmove>
    log_write(bp);
80101b39:	89 3c 24             	mov    %edi,(%esp)
80101b3c:	e8 9f 11 00 00       	call   80102ce0 <log_write>
    brelse(bp);
80101b41:	89 3c 24             	mov    %edi,(%esp)
80101b44:	e8 97 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b49:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b4f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b52:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b55:	77 91                	ja     80101ae8 <writei+0x58>
  }

  if(n > 0 && off > ip->size){
80101b57:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b5a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b5d:	72 39                	jb     80101b98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b62:	83 c4 2c             	add    $0x2c,%esp
80101b65:	5b                   	pop    %ebx
80101b66:	5e                   	pop    %esi
80101b67:	5f                   	pop    %edi
80101b68:	5d                   	pop    %ebp
80101b69:	c3                   	ret    
80101b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b74:	66 83 f8 09          	cmp    $0x9,%ax
80101b78:	77 2e                	ja     80101ba8 <writei+0x118>
80101b7a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b81:	85 c0                	test   %eax,%eax
80101b83:	74 23                	je     80101ba8 <writei+0x118>
    return devsw[ip->major].write(ip, src, n);
80101b85:	89 4d 10             	mov    %ecx,0x10(%ebp)
}
80101b88:	83 c4 2c             	add    $0x2c,%esp
80101b8b:	5b                   	pop    %ebx
80101b8c:	5e                   	pop    %esi
80101b8d:	5f                   	pop    %edi
80101b8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b8f:	ff e0                	jmp    *%eax
80101b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b98:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b9b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b9e:	89 04 24             	mov    %eax,(%esp)
80101ba1:	e8 7a fa ff ff       	call   80101620 <iupdate>
80101ba6:	eb b7                	jmp    80101b5f <writei+0xcf>
}
80101ba8:	83 c4 2c             	add    $0x2c,%esp
      return -1;
80101bab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101bb0:	5b                   	pop    %ebx
80101bb1:	5e                   	pop    %esi
80101bb2:	5f                   	pop    %edi
80101bb3:	5d                   	pop    %ebp
80101bb4:	c3                   	ret    
80101bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bc9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101bd0:	00 
80101bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd8:	89 04 24             	mov    %eax,(%esp)
80101bdb:	e8 20 28 00 00       	call   80104400 <strncmp>
}
80101be0:	c9                   	leave  
80101be1:	c3                   	ret    
80101be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	57                   	push   %edi
80101bf4:	56                   	push   %esi
80101bf5:	53                   	push   %ebx
80101bf6:	83 ec 2c             	sub    $0x2c,%esp
80101bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c01:	0f 85 97 00 00 00    	jne    80101c9e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c07:	8b 53 58             	mov    0x58(%ebx),%edx
80101c0a:	31 ff                	xor    %edi,%edi
80101c0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c0f:	85 d2                	test   %edx,%edx
80101c11:	75 0d                	jne    80101c20 <dirlookup+0x30>
80101c13:	eb 73                	jmp    80101c88 <dirlookup+0x98>
80101c15:	8d 76 00             	lea    0x0(%esi),%esi
80101c18:	83 c7 10             	add    $0x10,%edi
80101c1b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101c1e:	76 68                	jbe    80101c88 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c20:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c27:	00 
80101c28:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c2c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c30:	89 1c 24             	mov    %ebx,(%esp)
80101c33:	e8 58 fd ff ff       	call   80101990 <readi>
80101c38:	83 f8 10             	cmp    $0x10,%eax
80101c3b:	75 55                	jne    80101c92 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c3d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c42:	74 d4                	je     80101c18 <dirlookup+0x28>
  return strncmp(s, t, DIRSIZ);
80101c44:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c47:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c4e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c55:	00 
80101c56:	89 04 24             	mov    %eax,(%esp)
80101c59:	e8 a2 27 00 00       	call   80104400 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c5e:	85 c0                	test   %eax,%eax
80101c60:	75 b6                	jne    80101c18 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c62:	8b 45 10             	mov    0x10(%ebp),%eax
80101c65:	85 c0                	test   %eax,%eax
80101c67:	74 05                	je     80101c6e <dirlookup+0x7e>
        *poff = off;
80101c69:	8b 45 10             	mov    0x10(%ebp),%eax
80101c6c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c6e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c72:	8b 03                	mov    (%ebx),%eax
80101c74:	e8 c7 f5 ff ff       	call   80101240 <iget>
    }
  }

  return 0;
}
80101c79:	83 c4 2c             	add    $0x2c,%esp
80101c7c:	5b                   	pop    %ebx
80101c7d:	5e                   	pop    %esi
80101c7e:	5f                   	pop    %edi
80101c7f:	5d                   	pop    %ebp
80101c80:	c3                   	ret    
80101c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c88:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80101c8b:	31 c0                	xor    %eax,%eax
}
80101c8d:	5b                   	pop    %ebx
80101c8e:	5e                   	pop    %esi
80101c8f:	5f                   	pop    %edi
80101c90:	5d                   	pop    %ebp
80101c91:	c3                   	ret    
      panic("dirlookup read");
80101c92:	c7 04 24 1f 71 10 80 	movl   $0x8010711f,(%esp)
80101c99:	e8 c2 e6 ff ff       	call   80100360 <panic>
    panic("dirlookup not DIR");
80101c9e:	c7 04 24 0d 71 10 80 	movl   $0x8010710d,(%esp)
80101ca5:	e8 b6 e6 ff ff       	call   80100360 <panic>
80101caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cb0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cb0:	55                   	push   %ebp
80101cb1:	89 e5                	mov    %esp,%ebp
80101cb3:	57                   	push   %edi
80101cb4:	89 cf                	mov    %ecx,%edi
80101cb6:	56                   	push   %esi
80101cb7:	53                   	push   %ebx
80101cb8:	89 c3                	mov    %eax,%ebx
80101cba:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cbd:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101cc0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101cc3:	0f 84 51 01 00 00    	je     80101e1a <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101cc9:	e8 02 1a 00 00       	call   801036d0 <myproc>
80101cce:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101cd1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cd8:	e8 c3 24 00 00       	call   801041a0 <acquire>
  ip->ref++;
80101cdd:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ce1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101ce8:	e8 a3 25 00 00       	call   80104290 <release>
80101ced:	eb 04                	jmp    80101cf3 <namex+0x43>
80101cef:	90                   	nop
    path++;
80101cf0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cf3:	0f b6 03             	movzbl (%ebx),%eax
80101cf6:	3c 2f                	cmp    $0x2f,%al
80101cf8:	74 f6                	je     80101cf0 <namex+0x40>
  if(*path == 0)
80101cfa:	84 c0                	test   %al,%al
80101cfc:	0f 84 ed 00 00 00    	je     80101def <namex+0x13f>
  while(*path != '/' && *path != 0)
80101d02:	0f b6 03             	movzbl (%ebx),%eax
80101d05:	89 da                	mov    %ebx,%edx
80101d07:	84 c0                	test   %al,%al
80101d09:	0f 84 b1 00 00 00    	je     80101dc0 <namex+0x110>
80101d0f:	3c 2f                	cmp    $0x2f,%al
80101d11:	75 0f                	jne    80101d22 <namex+0x72>
80101d13:	e9 a8 00 00 00       	jmp    80101dc0 <namex+0x110>
80101d18:	3c 2f                	cmp    $0x2f,%al
80101d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d20:	74 0a                	je     80101d2c <namex+0x7c>
    path++;
80101d22:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d25:	0f b6 02             	movzbl (%edx),%eax
80101d28:	84 c0                	test   %al,%al
80101d2a:	75 ec                	jne    80101d18 <namex+0x68>
80101d2c:	89 d1                	mov    %edx,%ecx
80101d2e:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d30:	83 f9 0d             	cmp    $0xd,%ecx
80101d33:	0f 8e 8f 00 00 00    	jle    80101dc8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d39:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d3d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d44:	00 
80101d45:	89 3c 24             	mov    %edi,(%esp)
80101d48:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d4b:	e8 30 26 00 00       	call   80104380 <memmove>
    path++;
80101d50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d53:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d55:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d58:	75 0e                	jne    80101d68 <namex+0xb8>
80101d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d60:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d63:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d66:	74 f8                	je     80101d60 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d68:	89 34 24             	mov    %esi,(%esp)
80101d6b:	e8 70 f9 ff ff       	call   801016e0 <ilock>
    if(ip->type != T_DIR){
80101d70:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d75:	0f 85 85 00 00 00    	jne    80101e00 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d7b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d7e:	85 d2                	test   %edx,%edx
80101d80:	74 09                	je     80101d8b <namex+0xdb>
80101d82:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d85:	0f 84 a5 00 00 00    	je     80101e30 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d8b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d92:	00 
80101d93:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d97:	89 34 24             	mov    %esi,(%esp)
80101d9a:	e8 51 fe ff ff       	call   80101bf0 <dirlookup>
80101d9f:	85 c0                	test   %eax,%eax
80101da1:	74 5d                	je     80101e00 <namex+0x150>
  iunlock(ip);
80101da3:	89 34 24             	mov    %esi,(%esp)
80101da6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101da9:	e8 12 fa ff ff       	call   801017c0 <iunlock>
  iput(ip);
80101dae:	89 34 24             	mov    %esi,(%esp)
80101db1:	e8 4a fa ff ff       	call   80101800 <iput>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101db6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101db9:	89 c6                	mov    %eax,%esi
80101dbb:	e9 33 ff ff ff       	jmp    80101cf3 <namex+0x43>
  while(*path != '/' && *path != 0)
80101dc0:	31 c9                	xor    %ecx,%ecx
80101dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(name, s, len);
80101dc8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101dcc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101dd0:	89 3c 24             	mov    %edi,(%esp)
80101dd3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dd6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101dd9:	e8 a2 25 00 00       	call   80104380 <memmove>
    name[len] = 0;
80101dde:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101de1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101de4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101de8:	89 d3                	mov    %edx,%ebx
80101dea:	e9 66 ff ff ff       	jmp    80101d55 <namex+0xa5>
  }
  if(nameiparent){
80101def:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101df2:	85 c0                	test   %eax,%eax
80101df4:	75 4c                	jne    80101e42 <namex+0x192>
80101df6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101df8:	83 c4 2c             	add    $0x2c,%esp
80101dfb:	5b                   	pop    %ebx
80101dfc:	5e                   	pop    %esi
80101dfd:	5f                   	pop    %edi
80101dfe:	5d                   	pop    %ebp
80101dff:	c3                   	ret    
  iunlock(ip);
80101e00:	89 34 24             	mov    %esi,(%esp)
80101e03:	e8 b8 f9 ff ff       	call   801017c0 <iunlock>
  iput(ip);
80101e08:	89 34 24             	mov    %esi,(%esp)
80101e0b:	e8 f0 f9 ff ff       	call   80101800 <iput>
}
80101e10:	83 c4 2c             	add    $0x2c,%esp
      return 0;
80101e13:	31 c0                	xor    %eax,%eax
}
80101e15:	5b                   	pop    %ebx
80101e16:	5e                   	pop    %esi
80101e17:	5f                   	pop    %edi
80101e18:	5d                   	pop    %ebp
80101e19:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e1a:	ba 01 00 00 00       	mov    $0x1,%edx
80101e1f:	b8 01 00 00 00       	mov    $0x1,%eax
80101e24:	e8 17 f4 ff ff       	call   80101240 <iget>
80101e29:	89 c6                	mov    %eax,%esi
80101e2b:	e9 c3 fe ff ff       	jmp    80101cf3 <namex+0x43>
      iunlock(ip);
80101e30:	89 34 24             	mov    %esi,(%esp)
80101e33:	e8 88 f9 ff ff       	call   801017c0 <iunlock>
}
80101e38:	83 c4 2c             	add    $0x2c,%esp
      return ip;
80101e3b:	89 f0                	mov    %esi,%eax
}
80101e3d:	5b                   	pop    %ebx
80101e3e:	5e                   	pop    %esi
80101e3f:	5f                   	pop    %edi
80101e40:	5d                   	pop    %ebp
80101e41:	c3                   	ret    
    iput(ip);
80101e42:	89 34 24             	mov    %esi,(%esp)
80101e45:	e8 b6 f9 ff ff       	call   80101800 <iput>
    return 0;
80101e4a:	31 c0                	xor    %eax,%eax
80101e4c:	eb aa                	jmp    80101df8 <namex+0x148>
80101e4e:	66 90                	xchg   %ax,%ax

80101e50 <dirlink>:
{
80101e50:	55                   	push   %ebp
80101e51:	89 e5                	mov    %esp,%ebp
80101e53:	57                   	push   %edi
80101e54:	56                   	push   %esi
80101e55:	53                   	push   %ebx
80101e56:	83 ec 2c             	sub    $0x2c,%esp
80101e59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e5f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e66:	00 
80101e67:	89 1c 24             	mov    %ebx,(%esp)
80101e6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e6e:	e8 7d fd ff ff       	call   80101bf0 <dirlookup>
80101e73:	85 c0                	test   %eax,%eax
80101e75:	0f 85 8b 00 00 00    	jne    80101f06 <dirlink+0xb6>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e7b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e7e:	31 ff                	xor    %edi,%edi
80101e80:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e83:	85 c0                	test   %eax,%eax
80101e85:	75 13                	jne    80101e9a <dirlink+0x4a>
80101e87:	eb 35                	jmp    80101ebe <dirlink+0x6e>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	8d 57 10             	lea    0x10(%edi),%edx
80101e93:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e96:	89 d7                	mov    %edx,%edi
80101e98:	76 24                	jbe    80101ebe <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ea1:	00 
80101ea2:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ea6:	89 74 24 04          	mov    %esi,0x4(%esp)
80101eaa:	89 1c 24             	mov    %ebx,(%esp)
80101ead:	e8 de fa ff ff       	call   80101990 <readi>
80101eb2:	83 f8 10             	cmp    $0x10,%eax
80101eb5:	75 5e                	jne    80101f15 <dirlink+0xc5>
    if(de.inum == 0)
80101eb7:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ebc:	75 d2                	jne    80101e90 <dirlink+0x40>
  strncpy(de.name, name, DIRSIZ);
80101ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ec1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ec8:	00 
80101ec9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ecd:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ed0:	89 04 24             	mov    %eax,(%esp)
80101ed3:	e8 98 25 00 00       	call   80104470 <strncpy>
  de.inum = inum;
80101ed8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101edb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ee2:	00 
80101ee3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ee7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101eeb:	89 1c 24             	mov    %ebx,(%esp)
  de.inum = inum;
80101eee:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ef2:	e8 99 fb ff ff       	call   80101a90 <writei>
80101ef7:	83 f8 10             	cmp    $0x10,%eax
80101efa:	75 25                	jne    80101f21 <dirlink+0xd1>
  return 0;
80101efc:	31 c0                	xor    %eax,%eax
}
80101efe:	83 c4 2c             	add    $0x2c,%esp
80101f01:	5b                   	pop    %ebx
80101f02:	5e                   	pop    %esi
80101f03:	5f                   	pop    %edi
80101f04:	5d                   	pop    %ebp
80101f05:	c3                   	ret    
    iput(ip);
80101f06:	89 04 24             	mov    %eax,(%esp)
80101f09:	e8 f2 f8 ff ff       	call   80101800 <iput>
    return -1;
80101f0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f13:	eb e9                	jmp    80101efe <dirlink+0xae>
      panic("dirlink read");
80101f15:	c7 04 24 2e 71 10 80 	movl   $0x8010712e,(%esp)
80101f1c:	e8 3f e4 ff ff       	call   80100360 <panic>
    panic("dirlink");
80101f21:	c7 04 24 26 77 10 80 	movl   $0x80107726,(%esp)
80101f28:	e8 33 e4 ff ff       	call   80100360 <panic>
80101f2d:	8d 76 00             	lea    0x0(%esi),%esi

80101f30 <namei>:

struct inode*
namei(char *path)
{
80101f30:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f31:	31 d2                	xor    %edx,%edx
{
80101f33:	89 e5                	mov    %esp,%ebp
80101f35:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f38:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f3e:	e8 6d fd ff ff       	call   80101cb0 <namex>
}
80101f43:	c9                   	leave  
80101f44:	c3                   	ret    
80101f45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f50 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f50:	55                   	push   %ebp
  return namex(path, 1, name);
80101f51:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f56:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f5b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f5e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f5f:	e9 4c fd ff ff       	jmp    80101cb0 <namex>
80101f64:	66 90                	xchg   %ax,%ax
80101f66:	66 90                	xchg   %ax,%ax
80101f68:	66 90                	xchg   %ax,%ax
80101f6a:	66 90                	xchg   %ax,%ax
80101f6c:	66 90                	xchg   %ax,%ax
80101f6e:	66 90                	xchg   %ax,%ax

80101f70 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f70:	55                   	push   %ebp
80101f71:	89 e5                	mov    %esp,%ebp
80101f73:	56                   	push   %esi
80101f74:	89 c6                	mov    %eax,%esi
80101f76:	53                   	push   %ebx
80101f77:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f7a:	85 c0                	test   %eax,%eax
80101f7c:	0f 84 99 00 00 00    	je     8010201b <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f82:	8b 48 08             	mov    0x8(%eax),%ecx
80101f85:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f8b:	0f 87 7e 00 00 00    	ja     8010200f <idestart+0x9f>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f91:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f96:	66 90                	xchg   %ax,%ax
80101f98:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f99:	83 e0 c0             	and    $0xffffffc0,%eax
80101f9c:	3c 40                	cmp    $0x40,%al
80101f9e:	75 f8                	jne    80101f98 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fa0:	31 db                	xor    %ebx,%ebx
80101fa2:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101fa7:	89 d8                	mov    %ebx,%eax
80101fa9:	ee                   	out    %al,(%dx)
80101faa:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101faf:	b8 01 00 00 00       	mov    $0x1,%eax
80101fb4:	ee                   	out    %al,(%dx)
80101fb5:	0f b6 c1             	movzbl %cl,%eax
80101fb8:	b2 f3                	mov    $0xf3,%dl
80101fba:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101fbb:	89 c8                	mov    %ecx,%eax
80101fbd:	b2 f4                	mov    $0xf4,%dl
80101fbf:	c1 f8 08             	sar    $0x8,%eax
80101fc2:	ee                   	out    %al,(%dx)
80101fc3:	b2 f5                	mov    $0xf5,%dl
80101fc5:	89 d8                	mov    %ebx,%eax
80101fc7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fc8:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fcc:	b2 f6                	mov    $0xf6,%dl
80101fce:	83 e0 01             	and    $0x1,%eax
80101fd1:	c1 e0 04             	shl    $0x4,%eax
80101fd4:	83 c8 e0             	or     $0xffffffe0,%eax
80101fd7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fd8:	f6 06 04             	testb  $0x4,(%esi)
80101fdb:	75 13                	jne    80101ff0 <idestart+0x80>
80101fdd:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fe2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fe7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fe8:	83 c4 10             	add    $0x10,%esp
80101feb:	5b                   	pop    %ebx
80101fec:	5e                   	pop    %esi
80101fed:	5d                   	pop    %ebp
80101fee:	c3                   	ret    
80101fef:	90                   	nop
80101ff0:	b2 f7                	mov    $0xf7,%dl
80101ff2:	b8 30 00 00 00       	mov    $0x30,%eax
80101ff7:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101ff8:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101ffd:	83 c6 5c             	add    $0x5c,%esi
80102000:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102005:	fc                   	cld    
80102006:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102008:	83 c4 10             	add    $0x10,%esp
8010200b:	5b                   	pop    %ebx
8010200c:	5e                   	pop    %esi
8010200d:	5d                   	pop    %ebp
8010200e:	c3                   	ret    
    panic("incorrect blockno");
8010200f:	c7 04 24 98 71 10 80 	movl   $0x80107198,(%esp)
80102016:	e8 45 e3 ff ff       	call   80100360 <panic>
    panic("idestart");
8010201b:	c7 04 24 8f 71 10 80 	movl   $0x8010718f,(%esp)
80102022:	e8 39 e3 ff ff       	call   80100360 <panic>
80102027:	89 f6                	mov    %esi,%esi
80102029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102030 <ideinit>:
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
80102036:	c7 44 24 04 aa 71 10 	movl   $0x801071aa,0x4(%esp)
8010203d:	80 
8010203e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102045:	e8 66 20 00 00       	call   801040b0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010204a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010204f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102056:	83 e8 01             	sub    $0x1,%eax
80102059:	89 44 24 04          	mov    %eax,0x4(%esp)
8010205d:	e8 7e 02 00 00       	call   801022e0 <ioapicenable>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102062:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102067:	90                   	nop
80102068:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102069:	83 e0 c0             	and    $0xffffffc0,%eax
8010206c:	3c 40                	cmp    $0x40,%al
8010206e:	75 f8                	jne    80102068 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102070:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102075:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010207a:	ee                   	out    %al,(%dx)
8010207b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102080:	b2 f7                	mov    $0xf7,%dl
80102082:	eb 09                	jmp    8010208d <ideinit+0x5d>
80102084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<1000; i++){
80102088:	83 e9 01             	sub    $0x1,%ecx
8010208b:	74 0f                	je     8010209c <ideinit+0x6c>
8010208d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010208e:	84 c0                	test   %al,%al
80102090:	74 f6                	je     80102088 <ideinit+0x58>
      havedisk1 = 1;
80102092:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102099:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010209c:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020a1:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801020a6:	ee                   	out    %al,(%dx)
}
801020a7:	c9                   	leave  
801020a8:	c3                   	ret    
801020a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020b0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020b0:	55                   	push   %ebp
801020b1:	89 e5                	mov    %esp,%ebp
801020b3:	57                   	push   %edi
801020b4:	56                   	push   %esi
801020b5:	53                   	push   %ebx
801020b6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020b9:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020c0:	e8 db 20 00 00       	call   801041a0 <acquire>

  if((b = idequeue) == 0){
801020c5:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020cb:	85 db                	test   %ebx,%ebx
801020cd:	74 30                	je     801020ff <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020cf:	8b 43 58             	mov    0x58(%ebx),%eax
801020d2:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020d7:	8b 33                	mov    (%ebx),%esi
801020d9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020df:	74 37                	je     80102118 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020e1:	83 e6 fb             	and    $0xfffffffb,%esi
801020e4:	83 ce 02             	or     $0x2,%esi
801020e7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020e9:	89 1c 24             	mov    %ebx,(%esp)
801020ec:	e8 ef 1c 00 00       	call   80103de0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020f1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020f6:	85 c0                	test   %eax,%eax
801020f8:	74 05                	je     801020ff <ideintr+0x4f>
    idestart(idequeue);
801020fa:	e8 71 fe ff ff       	call   80101f70 <idestart>
    release(&idelock);
801020ff:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102106:	e8 85 21 00 00       	call   80104290 <release>

  release(&idelock);
}
8010210b:	83 c4 1c             	add    $0x1c,%esp
8010210e:	5b                   	pop    %ebx
8010210f:	5e                   	pop    %esi
80102110:	5f                   	pop    %edi
80102111:	5d                   	pop    %ebp
80102112:	c3                   	ret    
80102113:	90                   	nop
80102114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102118:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010211d:	8d 76 00             	lea    0x0(%esi),%esi
80102120:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102121:	89 c1                	mov    %eax,%ecx
80102123:	83 e1 c0             	and    $0xffffffc0,%ecx
80102126:	80 f9 40             	cmp    $0x40,%cl
80102129:	75 f5                	jne    80102120 <ideintr+0x70>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010212b:	a8 21                	test   $0x21,%al
8010212d:	75 b2                	jne    801020e1 <ideintr+0x31>
    insl(0x1f0, b->data, BSIZE/4);
8010212f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102132:	b9 80 00 00 00       	mov    $0x80,%ecx
80102137:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010213c:	fc                   	cld    
8010213d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010213f:	8b 33                	mov    (%ebx),%esi
80102141:	eb 9e                	jmp    801020e1 <ideintr+0x31>
80102143:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102150 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102150:	55                   	push   %ebp
80102151:	89 e5                	mov    %esp,%ebp
80102153:	53                   	push   %ebx
80102154:	83 ec 14             	sub    $0x14,%esp
80102157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010215a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010215d:	89 04 24             	mov    %eax,(%esp)
80102160:	e8 1b 1f 00 00       	call   80104080 <holdingsleep>
80102165:	85 c0                	test   %eax,%eax
80102167:	0f 84 9e 00 00 00    	je     8010220b <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010216d:	8b 03                	mov    (%ebx),%eax
8010216f:	83 e0 06             	and    $0x6,%eax
80102172:	83 f8 02             	cmp    $0x2,%eax
80102175:	0f 84 a8 00 00 00    	je     80102223 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010217b:	8b 53 04             	mov    0x4(%ebx),%edx
8010217e:	85 d2                	test   %edx,%edx
80102180:	74 0d                	je     8010218f <iderw+0x3f>
80102182:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102187:	85 c0                	test   %eax,%eax
80102189:	0f 84 88 00 00 00    	je     80102217 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010218f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102196:	e8 05 20 00 00       	call   801041a0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010219b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
801021a0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021a7:	85 c0                	test   %eax,%eax
801021a9:	75 07                	jne    801021b2 <iderw+0x62>
801021ab:	eb 4e                	jmp    801021fb <iderw+0xab>
801021ad:	8d 76 00             	lea    0x0(%esi),%esi
801021b0:	89 d0                	mov    %edx,%eax
801021b2:	8b 50 58             	mov    0x58(%eax),%edx
801021b5:	85 d2                	test   %edx,%edx
801021b7:	75 f7                	jne    801021b0 <iderw+0x60>
801021b9:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
801021bc:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801021be:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021c4:	74 3c                	je     80102202 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021c6:	8b 03                	mov    (%ebx),%eax
801021c8:	83 e0 06             	and    $0x6,%eax
801021cb:	83 f8 02             	cmp    $0x2,%eax
801021ce:	74 1a                	je     801021ea <iderw+0x9a>
    sleep(b, &idelock);
801021d0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801021d7:	80 
801021d8:	89 1c 24             	mov    %ebx,(%esp)
801021db:	e8 60 1a 00 00       	call   80103c40 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021e0:	8b 13                	mov    (%ebx),%edx
801021e2:	83 e2 06             	and    $0x6,%edx
801021e5:	83 fa 02             	cmp    $0x2,%edx
801021e8:	75 e6                	jne    801021d0 <iderw+0x80>
  }


  release(&idelock);
801021ea:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021f1:	83 c4 14             	add    $0x14,%esp
801021f4:	5b                   	pop    %ebx
801021f5:	5d                   	pop    %ebp
  release(&idelock);
801021f6:	e9 95 20 00 00       	jmp    80104290 <release>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021fb:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
80102200:	eb ba                	jmp    801021bc <iderw+0x6c>
    idestart(b);
80102202:	89 d8                	mov    %ebx,%eax
80102204:	e8 67 fd ff ff       	call   80101f70 <idestart>
80102209:	eb bb                	jmp    801021c6 <iderw+0x76>
    panic("iderw: buf not locked");
8010220b:	c7 04 24 ae 71 10 80 	movl   $0x801071ae,(%esp)
80102212:	e8 49 e1 ff ff       	call   80100360 <panic>
    panic("iderw: ide disk 1 not present");
80102217:	c7 04 24 d9 71 10 80 	movl   $0x801071d9,(%esp)
8010221e:	e8 3d e1 ff ff       	call   80100360 <panic>
    panic("iderw: nothing to do");
80102223:	c7 04 24 c4 71 10 80 	movl   $0x801071c4,(%esp)
8010222a:	e8 31 e1 ff ff       	call   80100360 <panic>
8010222f:	90                   	nop

80102230 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	56                   	push   %esi
80102234:	53                   	push   %ebx
80102235:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102238:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010223f:	00 c0 fe 
  ioapic->reg = reg;
80102242:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102249:	00 00 00 
  return ioapic->data;
8010224c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102252:	8b 42 10             	mov    0x10(%edx),%eax
  ioapic->reg = reg;
80102255:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010225b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102261:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102268:	c1 e8 10             	shr    $0x10,%eax
8010226b:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010226e:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102271:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102274:	39 c2                	cmp    %eax,%edx
80102276:	74 12                	je     8010228a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102278:	c7 04 24 f8 71 10 80 	movl   $0x801071f8,(%esp)
8010227f:	e8 cc e3 ff ff       	call   80100650 <cprintf>
80102284:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010228a:	ba 10 00 00 00       	mov    $0x10,%edx
8010228f:	31 c0                	xor    %eax,%eax
80102291:	eb 07                	jmp    8010229a <ioapicinit+0x6a>
80102293:	90                   	nop
80102294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102298:	89 cb                	mov    %ecx,%ebx
  ioapic->reg = reg;
8010229a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010229c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
801022a2:	8d 48 20             	lea    0x20(%eax),%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022a5:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  for(i = 0; i <= maxintr; i++){
801022ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ae:	89 4b 10             	mov    %ecx,0x10(%ebx)
801022b1:	8d 4a 01             	lea    0x1(%edx),%ecx
801022b4:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801022b7:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801022b9:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
801022bf:	39 c6                	cmp    %eax,%esi
  ioapic->data = data;
801022c1:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022c8:	7d ce                	jge    80102298 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022ca:	83 c4 10             	add    $0x10,%esp
801022cd:	5b                   	pop    %ebx
801022ce:	5e                   	pop    %esi
801022cf:	5d                   	pop    %ebp
801022d0:	c3                   	ret    
801022d1:	eb 0d                	jmp    801022e0 <ioapicenable>
801022d3:	90                   	nop
801022d4:	90                   	nop
801022d5:	90                   	nop
801022d6:	90                   	nop
801022d7:	90                   	nop
801022d8:	90                   	nop
801022d9:	90                   	nop
801022da:	90                   	nop
801022db:	90                   	nop
801022dc:	90                   	nop
801022dd:	90                   	nop
801022de:	90                   	nop
801022df:	90                   	nop

801022e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	8b 55 08             	mov    0x8(%ebp),%edx
801022e6:	53                   	push   %ebx
801022e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ea:	8d 5a 20             	lea    0x20(%edx),%ebx
801022ed:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
  ioapic->reg = reg;
801022f1:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f7:	c1 e0 18             	shl    $0x18,%eax
  ioapic->reg = reg;
801022fa:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022fc:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102302:	83 c1 01             	add    $0x1,%ecx
  ioapic->data = data;
80102305:	89 5a 10             	mov    %ebx,0x10(%edx)
  ioapic->reg = reg;
80102308:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
8010230a:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102310:	89 42 10             	mov    %eax,0x10(%edx)
}
80102313:	5b                   	pop    %ebx
80102314:	5d                   	pop    %ebp
80102315:	c3                   	ret    
80102316:	66 90                	xchg   %ax,%ax
80102318:	66 90                	xchg   %ax,%ax
8010231a:	66 90                	xchg   %ax,%ax
8010231c:	66 90                	xchg   %ax,%ax
8010231e:	66 90                	xchg   %ax,%ax

80102320 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	53                   	push   %ebx
80102324:	83 ec 14             	sub    $0x14,%esp
80102327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010232a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102330:	75 7c                	jne    801023ae <kfree+0x8e>
80102332:	81 fb f4 59 11 80    	cmp    $0x801159f4,%ebx
80102338:	72 74                	jb     801023ae <kfree+0x8e>
8010233a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102340:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102345:	77 67                	ja     801023ae <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102347:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010234e:	00 
8010234f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102356:	00 
80102357:	89 1c 24             	mov    %ebx,(%esp)
8010235a:	e8 81 1f 00 00       	call   801042e0 <memset>

  if(kmem.use_lock)
8010235f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102365:	85 d2                	test   %edx,%edx
80102367:	75 37                	jne    801023a0 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102369:	a1 78 26 11 80       	mov    0x80112678,%eax
8010236e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102370:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102375:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010237b:	85 c0                	test   %eax,%eax
8010237d:	75 09                	jne    80102388 <kfree+0x68>
    release(&kmem.lock);
}
8010237f:	83 c4 14             	add    $0x14,%esp
80102382:	5b                   	pop    %ebx
80102383:	5d                   	pop    %ebp
80102384:	c3                   	ret    
80102385:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102388:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010238f:	83 c4 14             	add    $0x14,%esp
80102392:	5b                   	pop    %ebx
80102393:	5d                   	pop    %ebp
    release(&kmem.lock);
80102394:	e9 f7 1e 00 00       	jmp    80104290 <release>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
801023a0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801023a7:	e8 f4 1d 00 00       	call   801041a0 <acquire>
801023ac:	eb bb                	jmp    80102369 <kfree+0x49>
    panic("kfree");
801023ae:	c7 04 24 2a 72 10 80 	movl   $0x8010722a,(%esp)
801023b5:	e8 a6 df ff ff       	call   80100360 <panic>
801023ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023c0 <freerange>:
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
801023c5:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
801023c8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023ce:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023d4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023da:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023e0:	39 de                	cmp    %ebx,%esi
801023e2:	73 08                	jae    801023ec <freerange+0x2c>
801023e4:	eb 18                	jmp    801023fe <freerange+0x3e>
801023e6:	66 90                	xchg   %ax,%ax
801023e8:	89 da                	mov    %ebx,%edx
801023ea:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023ec:	89 14 24             	mov    %edx,(%esp)
801023ef:	e8 2c ff ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023fa:	39 f0                	cmp    %esi,%eax
801023fc:	76 ea                	jbe    801023e8 <freerange+0x28>
}
801023fe:	83 c4 10             	add    $0x10,%esp
80102401:	5b                   	pop    %ebx
80102402:	5e                   	pop    %esi
80102403:	5d                   	pop    %ebp
80102404:	c3                   	ret    
80102405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102410 <kinit1>:
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	56                   	push   %esi
80102414:	53                   	push   %ebx
80102415:	83 ec 10             	sub    $0x10,%esp
80102418:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010241b:	c7 44 24 04 30 72 10 	movl   $0x80107230,0x4(%esp)
80102422:	80 
80102423:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010242a:	e8 81 1c 00 00       	call   801040b0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010242f:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 0;
80102432:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102439:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010243c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102442:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102448:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010244e:	39 de                	cmp    %ebx,%esi
80102450:	73 0a                	jae    8010245c <kinit1+0x4c>
80102452:	eb 1a                	jmp    8010246e <kinit1+0x5e>
80102454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102458:	89 da                	mov    %ebx,%edx
8010245a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010245c:	89 14 24             	mov    %edx,(%esp)
8010245f:	e8 bc fe ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102464:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010246a:	39 c6                	cmp    %eax,%esi
8010246c:	73 ea                	jae    80102458 <kinit1+0x48>
}
8010246e:	83 c4 10             	add    $0x10,%esp
80102471:	5b                   	pop    %ebx
80102472:	5e                   	pop    %esi
80102473:	5d                   	pop    %ebp
80102474:	c3                   	ret    
80102475:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102480 <kinit2>:
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	56                   	push   %esi
80102484:	53                   	push   %ebx
80102485:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102488:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010248b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010248e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102494:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010249a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801024a0:	39 de                	cmp    %ebx,%esi
801024a2:	73 08                	jae    801024ac <kinit2+0x2c>
801024a4:	eb 18                	jmp    801024be <kinit2+0x3e>
801024a6:	66 90                	xchg   %ax,%ax
801024a8:	89 da                	mov    %ebx,%edx
801024aa:	89 c3                	mov    %eax,%ebx
    kfree(p);
801024ac:	89 14 24             	mov    %edx,(%esp)
801024af:	e8 6c fe ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801024ba:	39 c6                	cmp    %eax,%esi
801024bc:	73 ea                	jae    801024a8 <kinit2+0x28>
  kmem.use_lock = 1;
801024be:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024c5:	00 00 00 
}
801024c8:	83 c4 10             	add    $0x10,%esp
801024cb:	5b                   	pop    %ebx
801024cc:	5e                   	pop    %esi
801024cd:	5d                   	pop    %ebp
801024ce:	c3                   	ret    
801024cf:	90                   	nop

801024d0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	53                   	push   %ebx
801024d4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024d7:	a1 74 26 11 80       	mov    0x80112674,%eax
801024dc:	85 c0                	test   %eax,%eax
801024de:	75 30                	jne    80102510 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024e0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024e6:	85 db                	test   %ebx,%ebx
801024e8:	74 08                	je     801024f2 <kalloc+0x22>
    kmem.freelist = r->next;
801024ea:	8b 13                	mov    (%ebx),%edx
801024ec:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024f2:	85 c0                	test   %eax,%eax
801024f4:	74 0c                	je     80102502 <kalloc+0x32>
    release(&kmem.lock);
801024f6:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024fd:	e8 8e 1d 00 00       	call   80104290 <release>
  return (char*)r;
}
80102502:	83 c4 14             	add    $0x14,%esp
80102505:	89 d8                	mov    %ebx,%eax
80102507:	5b                   	pop    %ebx
80102508:	5d                   	pop    %ebp
80102509:	c3                   	ret    
8010250a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102510:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102517:	e8 84 1c 00 00       	call   801041a0 <acquire>
8010251c:	a1 74 26 11 80       	mov    0x80112674,%eax
80102521:	eb bd                	jmp    801024e0 <kalloc+0x10>
80102523:	66 90                	xchg   %ax,%ax
80102525:	66 90                	xchg   %ax,%ax
80102527:	66 90                	xchg   %ax,%ax
80102529:	66 90                	xchg   %ax,%ax
8010252b:	66 90                	xchg   %ax,%ax
8010252d:	66 90                	xchg   %ax,%ax
8010252f:	90                   	nop

80102530 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102530:	ba 64 00 00 00       	mov    $0x64,%edx
80102535:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102536:	a8 01                	test   $0x1,%al
80102538:	0f 84 ba 00 00 00    	je     801025f8 <kbdgetc+0xc8>
8010253e:	b2 60                	mov    $0x60,%dl
80102540:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102541:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102544:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010254a:	0f 84 88 00 00 00    	je     801025d8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102550:	84 c0                	test   %al,%al
80102552:	79 2c                	jns    80102580 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102554:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010255a:	f6 c2 40             	test   $0x40,%dl
8010255d:	75 05                	jne    80102564 <kbdgetc+0x34>
8010255f:	89 c1                	mov    %eax,%ecx
80102561:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102564:	0f b6 81 60 73 10 80 	movzbl -0x7fef8ca0(%ecx),%eax
8010256b:	83 c8 40             	or     $0x40,%eax
8010256e:	0f b6 c0             	movzbl %al,%eax
80102571:	f7 d0                	not    %eax
80102573:	21 d0                	and    %edx,%eax
80102575:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010257a:	31 c0                	xor    %eax,%eax
8010257c:	c3                   	ret    
8010257d:	8d 76 00             	lea    0x0(%esi),%esi
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	53                   	push   %ebx
80102584:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(shift & E0ESC){
8010258a:	f6 c3 40             	test   $0x40,%bl
8010258d:	74 09                	je     80102598 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010258f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102592:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102595:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102598:	0f b6 91 60 73 10 80 	movzbl -0x7fef8ca0(%ecx),%edx
  shift ^= togglecode[data];
8010259f:	0f b6 81 60 72 10 80 	movzbl -0x7fef8da0(%ecx),%eax
  shift |= shiftcode[data];
801025a6:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801025a8:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801025aa:	89 d0                	mov    %edx,%eax
801025ac:	83 e0 03             	and    $0x3,%eax
801025af:	8b 04 85 40 72 10 80 	mov    -0x7fef8dc0(,%eax,4),%eax
  shift ^= togglecode[data];
801025b6:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  if(shift & CAPSLOCK){
801025bc:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801025bf:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801025c3:	74 0b                	je     801025d0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
801025c5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025c8:	83 fa 19             	cmp    $0x19,%edx
801025cb:	77 1b                	ja     801025e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025cd:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025d0:	5b                   	pop    %ebx
801025d1:	5d                   	pop    %ebp
801025d2:	c3                   	ret    
801025d3:	90                   	nop
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025d8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801025df:	31 c0                	xor    %eax,%eax
801025e1:	c3                   	ret    
801025e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801025e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025eb:	8d 50 20             	lea    0x20(%eax),%edx
801025ee:	83 f9 19             	cmp    $0x19,%ecx
801025f1:	0f 46 c2             	cmovbe %edx,%eax
  return c;
801025f4:	eb da                	jmp    801025d0 <kbdgetc+0xa0>
801025f6:	66 90                	xchg   %ax,%ax
    return -1;
801025f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025fd:	c3                   	ret    
801025fe:	66 90                	xchg   %ax,%ax

80102600 <kbdintr>:

void
kbdintr(void)
{
80102600:	55                   	push   %ebp
80102601:	89 e5                	mov    %esp,%ebp
80102603:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102606:	c7 04 24 30 25 10 80 	movl   $0x80102530,(%esp)
8010260d:	e8 9e e1 ff ff       	call   801007b0 <consoleintr>
}
80102612:	c9                   	leave  
80102613:	c3                   	ret    
80102614:	66 90                	xchg   %ax,%ax
80102616:	66 90                	xchg   %ax,%ax
80102618:	66 90                	xchg   %ax,%ax
8010261a:	66 90                	xchg   %ax,%ax
8010261c:	66 90                	xchg   %ax,%ax
8010261e:	66 90                	xchg   %ax,%ax

80102620 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
80102620:	55                   	push   %ebp
80102621:	89 c1                	mov    %eax,%ecx
80102623:	89 e5                	mov    %esp,%ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102625:	ba 70 00 00 00       	mov    $0x70,%edx
8010262a:	53                   	push   %ebx
8010262b:	31 c0                	xor    %eax,%eax
8010262d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010262e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102633:	89 da                	mov    %ebx,%edx
80102635:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
80102636:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102639:	b2 70                	mov    $0x70,%dl
8010263b:	89 01                	mov    %eax,(%ecx)
8010263d:	b8 02 00 00 00       	mov    $0x2,%eax
80102642:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102643:	89 da                	mov    %ebx,%edx
80102645:	ec                   	in     (%dx),%al
80102646:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102649:	b2 70                	mov    $0x70,%dl
8010264b:	89 41 04             	mov    %eax,0x4(%ecx)
8010264e:	b8 04 00 00 00       	mov    $0x4,%eax
80102653:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102654:	89 da                	mov    %ebx,%edx
80102656:	ec                   	in     (%dx),%al
80102657:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010265a:	b2 70                	mov    $0x70,%dl
8010265c:	89 41 08             	mov    %eax,0x8(%ecx)
8010265f:	b8 07 00 00 00       	mov    $0x7,%eax
80102664:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102665:	89 da                	mov    %ebx,%edx
80102667:	ec                   	in     (%dx),%al
80102668:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010266b:	b2 70                	mov    $0x70,%dl
8010266d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102670:	b8 08 00 00 00       	mov    $0x8,%eax
80102675:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102676:	89 da                	mov    %ebx,%edx
80102678:	ec                   	in     (%dx),%al
80102679:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010267c:	b2 70                	mov    $0x70,%dl
8010267e:	89 41 10             	mov    %eax,0x10(%ecx)
80102681:	b8 09 00 00 00       	mov    $0x9,%eax
80102686:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102687:	89 da                	mov    %ebx,%edx
80102689:	ec                   	in     (%dx),%al
8010268a:	0f b6 d8             	movzbl %al,%ebx
8010268d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102690:	5b                   	pop    %ebx
80102691:	5d                   	pop    %ebp
80102692:	c3                   	ret    
80102693:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026a0 <lapicinit>:
  if(!lapic)
801026a0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801026a5:	55                   	push   %ebp
801026a6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801026a8:	85 c0                	test   %eax,%eax
801026aa:	0f 84 c0 00 00 00    	je     80102770 <lapicinit+0xd0>
  lapic[index] = value;
801026b0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026b7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ba:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026bd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ca:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026d1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026d4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026de:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026e1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026eb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026f8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026fb:	8b 50 20             	mov    0x20(%eax),%edx
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026fe:	8b 50 30             	mov    0x30(%eax),%edx
80102701:	c1 ea 10             	shr    $0x10,%edx
80102704:	80 fa 03             	cmp    $0x3,%dl
80102707:	77 6f                	ja     80102778 <lapicinit+0xd8>
  lapic[index] = value;
80102709:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102710:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102713:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102716:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010271d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102720:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102723:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010272a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010272d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102730:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102737:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010273a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010273d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102744:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102747:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010274a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102751:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102754:	8b 50 20             	mov    0x20(%eax),%edx
80102757:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
80102758:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010275e:	80 e6 10             	and    $0x10,%dh
80102761:	75 f5                	jne    80102758 <lapicinit+0xb8>
  lapic[index] = value;
80102763:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010276a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010276d:	8b 40 20             	mov    0x20(%eax),%eax
}
80102770:	5d                   	pop    %ebp
80102771:	c3                   	ret    
80102772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102778:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010277f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102782:	8b 50 20             	mov    0x20(%eax),%edx
80102785:	eb 82                	jmp    80102709 <lapicinit+0x69>
80102787:	89 f6                	mov    %esi,%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <lapicid>:
  if (!lapic)
80102790:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102795:	55                   	push   %ebp
80102796:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102798:	85 c0                	test   %eax,%eax
8010279a:	74 0c                	je     801027a8 <lapicid+0x18>
  return lapic[ID] >> 24;
8010279c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010279f:	5d                   	pop    %ebp
  return lapic[ID] >> 24;
801027a0:	c1 e8 18             	shr    $0x18,%eax
}
801027a3:	c3                   	ret    
801027a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801027a8:	31 c0                	xor    %eax,%eax
}
801027aa:	5d                   	pop    %ebp
801027ab:	c3                   	ret    
801027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027b0 <lapiceoi>:
  if(lapic)
801027b0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801027b5:	55                   	push   %ebp
801027b6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027b8:	85 c0                	test   %eax,%eax
801027ba:	74 0d                	je     801027c9 <lapiceoi+0x19>
  lapic[index] = value;
801027bc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027c3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c6:	8b 40 20             	mov    0x20(%eax),%eax
}
801027c9:	5d                   	pop    %ebp
801027ca:	c3                   	ret    
801027cb:	90                   	nop
801027cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027d0 <microdelay>:
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
}
801027d3:	5d                   	pop    %ebp
801027d4:	c3                   	ret    
801027d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027e0 <lapicstartap>:
{
801027e0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027e1:	ba 70 00 00 00       	mov    $0x70,%edx
801027e6:	89 e5                	mov    %esp,%ebp
801027e8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027ed:	53                   	push   %ebx
801027ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027f4:	ee                   	out    %al,(%dx)
801027f5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027fa:	b2 71                	mov    $0x71,%dl
801027fc:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
801027fd:	31 c0                	xor    %eax,%eax
801027ff:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102805:	89 d8                	mov    %ebx,%eax
80102807:	c1 e8 04             	shr    $0x4,%eax
8010280a:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102810:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(ICRHI, apicid<<24);
80102815:	c1 e1 18             	shl    $0x18,%ecx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102818:	c1 eb 0c             	shr    $0xc,%ebx
  lapic[index] = value;
8010281b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102821:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102824:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010282b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102831:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102838:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102844:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102847:	89 da                	mov    %ebx,%edx
80102849:	80 ce 06             	or     $0x6,%dh
  lapic[index] = value;
8010284c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102852:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102855:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010285b:	8b 48 20             	mov    0x20(%eax),%ecx
  lapic[index] = value;
8010285e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102864:	8b 40 20             	mov    0x20(%eax),%eax
}
80102867:	5b                   	pop    %ebx
80102868:	5d                   	pop    %ebp
80102869:	c3                   	ret    
8010286a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102870 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102870:	55                   	push   %ebp
80102871:	ba 70 00 00 00       	mov    $0x70,%edx
80102876:	89 e5                	mov    %esp,%ebp
80102878:	b8 0b 00 00 00       	mov    $0xb,%eax
8010287d:	57                   	push   %edi
8010287e:	56                   	push   %esi
8010287f:	53                   	push   %ebx
80102880:	83 ec 4c             	sub    $0x4c,%esp
80102883:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102884:	b2 71                	mov    $0x71,%dl
80102886:	ec                   	in     (%dx),%al
80102887:	88 45 b7             	mov    %al,-0x49(%ebp)
8010288a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010288d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102891:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102898:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010289d:	89 d8                	mov    %ebx,%eax
8010289f:	e8 7c fd ff ff       	call   80102620 <fill_rtcdate>
801028a4:	b8 0a 00 00 00       	mov    $0xa,%eax
801028a9:	89 f2                	mov    %esi,%edx
801028ab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ac:	ba 71 00 00 00       	mov    $0x71,%edx
801028b1:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028b2:	84 c0                	test   %al,%al
801028b4:	78 e7                	js     8010289d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
801028b6:	89 f8                	mov    %edi,%eax
801028b8:	e8 63 fd ff ff       	call   80102620 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028bd:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801028c4:	00 
801028c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
801028c9:	89 1c 24             	mov    %ebx,(%esp)
801028cc:	e8 5f 1a 00 00       	call   80104330 <memcmp>
801028d1:	85 c0                	test   %eax,%eax
801028d3:	75 c3                	jne    80102898 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801028d5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028d9:	75 78                	jne    80102953 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028db:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028de:	89 c2                	mov    %eax,%edx
801028e0:	83 e0 0f             	and    $0xf,%eax
801028e3:	c1 ea 04             	shr    $0x4,%edx
801028e6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028e9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028ec:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028ef:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028f2:	89 c2                	mov    %eax,%edx
801028f4:	83 e0 0f             	and    $0xf,%eax
801028f7:	c1 ea 04             	shr    $0x4,%edx
801028fa:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028fd:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102900:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102903:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102906:	89 c2                	mov    %eax,%edx
80102908:	83 e0 0f             	and    $0xf,%eax
8010290b:	c1 ea 04             	shr    $0x4,%edx
8010290e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102911:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102914:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102917:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010291a:	89 c2                	mov    %eax,%edx
8010291c:	83 e0 0f             	and    $0xf,%eax
8010291f:	c1 ea 04             	shr    $0x4,%edx
80102922:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102925:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102928:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010292b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010292e:	89 c2                	mov    %eax,%edx
80102930:	83 e0 0f             	and    $0xf,%eax
80102933:	c1 ea 04             	shr    $0x4,%edx
80102936:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102939:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010293c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010293f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102942:	89 c2                	mov    %eax,%edx
80102944:	83 e0 0f             	and    $0xf,%eax
80102947:	c1 ea 04             	shr    $0x4,%edx
8010294a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010294d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102950:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102953:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102956:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102959:	89 01                	mov    %eax,(%ecx)
8010295b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010295e:	89 41 04             	mov    %eax,0x4(%ecx)
80102961:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102964:	89 41 08             	mov    %eax,0x8(%ecx)
80102967:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010296a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010296d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102970:	89 41 10             	mov    %eax,0x10(%ecx)
80102973:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102976:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102979:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102980:	83 c4 4c             	add    $0x4c,%esp
80102983:	5b                   	pop    %ebx
80102984:	5e                   	pop    %esi
80102985:	5f                   	pop    %edi
80102986:	5d                   	pop    %ebp
80102987:	c3                   	ret    
80102988:	66 90                	xchg   %ax,%ax
8010298a:	66 90                	xchg   %ax,%ax
8010298c:	66 90                	xchg   %ax,%ax
8010298e:	66 90                	xchg   %ax,%ax

80102990 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102990:	55                   	push   %ebp
80102991:	89 e5                	mov    %esp,%ebp
80102993:	57                   	push   %edi
80102994:	56                   	push   %esi
80102995:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102996:	31 db                	xor    %ebx,%ebx
{
80102998:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010299b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
801029a0:	85 c0                	test   %eax,%eax
801029a2:	7e 78                	jle    80102a1c <install_trans+0x8c>
801029a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029a8:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801029ad:	01 d8                	add    %ebx,%eax
801029af:	83 c0 01             	add    $0x1,%eax
801029b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801029b6:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029bb:	89 04 24             	mov    %eax,(%esp)
801029be:	e8 0d d7 ff ff       	call   801000d0 <bread>
801029c3:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029c5:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
801029cc:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801029d3:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029d8:	89 04 24             	mov    %eax,(%esp)
801029db:	e8 f0 d6 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029e0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029e7:	00 
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029e8:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029ea:	8d 47 5c             	lea    0x5c(%edi),%eax
801029ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801029f1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029f4:	89 04 24             	mov    %eax,(%esp)
801029f7:	e8 84 19 00 00       	call   80104380 <memmove>
    bwrite(dbuf);  // write dst to disk
801029fc:	89 34 24             	mov    %esi,(%esp)
801029ff:	e8 9c d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a04:	89 3c 24             	mov    %edi,(%esp)
80102a07:	e8 d4 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a0c:	89 34 24             	mov    %esi,(%esp)
80102a0f:	e8 cc d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a14:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102a1a:	7f 8c                	jg     801029a8 <install_trans+0x18>
  }
}
80102a1c:	83 c4 1c             	add    $0x1c,%esp
80102a1f:	5b                   	pop    %ebx
80102a20:	5e                   	pop    %esi
80102a21:	5f                   	pop    %edi
80102a22:	5d                   	pop    %ebp
80102a23:	c3                   	ret    
80102a24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a30 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a30:	55                   	push   %ebp
80102a31:	89 e5                	mov    %esp,%ebp
80102a33:	57                   	push   %edi
80102a34:	56                   	push   %esi
80102a35:	53                   	push   %ebx
80102a36:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a39:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a3e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a42:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a47:	89 04 24             	mov    %eax,(%esp)
80102a4a:	e8 81 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a4f:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a55:	31 d2                	xor    %edx,%edx
80102a57:	85 db                	test   %ebx,%ebx
  struct buf *buf = bread(log.dev, log.start);
80102a59:	89 c7                	mov    %eax,%edi
  hb->n = log.lh.n;
80102a5b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a5e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a61:	7e 17                	jle    80102a7a <write_head+0x4a>
80102a63:	90                   	nop
80102a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a68:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a6f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102a73:	83 c2 01             	add    $0x1,%edx
80102a76:	39 da                	cmp    %ebx,%edx
80102a78:	75 ee                	jne    80102a68 <write_head+0x38>
  }
  bwrite(buf);
80102a7a:	89 3c 24             	mov    %edi,(%esp)
80102a7d:	e8 1e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a82:	89 3c 24             	mov    %edi,(%esp)
80102a85:	e8 56 d7 ff ff       	call   801001e0 <brelse>
}
80102a8a:	83 c4 1c             	add    $0x1c,%esp
80102a8d:	5b                   	pop    %ebx
80102a8e:	5e                   	pop    %esi
80102a8f:	5f                   	pop    %edi
80102a90:	5d                   	pop    %ebp
80102a91:	c3                   	ret    
80102a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102aa0 <initlog>:
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	56                   	push   %esi
80102aa4:	53                   	push   %ebx
80102aa5:	83 ec 30             	sub    $0x30,%esp
80102aa8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102aab:	c7 44 24 04 60 74 10 	movl   $0x80107460,0x4(%esp)
80102ab2:	80 
80102ab3:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102aba:	e8 f1 15 00 00       	call   801040b0 <initlock>
  readsb(dev, &sb);
80102abf:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ac2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ac6:	89 1c 24             	mov    %ebx,(%esp)
80102ac9:	e8 f2 e8 ff ff       	call   801013c0 <readsb>
  log.start = sb.logstart;
80102ace:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102ad1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  struct buf *buf = bread(log.dev, log.start);
80102ad4:	89 1c 24             	mov    %ebx,(%esp)
  log.dev = dev;
80102ad7:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  struct buf *buf = bread(log.dev, log.start);
80102add:	89 44 24 04          	mov    %eax,0x4(%esp)
  log.size = sb.nlog;
80102ae1:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102ae7:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102aec:	e8 df d5 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102af1:	31 d2                	xor    %edx,%edx
  log.lh.n = lh->n;
80102af3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102af6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102af9:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102afb:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102b01:	7e 17                	jle    80102b1a <initlog+0x7a>
80102b03:	90                   	nop
80102b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102b08:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102b0c:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102b13:	83 c2 01             	add    $0x1,%edx
80102b16:	39 da                	cmp    %ebx,%edx
80102b18:	75 ee                	jne    80102b08 <initlog+0x68>
  brelse(buf);
80102b1a:	89 04 24             	mov    %eax,(%esp)
80102b1d:	e8 be d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b22:	e8 69 fe ff ff       	call   80102990 <install_trans>
  log.lh.n = 0;
80102b27:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b2e:	00 00 00 
  write_head(); // clear the log
80102b31:	e8 fa fe ff ff       	call   80102a30 <write_head>
}
80102b36:	83 c4 30             	add    $0x30,%esp
80102b39:	5b                   	pop    %ebx
80102b3a:	5e                   	pop    %esi
80102b3b:	5d                   	pop    %ebp
80102b3c:	c3                   	ret    
80102b3d:	8d 76 00             	lea    0x0(%esi),%esi

80102b40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b40:	55                   	push   %ebp
80102b41:	89 e5                	mov    %esp,%ebp
80102b43:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b46:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b4d:	e8 4e 16 00 00       	call   801041a0 <acquire>
80102b52:	eb 18                	jmp    80102b6c <begin_op+0x2c>
80102b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b58:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b5f:	80 
80102b60:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b67:	e8 d4 10 00 00       	call   80103c40 <sleep>
    if(log.committing){
80102b6c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b71:	85 c0                	test   %eax,%eax
80102b73:	75 e3                	jne    80102b58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b75:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b7a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b80:	83 c0 01             	add    $0x1,%eax
80102b83:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b86:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b89:	83 fa 1e             	cmp    $0x1e,%edx
80102b8c:	7f ca                	jg     80102b58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b8e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      log.outstanding += 1;
80102b95:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b9a:	e8 f1 16 00 00       	call   80104290 <release>
      break;
    }
  }
}
80102b9f:	c9                   	leave  
80102ba0:	c3                   	ret    
80102ba1:	eb 0d                	jmp    80102bb0 <end_op>
80102ba3:	90                   	nop
80102ba4:	90                   	nop
80102ba5:	90                   	nop
80102ba6:	90                   	nop
80102ba7:	90                   	nop
80102ba8:	90                   	nop
80102ba9:	90                   	nop
80102baa:	90                   	nop
80102bab:	90                   	nop
80102bac:	90                   	nop
80102bad:	90                   	nop
80102bae:	90                   	nop
80102baf:	90                   	nop

80102bb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102bb0:	55                   	push   %ebp
80102bb1:	89 e5                	mov    %esp,%ebp
80102bb3:	57                   	push   %edi
80102bb4:	56                   	push   %esi
80102bb5:	53                   	push   %ebx
80102bb6:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102bb9:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102bc0:	e8 db 15 00 00       	call   801041a0 <acquire>
  log.outstanding -= 1;
80102bc5:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102bca:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
  log.outstanding -= 1;
80102bd0:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102bd3:	85 d2                	test   %edx,%edx
  log.outstanding -= 1;
80102bd5:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102bda:	0f 85 f3 00 00 00    	jne    80102cd3 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102be0:	85 c0                	test   %eax,%eax
80102be2:	0f 85 cb 00 00 00    	jne    80102cb3 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102be8:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bef:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
80102bf1:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102bf8:	00 00 00 
  release(&log.lock);
80102bfb:	e8 90 16 00 00       	call   80104290 <release>
  if (log.lh.n > 0) {
80102c00:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102c05:	85 c0                	test   %eax,%eax
80102c07:	0f 8e 90 00 00 00    	jle    80102c9d <end_op+0xed>
80102c0d:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c10:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c15:	01 d8                	add    %ebx,%eax
80102c17:	83 c0 01             	add    $0x1,%eax
80102c1a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c1e:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c23:	89 04 24             	mov    %eax,(%esp)
80102c26:	e8 a5 d4 ff ff       	call   801000d0 <bread>
80102c2b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c2d:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102c34:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c37:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c3b:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c40:	89 04 24             	mov    %eax,(%esp)
80102c43:	e8 88 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c48:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c4f:	00 
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c50:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c52:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c55:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c59:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c5c:	89 04 24             	mov    %eax,(%esp)
80102c5f:	e8 1c 17 00 00       	call   80104380 <memmove>
    bwrite(to);  // write the log
80102c64:	89 34 24             	mov    %esi,(%esp)
80102c67:	e8 34 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c6c:	89 3c 24             	mov    %edi,(%esp)
80102c6f:	e8 6c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c74:	89 34 24             	mov    %esi,(%esp)
80102c77:	e8 64 d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c7c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c82:	7c 8c                	jl     80102c10 <end_op+0x60>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c84:	e8 a7 fd ff ff       	call   80102a30 <write_head>
    install_trans(); // Now install writes to home locations
80102c89:	e8 02 fd ff ff       	call   80102990 <install_trans>
    log.lh.n = 0;
80102c8e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c95:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c98:	e8 93 fd ff ff       	call   80102a30 <write_head>
    acquire(&log.lock);
80102c9d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ca4:	e8 f7 14 00 00       	call   801041a0 <acquire>
    log.committing = 0;
80102ca9:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102cb0:	00 00 00 
    wakeup(&log);
80102cb3:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cba:	e8 21 11 00 00       	call   80103de0 <wakeup>
    release(&log.lock);
80102cbf:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cc6:	e8 c5 15 00 00       	call   80104290 <release>
}
80102ccb:	83 c4 1c             	add    $0x1c,%esp
80102cce:	5b                   	pop    %ebx
80102ccf:	5e                   	pop    %esi
80102cd0:	5f                   	pop    %edi
80102cd1:	5d                   	pop    %ebp
80102cd2:	c3                   	ret    
    panic("log.committing");
80102cd3:	c7 04 24 64 74 10 80 	movl   $0x80107464,(%esp)
80102cda:	e8 81 d6 ff ff       	call   80100360 <panic>
80102cdf:	90                   	nop

80102ce0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ce0:	55                   	push   %ebp
80102ce1:	89 e5                	mov    %esp,%ebp
80102ce3:	53                   	push   %ebx
80102ce4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ce7:	a1 c8 26 11 80       	mov    0x801126c8,%eax
{
80102cec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cef:	83 f8 1d             	cmp    $0x1d,%eax
80102cf2:	0f 8f 98 00 00 00    	jg     80102d90 <log_write+0xb0>
80102cf8:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102cfe:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102d01:	39 d0                	cmp    %edx,%eax
80102d03:	0f 8d 87 00 00 00    	jge    80102d90 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d09:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d0e:	85 c0                	test   %eax,%eax
80102d10:	0f 8e 86 00 00 00    	jle    80102d9c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d16:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d1d:	e8 7e 14 00 00       	call   801041a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d22:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d28:	83 fa 00             	cmp    $0x0,%edx
80102d2b:	7e 54                	jle    80102d81 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d2d:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102d30:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d32:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102d38:	75 0f                	jne    80102d49 <log_write+0x69>
80102d3a:	eb 3c                	jmp    80102d78 <log_write+0x98>
80102d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d40:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d47:	74 2f                	je     80102d78 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102d49:	83 c0 01             	add    $0x1,%eax
80102d4c:	39 d0                	cmp    %edx,%eax
80102d4e:	75 f0                	jne    80102d40 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102d50:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d57:	83 c2 01             	add    $0x1,%edx
80102d5a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d60:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d63:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d6a:	83 c4 14             	add    $0x14,%esp
80102d6d:	5b                   	pop    %ebx
80102d6e:	5d                   	pop    %ebp
  release(&log.lock);
80102d6f:	e9 1c 15 00 00       	jmp    80104290 <release>
80102d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80102d78:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d7f:	eb df                	jmp    80102d60 <log_write+0x80>
80102d81:	8b 43 08             	mov    0x8(%ebx),%eax
80102d84:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102d89:	75 d5                	jne    80102d60 <log_write+0x80>
80102d8b:	eb ca                	jmp    80102d57 <log_write+0x77>
80102d8d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("too big a transaction");
80102d90:	c7 04 24 73 74 10 80 	movl   $0x80107473,(%esp)
80102d97:	e8 c4 d5 ff ff       	call   80100360 <panic>
    panic("log_write outside of trans");
80102d9c:	c7 04 24 89 74 10 80 	movl   $0x80107489,(%esp)
80102da3:	e8 b8 d5 ff ff       	call   80100360 <panic>
80102da8:	66 90                	xchg   %ax,%ax
80102daa:	66 90                	xchg   %ax,%ax
80102dac:	66 90                	xchg   %ax,%ax
80102dae:	66 90                	xchg   %ax,%ax

80102db0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	53                   	push   %ebx
80102db4:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102db7:	e8 f4 08 00 00       	call   801036b0 <cpuid>
80102dbc:	89 c3                	mov    %eax,%ebx
80102dbe:	e8 ed 08 00 00       	call   801036b0 <cpuid>
80102dc3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102dc7:	c7 04 24 a4 74 10 80 	movl   $0x801074a4,(%esp)
80102dce:	89 44 24 04          	mov    %eax,0x4(%esp)
80102dd2:	e8 79 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102dd7:	e8 64 27 00 00       	call   80105540 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ddc:	e8 4f 08 00 00       	call   80103630 <mycpu>
80102de1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102de3:	b8 01 00 00 00       	mov    $0x1,%eax
80102de8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102def:	e8 9c 0b 00 00       	call   80103990 <scheduler>
80102df4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102dfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102e00 <mpenter>:
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e06:	e8 f5 38 00 00       	call   80106700 <switchkvm>
  seginit();
80102e0b:	e8 60 36 00 00       	call   80106470 <seginit>
  lapicinit();
80102e10:	e8 8b f8 ff ff       	call   801026a0 <lapicinit>
  mpmain();
80102e15:	e8 96 ff ff ff       	call   80102db0 <mpmain>
80102e1a:	66 90                	xchg   %ax,%ax
80102e1c:	66 90                	xchg   %ax,%ax
80102e1e:	66 90                	xchg   %ax,%ax

80102e20 <main>:
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e24:	bb 80 27 11 80       	mov    $0x80112780,%ebx
{
80102e29:	83 e4 f0             	and    $0xfffffff0,%esp
80102e2c:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e2f:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e36:	80 
80102e37:	c7 04 24 f4 59 11 80 	movl   $0x801159f4,(%esp)
80102e3e:	e8 cd f5 ff ff       	call   80102410 <kinit1>
  kvmalloc();      // kernel page table
80102e43:	e8 78 3d 00 00       	call   80106bc0 <kvmalloc>
  mpinit();        // detect other processors
80102e48:	e8 73 01 00 00       	call   80102fc0 <mpinit>
80102e4d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e50:	e8 4b f8 ff ff       	call   801026a0 <lapicinit>
  seginit();       // segment descriptors
80102e55:	e8 16 36 00 00       	call   80106470 <seginit>
  picinit();       // disable pic
80102e5a:	e8 21 03 00 00       	call   80103180 <picinit>
80102e5f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e60:	e8 cb f3 ff ff       	call   80102230 <ioapicinit>
  consoleinit();   // console hardware
80102e65:	e8 e6 da ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e6a:	e8 d1 2a 00 00       	call   80105940 <uartinit>
80102e6f:	90                   	nop
  pinit();         // process table
80102e70:	e8 9b 07 00 00       	call   80103610 <pinit>
  shminit();       // shared memory
80102e75:	e8 96 40 00 00       	call   80106f10 <shminit>
  tvinit();        // trap vectors
80102e7a:	e8 21 26 00 00       	call   801054a0 <tvinit>
80102e7f:	90                   	nop
  binit();         // buffer cache
80102e80:	e8 bb d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102e85:	e8 e6 de ff ff       	call   80100d70 <fileinit>
  ideinit();       // disk 
80102e8a:	e8 a1 f1 ff ff       	call   80102030 <ideinit>
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e8f:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e96:	00 
80102e97:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102e9e:	80 
80102e9f:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102ea6:	e8 d5 14 00 00       	call   80104380 <memmove>
  for(c = cpus; c < cpus+ncpu; c++){
80102eab:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102eb2:	00 00 00 
80102eb5:	05 80 27 11 80       	add    $0x80112780,%eax
80102eba:	39 d8                	cmp    %ebx,%eax
80102ebc:	76 65                	jbe    80102f23 <main+0x103>
80102ebe:	66 90                	xchg   %ax,%ax
    if(c == mycpu())  // We've started already.
80102ec0:	e8 6b 07 00 00       	call   80103630 <mycpu>
80102ec5:	39 d8                	cmp    %ebx,%eax
80102ec7:	74 41                	je     80102f0a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ec9:	e8 02 f6 ff ff       	call   801024d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102ece:	c7 05 f8 6f 00 80 00 	movl   $0x80102e00,0x80006ff8
80102ed5:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102ed8:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102edf:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ee2:	05 00 10 00 00       	add    $0x1000,%eax
80102ee7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102eec:	0f b6 03             	movzbl (%ebx),%eax
80102eef:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102ef6:	00 
80102ef7:	89 04 24             	mov    %eax,(%esp)
80102efa:	e8 e1 f8 ff ff       	call   801027e0 <lapicstartap>
80102eff:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f00:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f06:	85 c0                	test   %eax,%eax
80102f08:	74 f6                	je     80102f00 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f0a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f11:	00 00 00 
80102f14:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f1a:	05 80 27 11 80       	add    $0x80112780,%eax
80102f1f:	39 c3                	cmp    %eax,%ebx
80102f21:	72 9d                	jb     80102ec0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f23:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f2a:	8e 
80102f2b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f32:	e8 49 f5 ff ff       	call   80102480 <kinit2>
  userinit();      // first user process
80102f37:	e8 c4 07 00 00       	call   80103700 <userinit>
  mpmain();        // finish this processor's setup
80102f3c:	e8 6f fe ff ff       	call   80102db0 <mpmain>
80102f41:	66 90                	xchg   %ax,%ax
80102f43:	66 90                	xchg   %ax,%ax
80102f45:	66 90                	xchg   %ax,%ax
80102f47:	66 90                	xchg   %ax,%ax
80102f49:	66 90                	xchg   %ax,%ax
80102f4b:	66 90                	xchg   %ax,%ax
80102f4d:	66 90                	xchg   %ax,%ax
80102f4f:	90                   	nop

80102f50 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f54:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102f5a:	53                   	push   %ebx
  e = addr+len;
80102f5b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102f5e:	83 ec 10             	sub    $0x10,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102f61:	39 de                	cmp    %ebx,%esi
80102f63:	73 3c                	jae    80102fa1 <mpsearch1+0x51>
80102f65:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f68:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f6f:	00 
80102f70:	c7 44 24 04 b8 74 10 	movl   $0x801074b8,0x4(%esp)
80102f77:	80 
80102f78:	89 34 24             	mov    %esi,(%esp)
80102f7b:	e8 b0 13 00 00       	call   80104330 <memcmp>
80102f80:	85 c0                	test   %eax,%eax
80102f82:	75 16                	jne    80102f9a <mpsearch1+0x4a>
80102f84:	31 c9                	xor    %ecx,%ecx
80102f86:	31 d2                	xor    %edx,%edx
    sum += addr[i];
80102f88:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
  for(i=0; i<len; i++)
80102f8c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f8f:	01 c1                	add    %eax,%ecx
  for(i=0; i<len; i++)
80102f91:	83 fa 10             	cmp    $0x10,%edx
80102f94:	75 f2                	jne    80102f88 <mpsearch1+0x38>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f96:	84 c9                	test   %cl,%cl
80102f98:	74 10                	je     80102faa <mpsearch1+0x5a>
  for(p = addr; p < e; p += sizeof(struct mp))
80102f9a:	83 c6 10             	add    $0x10,%esi
80102f9d:	39 f3                	cmp    %esi,%ebx
80102f9f:	77 c7                	ja     80102f68 <mpsearch1+0x18>
      return (struct mp*)p;
  return 0;
}
80102fa1:	83 c4 10             	add    $0x10,%esp
  return 0;
80102fa4:	31 c0                	xor    %eax,%eax
}
80102fa6:	5b                   	pop    %ebx
80102fa7:	5e                   	pop    %esi
80102fa8:	5d                   	pop    %ebp
80102fa9:	c3                   	ret    
80102faa:	83 c4 10             	add    $0x10,%esp
80102fad:	89 f0                	mov    %esi,%eax
80102faf:	5b                   	pop    %ebx
80102fb0:	5e                   	pop    %esi
80102fb1:	5d                   	pop    %ebp
80102fb2:	c3                   	ret    
80102fb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fc0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	57                   	push   %edi
80102fc4:	56                   	push   %esi
80102fc5:	53                   	push   %ebx
80102fc6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102fc9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102fd0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102fd7:	c1 e0 08             	shl    $0x8,%eax
80102fda:	09 d0                	or     %edx,%eax
80102fdc:	c1 e0 04             	shl    $0x4,%eax
80102fdf:	85 c0                	test   %eax,%eax
80102fe1:	75 1b                	jne    80102ffe <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102fe3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102fea:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102ff1:	c1 e0 08             	shl    $0x8,%eax
80102ff4:	09 d0                	or     %edx,%eax
80102ff6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102ff9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80102ffe:	ba 00 04 00 00       	mov    $0x400,%edx
80103003:	e8 48 ff ff ff       	call   80102f50 <mpsearch1>
80103008:	85 c0                	test   %eax,%eax
8010300a:	89 c7                	mov    %eax,%edi
8010300c:	0f 84 22 01 00 00    	je     80103134 <mpinit+0x174>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103012:	8b 77 04             	mov    0x4(%edi),%esi
80103015:	85 f6                	test   %esi,%esi
80103017:	0f 84 30 01 00 00    	je     8010314d <mpinit+0x18d>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010301d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103023:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010302a:	00 
8010302b:	c7 44 24 04 bd 74 10 	movl   $0x801074bd,0x4(%esp)
80103032:	80 
80103033:	89 04 24             	mov    %eax,(%esp)
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103036:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103039:	e8 f2 12 00 00       	call   80104330 <memcmp>
8010303e:	85 c0                	test   %eax,%eax
80103040:	0f 85 07 01 00 00    	jne    8010314d <mpinit+0x18d>
  if(conf->version != 1 && conf->version != 4)
80103046:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010304d:	3c 04                	cmp    $0x4,%al
8010304f:	0f 85 0b 01 00 00    	jne    80103160 <mpinit+0x1a0>
  if(sum((uchar*)conf, conf->length) != 0)
80103055:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
  for(i=0; i<len; i++)
8010305c:	85 c0                	test   %eax,%eax
8010305e:	74 21                	je     80103081 <mpinit+0xc1>
  sum = 0;
80103060:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103062:	31 d2                	xor    %edx,%edx
80103064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103068:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010306f:	80 
  for(i=0; i<len; i++)
80103070:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103073:	01 d9                	add    %ebx,%ecx
  for(i=0; i<len; i++)
80103075:	39 d0                	cmp    %edx,%eax
80103077:	7f ef                	jg     80103068 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103079:	84 c9                	test   %cl,%cl
8010307b:	0f 85 cc 00 00 00    	jne    8010314d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103081:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103084:	85 c0                	test   %eax,%eax
80103086:	0f 84 c1 00 00 00    	je     8010314d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010308c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  ismp = 1;
80103092:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103097:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010309c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801030a3:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801030a9:	03 55 e4             	add    -0x1c(%ebp),%edx
801030ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030b0:	39 c2                	cmp    %eax,%edx
801030b2:	76 1b                	jbe    801030cf <mpinit+0x10f>
801030b4:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
801030b7:	80 f9 04             	cmp    $0x4,%cl
801030ba:	77 74                	ja     80103130 <mpinit+0x170>
801030bc:	ff 24 8d fc 74 10 80 	jmp    *-0x7fef8b04(,%ecx,4)
801030c3:	90                   	nop
801030c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801030c8:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030cb:	39 c2                	cmp    %eax,%edx
801030cd:	77 e5                	ja     801030b4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801030cf:	85 db                	test   %ebx,%ebx
801030d1:	0f 84 93 00 00 00    	je     8010316a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801030d7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801030db:	74 12                	je     801030ef <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030dd:	ba 22 00 00 00       	mov    $0x22,%edx
801030e2:	b8 70 00 00 00       	mov    $0x70,%eax
801030e7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030e8:	b2 23                	mov    $0x23,%dl
801030ea:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801030eb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ee:	ee                   	out    %al,(%dx)
  }
}
801030ef:	83 c4 1c             	add    $0x1c,%esp
801030f2:	5b                   	pop    %ebx
801030f3:	5e                   	pop    %esi
801030f4:	5f                   	pop    %edi
801030f5:	5d                   	pop    %ebp
801030f6:	c3                   	ret    
801030f7:	90                   	nop
      if(ncpu < NCPU) {
801030f8:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801030fe:	83 fe 07             	cmp    $0x7,%esi
80103101:	7f 17                	jg     8010311a <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103103:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
80103107:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
8010310d:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103114:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
      p += sizeof(struct mpproc);
8010311a:	83 c0 14             	add    $0x14,%eax
      continue;
8010311d:	eb 91                	jmp    801030b0 <mpinit+0xf0>
8010311f:	90                   	nop
      ioapicid = ioapic->apicno;
80103120:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103124:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103127:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
8010312d:	eb 81                	jmp    801030b0 <mpinit+0xf0>
8010312f:	90                   	nop
      ismp = 0;
80103130:	31 db                	xor    %ebx,%ebx
80103132:	eb 83                	jmp    801030b7 <mpinit+0xf7>
  return mpsearch1(0xF0000, 0x10000);
80103134:	ba 00 00 01 00       	mov    $0x10000,%edx
80103139:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010313e:	e8 0d fe ff ff       	call   80102f50 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103143:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103145:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103147:	0f 85 c5 fe ff ff    	jne    80103012 <mpinit+0x52>
    panic("Expect to run on an SMP");
8010314d:	c7 04 24 c2 74 10 80 	movl   $0x801074c2,(%esp)
80103154:	e8 07 d2 ff ff       	call   80100360 <panic>
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(conf->version != 1 && conf->version != 4)
80103160:	3c 01                	cmp    $0x1,%al
80103162:	0f 84 ed fe ff ff    	je     80103055 <mpinit+0x95>
80103168:	eb e3                	jmp    8010314d <mpinit+0x18d>
    panic("Didn't find a suitable machine");
8010316a:	c7 04 24 dc 74 10 80 	movl   $0x801074dc,(%esp)
80103171:	e8 ea d1 ff ff       	call   80100360 <panic>
80103176:	66 90                	xchg   %ax,%ax
80103178:	66 90                	xchg   %ax,%ax
8010317a:	66 90                	xchg   %ax,%ax
8010317c:	66 90                	xchg   %ax,%ax
8010317e:	66 90                	xchg   %ax,%ax

80103180 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103180:	55                   	push   %ebp
80103181:	ba 21 00 00 00       	mov    $0x21,%edx
80103186:	89 e5                	mov    %esp,%ebp
80103188:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010318d:	ee                   	out    %al,(%dx)
8010318e:	b2 a1                	mov    $0xa1,%dl
80103190:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103191:	5d                   	pop    %ebp
80103192:	c3                   	ret    
80103193:	66 90                	xchg   %ax,%ax
80103195:	66 90                	xchg   %ax,%ax
80103197:	66 90                	xchg   %ax,%ax
80103199:	66 90                	xchg   %ax,%ax
8010319b:	66 90                	xchg   %ax,%ax
8010319d:	66 90                	xchg   %ax,%ax
8010319f:	90                   	nop

801031a0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	57                   	push   %edi
801031a4:	56                   	push   %esi
801031a5:	53                   	push   %ebx
801031a6:	83 ec 1c             	sub    $0x1c,%esp
801031a9:	8b 75 08             	mov    0x8(%ebp),%esi
801031ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801031af:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801031b5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801031bb:	e8 d0 db ff ff       	call   80100d90 <filealloc>
801031c0:	85 c0                	test   %eax,%eax
801031c2:	89 06                	mov    %eax,(%esi)
801031c4:	0f 84 a4 00 00 00    	je     8010326e <pipealloc+0xce>
801031ca:	e8 c1 db ff ff       	call   80100d90 <filealloc>
801031cf:	85 c0                	test   %eax,%eax
801031d1:	89 03                	mov    %eax,(%ebx)
801031d3:	0f 84 87 00 00 00    	je     80103260 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801031d9:	e8 f2 f2 ff ff       	call   801024d0 <kalloc>
801031de:	85 c0                	test   %eax,%eax
801031e0:	89 c7                	mov    %eax,%edi
801031e2:	74 7c                	je     80103260 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801031e4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031eb:	00 00 00 
  p->writeopen = 1;
801031ee:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031f5:	00 00 00 
  p->nwrite = 0;
801031f8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031ff:	00 00 00 
  p->nread = 0;
80103202:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103209:	00 00 00 
  initlock(&p->lock, "pipe");
8010320c:	89 04 24             	mov    %eax,(%esp)
8010320f:	c7 44 24 04 10 75 10 	movl   $0x80107510,0x4(%esp)
80103216:	80 
80103217:	e8 94 0e 00 00       	call   801040b0 <initlock>
  (*f0)->type = FD_PIPE;
8010321c:	8b 06                	mov    (%esi),%eax
8010321e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103224:	8b 06                	mov    (%esi),%eax
80103226:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010322a:	8b 06                	mov    (%esi),%eax
8010322c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103230:	8b 06                	mov    (%esi),%eax
80103232:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103235:	8b 03                	mov    (%ebx),%eax
80103237:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010323d:	8b 03                	mov    (%ebx),%eax
8010323f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103243:	8b 03                	mov    (%ebx),%eax
80103245:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103249:	8b 03                	mov    (%ebx),%eax
  return 0;
8010324b:	31 db                	xor    %ebx,%ebx
  (*f1)->pipe = p;
8010324d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103250:	83 c4 1c             	add    $0x1c,%esp
80103253:	89 d8                	mov    %ebx,%eax
80103255:	5b                   	pop    %ebx
80103256:	5e                   	pop    %esi
80103257:	5f                   	pop    %edi
80103258:	5d                   	pop    %ebp
80103259:	c3                   	ret    
8010325a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*f0)
80103260:	8b 06                	mov    (%esi),%eax
80103262:	85 c0                	test   %eax,%eax
80103264:	74 08                	je     8010326e <pipealloc+0xce>
    fileclose(*f0);
80103266:	89 04 24             	mov    %eax,(%esp)
80103269:	e8 e2 db ff ff       	call   80100e50 <fileclose>
  if(*f1)
8010326e:	8b 03                	mov    (%ebx),%eax
  return -1;
80103270:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if(*f1)
80103275:	85 c0                	test   %eax,%eax
80103277:	74 d7                	je     80103250 <pipealloc+0xb0>
    fileclose(*f1);
80103279:	89 04 24             	mov    %eax,(%esp)
8010327c:	e8 cf db ff ff       	call   80100e50 <fileclose>
}
80103281:	83 c4 1c             	add    $0x1c,%esp
80103284:	89 d8                	mov    %ebx,%eax
80103286:	5b                   	pop    %ebx
80103287:	5e                   	pop    %esi
80103288:	5f                   	pop    %edi
80103289:	5d                   	pop    %ebp
8010328a:	c3                   	ret    
8010328b:	90                   	nop
8010328c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103290 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103290:	55                   	push   %ebp
80103291:	89 e5                	mov    %esp,%ebp
80103293:	56                   	push   %esi
80103294:	53                   	push   %ebx
80103295:	83 ec 10             	sub    $0x10,%esp
80103298:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010329b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010329e:	89 1c 24             	mov    %ebx,(%esp)
801032a1:	e8 fa 0e 00 00       	call   801041a0 <acquire>
  if(writable){
801032a6:	85 f6                	test   %esi,%esi
801032a8:	74 3e                	je     801032e8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
801032aa:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801032b0:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801032b7:	00 00 00 
    wakeup(&p->nread);
801032ba:	89 04 24             	mov    %eax,(%esp)
801032bd:	e8 1e 0b 00 00       	call   80103de0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801032c2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801032c8:	85 d2                	test   %edx,%edx
801032ca:	75 0a                	jne    801032d6 <pipeclose+0x46>
801032cc:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801032d2:	85 c0                	test   %eax,%eax
801032d4:	74 32                	je     80103308 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032d6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032d9:	83 c4 10             	add    $0x10,%esp
801032dc:	5b                   	pop    %ebx
801032dd:	5e                   	pop    %esi
801032de:	5d                   	pop    %ebp
    release(&p->lock);
801032df:	e9 ac 0f 00 00       	jmp    80104290 <release>
801032e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801032e8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801032ee:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032f5:	00 00 00 
    wakeup(&p->nwrite);
801032f8:	89 04 24             	mov    %eax,(%esp)
801032fb:	e8 e0 0a 00 00       	call   80103de0 <wakeup>
80103300:	eb c0                	jmp    801032c2 <pipeclose+0x32>
80103302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&p->lock);
80103308:	89 1c 24             	mov    %ebx,(%esp)
8010330b:	e8 80 0f 00 00       	call   80104290 <release>
    kfree((char*)p);
80103310:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103313:	83 c4 10             	add    $0x10,%esp
80103316:	5b                   	pop    %ebx
80103317:	5e                   	pop    %esi
80103318:	5d                   	pop    %ebp
    kfree((char*)p);
80103319:	e9 02 f0 ff ff       	jmp    80102320 <kfree>
8010331e:	66 90                	xchg   %ax,%ax

80103320 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	57                   	push   %edi
80103324:	56                   	push   %esi
80103325:	53                   	push   %ebx
80103326:	83 ec 1c             	sub    $0x1c,%esp
80103329:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010332c:	89 1c 24             	mov    %ebx,(%esp)
8010332f:	e8 6c 0e 00 00       	call   801041a0 <acquire>
  for(i = 0; i < n; i++){
80103334:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103337:	85 c9                	test   %ecx,%ecx
80103339:	0f 8e b2 00 00 00    	jle    801033f1 <pipewrite+0xd1>
8010333f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103342:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103348:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010334e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103354:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103357:	03 4d 10             	add    0x10(%ebp),%ecx
8010335a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010335d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103363:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103369:	39 c8                	cmp    %ecx,%eax
8010336b:	74 38                	je     801033a5 <pipewrite+0x85>
8010336d:	eb 55                	jmp    801033c4 <pipewrite+0xa4>
8010336f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103370:	e8 5b 03 00 00       	call   801036d0 <myproc>
80103375:	8b 40 24             	mov    0x24(%eax),%eax
80103378:	85 c0                	test   %eax,%eax
8010337a:	75 33                	jne    801033af <pipewrite+0x8f>
      wakeup(&p->nread);
8010337c:	89 3c 24             	mov    %edi,(%esp)
8010337f:	e8 5c 0a 00 00       	call   80103de0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103384:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103388:	89 34 24             	mov    %esi,(%esp)
8010338b:	e8 b0 08 00 00       	call   80103c40 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103390:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103396:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010339c:	05 00 02 00 00       	add    $0x200,%eax
801033a1:	39 c2                	cmp    %eax,%edx
801033a3:	75 23                	jne    801033c8 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
801033a5:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033ab:	85 d2                	test   %edx,%edx
801033ad:	75 c1                	jne    80103370 <pipewrite+0x50>
        release(&p->lock);
801033af:	89 1c 24             	mov    %ebx,(%esp)
801033b2:	e8 d9 0e 00 00       	call   80104290 <release>
        return -1;
801033b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801033bc:	83 c4 1c             	add    $0x1c,%esp
801033bf:	5b                   	pop    %ebx
801033c0:	5e                   	pop    %esi
801033c1:	5f                   	pop    %edi
801033c2:	5d                   	pop    %ebp
801033c3:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033c4:	89 c2                	mov    %eax,%edx
801033c6:	66 90                	xchg   %ax,%ax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801033c8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033cb:	8d 42 01             	lea    0x1(%edx),%eax
801033ce:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801033d4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801033da:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801033de:	0f b6 09             	movzbl (%ecx),%ecx
801033e1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801033e5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033e8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033eb:	0f 85 6c ff ff ff    	jne    8010335d <pipewrite+0x3d>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801033f1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033f7:	89 04 24             	mov    %eax,(%esp)
801033fa:	e8 e1 09 00 00       	call   80103de0 <wakeup>
  release(&p->lock);
801033ff:	89 1c 24             	mov    %ebx,(%esp)
80103402:	e8 89 0e 00 00       	call   80104290 <release>
  return n;
80103407:	8b 45 10             	mov    0x10(%ebp),%eax
8010340a:	eb b0                	jmp    801033bc <pipewrite+0x9c>
8010340c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103410 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	57                   	push   %edi
80103414:	56                   	push   %esi
80103415:	53                   	push   %ebx
80103416:	83 ec 1c             	sub    $0x1c,%esp
80103419:	8b 75 08             	mov    0x8(%ebp),%esi
8010341c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010341f:	89 34 24             	mov    %esi,(%esp)
80103422:	e8 79 0d 00 00       	call   801041a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103427:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010342d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103433:	75 5b                	jne    80103490 <piperead+0x80>
80103435:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010343b:	85 db                	test   %ebx,%ebx
8010343d:	74 51                	je     80103490 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010343f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103445:	eb 25                	jmp    8010346c <piperead+0x5c>
80103447:	90                   	nop
80103448:	89 74 24 04          	mov    %esi,0x4(%esp)
8010344c:	89 1c 24             	mov    %ebx,(%esp)
8010344f:	e8 ec 07 00 00       	call   80103c40 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103454:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010345a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103460:	75 2e                	jne    80103490 <piperead+0x80>
80103462:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103468:	85 d2                	test   %edx,%edx
8010346a:	74 24                	je     80103490 <piperead+0x80>
    if(myproc()->killed){
8010346c:	e8 5f 02 00 00       	call   801036d0 <myproc>
80103471:	8b 48 24             	mov    0x24(%eax),%ecx
80103474:	85 c9                	test   %ecx,%ecx
80103476:	74 d0                	je     80103448 <piperead+0x38>
      release(&p->lock);
80103478:	89 34 24             	mov    %esi,(%esp)
8010347b:	e8 10 0e 00 00       	call   80104290 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103480:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80103483:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103488:	5b                   	pop    %ebx
80103489:	5e                   	pop    %esi
8010348a:	5f                   	pop    %edi
8010348b:	5d                   	pop    %ebp
8010348c:	c3                   	ret    
8010348d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103490:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103493:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103495:	85 d2                	test   %edx,%edx
80103497:	7f 2b                	jg     801034c4 <piperead+0xb4>
80103499:	eb 31                	jmp    801034cc <piperead+0xbc>
8010349b:	90                   	nop
8010349c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    addr[i] = p->data[p->nread++ % PIPESIZE];
801034a0:	8d 48 01             	lea    0x1(%eax),%ecx
801034a3:	25 ff 01 00 00       	and    $0x1ff,%eax
801034a8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801034ae:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801034b3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034b6:	83 c3 01             	add    $0x1,%ebx
801034b9:	3b 5d 10             	cmp    0x10(%ebp),%ebx
801034bc:	74 0e                	je     801034cc <piperead+0xbc>
    if(p->nread == p->nwrite)
801034be:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801034c4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801034ca:	75 d4                	jne    801034a0 <piperead+0x90>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801034cc:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801034d2:	89 04 24             	mov    %eax,(%esp)
801034d5:	e8 06 09 00 00       	call   80103de0 <wakeup>
  release(&p->lock);
801034da:	89 34 24             	mov    %esi,(%esp)
801034dd:	e8 ae 0d 00 00       	call   80104290 <release>
}
801034e2:	83 c4 1c             	add    $0x1c,%esp
  return i;
801034e5:	89 d8                	mov    %ebx,%eax
}
801034e7:	5b                   	pop    %ebx
801034e8:	5e                   	pop    %esi
801034e9:	5f                   	pop    %edi
801034ea:	5d                   	pop    %ebp
801034eb:	c3                   	ret    
801034ec:	66 90                	xchg   %ax,%ax
801034ee:	66 90                	xchg   %ax,%ax

801034f0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034f4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801034f9:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801034fc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103503:	e8 98 0c 00 00       	call   801041a0 <acquire>
80103508:	eb 14                	jmp    8010351e <allocproc+0x2e>
8010350a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103510:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103516:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
8010351c:	74 7a                	je     80103598 <allocproc+0xa8>
    if(p->state == UNUSED)
8010351e:	8b 43 0c             	mov    0xc(%ebx),%eax
80103521:	85 c0                	test   %eax,%eax
80103523:	75 eb                	jne    80103510 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103525:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
8010352a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  p->state = EMBRYO;
80103531:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103538:	8d 50 01             	lea    0x1(%eax),%edx
8010353b:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
80103541:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103544:	e8 47 0d 00 00       	call   80104290 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103549:	e8 82 ef ff ff       	call   801024d0 <kalloc>
8010354e:	85 c0                	test   %eax,%eax
80103550:	89 43 08             	mov    %eax,0x8(%ebx)
80103553:	74 57                	je     801035ac <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103555:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010355b:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103560:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103563:	c7 40 14 95 54 10 80 	movl   $0x80105495,0x14(%eax)
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010356a:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80103571:	00 
80103572:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103579:	00 
8010357a:	89 04 24             	mov    %eax,(%esp)
  p->context = (struct context*)sp;
8010357d:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103580:	e8 5b 0d 00 00       	call   801042e0 <memset>
  p->context->eip = (uint)forkret;
80103585:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103588:	c7 40 10 c0 35 10 80 	movl   $0x801035c0,0x10(%eax)

  return p;
8010358f:	89 d8                	mov    %ebx,%eax
}
80103591:	83 c4 14             	add    $0x14,%esp
80103594:	5b                   	pop    %ebx
80103595:	5d                   	pop    %ebp
80103596:	c3                   	ret    
80103597:	90                   	nop
  release(&ptable.lock);
80103598:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010359f:	e8 ec 0c 00 00       	call   80104290 <release>
}
801035a4:	83 c4 14             	add    $0x14,%esp
  return 0;
801035a7:	31 c0                	xor    %eax,%eax
}
801035a9:	5b                   	pop    %ebx
801035aa:	5d                   	pop    %ebp
801035ab:	c3                   	ret    
    p->state = UNUSED;
801035ac:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801035b3:	eb dc                	jmp    80103591 <allocproc+0xa1>
801035b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801035c6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035cd:	e8 be 0c 00 00       	call   80104290 <release>

  if (first) {
801035d2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801035d7:	85 c0                	test   %eax,%eax
801035d9:	75 05                	jne    801035e0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035db:	c9                   	leave  
801035dc:	c3                   	ret    
801035dd:	8d 76 00             	lea    0x0(%esi),%esi
    iinit(ROOTDEV);
801035e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    first = 0;
801035e7:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801035ee:	00 00 00 
    iinit(ROOTDEV);
801035f1:	e8 aa de ff ff       	call   801014a0 <iinit>
    initlog(ROOTDEV);
801035f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801035fd:	e8 9e f4 ff ff       	call   80102aa0 <initlog>
}
80103602:	c9                   	leave  
80103603:	c3                   	ret    
80103604:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010360a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103610 <pinit>:
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103616:	c7 44 24 04 15 75 10 	movl   $0x80107515,0x4(%esp)
8010361d:	80 
8010361e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103625:	e8 86 0a 00 00       	call   801040b0 <initlock>
}
8010362a:	c9                   	leave  
8010362b:	c3                   	ret    
8010362c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103630 <mycpu>:
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	56                   	push   %esi
80103634:	53                   	push   %ebx
80103635:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103638:	9c                   	pushf  
80103639:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010363a:	f6 c4 02             	test   $0x2,%ah
8010363d:	75 57                	jne    80103696 <mycpu+0x66>
  apicid = lapicid();
8010363f:	e8 4c f1 ff ff       	call   80102790 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103644:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010364a:	85 f6                	test   %esi,%esi
8010364c:	7e 3c                	jle    8010368a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010364e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103655:	39 c2                	cmp    %eax,%edx
80103657:	74 2d                	je     80103686 <mycpu+0x56>
80103659:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010365e:	31 d2                	xor    %edx,%edx
80103660:	83 c2 01             	add    $0x1,%edx
80103663:	39 f2                	cmp    %esi,%edx
80103665:	74 23                	je     8010368a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103667:	0f b6 19             	movzbl (%ecx),%ebx
8010366a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103670:	39 c3                	cmp    %eax,%ebx
80103672:	75 ec                	jne    80103660 <mycpu+0x30>
      return &cpus[i];
80103674:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
}
8010367a:	83 c4 10             	add    $0x10,%esp
8010367d:	5b                   	pop    %ebx
8010367e:	5e                   	pop    %esi
8010367f:	5d                   	pop    %ebp
      return &cpus[i];
80103680:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103685:	c3                   	ret    
  for (i = 0; i < ncpu; ++i) {
80103686:	31 d2                	xor    %edx,%edx
80103688:	eb ea                	jmp    80103674 <mycpu+0x44>
  panic("unknown apicid\n");
8010368a:	c7 04 24 1c 75 10 80 	movl   $0x8010751c,(%esp)
80103691:	e8 ca cc ff ff       	call   80100360 <panic>
    panic("mycpu called with interrupts enabled\n");
80103696:	c7 04 24 f8 75 10 80 	movl   $0x801075f8,(%esp)
8010369d:	e8 be cc ff ff       	call   80100360 <panic>
801036a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036b0 <cpuid>:
cpuid() {
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801036b6:	e8 75 ff ff ff       	call   80103630 <mycpu>
}
801036bb:	c9                   	leave  
  return mycpu()-cpus;
801036bc:	2d 80 27 11 80       	sub    $0x80112780,%eax
801036c1:	c1 f8 04             	sar    $0x4,%eax
801036c4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801036ca:	c3                   	ret    
801036cb:	90                   	nop
801036cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036d0 <myproc>:
myproc(void) {
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	53                   	push   %ebx
801036d4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801036d7:	e8 84 0a 00 00       	call   80104160 <pushcli>
  c = mycpu();
801036dc:	e8 4f ff ff ff       	call   80103630 <mycpu>
  p = c->proc;
801036e1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036e7:	e8 34 0b 00 00       	call   80104220 <popcli>
}
801036ec:	83 c4 04             	add    $0x4,%esp
801036ef:	89 d8                	mov    %ebx,%eax
801036f1:	5b                   	pop    %ebx
801036f2:	5d                   	pop    %ebp
801036f3:	c3                   	ret    
801036f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103700 <userinit>:
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	53                   	push   %ebx
80103704:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
80103707:	e8 e4 fd ff ff       	call   801034f0 <allocproc>
8010370c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010370e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103713:	e8 18 34 00 00       	call   80106b30 <setupkvm>
80103718:	85 c0                	test   %eax,%eax
8010371a:	89 43 04             	mov    %eax,0x4(%ebx)
8010371d:	0f 84 d4 00 00 00    	je     801037f7 <userinit+0xf7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103723:	89 04 24             	mov    %eax,(%esp)
80103726:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010372d:	00 
8010372e:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103735:	80 
80103736:	e8 f5 30 00 00       	call   80106830 <inituvm>
  p->sz = PGSIZE;
8010373b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103741:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103748:	00 
80103749:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103750:	00 
80103751:	8b 43 18             	mov    0x18(%ebx),%eax
80103754:	89 04 24             	mov    %eax,(%esp)
80103757:	e8 84 0b 00 00       	call   801042e0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010375c:	8b 43 18             	mov    0x18(%ebx),%eax
8010375f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103764:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103769:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010376d:	8b 43 18             	mov    0x18(%ebx),%eax
80103770:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103774:	8b 43 18             	mov    0x18(%ebx),%eax
80103777:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010377b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010377f:	8b 43 18             	mov    0x18(%ebx),%eax
80103782:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103786:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010378a:	8b 43 18             	mov    0x18(%ebx),%eax
8010378d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103794:	8b 43 18             	mov    0x18(%ebx),%eax
80103797:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010379e:	8b 43 18             	mov    0x18(%ebx),%eax
801037a1:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801037a8:	8d 43 6c             	lea    0x6c(%ebx),%eax
801037ab:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801037b2:	00 
801037b3:	c7 44 24 04 45 75 10 	movl   $0x80107545,0x4(%esp)
801037ba:	80 
801037bb:	89 04 24             	mov    %eax,(%esp)
801037be:	e8 fd 0c 00 00       	call   801044c0 <safestrcpy>
  p->cwd = namei("/");
801037c3:	c7 04 24 4e 75 10 80 	movl   $0x8010754e,(%esp)
801037ca:	e8 61 e7 ff ff       	call   80101f30 <namei>
801037cf:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801037d2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037d9:	e8 c2 09 00 00       	call   801041a0 <acquire>
  p->state = RUNNABLE;
801037de:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801037e5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037ec:	e8 9f 0a 00 00       	call   80104290 <release>
}
801037f1:	83 c4 14             	add    $0x14,%esp
801037f4:	5b                   	pop    %ebx
801037f5:	5d                   	pop    %ebp
801037f6:	c3                   	ret    
    panic("userinit: out of memory?");
801037f7:	c7 04 24 2c 75 10 80 	movl   $0x8010752c,(%esp)
801037fe:	e8 5d cb ff ff       	call   80100360 <panic>
80103803:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103810 <growproc>:
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	56                   	push   %esi
80103814:	53                   	push   %ebx
80103815:	83 ec 10             	sub    $0x10,%esp
80103818:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
8010381b:	e8 b0 fe ff ff       	call   801036d0 <myproc>
  if(n > 0){
80103820:	83 fe 00             	cmp    $0x0,%esi
  struct proc *curproc = myproc();
80103823:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103825:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103827:	7e 2f                	jle    80103858 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103829:	01 c6                	add    %eax,%esi
8010382b:	89 74 24 08          	mov    %esi,0x8(%esp)
8010382f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103833:	8b 43 04             	mov    0x4(%ebx),%eax
80103836:	89 04 24             	mov    %eax,(%esp)
80103839:	e8 52 31 00 00       	call   80106990 <allocuvm>
8010383e:	85 c0                	test   %eax,%eax
80103840:	74 36                	je     80103878 <growproc+0x68>
  curproc->sz = sz;
80103842:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103844:	89 1c 24             	mov    %ebx,(%esp)
80103847:	e8 d4 2e 00 00       	call   80106720 <switchuvm>
  return 0;
8010384c:	31 c0                	xor    %eax,%eax
}
8010384e:	83 c4 10             	add    $0x10,%esp
80103851:	5b                   	pop    %ebx
80103852:	5e                   	pop    %esi
80103853:	5d                   	pop    %ebp
80103854:	c3                   	ret    
80103855:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(n < 0){
80103858:	74 e8                	je     80103842 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010385a:	01 c6                	add    %eax,%esi
8010385c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103860:	89 44 24 04          	mov    %eax,0x4(%esp)
80103864:	8b 43 04             	mov    0x4(%ebx),%eax
80103867:	89 04 24             	mov    %eax,(%esp)
8010386a:	e8 21 32 00 00       	call   80106a90 <deallocuvm>
8010386f:	85 c0                	test   %eax,%eax
80103871:	75 cf                	jne    80103842 <growproc+0x32>
80103873:	90                   	nop
80103874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80103878:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010387d:	eb cf                	jmp    8010384e <growproc+0x3e>
8010387f:	90                   	nop

80103880 <fork>:
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	57                   	push   %edi
80103884:	56                   	push   %esi
80103885:	53                   	push   %ebx
80103886:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103889:	e8 42 fe ff ff       	call   801036d0 <myproc>
8010388e:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103890:	e8 5b fc ff ff       	call   801034f0 <allocproc>
80103895:	85 c0                	test   %eax,%eax
80103897:	89 c7                	mov    %eax,%edi
80103899:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010389c:	0f 84 bc 00 00 00    	je     8010395e <fork+0xde>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801038a2:	8b 03                	mov    (%ebx),%eax
801038a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801038a8:	8b 43 04             	mov    0x4(%ebx),%eax
801038ab:	89 04 24             	mov    %eax,(%esp)
801038ae:	e8 6d 33 00 00       	call   80106c20 <copyuvm>
801038b3:	85 c0                	test   %eax,%eax
801038b5:	89 47 04             	mov    %eax,0x4(%edi)
801038b8:	0f 84 a7 00 00 00    	je     80103965 <fork+0xe5>
  np->sz = curproc->sz;
801038be:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
801038c0:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
801038c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038c8:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
801038ca:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
801038cd:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
801038d0:	8b 73 18             	mov    0x18(%ebx),%esi
801038d3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801038d5:	31 f6                	xor    %esi,%esi
  np->stack_pages = curproc->stack_pages;
801038d7:	8b 43 7c             	mov    0x7c(%ebx),%eax
801038da:	89 42 7c             	mov    %eax,0x7c(%edx)
  np->tf->eax = 0;
801038dd:	8b 42 18             	mov    0x18(%edx),%eax
801038e0:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801038e7:	90                   	nop
    if(curproc->ofile[i])
801038e8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801038ec:	85 c0                	test   %eax,%eax
801038ee:	74 0f                	je     801038ff <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
801038f0:	89 04 24             	mov    %eax,(%esp)
801038f3:	e8 08 d5 ff ff       	call   80100e00 <filedup>
801038f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038fb:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801038ff:	83 c6 01             	add    $0x1,%esi
80103902:	83 fe 10             	cmp    $0x10,%esi
80103905:	75 e1                	jne    801038e8 <fork+0x68>
  np->cwd = idup(curproc->cwd);
80103907:	8b 43 68             	mov    0x68(%ebx),%eax
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010390a:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010390d:	89 04 24             	mov    %eax,(%esp)
80103910:	e8 9b dd ff ff       	call   801016b0 <idup>
80103915:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103918:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010391b:	8d 47 6c             	lea    0x6c(%edi),%eax
8010391e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103922:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103929:	00 
8010392a:	89 04 24             	mov    %eax,(%esp)
8010392d:	e8 8e 0b 00 00       	call   801044c0 <safestrcpy>
  pid = np->pid;
80103932:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103935:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010393c:	e8 5f 08 00 00       	call   801041a0 <acquire>
  np->state = RUNNABLE;
80103941:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103948:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010394f:	e8 3c 09 00 00       	call   80104290 <release>
  return pid;
80103954:	89 d8                	mov    %ebx,%eax
}
80103956:	83 c4 1c             	add    $0x1c,%esp
80103959:	5b                   	pop    %ebx
8010395a:	5e                   	pop    %esi
8010395b:	5f                   	pop    %edi
8010395c:	5d                   	pop    %ebp
8010395d:	c3                   	ret    
    return -1;
8010395e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103963:	eb f1                	jmp    80103956 <fork+0xd6>
    kfree(np->kstack);
80103965:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103968:	8b 47 08             	mov    0x8(%edi),%eax
8010396b:	89 04 24             	mov    %eax,(%esp)
8010396e:	e8 ad e9 ff ff       	call   80102320 <kfree>
    return -1;
80103973:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    np->kstack = 0;
80103978:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
8010397f:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103986:	eb ce                	jmp    80103956 <fork+0xd6>
80103988:	90                   	nop
80103989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103990 <scheduler>:
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	57                   	push   %edi
80103994:	56                   	push   %esi
80103995:	53                   	push   %ebx
80103996:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103999:	e8 92 fc ff ff       	call   80103630 <mycpu>
8010399e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801039a0:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801039a7:	00 00 00 
801039aa:	8d 78 04             	lea    0x4(%eax),%edi
801039ad:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801039b0:	fb                   	sti    
    acquire(&ptable.lock);
801039b1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039b8:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
801039bd:	e8 de 07 00 00       	call   801041a0 <acquire>
801039c2:	eb 12                	jmp    801039d6 <scheduler+0x46>
801039c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039c8:	81 c3 84 00 00 00    	add    $0x84,%ebx
801039ce:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
801039d4:	74 4a                	je     80103a20 <scheduler+0x90>
      if(p->state != RUNNABLE)
801039d6:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801039da:	75 ec                	jne    801039c8 <scheduler+0x38>
      c->proc = p;
801039dc:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801039e2:	89 1c 24             	mov    %ebx,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039e5:	81 c3 84 00 00 00    	add    $0x84,%ebx
      switchuvm(p);
801039eb:	e8 30 2d 00 00       	call   80106720 <switchuvm>
      swtch(&(c->scheduler), p->context);
801039f0:	8b 43 98             	mov    -0x68(%ebx),%eax
      p->state = RUNNING;
801039f3:	c7 43 88 04 00 00 00 	movl   $0x4,-0x78(%ebx)
      swtch(&(c->scheduler), p->context);
801039fa:	89 3c 24             	mov    %edi,(%esp)
801039fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a01:	e8 15 0b 00 00       	call   8010451b <swtch>
      switchkvm();
80103a06:	e8 f5 2c 00 00       	call   80106700 <switchkvm>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a0b:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
      c->proc = 0;
80103a11:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103a18:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a1b:	75 b9                	jne    801039d6 <scheduler+0x46>
80103a1d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ptable.lock);
80103a20:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a27:	e8 64 08 00 00       	call   80104290 <release>
  }
80103a2c:	eb 82                	jmp    801039b0 <scheduler+0x20>
80103a2e:	66 90                	xchg   %ax,%ax

80103a30 <sched>:
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	56                   	push   %esi
80103a34:	53                   	push   %ebx
80103a35:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = myproc();
80103a38:	e8 93 fc ff ff       	call   801036d0 <myproc>
  if(!holding(&ptable.lock))
80103a3d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *p = myproc();
80103a44:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103a46:	e8 e5 06 00 00       	call   80104130 <holding>
80103a4b:	85 c0                	test   %eax,%eax
80103a4d:	74 4f                	je     80103a9e <sched+0x6e>
  if(mycpu()->ncli != 1)
80103a4f:	e8 dc fb ff ff       	call   80103630 <mycpu>
80103a54:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103a5b:	75 65                	jne    80103ac2 <sched+0x92>
  if(p->state == RUNNING)
80103a5d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103a61:	74 53                	je     80103ab6 <sched+0x86>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a63:	9c                   	pushf  
80103a64:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a65:	f6 c4 02             	test   $0x2,%ah
80103a68:	75 40                	jne    80103aaa <sched+0x7a>
  intena = mycpu()->intena;
80103a6a:	e8 c1 fb ff ff       	call   80103630 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103a6f:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103a72:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103a78:	e8 b3 fb ff ff       	call   80103630 <mycpu>
80103a7d:	8b 40 04             	mov    0x4(%eax),%eax
80103a80:	89 1c 24             	mov    %ebx,(%esp)
80103a83:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a87:	e8 8f 0a 00 00       	call   8010451b <swtch>
  mycpu()->intena = intena;
80103a8c:	e8 9f fb ff ff       	call   80103630 <mycpu>
80103a91:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103a97:	83 c4 10             	add    $0x10,%esp
80103a9a:	5b                   	pop    %ebx
80103a9b:	5e                   	pop    %esi
80103a9c:	5d                   	pop    %ebp
80103a9d:	c3                   	ret    
    panic("sched ptable.lock");
80103a9e:	c7 04 24 50 75 10 80 	movl   $0x80107550,(%esp)
80103aa5:	e8 b6 c8 ff ff       	call   80100360 <panic>
    panic("sched interruptible");
80103aaa:	c7 04 24 7c 75 10 80 	movl   $0x8010757c,(%esp)
80103ab1:	e8 aa c8 ff ff       	call   80100360 <panic>
    panic("sched running");
80103ab6:	c7 04 24 6e 75 10 80 	movl   $0x8010756e,(%esp)
80103abd:	e8 9e c8 ff ff       	call   80100360 <panic>
    panic("sched locks");
80103ac2:	c7 04 24 62 75 10 80 	movl   $0x80107562,(%esp)
80103ac9:	e8 92 c8 ff ff       	call   80100360 <panic>
80103ace:	66 90                	xchg   %ax,%ax

80103ad0 <exit>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	56                   	push   %esi
  if(curproc == initproc)
80103ad4:	31 f6                	xor    %esi,%esi
{
80103ad6:	53                   	push   %ebx
80103ad7:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103ada:	e8 f1 fb ff ff       	call   801036d0 <myproc>
  if(curproc == initproc)
80103adf:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
  struct proc *curproc = myproc();
80103ae5:	89 c3                	mov    %eax,%ebx
  if(curproc == initproc)
80103ae7:	0f 84 fd 00 00 00    	je     80103bea <exit+0x11a>
80103aed:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103af0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103af4:	85 c0                	test   %eax,%eax
80103af6:	74 10                	je     80103b08 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103af8:	89 04 24             	mov    %eax,(%esp)
80103afb:	e8 50 d3 ff ff       	call   80100e50 <fileclose>
      curproc->ofile[fd] = 0;
80103b00:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103b07:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103b08:	83 c6 01             	add    $0x1,%esi
80103b0b:	83 fe 10             	cmp    $0x10,%esi
80103b0e:	75 e0                	jne    80103af0 <exit+0x20>
  begin_op();
80103b10:	e8 2b f0 ff ff       	call   80102b40 <begin_op>
  iput(curproc->cwd);
80103b15:	8b 43 68             	mov    0x68(%ebx),%eax
80103b18:	89 04 24             	mov    %eax,(%esp)
80103b1b:	e8 e0 dc ff ff       	call   80101800 <iput>
  end_op();
80103b20:	e8 8b f0 ff ff       	call   80102bb0 <end_op>
  curproc->cwd = 0;
80103b25:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103b2c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b33:	e8 68 06 00 00       	call   801041a0 <acquire>
  wakeup1(curproc->parent);
80103b38:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b3b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b40:	eb 14                	jmp    80103b56 <exit+0x86>
80103b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b48:	81 c2 84 00 00 00    	add    $0x84,%edx
80103b4e:	81 fa 54 4e 11 80    	cmp    $0x80114e54,%edx
80103b54:	74 20                	je     80103b76 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103b56:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b5a:	75 ec                	jne    80103b48 <exit+0x78>
80103b5c:	3b 42 20             	cmp    0x20(%edx),%eax
80103b5f:	75 e7                	jne    80103b48 <exit+0x78>
      p->state = RUNNABLE;
80103b61:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b68:	81 c2 84 00 00 00    	add    $0x84,%edx
80103b6e:	81 fa 54 4e 11 80    	cmp    $0x80114e54,%edx
80103b74:	75 e0                	jne    80103b56 <exit+0x86>
      p->parent = initproc;
80103b76:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103b7b:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103b80:	eb 14                	jmp    80103b96 <exit+0xc6>
80103b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b88:	81 c1 84 00 00 00    	add    $0x84,%ecx
80103b8e:	81 f9 54 4e 11 80    	cmp    $0x80114e54,%ecx
80103b94:	74 3c                	je     80103bd2 <exit+0x102>
    if(p->parent == curproc){
80103b96:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103b99:	75 ed                	jne    80103b88 <exit+0xb8>
      if(p->state == ZOMBIE)
80103b9b:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
      p->parent = initproc;
80103b9f:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103ba2:	75 e4                	jne    80103b88 <exit+0xb8>
80103ba4:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103ba9:	eb 13                	jmp    80103bbe <exit+0xee>
80103bab:	90                   	nop
80103bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bb0:	81 c2 84 00 00 00    	add    $0x84,%edx
80103bb6:	81 fa 54 4e 11 80    	cmp    $0x80114e54,%edx
80103bbc:	74 ca                	je     80103b88 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103bbe:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103bc2:	75 ec                	jne    80103bb0 <exit+0xe0>
80103bc4:	3b 42 20             	cmp    0x20(%edx),%eax
80103bc7:	75 e7                	jne    80103bb0 <exit+0xe0>
      p->state = RUNNABLE;
80103bc9:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103bd0:	eb de                	jmp    80103bb0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103bd2:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103bd9:	e8 52 fe ff ff       	call   80103a30 <sched>
  panic("zombie exit");
80103bde:	c7 04 24 9d 75 10 80 	movl   $0x8010759d,(%esp)
80103be5:	e8 76 c7 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103bea:	c7 04 24 90 75 10 80 	movl   $0x80107590,(%esp)
80103bf1:	e8 6a c7 ff ff       	call   80100360 <panic>
80103bf6:	8d 76 00             	lea    0x0(%esi),%esi
80103bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c00 <yield>:
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103c06:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c0d:	e8 8e 05 00 00       	call   801041a0 <acquire>
  myproc()->state = RUNNABLE;
80103c12:	e8 b9 fa ff ff       	call   801036d0 <myproc>
80103c17:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103c1e:	e8 0d fe ff ff       	call   80103a30 <sched>
  release(&ptable.lock);
80103c23:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c2a:	e8 61 06 00 00       	call   80104290 <release>
}
80103c2f:	c9                   	leave  
80103c30:	c3                   	ret    
80103c31:	eb 0d                	jmp    80103c40 <sleep>
80103c33:	90                   	nop
80103c34:	90                   	nop
80103c35:	90                   	nop
80103c36:	90                   	nop
80103c37:	90                   	nop
80103c38:	90                   	nop
80103c39:	90                   	nop
80103c3a:	90                   	nop
80103c3b:	90                   	nop
80103c3c:	90                   	nop
80103c3d:	90                   	nop
80103c3e:	90                   	nop
80103c3f:	90                   	nop

80103c40 <sleep>:
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	57                   	push   %edi
80103c44:	56                   	push   %esi
80103c45:	53                   	push   %ebx
80103c46:	83 ec 1c             	sub    $0x1c,%esp
80103c49:	8b 7d 08             	mov    0x8(%ebp),%edi
80103c4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103c4f:	e8 7c fa ff ff       	call   801036d0 <myproc>
  if(p == 0)
80103c54:	85 c0                	test   %eax,%eax
  struct proc *p = myproc();
80103c56:	89 c3                	mov    %eax,%ebx
  if(p == 0)
80103c58:	0f 84 7c 00 00 00    	je     80103cda <sleep+0x9a>
  if(lk == 0)
80103c5e:	85 f6                	test   %esi,%esi
80103c60:	74 6c                	je     80103cce <sleep+0x8e>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103c62:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103c68:	74 46                	je     80103cb0 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103c6a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c71:	e8 2a 05 00 00       	call   801041a0 <acquire>
    release(lk);
80103c76:	89 34 24             	mov    %esi,(%esp)
80103c79:	e8 12 06 00 00       	call   80104290 <release>
  p->chan = chan;
80103c7e:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103c81:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103c88:	e8 a3 fd ff ff       	call   80103a30 <sched>
  p->chan = 0;
80103c8d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103c94:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c9b:	e8 f0 05 00 00       	call   80104290 <release>
    acquire(lk);
80103ca0:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103ca3:	83 c4 1c             	add    $0x1c,%esp
80103ca6:	5b                   	pop    %ebx
80103ca7:	5e                   	pop    %esi
80103ca8:	5f                   	pop    %edi
80103ca9:	5d                   	pop    %ebp
    acquire(lk);
80103caa:	e9 f1 04 00 00       	jmp    801041a0 <acquire>
80103caf:	90                   	nop
  p->chan = chan;
80103cb0:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103cb3:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103cba:	e8 71 fd ff ff       	call   80103a30 <sched>
  p->chan = 0;
80103cbf:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103cc6:	83 c4 1c             	add    $0x1c,%esp
80103cc9:	5b                   	pop    %ebx
80103cca:	5e                   	pop    %esi
80103ccb:	5f                   	pop    %edi
80103ccc:	5d                   	pop    %ebp
80103ccd:	c3                   	ret    
    panic("sleep without lk");
80103cce:	c7 04 24 af 75 10 80 	movl   $0x801075af,(%esp)
80103cd5:	e8 86 c6 ff ff       	call   80100360 <panic>
    panic("sleep");
80103cda:	c7 04 24 a9 75 10 80 	movl   $0x801075a9,(%esp)
80103ce1:	e8 7a c6 ff ff       	call   80100360 <panic>
80103ce6:	8d 76 00             	lea    0x0(%esi),%esi
80103ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cf0 <wait>:
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	56                   	push   %esi
80103cf4:	53                   	push   %ebx
80103cf5:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103cf8:	e8 d3 f9 ff ff       	call   801036d0 <myproc>
  acquire(&ptable.lock);
80103cfd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *curproc = myproc();
80103d04:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103d06:	e8 95 04 00 00       	call   801041a0 <acquire>
    havekids = 0;
80103d0b:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d0d:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103d12:	eb 12                	jmp    80103d26 <wait+0x36>
80103d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d18:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103d1e:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
80103d24:	74 22                	je     80103d48 <wait+0x58>
      if(p->parent != curproc)
80103d26:	39 73 14             	cmp    %esi,0x14(%ebx)
80103d29:	75 ed                	jne    80103d18 <wait+0x28>
      if(p->state == ZOMBIE){
80103d2b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103d2f:	74 34                	je     80103d65 <wait+0x75>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d31:	81 c3 84 00 00 00    	add    $0x84,%ebx
      havekids = 1;
80103d37:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d3c:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
80103d42:	75 e2                	jne    80103d26 <wait+0x36>
80103d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(!havekids || curproc->killed){
80103d48:	85 c0                	test   %eax,%eax
80103d4a:	74 6e                	je     80103dba <wait+0xca>
80103d4c:	8b 46 24             	mov    0x24(%esi),%eax
80103d4f:	85 c0                	test   %eax,%eax
80103d51:	75 67                	jne    80103dba <wait+0xca>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103d53:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103d5a:	80 
80103d5b:	89 34 24             	mov    %esi,(%esp)
80103d5e:	e8 dd fe ff ff       	call   80103c40 <sleep>
  }
80103d63:	eb a6                	jmp    80103d0b <wait+0x1b>
        kfree(p->kstack);
80103d65:	8b 43 08             	mov    0x8(%ebx),%eax
        pid = p->pid;
80103d68:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103d6b:	89 04 24             	mov    %eax,(%esp)
80103d6e:	e8 ad e5 ff ff       	call   80102320 <kfree>
        freevm(p->pgdir);
80103d73:	8b 43 04             	mov    0x4(%ebx),%eax
        p->kstack = 0;
80103d76:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103d7d:	89 04 24             	mov    %eax,(%esp)
80103d80:	e8 2b 2d 00 00       	call   80106ab0 <freevm>
        release(&ptable.lock);
80103d85:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103d8c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103d93:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103d9a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103d9e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103da5:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103dac:	e8 df 04 00 00       	call   80104290 <release>
}
80103db1:	83 c4 10             	add    $0x10,%esp
        return pid;
80103db4:	89 f0                	mov    %esi,%eax
}
80103db6:	5b                   	pop    %ebx
80103db7:	5e                   	pop    %esi
80103db8:	5d                   	pop    %ebp
80103db9:	c3                   	ret    
      release(&ptable.lock);
80103dba:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103dc1:	e8 ca 04 00 00       	call   80104290 <release>
}
80103dc6:	83 c4 10             	add    $0x10,%esp
      return -1;
80103dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103dce:	5b                   	pop    %ebx
80103dcf:	5e                   	pop    %esi
80103dd0:	5d                   	pop    %ebp
80103dd1:	c3                   	ret    
80103dd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103de0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	53                   	push   %ebx
80103de4:	83 ec 14             	sub    $0x14,%esp
80103de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103dea:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103df1:	e8 aa 03 00 00       	call   801041a0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103df6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103dfb:	eb 0f                	jmp    80103e0c <wakeup+0x2c>
80103dfd:	8d 76 00             	lea    0x0(%esi),%esi
80103e00:	05 84 00 00 00       	add    $0x84,%eax
80103e05:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103e0a:	74 24                	je     80103e30 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
80103e0c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e10:	75 ee                	jne    80103e00 <wakeup+0x20>
80103e12:	3b 58 20             	cmp    0x20(%eax),%ebx
80103e15:	75 e9                	jne    80103e00 <wakeup+0x20>
      p->state = RUNNABLE;
80103e17:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e1e:	05 84 00 00 00       	add    $0x84,%eax
80103e23:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103e28:	75 e2                	jne    80103e0c <wakeup+0x2c>
80103e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  wakeup1(chan);
  release(&ptable.lock);
80103e30:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103e37:	83 c4 14             	add    $0x14,%esp
80103e3a:	5b                   	pop    %ebx
80103e3b:	5d                   	pop    %ebp
  release(&ptable.lock);
80103e3c:	e9 4f 04 00 00       	jmp    80104290 <release>
80103e41:	eb 0d                	jmp    80103e50 <kill>
80103e43:	90                   	nop
80103e44:	90                   	nop
80103e45:	90                   	nop
80103e46:	90                   	nop
80103e47:	90                   	nop
80103e48:	90                   	nop
80103e49:	90                   	nop
80103e4a:	90                   	nop
80103e4b:	90                   	nop
80103e4c:	90                   	nop
80103e4d:	90                   	nop
80103e4e:	90                   	nop
80103e4f:	90                   	nop

80103e50 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	53                   	push   %ebx
80103e54:	83 ec 14             	sub    $0x14,%esp
80103e57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103e5a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e61:	e8 3a 03 00 00       	call   801041a0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e66:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e6b:	eb 0f                	jmp    80103e7c <kill+0x2c>
80103e6d:	8d 76 00             	lea    0x0(%esi),%esi
80103e70:	05 84 00 00 00       	add    $0x84,%eax
80103e75:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103e7a:	74 3c                	je     80103eb8 <kill+0x68>
    if(p->pid == pid){
80103e7c:	39 58 10             	cmp    %ebx,0x10(%eax)
80103e7f:	75 ef                	jne    80103e70 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e81:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103e85:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103e8c:	74 1a                	je     80103ea8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103e8e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e95:	e8 f6 03 00 00       	call   80104290 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e9a:	83 c4 14             	add    $0x14,%esp
      return 0;
80103e9d:	31 c0                	xor    %eax,%eax
}
80103e9f:	5b                   	pop    %ebx
80103ea0:	5d                   	pop    %ebp
80103ea1:	c3                   	ret    
80103ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        p->state = RUNNABLE;
80103ea8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103eaf:	eb dd                	jmp    80103e8e <kill+0x3e>
80103eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103eb8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ebf:	e8 cc 03 00 00       	call   80104290 <release>
}
80103ec4:	83 c4 14             	add    $0x14,%esp
  return -1;
80103ec7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103ecc:	5b                   	pop    %ebx
80103ecd:	5d                   	pop    %ebp
80103ece:	c3                   	ret    
80103ecf:	90                   	nop

80103ed0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	57                   	push   %edi
80103ed4:	56                   	push   %esi
80103ed5:	53                   	push   %ebx
80103ed6:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103edb:	83 ec 4c             	sub    $0x4c,%esp
80103ede:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103ee1:	eb 23                	jmp    80103f06 <procdump+0x36>
80103ee3:	90                   	nop
80103ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103ee8:	c7 04 24 ff 79 10 80 	movl   $0x801079ff,(%esp)
80103eef:	e8 5c c7 ff ff       	call   80100650 <cprintf>
80103ef4:	81 c3 84 00 00 00    	add    $0x84,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103efa:	81 fb c0 4e 11 80    	cmp    $0x80114ec0,%ebx
80103f00:	0f 84 8a 00 00 00    	je     80103f90 <procdump+0xc0>
    if(p->state == UNUSED)
80103f06:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103f09:	85 c0                	test   %eax,%eax
80103f0b:	74 e7                	je     80103ef4 <procdump+0x24>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f0d:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80103f10:	ba c0 75 10 80       	mov    $0x801075c0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f15:	77 11                	ja     80103f28 <procdump+0x58>
80103f17:	8b 14 85 20 76 10 80 	mov    -0x7fef89e0(,%eax,4),%edx
      state = "???";
80103f1e:	b8 c0 75 10 80       	mov    $0x801075c0,%eax
80103f23:	85 d2                	test   %edx,%edx
80103f25:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103f28:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103f2b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103f2f:	89 54 24 08          	mov    %edx,0x8(%esp)
80103f33:	c7 04 24 c4 75 10 80 	movl   $0x801075c4,(%esp)
80103f3a:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f3e:	e8 0d c7 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103f43:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103f47:	75 9f                	jne    80103ee8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103f49:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103f4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f50:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103f53:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103f56:	8b 40 0c             	mov    0xc(%eax),%eax
80103f59:	83 c0 08             	add    $0x8,%eax
80103f5c:	89 04 24             	mov    %eax,(%esp)
80103f5f:	e8 6c 01 00 00       	call   801040d0 <getcallerpcs>
80103f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103f68:	8b 17                	mov    (%edi),%edx
80103f6a:	85 d2                	test   %edx,%edx
80103f6c:	0f 84 76 ff ff ff    	je     80103ee8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103f72:	89 54 24 04          	mov    %edx,0x4(%esp)
80103f76:	83 c7 04             	add    $0x4,%edi
80103f79:	c7 04 24 e1 6f 10 80 	movl   $0x80106fe1,(%esp)
80103f80:	e8 cb c6 ff ff       	call   80100650 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103f85:	39 f7                	cmp    %esi,%edi
80103f87:	75 df                	jne    80103f68 <procdump+0x98>
80103f89:	e9 5a ff ff ff       	jmp    80103ee8 <procdump+0x18>
80103f8e:	66 90                	xchg   %ax,%ax
  }
}
80103f90:	83 c4 4c             	add    $0x4c,%esp
80103f93:	5b                   	pop    %ebx
80103f94:	5e                   	pop    %esi
80103f95:	5f                   	pop    %edi
80103f96:	5d                   	pop    %ebp
80103f97:	c3                   	ret    
80103f98:	66 90                	xchg   %ax,%ax
80103f9a:	66 90                	xchg   %ax,%ax
80103f9c:	66 90                	xchg   %ax,%ax
80103f9e:	66 90                	xchg   %ax,%ax

80103fa0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	53                   	push   %ebx
80103fa4:	83 ec 14             	sub    $0x14,%esp
80103fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103faa:	c7 44 24 04 38 76 10 	movl   $0x80107638,0x4(%esp)
80103fb1:	80 
80103fb2:	8d 43 04             	lea    0x4(%ebx),%eax
80103fb5:	89 04 24             	mov    %eax,(%esp)
80103fb8:	e8 f3 00 00 00       	call   801040b0 <initlock>
  lk->name = name;
80103fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80103fc0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103fc6:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80103fcd:	89 43 38             	mov    %eax,0x38(%ebx)
}
80103fd0:	83 c4 14             	add    $0x14,%esp
80103fd3:	5b                   	pop    %ebx
80103fd4:	5d                   	pop    %ebp
80103fd5:	c3                   	ret    
80103fd6:	8d 76 00             	lea    0x0(%esi),%esi
80103fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fe0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	56                   	push   %esi
80103fe4:	53                   	push   %ebx
80103fe5:	83 ec 10             	sub    $0x10,%esp
80103fe8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103feb:	8d 73 04             	lea    0x4(%ebx),%esi
80103fee:	89 34 24             	mov    %esi,(%esp)
80103ff1:	e8 aa 01 00 00       	call   801041a0 <acquire>
  while (lk->locked) {
80103ff6:	8b 13                	mov    (%ebx),%edx
80103ff8:	85 d2                	test   %edx,%edx
80103ffa:	74 16                	je     80104012 <acquiresleep+0x32>
80103ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104000:	89 74 24 04          	mov    %esi,0x4(%esp)
80104004:	89 1c 24             	mov    %ebx,(%esp)
80104007:	e8 34 fc ff ff       	call   80103c40 <sleep>
  while (lk->locked) {
8010400c:	8b 03                	mov    (%ebx),%eax
8010400e:	85 c0                	test   %eax,%eax
80104010:	75 ee                	jne    80104000 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104012:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104018:	e8 b3 f6 ff ff       	call   801036d0 <myproc>
8010401d:	8b 40 10             	mov    0x10(%eax),%eax
80104020:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104023:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104026:	83 c4 10             	add    $0x10,%esp
80104029:	5b                   	pop    %ebx
8010402a:	5e                   	pop    %esi
8010402b:	5d                   	pop    %ebp
  release(&lk->lk);
8010402c:	e9 5f 02 00 00       	jmp    80104290 <release>
80104031:	eb 0d                	jmp    80104040 <releasesleep>
80104033:	90                   	nop
80104034:	90                   	nop
80104035:	90                   	nop
80104036:	90                   	nop
80104037:	90                   	nop
80104038:	90                   	nop
80104039:	90                   	nop
8010403a:	90                   	nop
8010403b:	90                   	nop
8010403c:	90                   	nop
8010403d:	90                   	nop
8010403e:	90                   	nop
8010403f:	90                   	nop

80104040 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	56                   	push   %esi
80104044:	53                   	push   %ebx
80104045:	83 ec 10             	sub    $0x10,%esp
80104048:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010404b:	8d 73 04             	lea    0x4(%ebx),%esi
8010404e:	89 34 24             	mov    %esi,(%esp)
80104051:	e8 4a 01 00 00       	call   801041a0 <acquire>
  lk->locked = 0;
80104056:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010405c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104063:	89 1c 24             	mov    %ebx,(%esp)
80104066:	e8 75 fd ff ff       	call   80103de0 <wakeup>
  release(&lk->lk);
8010406b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010406e:	83 c4 10             	add    $0x10,%esp
80104071:	5b                   	pop    %ebx
80104072:	5e                   	pop    %esi
80104073:	5d                   	pop    %ebp
  release(&lk->lk);
80104074:	e9 17 02 00 00       	jmp    80104290 <release>
80104079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104080 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	56                   	push   %esi
80104084:	53                   	push   %ebx
80104085:	83 ec 10             	sub    $0x10,%esp
80104088:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010408b:	8d 73 04             	lea    0x4(%ebx),%esi
8010408e:	89 34 24             	mov    %esi,(%esp)
80104091:	e8 0a 01 00 00       	call   801041a0 <acquire>
  r = lk->locked;
80104096:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104098:	89 34 24             	mov    %esi,(%esp)
8010409b:	e8 f0 01 00 00       	call   80104290 <release>
  return r;
}
801040a0:	83 c4 10             	add    $0x10,%esp
801040a3:	89 d8                	mov    %ebx,%eax
801040a5:	5b                   	pop    %ebx
801040a6:	5e                   	pop    %esi
801040a7:	5d                   	pop    %ebp
801040a8:	c3                   	ret    
801040a9:	66 90                	xchg   %ax,%ax
801040ab:	66 90                	xchg   %ax,%ax
801040ad:	66 90                	xchg   %ax,%ax
801040af:	90                   	nop

801040b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801040b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801040b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801040bf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801040c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801040c9:	5d                   	pop    %ebp
801040ca:	c3                   	ret    
801040cb:	90                   	nop
801040cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801040d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801040d3:	8b 45 08             	mov    0x8(%ebp),%eax
{
801040d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801040d9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801040da:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801040dd:	31 c0                	xor    %eax,%eax
801040df:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801040e0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801040e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801040ec:	77 1a                	ja     80104108 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801040ee:	8b 5a 04             	mov    0x4(%edx),%ebx
801040f1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801040f4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801040f7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801040f9:	83 f8 0a             	cmp    $0xa,%eax
801040fc:	75 e2                	jne    801040e0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801040fe:	5b                   	pop    %ebx
801040ff:	5d                   	pop    %ebp
80104100:	c3                   	ret    
80104101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104108:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
8010410f:	83 c0 01             	add    $0x1,%eax
80104112:	83 f8 0a             	cmp    $0xa,%eax
80104115:	74 e7                	je     801040fe <getcallerpcs+0x2e>
    pcs[i] = 0;
80104117:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
8010411e:	83 c0 01             	add    $0x1,%eax
80104121:	83 f8 0a             	cmp    $0xa,%eax
80104124:	75 e2                	jne    80104108 <getcallerpcs+0x38>
80104126:	eb d6                	jmp    801040fe <getcallerpcs+0x2e>
80104128:	90                   	nop
80104129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104130 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104130:	55                   	push   %ebp
  return lock->locked && lock->cpu == mycpu();
80104131:	31 c0                	xor    %eax,%eax
{
80104133:	89 e5                	mov    %esp,%ebp
80104135:	53                   	push   %ebx
80104136:	83 ec 04             	sub    $0x4,%esp
80104139:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010413c:	8b 0a                	mov    (%edx),%ecx
8010413e:	85 c9                	test   %ecx,%ecx
80104140:	74 10                	je     80104152 <holding+0x22>
80104142:	8b 5a 08             	mov    0x8(%edx),%ebx
80104145:	e8 e6 f4 ff ff       	call   80103630 <mycpu>
8010414a:	39 c3                	cmp    %eax,%ebx
8010414c:	0f 94 c0             	sete   %al
8010414f:	0f b6 c0             	movzbl %al,%eax
}
80104152:	83 c4 04             	add    $0x4,%esp
80104155:	5b                   	pop    %ebx
80104156:	5d                   	pop    %ebp
80104157:	c3                   	ret    
80104158:	90                   	nop
80104159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104160 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
80104164:	83 ec 04             	sub    $0x4,%esp
80104167:	9c                   	pushf  
80104168:	5b                   	pop    %ebx
  asm volatile("cli");
80104169:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010416a:	e8 c1 f4 ff ff       	call   80103630 <mycpu>
8010416f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104175:	85 c0                	test   %eax,%eax
80104177:	75 11                	jne    8010418a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104179:	e8 b2 f4 ff ff       	call   80103630 <mycpu>
8010417e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104184:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010418a:	e8 a1 f4 ff ff       	call   80103630 <mycpu>
8010418f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104196:	83 c4 04             	add    $0x4,%esp
80104199:	5b                   	pop    %ebx
8010419a:	5d                   	pop    %ebp
8010419b:	c3                   	ret    
8010419c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801041a0 <acquire>:
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	53                   	push   %ebx
801041a4:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801041a7:	e8 b4 ff ff ff       	call   80104160 <pushcli>
  if(holding(lk))
801041ac:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801041af:	8b 02                	mov    (%edx),%eax
801041b1:	85 c0                	test   %eax,%eax
801041b3:	75 43                	jne    801041f8 <acquire+0x58>
  asm volatile("lock; xchgl %0, %1" :
801041b5:	b9 01 00 00 00       	mov    $0x1,%ecx
801041ba:	eb 07                	jmp    801041c3 <acquire+0x23>
801041bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041c0:	8b 55 08             	mov    0x8(%ebp),%edx
801041c3:	89 c8                	mov    %ecx,%eax
801041c5:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&lk->locked, 1) != 0)
801041c8:	85 c0                	test   %eax,%eax
801041ca:	75 f4                	jne    801041c0 <acquire+0x20>
  __sync_synchronize();
801041cc:	0f ae f0             	mfence 
  lk->cpu = mycpu();
801041cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
801041d2:	e8 59 f4 ff ff       	call   80103630 <mycpu>
801041d7:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801041da:	8b 45 08             	mov    0x8(%ebp),%eax
801041dd:	83 c0 0c             	add    $0xc,%eax
801041e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801041e4:	8d 45 08             	lea    0x8(%ebp),%eax
801041e7:	89 04 24             	mov    %eax,(%esp)
801041ea:	e8 e1 fe ff ff       	call   801040d0 <getcallerpcs>
}
801041ef:	83 c4 14             	add    $0x14,%esp
801041f2:	5b                   	pop    %ebx
801041f3:	5d                   	pop    %ebp
801041f4:	c3                   	ret    
801041f5:	8d 76 00             	lea    0x0(%esi),%esi
  return lock->locked && lock->cpu == mycpu();
801041f8:	8b 5a 08             	mov    0x8(%edx),%ebx
801041fb:	e8 30 f4 ff ff       	call   80103630 <mycpu>
  if(holding(lk))
80104200:	39 c3                	cmp    %eax,%ebx
80104202:	74 05                	je     80104209 <acquire+0x69>
80104204:	8b 55 08             	mov    0x8(%ebp),%edx
80104207:	eb ac                	jmp    801041b5 <acquire+0x15>
    panic("acquire");
80104209:	c7 04 24 43 76 10 80 	movl   $0x80107643,(%esp)
80104210:	e8 4b c1 ff ff       	call   80100360 <panic>
80104215:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104220 <popcli>:

void
popcli(void)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104226:	9c                   	pushf  
80104227:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104228:	f6 c4 02             	test   $0x2,%ah
8010422b:	75 49                	jne    80104276 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010422d:	e8 fe f3 ff ff       	call   80103630 <mycpu>
80104232:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104238:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010423b:	85 d2                	test   %edx,%edx
8010423d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104243:	78 25                	js     8010426a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104245:	e8 e6 f3 ff ff       	call   80103630 <mycpu>
8010424a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104250:	85 d2                	test   %edx,%edx
80104252:	74 04                	je     80104258 <popcli+0x38>
    sti();
}
80104254:	c9                   	leave  
80104255:	c3                   	ret    
80104256:	66 90                	xchg   %ax,%ax
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104258:	e8 d3 f3 ff ff       	call   80103630 <mycpu>
8010425d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104263:	85 c0                	test   %eax,%eax
80104265:	74 ed                	je     80104254 <popcli+0x34>
  asm volatile("sti");
80104267:	fb                   	sti    
}
80104268:	c9                   	leave  
80104269:	c3                   	ret    
    panic("popcli");
8010426a:	c7 04 24 62 76 10 80 	movl   $0x80107662,(%esp)
80104271:	e8 ea c0 ff ff       	call   80100360 <panic>
    panic("popcli - interruptible");
80104276:	c7 04 24 4b 76 10 80 	movl   $0x8010764b,(%esp)
8010427d:	e8 de c0 ff ff       	call   80100360 <panic>
80104282:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104290 <release>:
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	56                   	push   %esi
80104294:	53                   	push   %ebx
80104295:	83 ec 10             	sub    $0x10,%esp
80104298:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
8010429b:	8b 03                	mov    (%ebx),%eax
8010429d:	85 c0                	test   %eax,%eax
8010429f:	75 0f                	jne    801042b0 <release+0x20>
    panic("release");
801042a1:	c7 04 24 69 76 10 80 	movl   $0x80107669,(%esp)
801042a8:	e8 b3 c0 ff ff       	call   80100360 <panic>
801042ad:	8d 76 00             	lea    0x0(%esi),%esi
  return lock->locked && lock->cpu == mycpu();
801042b0:	8b 73 08             	mov    0x8(%ebx),%esi
801042b3:	e8 78 f3 ff ff       	call   80103630 <mycpu>
  if(!holding(lk))
801042b8:	39 c6                	cmp    %eax,%esi
801042ba:	75 e5                	jne    801042a1 <release+0x11>
  lk->pcs[0] = 0;
801042bc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801042c3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801042ca:	0f ae f0             	mfence 
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801042cd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801042d3:	83 c4 10             	add    $0x10,%esp
801042d6:	5b                   	pop    %ebx
801042d7:	5e                   	pop    %esi
801042d8:	5d                   	pop    %ebp
  popcli();
801042d9:	e9 42 ff ff ff       	jmp    80104220 <popcli>
801042de:	66 90                	xchg   %ax,%ax

801042e0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	8b 55 08             	mov    0x8(%ebp),%edx
801042e6:	57                   	push   %edi
801042e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801042ea:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801042eb:	f6 c2 03             	test   $0x3,%dl
801042ee:	75 05                	jne    801042f5 <memset+0x15>
801042f0:	f6 c1 03             	test   $0x3,%cl
801042f3:	74 13                	je     80104308 <memset+0x28>
  asm volatile("cld; rep stosb" :
801042f5:	89 d7                	mov    %edx,%edi
801042f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801042fa:	fc                   	cld    
801042fb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801042fd:	5b                   	pop    %ebx
801042fe:	89 d0                	mov    %edx,%eax
80104300:	5f                   	pop    %edi
80104301:	5d                   	pop    %ebp
80104302:	c3                   	ret    
80104303:	90                   	nop
80104304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104308:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010430c:	c1 e9 02             	shr    $0x2,%ecx
8010430f:	89 f8                	mov    %edi,%eax
80104311:	89 fb                	mov    %edi,%ebx
80104313:	c1 e0 18             	shl    $0x18,%eax
80104316:	c1 e3 10             	shl    $0x10,%ebx
80104319:	09 d8                	or     %ebx,%eax
8010431b:	09 f8                	or     %edi,%eax
8010431d:	c1 e7 08             	shl    $0x8,%edi
80104320:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104322:	89 d7                	mov    %edx,%edi
80104324:	fc                   	cld    
80104325:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104327:	5b                   	pop    %ebx
80104328:	89 d0                	mov    %edx,%eax
8010432a:	5f                   	pop    %edi
8010432b:	5d                   	pop    %ebp
8010432c:	c3                   	ret    
8010432d:	8d 76 00             	lea    0x0(%esi),%esi

80104330 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	8b 45 10             	mov    0x10(%ebp),%eax
80104336:	57                   	push   %edi
80104337:	56                   	push   %esi
80104338:	8b 75 0c             	mov    0xc(%ebp),%esi
8010433b:	53                   	push   %ebx
8010433c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010433f:	85 c0                	test   %eax,%eax
80104341:	8d 78 ff             	lea    -0x1(%eax),%edi
80104344:	74 26                	je     8010436c <memcmp+0x3c>
    if(*s1 != *s2)
80104346:	0f b6 03             	movzbl (%ebx),%eax
80104349:	31 d2                	xor    %edx,%edx
8010434b:	0f b6 0e             	movzbl (%esi),%ecx
8010434e:	38 c8                	cmp    %cl,%al
80104350:	74 16                	je     80104368 <memcmp+0x38>
80104352:	eb 24                	jmp    80104378 <memcmp+0x48>
80104354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104358:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010435d:	83 c2 01             	add    $0x1,%edx
80104360:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104364:	38 c8                	cmp    %cl,%al
80104366:	75 10                	jne    80104378 <memcmp+0x48>
  while(n-- > 0){
80104368:	39 fa                	cmp    %edi,%edx
8010436a:	75 ec                	jne    80104358 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010436c:	5b                   	pop    %ebx
  return 0;
8010436d:	31 c0                	xor    %eax,%eax
}
8010436f:	5e                   	pop    %esi
80104370:	5f                   	pop    %edi
80104371:	5d                   	pop    %ebp
80104372:	c3                   	ret    
80104373:	90                   	nop
80104374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104378:	5b                   	pop    %ebx
      return *s1 - *s2;
80104379:	29 c8                	sub    %ecx,%eax
}
8010437b:	5e                   	pop    %esi
8010437c:	5f                   	pop    %edi
8010437d:	5d                   	pop    %ebp
8010437e:	c3                   	ret    
8010437f:	90                   	nop

80104380 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	57                   	push   %edi
80104384:	8b 45 08             	mov    0x8(%ebp),%eax
80104387:	56                   	push   %esi
80104388:	8b 75 0c             	mov    0xc(%ebp),%esi
8010438b:	53                   	push   %ebx
8010438c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010438f:	39 c6                	cmp    %eax,%esi
80104391:	73 35                	jae    801043c8 <memmove+0x48>
80104393:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104396:	39 c8                	cmp    %ecx,%eax
80104398:	73 2e                	jae    801043c8 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010439a:	85 db                	test   %ebx,%ebx
    d += n;
8010439c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010439f:	8d 53 ff             	lea    -0x1(%ebx),%edx
801043a2:	74 1b                	je     801043bf <memmove+0x3f>
801043a4:	f7 db                	neg    %ebx
801043a6:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
801043a9:	01 fb                	add    %edi,%ebx
801043ab:	90                   	nop
801043ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801043b0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801043b4:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    while(n-- > 0)
801043b7:	83 ea 01             	sub    $0x1,%edx
801043ba:	83 fa ff             	cmp    $0xffffffff,%edx
801043bd:	75 f1                	jne    801043b0 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801043bf:	5b                   	pop    %ebx
801043c0:	5e                   	pop    %esi
801043c1:	5f                   	pop    %edi
801043c2:	5d                   	pop    %ebp
801043c3:	c3                   	ret    
801043c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801043c8:	31 d2                	xor    %edx,%edx
801043ca:	85 db                	test   %ebx,%ebx
801043cc:	74 f1                	je     801043bf <memmove+0x3f>
801043ce:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801043d0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801043d4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801043d7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801043da:	39 da                	cmp    %ebx,%edx
801043dc:	75 f2                	jne    801043d0 <memmove+0x50>
}
801043de:	5b                   	pop    %ebx
801043df:	5e                   	pop    %esi
801043e0:	5f                   	pop    %edi
801043e1:	5d                   	pop    %ebp
801043e2:	c3                   	ret    
801043e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043f0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801043f3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801043f4:	eb 8a                	jmp    80104380 <memmove>
801043f6:	8d 76 00             	lea    0x0(%esi),%esi
801043f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104400 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	56                   	push   %esi
80104404:	8b 75 10             	mov    0x10(%ebp),%esi
80104407:	53                   	push   %ebx
80104408:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010440b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
8010440e:	85 f6                	test   %esi,%esi
80104410:	74 30                	je     80104442 <strncmp+0x42>
80104412:	0f b6 01             	movzbl (%ecx),%eax
80104415:	84 c0                	test   %al,%al
80104417:	74 2f                	je     80104448 <strncmp+0x48>
80104419:	0f b6 13             	movzbl (%ebx),%edx
8010441c:	38 d0                	cmp    %dl,%al
8010441e:	75 46                	jne    80104466 <strncmp+0x66>
80104420:	8d 51 01             	lea    0x1(%ecx),%edx
80104423:	01 ce                	add    %ecx,%esi
80104425:	eb 14                	jmp    8010443b <strncmp+0x3b>
80104427:	90                   	nop
80104428:	0f b6 02             	movzbl (%edx),%eax
8010442b:	84 c0                	test   %al,%al
8010442d:	74 31                	je     80104460 <strncmp+0x60>
8010442f:	0f b6 19             	movzbl (%ecx),%ebx
80104432:	83 c2 01             	add    $0x1,%edx
80104435:	38 d8                	cmp    %bl,%al
80104437:	75 17                	jne    80104450 <strncmp+0x50>
    n--, p++, q++;
80104439:	89 cb                	mov    %ecx,%ebx
  while(n > 0 && *p && *p == *q)
8010443b:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
8010443d:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(n > 0 && *p && *p == *q)
80104440:	75 e6                	jne    80104428 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104442:	5b                   	pop    %ebx
    return 0;
80104443:	31 c0                	xor    %eax,%eax
}
80104445:	5e                   	pop    %esi
80104446:	5d                   	pop    %ebp
80104447:	c3                   	ret    
80104448:	0f b6 1b             	movzbl (%ebx),%ebx
  while(n > 0 && *p && *p == *q)
8010444b:	31 c0                	xor    %eax,%eax
8010444d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
80104450:	0f b6 d3             	movzbl %bl,%edx
80104453:	29 d0                	sub    %edx,%eax
}
80104455:	5b                   	pop    %ebx
80104456:	5e                   	pop    %esi
80104457:	5d                   	pop    %ebp
80104458:	c3                   	ret    
80104459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104460:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104464:	eb ea                	jmp    80104450 <strncmp+0x50>
  while(n > 0 && *p && *p == *q)
80104466:	89 d3                	mov    %edx,%ebx
80104468:	eb e6                	jmp    80104450 <strncmp+0x50>
8010446a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104470 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	8b 45 08             	mov    0x8(%ebp),%eax
80104476:	56                   	push   %esi
80104477:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010447a:	53                   	push   %ebx
8010447b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010447e:	89 c2                	mov    %eax,%edx
80104480:	eb 19                	jmp    8010449b <strncpy+0x2b>
80104482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104488:	83 c3 01             	add    $0x1,%ebx
8010448b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010448f:	83 c2 01             	add    $0x1,%edx
80104492:	84 c9                	test   %cl,%cl
80104494:	88 4a ff             	mov    %cl,-0x1(%edx)
80104497:	74 09                	je     801044a2 <strncpy+0x32>
80104499:	89 f1                	mov    %esi,%ecx
8010449b:	85 c9                	test   %ecx,%ecx
8010449d:	8d 71 ff             	lea    -0x1(%ecx),%esi
801044a0:	7f e6                	jg     80104488 <strncpy+0x18>
    ;
  while(n-- > 0)
801044a2:	31 c9                	xor    %ecx,%ecx
801044a4:	85 f6                	test   %esi,%esi
801044a6:	7e 0f                	jle    801044b7 <strncpy+0x47>
    *s++ = 0;
801044a8:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801044ac:	89 f3                	mov    %esi,%ebx
801044ae:	83 c1 01             	add    $0x1,%ecx
801044b1:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801044b3:	85 db                	test   %ebx,%ebx
801044b5:	7f f1                	jg     801044a8 <strncpy+0x38>
  return os;
}
801044b7:	5b                   	pop    %ebx
801044b8:	5e                   	pop    %esi
801044b9:	5d                   	pop    %ebp
801044ba:	c3                   	ret    
801044bb:	90                   	nop
801044bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
801044c6:	56                   	push   %esi
801044c7:	8b 45 08             	mov    0x8(%ebp),%eax
801044ca:	53                   	push   %ebx
801044cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801044ce:	85 c9                	test   %ecx,%ecx
801044d0:	7e 26                	jle    801044f8 <safestrcpy+0x38>
801044d2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801044d6:	89 c1                	mov    %eax,%ecx
801044d8:	eb 17                	jmp    801044f1 <safestrcpy+0x31>
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801044e0:	83 c2 01             	add    $0x1,%edx
801044e3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801044e7:	83 c1 01             	add    $0x1,%ecx
801044ea:	84 db                	test   %bl,%bl
801044ec:	88 59 ff             	mov    %bl,-0x1(%ecx)
801044ef:	74 04                	je     801044f5 <safestrcpy+0x35>
801044f1:	39 f2                	cmp    %esi,%edx
801044f3:	75 eb                	jne    801044e0 <safestrcpy+0x20>
    ;
  *s = 0;
801044f5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801044f8:	5b                   	pop    %ebx
801044f9:	5e                   	pop    %esi
801044fa:	5d                   	pop    %ebp
801044fb:	c3                   	ret    
801044fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104500 <strlen>:

int
strlen(const char *s)
{
80104500:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104501:	31 c0                	xor    %eax,%eax
{
80104503:	89 e5                	mov    %esp,%ebp
80104505:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104508:	80 3a 00             	cmpb   $0x0,(%edx)
8010450b:	74 0c                	je     80104519 <strlen+0x19>
8010450d:	8d 76 00             	lea    0x0(%esi),%esi
80104510:	83 c0 01             	add    $0x1,%eax
80104513:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104517:	75 f7                	jne    80104510 <strlen+0x10>
    ;
  return n;
}
80104519:	5d                   	pop    %ebp
8010451a:	c3                   	ret    

8010451b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010451b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010451f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104523:	55                   	push   %ebp
  pushl %ebx
80104524:	53                   	push   %ebx
  pushl %esi
80104525:	56                   	push   %esi
  pushl %edi
80104526:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104527:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104529:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010452b:	5f                   	pop    %edi
  popl %esi
8010452c:	5e                   	pop    %esi
  popl %ebx
8010452d:	5b                   	pop    %ebx
  popl %ebp
8010452e:	5d                   	pop    %ebp
  ret
8010452f:	c3                   	ret    

80104530 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	8b 45 08             	mov    0x8(%ebp),%eax
  //struct proc *curproc = myproc();

  //if(addr >= curproc->sz || addr+4 > curproc->sz)
  if(addr >= (KERNBASE-1) || addr+4 > (KERNBASE-1))
80104536:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
8010453b:	77 0b                	ja     80104548 <fetchint+0x18>
    return -1;
  *ip = *(int*)(addr);
8010453d:	8b 10                	mov    (%eax),%edx
8010453f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104542:	89 10                	mov    %edx,(%eax)
  return 0;
80104544:	31 c0                	xor    %eax,%eax
}
80104546:	5d                   	pop    %ebp
80104547:	c3                   	ret    
    return -1;
80104548:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010454d:	5d                   	pop    %ebp
8010454e:	c3                   	ret    
8010454f:	90                   	nop

80104550 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	8b 55 08             	mov    0x8(%ebp),%edx
  char *s, *ep;
  //struct proc *curproc = myproc();

  if(addr >= (KERNBASE-1))
80104556:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010455c:	77 21                	ja     8010457f <fetchstr+0x2f>
    return -1;
  *pp = (char*)addr;
8010455e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104561:	89 d0                	mov    %edx,%eax
80104563:	89 11                	mov    %edx,(%ecx)
  //ep = (char*)curproc->sz;
  ep = (char*)(KERNBASE-1);
  for(s = *pp; s < ep; s++){
    if(*s == 0)
80104565:	80 3a 00             	cmpb   $0x0,(%edx)
80104568:	75 0b                	jne    80104575 <fetchstr+0x25>
8010456a:	eb 1c                	jmp    80104588 <fetchstr+0x38>
8010456c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104570:	80 38 00             	cmpb   $0x0,(%eax)
80104573:	74 13                	je     80104588 <fetchstr+0x38>
  for(s = *pp; s < ep; s++){
80104575:	83 c0 01             	add    $0x1,%eax
80104578:	3d ff ff ff 7f       	cmp    $0x7fffffff,%eax
8010457d:	75 f1                	jne    80104570 <fetchstr+0x20>
    return -1;
8010457f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104584:	5d                   	pop    %ebp
80104585:	c3                   	ret    
80104586:	66 90                	xchg   %ax,%ax
      return s - *pp;
80104588:	29 d0                	sub    %edx,%eax
}
8010458a:	5d                   	pop    %ebp
8010458b:	c3                   	ret    
8010458c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104590 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104596:	e8 35 f1 ff ff       	call   801036d0 <myproc>
8010459b:	8b 55 08             	mov    0x8(%ebp),%edx
8010459e:	8b 40 18             	mov    0x18(%eax),%eax
801045a1:	8b 40 44             	mov    0x44(%eax),%eax
801045a4:	8d 44 90 04          	lea    0x4(%eax,%edx,4),%eax
  if(addr >= (KERNBASE-1) || addr+4 > (KERNBASE-1))
801045a8:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
801045ad:	77 11                	ja     801045c0 <argint+0x30>
  *ip = *(int*)(addr);
801045af:	8b 10                	mov    (%eax),%edx
801045b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801045b4:	89 10                	mov    %edx,(%eax)
  return 0;
801045b6:	31 c0                	xor    %eax,%eax
}
801045b8:	c9                   	leave  
801045b9:	c3                   	ret    
801045ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801045c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045c5:	c9                   	leave  
801045c6:	c3                   	ret    
801045c7:	89 f6                	mov    %esi,%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045d0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	53                   	push   %ebx
801045d4:	83 ec 24             	sub    $0x24,%esp
801045d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  //struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
801045da:	8d 45 f4             	lea    -0xc(%ebp),%eax
801045dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801045e1:	8b 45 08             	mov    0x8(%ebp),%eax
801045e4:	89 04 24             	mov    %eax,(%esp)
801045e7:	e8 a4 ff ff ff       	call   80104590 <argint>
801045ec:	85 c0                	test   %eax,%eax
801045ee:	78 20                	js     80104610 <argptr+0x40>
    return -1;
  //if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
  if(size < 0 || (uint)i >= (KERNBASE-1) || (uint)i+size > (KERNBASE-1))
801045f0:	85 db                	test   %ebx,%ebx
801045f2:	78 1c                	js     80104610 <argptr+0x40>
801045f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
801045fc:	77 12                	ja     80104610 <argptr+0x40>
801045fe:	01 c3                	add    %eax,%ebx
80104600:	78 0e                	js     80104610 <argptr+0x40>
    return -1;
  *pp = (char*)i;
80104602:	8b 55 0c             	mov    0xc(%ebp),%edx
80104605:	89 02                	mov    %eax,(%edx)
  return 0;
80104607:	31 c0                	xor    %eax,%eax
}
80104609:	83 c4 24             	add    $0x24,%esp
8010460c:	5b                   	pop    %ebx
8010460d:	5d                   	pop    %ebp
8010460e:	c3                   	ret    
8010460f:	90                   	nop
    return -1;
80104610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104615:	eb f2                	jmp    80104609 <argptr+0x39>
80104617:	89 f6                	mov    %esi,%esi
80104619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104620 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104626:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104629:	89 44 24 04          	mov    %eax,0x4(%esp)
8010462d:	8b 45 08             	mov    0x8(%ebp),%eax
80104630:	89 04 24             	mov    %eax,(%esp)
80104633:	e8 58 ff ff ff       	call   80104590 <argint>
80104638:	85 c0                	test   %eax,%eax
8010463a:	78 2b                	js     80104667 <argstr+0x47>
    return -1;
  return fetchstr(addr, pp);
8010463c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  if(addr >= (KERNBASE-1))
8010463f:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104645:	77 20                	ja     80104667 <argstr+0x47>
  *pp = (char*)addr;
80104647:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010464a:	89 d0                	mov    %edx,%eax
8010464c:	89 11                	mov    %edx,(%ecx)
    if(*s == 0)
8010464e:	80 3a 00             	cmpb   $0x0,(%edx)
80104651:	75 0a                	jne    8010465d <argstr+0x3d>
80104653:	eb 1b                	jmp    80104670 <argstr+0x50>
80104655:	8d 76 00             	lea    0x0(%esi),%esi
80104658:	80 38 00             	cmpb   $0x0,(%eax)
8010465b:	74 13                	je     80104670 <argstr+0x50>
  for(s = *pp; s < ep; s++){
8010465d:	83 c0 01             	add    $0x1,%eax
80104660:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
80104665:	76 f1                	jbe    80104658 <argstr+0x38>
    return -1;
80104667:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010466c:	c9                   	leave  
8010466d:	c3                   	ret    
8010466e:	66 90                	xchg   %ax,%ax
      return s - *pp;
80104670:	29 d0                	sub    %edx,%eax
}
80104672:	c9                   	leave  
80104673:	c3                   	ret    
80104674:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010467a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104680 <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
80104685:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104688:	e8 43 f0 ff ff       	call   801036d0 <myproc>

  num = curproc->tf->eax;
8010468d:	8b 70 18             	mov    0x18(%eax),%esi
  struct proc *curproc = myproc();
80104690:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
80104692:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104695:	8d 50 ff             	lea    -0x1(%eax),%edx
80104698:	83 fa 16             	cmp    $0x16,%edx
8010469b:	77 1b                	ja     801046b8 <syscall+0x38>
8010469d:	8b 14 85 a0 76 10 80 	mov    -0x7fef8960(,%eax,4),%edx
801046a4:	85 d2                	test   %edx,%edx
801046a6:	74 10                	je     801046b8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801046a8:	ff d2                	call   *%edx
801046aa:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801046ad:	83 c4 10             	add    $0x10,%esp
801046b0:	5b                   	pop    %ebx
801046b1:	5e                   	pop    %esi
801046b2:	5d                   	pop    %ebp
801046b3:	c3                   	ret    
801046b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801046b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
801046bc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801046bf:	89 44 24 08          	mov    %eax,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
801046c3:	8b 43 10             	mov    0x10(%ebx),%eax
801046c6:	c7 04 24 71 76 10 80 	movl   $0x80107671,(%esp)
801046cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801046d1:	e8 7a bf ff ff       	call   80100650 <cprintf>
    curproc->tf->eax = -1;
801046d6:	8b 43 18             	mov    0x18(%ebx),%eax
801046d9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801046e0:	83 c4 10             	add    $0x10,%esp
801046e3:	5b                   	pop    %ebx
801046e4:	5e                   	pop    %esi
801046e5:	5d                   	pop    %ebp
801046e6:	c3                   	ret    
801046e7:	66 90                	xchg   %ax,%ax
801046e9:	66 90                	xchg   %ax,%ax
801046eb:	66 90                	xchg   %ax,%ax
801046ed:	66 90                	xchg   %ax,%ax
801046ef:	90                   	nop

801046f0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	53                   	push   %ebx
801046f4:	89 c3                	mov    %eax,%ebx
801046f6:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
801046f9:	e8 d2 ef ff ff       	call   801036d0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801046fe:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
80104700:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104704:	85 c9                	test   %ecx,%ecx
80104706:	74 18                	je     80104720 <fdalloc+0x30>
  for(fd = 0; fd < NOFILE; fd++){
80104708:	83 c2 01             	add    $0x1,%edx
8010470b:	83 fa 10             	cmp    $0x10,%edx
8010470e:	75 f0                	jne    80104700 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
80104710:	83 c4 04             	add    $0x4,%esp
  return -1;
80104713:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104718:	5b                   	pop    %ebx
80104719:	5d                   	pop    %ebp
8010471a:	c3                   	ret    
8010471b:	90                   	nop
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80104720:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
}
80104724:	83 c4 04             	add    $0x4,%esp
      return fd;
80104727:	89 d0                	mov    %edx,%eax
}
80104729:	5b                   	pop    %ebx
8010472a:	5d                   	pop    %ebp
8010472b:	c3                   	ret    
8010472c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104730 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	57                   	push   %edi
80104734:	56                   	push   %esi
80104735:	53                   	push   %ebx
80104736:	83 ec 4c             	sub    $0x4c,%esp
80104739:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010473c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010473f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104742:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104746:	89 04 24             	mov    %eax,(%esp)
{
80104749:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010474c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010474f:	e8 fc d7 ff ff       	call   80101f50 <nameiparent>
80104754:	85 c0                	test   %eax,%eax
80104756:	89 c7                	mov    %eax,%edi
80104758:	0f 84 da 00 00 00    	je     80104838 <create+0x108>
    return 0;
  ilock(dp);
8010475e:	89 04 24             	mov    %eax,(%esp)
80104761:	e8 7a cf ff ff       	call   801016e0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104766:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104769:	89 44 24 08          	mov    %eax,0x8(%esp)
8010476d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104771:	89 3c 24             	mov    %edi,(%esp)
80104774:	e8 77 d4 ff ff       	call   80101bf0 <dirlookup>
80104779:	85 c0                	test   %eax,%eax
8010477b:	89 c6                	mov    %eax,%esi
8010477d:	74 41                	je     801047c0 <create+0x90>
    iunlockput(dp);
8010477f:	89 3c 24             	mov    %edi,(%esp)
80104782:	e8 b9 d1 ff ff       	call   80101940 <iunlockput>
    ilock(ip);
80104787:	89 34 24             	mov    %esi,(%esp)
8010478a:	e8 51 cf ff ff       	call   801016e0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010478f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104794:	75 12                	jne    801047a8 <create+0x78>
80104796:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010479b:	89 f0                	mov    %esi,%eax
8010479d:	75 09                	jne    801047a8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010479f:	83 c4 4c             	add    $0x4c,%esp
801047a2:	5b                   	pop    %ebx
801047a3:	5e                   	pop    %esi
801047a4:	5f                   	pop    %edi
801047a5:	5d                   	pop    %ebp
801047a6:	c3                   	ret    
801047a7:	90                   	nop
    iunlockput(ip);
801047a8:	89 34 24             	mov    %esi,(%esp)
801047ab:	e8 90 d1 ff ff       	call   80101940 <iunlockput>
}
801047b0:	83 c4 4c             	add    $0x4c,%esp
    return 0;
801047b3:	31 c0                	xor    %eax,%eax
}
801047b5:	5b                   	pop    %ebx
801047b6:	5e                   	pop    %esi
801047b7:	5f                   	pop    %edi
801047b8:	5d                   	pop    %ebp
801047b9:	c3                   	ret    
801047ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
801047c0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801047c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801047c8:	8b 07                	mov    (%edi),%eax
801047ca:	89 04 24             	mov    %eax,(%esp)
801047cd:	e8 7e cd ff ff       	call   80101550 <ialloc>
801047d2:	85 c0                	test   %eax,%eax
801047d4:	89 c6                	mov    %eax,%esi
801047d6:	0f 84 bf 00 00 00    	je     8010489b <create+0x16b>
  ilock(ip);
801047dc:	89 04 24             	mov    %eax,(%esp)
801047df:	e8 fc ce ff ff       	call   801016e0 <ilock>
  ip->major = major;
801047e4:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801047e8:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801047ec:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801047f0:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801047f4:	b8 01 00 00 00       	mov    $0x1,%eax
801047f9:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801047fd:	89 34 24             	mov    %esi,(%esp)
80104800:	e8 1b ce ff ff       	call   80101620 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104805:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010480a:	74 34                	je     80104840 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
8010480c:	8b 46 04             	mov    0x4(%esi),%eax
8010480f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104813:	89 3c 24             	mov    %edi,(%esp)
80104816:	89 44 24 08          	mov    %eax,0x8(%esp)
8010481a:	e8 31 d6 ff ff       	call   80101e50 <dirlink>
8010481f:	85 c0                	test   %eax,%eax
80104821:	78 6c                	js     8010488f <create+0x15f>
  iunlockput(dp);
80104823:	89 3c 24             	mov    %edi,(%esp)
80104826:	e8 15 d1 ff ff       	call   80101940 <iunlockput>
}
8010482b:	83 c4 4c             	add    $0x4c,%esp
  return ip;
8010482e:	89 f0                	mov    %esi,%eax
}
80104830:	5b                   	pop    %ebx
80104831:	5e                   	pop    %esi
80104832:	5f                   	pop    %edi
80104833:	5d                   	pop    %ebp
80104834:	c3                   	ret    
80104835:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
80104838:	31 c0                	xor    %eax,%eax
8010483a:	e9 60 ff ff ff       	jmp    8010479f <create+0x6f>
8010483f:	90                   	nop
    dp->nlink++;  // for ".."
80104840:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104845:	89 3c 24             	mov    %edi,(%esp)
80104848:	e8 d3 cd ff ff       	call   80101620 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010484d:	8b 46 04             	mov    0x4(%esi),%eax
80104850:	c7 44 24 04 1c 77 10 	movl   $0x8010771c,0x4(%esp)
80104857:	80 
80104858:	89 34 24             	mov    %esi,(%esp)
8010485b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010485f:	e8 ec d5 ff ff       	call   80101e50 <dirlink>
80104864:	85 c0                	test   %eax,%eax
80104866:	78 1b                	js     80104883 <create+0x153>
80104868:	8b 47 04             	mov    0x4(%edi),%eax
8010486b:	c7 44 24 04 1b 77 10 	movl   $0x8010771b,0x4(%esp)
80104872:	80 
80104873:	89 34 24             	mov    %esi,(%esp)
80104876:	89 44 24 08          	mov    %eax,0x8(%esp)
8010487a:	e8 d1 d5 ff ff       	call   80101e50 <dirlink>
8010487f:	85 c0                	test   %eax,%eax
80104881:	79 89                	jns    8010480c <create+0xdc>
      panic("create dots");
80104883:	c7 04 24 0f 77 10 80 	movl   $0x8010770f,(%esp)
8010488a:	e8 d1 ba ff ff       	call   80100360 <panic>
    panic("create: dirlink");
8010488f:	c7 04 24 1e 77 10 80 	movl   $0x8010771e,(%esp)
80104896:	e8 c5 ba ff ff       	call   80100360 <panic>
    panic("create: ialloc");
8010489b:	c7 04 24 00 77 10 80 	movl   $0x80107700,(%esp)
801048a2:	e8 b9 ba ff ff       	call   80100360 <panic>
801048a7:	89 f6                	mov    %esi,%esi
801048a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048b0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	56                   	push   %esi
801048b4:	89 c6                	mov    %eax,%esi
801048b6:	53                   	push   %ebx
801048b7:	89 d3                	mov    %edx,%ebx
801048b9:	83 ec 20             	sub    $0x20,%esp
  if(argint(n, &fd) < 0)
801048bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801048c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801048ca:	e8 c1 fc ff ff       	call   80104590 <argint>
801048cf:	85 c0                	test   %eax,%eax
801048d1:	78 2d                	js     80104900 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801048d3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801048d7:	77 27                	ja     80104900 <argfd.constprop.0+0x50>
801048d9:	e8 f2 ed ff ff       	call   801036d0 <myproc>
801048de:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048e1:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801048e5:	85 c0                	test   %eax,%eax
801048e7:	74 17                	je     80104900 <argfd.constprop.0+0x50>
  if(pfd)
801048e9:	85 f6                	test   %esi,%esi
801048eb:	74 02                	je     801048ef <argfd.constprop.0+0x3f>
    *pfd = fd;
801048ed:	89 16                	mov    %edx,(%esi)
  if(pf)
801048ef:	85 db                	test   %ebx,%ebx
801048f1:	74 1d                	je     80104910 <argfd.constprop.0+0x60>
    *pf = f;
801048f3:	89 03                	mov    %eax,(%ebx)
  return 0;
801048f5:	31 c0                	xor    %eax,%eax
}
801048f7:	83 c4 20             	add    $0x20,%esp
801048fa:	5b                   	pop    %ebx
801048fb:	5e                   	pop    %esi
801048fc:	5d                   	pop    %ebp
801048fd:	c3                   	ret    
801048fe:	66 90                	xchg   %ax,%ax
80104900:	83 c4 20             	add    $0x20,%esp
    return -1;
80104903:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104908:	5b                   	pop    %ebx
80104909:	5e                   	pop    %esi
8010490a:	5d                   	pop    %ebp
8010490b:	c3                   	ret    
8010490c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
80104910:	31 c0                	xor    %eax,%eax
80104912:	eb e3                	jmp    801048f7 <argfd.constprop.0+0x47>
80104914:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010491a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104920 <sys_dup>:
{
80104920:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104921:	31 c0                	xor    %eax,%eax
{
80104923:	89 e5                	mov    %esp,%ebp
80104925:	53                   	push   %ebx
80104926:	83 ec 24             	sub    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
80104929:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010492c:	e8 7f ff ff ff       	call   801048b0 <argfd.constprop.0>
80104931:	85 c0                	test   %eax,%eax
80104933:	78 23                	js     80104958 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104935:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104938:	e8 b3 fd ff ff       	call   801046f0 <fdalloc>
8010493d:	85 c0                	test   %eax,%eax
8010493f:	89 c3                	mov    %eax,%ebx
80104941:	78 15                	js     80104958 <sys_dup+0x38>
  filedup(f);
80104943:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104946:	89 04 24             	mov    %eax,(%esp)
80104949:	e8 b2 c4 ff ff       	call   80100e00 <filedup>
  return fd;
8010494e:	89 d8                	mov    %ebx,%eax
}
80104950:	83 c4 24             	add    $0x24,%esp
80104953:	5b                   	pop    %ebx
80104954:	5d                   	pop    %ebp
80104955:	c3                   	ret    
80104956:	66 90                	xchg   %ax,%ax
    return -1;
80104958:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010495d:	eb f1                	jmp    80104950 <sys_dup+0x30>
8010495f:	90                   	nop

80104960 <sys_read>:
{
80104960:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104961:	31 c0                	xor    %eax,%eax
{
80104963:	89 e5                	mov    %esp,%ebp
80104965:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104968:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010496b:	e8 40 ff ff ff       	call   801048b0 <argfd.constprop.0>
80104970:	85 c0                	test   %eax,%eax
80104972:	78 54                	js     801049c8 <sys_read+0x68>
80104974:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104977:	89 44 24 04          	mov    %eax,0x4(%esp)
8010497b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104982:	e8 09 fc ff ff       	call   80104590 <argint>
80104987:	85 c0                	test   %eax,%eax
80104989:	78 3d                	js     801049c8 <sys_read+0x68>
8010498b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010498e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104995:	89 44 24 08          	mov    %eax,0x8(%esp)
80104999:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010499c:	89 44 24 04          	mov    %eax,0x4(%esp)
801049a0:	e8 2b fc ff ff       	call   801045d0 <argptr>
801049a5:	85 c0                	test   %eax,%eax
801049a7:	78 1f                	js     801049c8 <sys_read+0x68>
  return fileread(f, p, n);
801049a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049ac:	89 44 24 08          	mov    %eax,0x8(%esp)
801049b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801049b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049ba:	89 04 24             	mov    %eax,(%esp)
801049bd:	e8 9e c5 ff ff       	call   80100f60 <fileread>
}
801049c2:	c9                   	leave  
801049c3:	c3                   	ret    
801049c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049cd:	c9                   	leave  
801049ce:	c3                   	ret    
801049cf:	90                   	nop

801049d0 <sys_write>:
{
801049d0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801049d1:	31 c0                	xor    %eax,%eax
{
801049d3:	89 e5                	mov    %esp,%ebp
801049d5:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801049d8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801049db:	e8 d0 fe ff ff       	call   801048b0 <argfd.constprop.0>
801049e0:	85 c0                	test   %eax,%eax
801049e2:	78 54                	js     80104a38 <sys_write+0x68>
801049e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801049eb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801049f2:	e8 99 fb ff ff       	call   80104590 <argint>
801049f7:	85 c0                	test   %eax,%eax
801049f9:	78 3d                	js     80104a38 <sys_write+0x68>
801049fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a05:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a10:	e8 bb fb ff ff       	call   801045d0 <argptr>
80104a15:	85 c0                	test   %eax,%eax
80104a17:	78 1f                	js     80104a38 <sys_write+0x68>
  return filewrite(f, p, n);
80104a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a1c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a23:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a27:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a2a:	89 04 24             	mov    %eax,(%esp)
80104a2d:	e8 ce c5 ff ff       	call   80101000 <filewrite>
}
80104a32:	c9                   	leave  
80104a33:	c3                   	ret    
80104a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a3d:	c9                   	leave  
80104a3e:	c3                   	ret    
80104a3f:	90                   	nop

80104a40 <sys_close>:
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
80104a46:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104a49:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a4c:	e8 5f fe ff ff       	call   801048b0 <argfd.constprop.0>
80104a51:	85 c0                	test   %eax,%eax
80104a53:	78 23                	js     80104a78 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
80104a55:	e8 76 ec ff ff       	call   801036d0 <myproc>
80104a5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a5d:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104a64:	00 
  fileclose(f);
80104a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a68:	89 04 24             	mov    %eax,(%esp)
80104a6b:	e8 e0 c3 ff ff       	call   80100e50 <fileclose>
  return 0;
80104a70:	31 c0                	xor    %eax,%eax
}
80104a72:	c9                   	leave  
80104a73:	c3                   	ret    
80104a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a7d:	c9                   	leave  
80104a7e:	c3                   	ret    
80104a7f:	90                   	nop

80104a80 <sys_fstat>:
{
80104a80:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a81:	31 c0                	xor    %eax,%eax
{
80104a83:	89 e5                	mov    %esp,%ebp
80104a85:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a88:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104a8b:	e8 20 fe ff ff       	call   801048b0 <argfd.constprop.0>
80104a90:	85 c0                	test   %eax,%eax
80104a92:	78 34                	js     80104ac8 <sys_fstat+0x48>
80104a94:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a97:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104a9e:	00 
80104a9f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aa3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104aaa:	e8 21 fb ff ff       	call   801045d0 <argptr>
80104aaf:	85 c0                	test   %eax,%eax
80104ab1:	78 15                	js     80104ac8 <sys_fstat+0x48>
  return filestat(f, st);
80104ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab6:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104abd:	89 04 24             	mov    %eax,(%esp)
80104ac0:	e8 4b c4 ff ff       	call   80100f10 <filestat>
}
80104ac5:	c9                   	leave  
80104ac6:	c3                   	ret    
80104ac7:	90                   	nop
    return -1;
80104ac8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104acd:	c9                   	leave  
80104ace:	c3                   	ret    
80104acf:	90                   	nop

80104ad0 <sys_link>:
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	57                   	push   %edi
80104ad4:	56                   	push   %esi
80104ad5:	53                   	push   %ebx
80104ad6:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ad9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104adc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ae0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ae7:	e8 34 fb ff ff       	call   80104620 <argstr>
80104aec:	85 c0                	test   %eax,%eax
80104aee:	0f 88 e6 00 00 00    	js     80104bda <sys_link+0x10a>
80104af4:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104af7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104afb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b02:	e8 19 fb ff ff       	call   80104620 <argstr>
80104b07:	85 c0                	test   %eax,%eax
80104b09:	0f 88 cb 00 00 00    	js     80104bda <sys_link+0x10a>
  begin_op();
80104b0f:	e8 2c e0 ff ff       	call   80102b40 <begin_op>
  if((ip = namei(old)) == 0){
80104b14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104b17:	89 04 24             	mov    %eax,(%esp)
80104b1a:	e8 11 d4 ff ff       	call   80101f30 <namei>
80104b1f:	85 c0                	test   %eax,%eax
80104b21:	89 c3                	mov    %eax,%ebx
80104b23:	0f 84 ac 00 00 00    	je     80104bd5 <sys_link+0x105>
  ilock(ip);
80104b29:	89 04 24             	mov    %eax,(%esp)
80104b2c:	e8 af cb ff ff       	call   801016e0 <ilock>
  if(ip->type == T_DIR){
80104b31:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b36:	0f 84 91 00 00 00    	je     80104bcd <sys_link+0xfd>
  ip->nlink++;
80104b3c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104b41:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104b44:	89 1c 24             	mov    %ebx,(%esp)
80104b47:	e8 d4 ca ff ff       	call   80101620 <iupdate>
  iunlock(ip);
80104b4c:	89 1c 24             	mov    %ebx,(%esp)
80104b4f:	e8 6c cc ff ff       	call   801017c0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104b54:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104b57:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104b5b:	89 04 24             	mov    %eax,(%esp)
80104b5e:	e8 ed d3 ff ff       	call   80101f50 <nameiparent>
80104b63:	85 c0                	test   %eax,%eax
80104b65:	89 c6                	mov    %eax,%esi
80104b67:	74 4f                	je     80104bb8 <sys_link+0xe8>
  ilock(dp);
80104b69:	89 04 24             	mov    %eax,(%esp)
80104b6c:	e8 6f cb ff ff       	call   801016e0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104b71:	8b 03                	mov    (%ebx),%eax
80104b73:	39 06                	cmp    %eax,(%esi)
80104b75:	75 39                	jne    80104bb0 <sys_link+0xe0>
80104b77:	8b 43 04             	mov    0x4(%ebx),%eax
80104b7a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104b7e:	89 34 24             	mov    %esi,(%esp)
80104b81:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b85:	e8 c6 d2 ff ff       	call   80101e50 <dirlink>
80104b8a:	85 c0                	test   %eax,%eax
80104b8c:	78 22                	js     80104bb0 <sys_link+0xe0>
  iunlockput(dp);
80104b8e:	89 34 24             	mov    %esi,(%esp)
80104b91:	e8 aa cd ff ff       	call   80101940 <iunlockput>
  iput(ip);
80104b96:	89 1c 24             	mov    %ebx,(%esp)
80104b99:	e8 62 cc ff ff       	call   80101800 <iput>
  end_op();
80104b9e:	e8 0d e0 ff ff       	call   80102bb0 <end_op>
}
80104ba3:	83 c4 3c             	add    $0x3c,%esp
  return 0;
80104ba6:	31 c0                	xor    %eax,%eax
}
80104ba8:	5b                   	pop    %ebx
80104ba9:	5e                   	pop    %esi
80104baa:	5f                   	pop    %edi
80104bab:	5d                   	pop    %ebp
80104bac:	c3                   	ret    
80104bad:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104bb0:	89 34 24             	mov    %esi,(%esp)
80104bb3:	e8 88 cd ff ff       	call   80101940 <iunlockput>
  ilock(ip);
80104bb8:	89 1c 24             	mov    %ebx,(%esp)
80104bbb:	e8 20 cb ff ff       	call   801016e0 <ilock>
  ip->nlink--;
80104bc0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104bc5:	89 1c 24             	mov    %ebx,(%esp)
80104bc8:	e8 53 ca ff ff       	call   80101620 <iupdate>
  iunlockput(ip);
80104bcd:	89 1c 24             	mov    %ebx,(%esp)
80104bd0:	e8 6b cd ff ff       	call   80101940 <iunlockput>
  end_op();
80104bd5:	e8 d6 df ff ff       	call   80102bb0 <end_op>
}
80104bda:	83 c4 3c             	add    $0x3c,%esp
  return -1;
80104bdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104be2:	5b                   	pop    %ebx
80104be3:	5e                   	pop    %esi
80104be4:	5f                   	pop    %edi
80104be5:	5d                   	pop    %ebp
80104be6:	c3                   	ret    
80104be7:	89 f6                	mov    %esi,%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bf0 <sys_unlink>:
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	57                   	push   %edi
80104bf4:	56                   	push   %esi
80104bf5:	53                   	push   %ebx
80104bf6:	83 ec 5c             	sub    $0x5c,%esp
  if(argstr(0, &path) < 0)
80104bf9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c00:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104c07:	e8 14 fa ff ff       	call   80104620 <argstr>
80104c0c:	85 c0                	test   %eax,%eax
80104c0e:	0f 88 76 01 00 00    	js     80104d8a <sys_unlink+0x19a>
  begin_op();
80104c14:	e8 27 df ff ff       	call   80102b40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104c19:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104c1c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104c1f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c23:	89 04 24             	mov    %eax,(%esp)
80104c26:	e8 25 d3 ff ff       	call   80101f50 <nameiparent>
80104c2b:	85 c0                	test   %eax,%eax
80104c2d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104c30:	0f 84 4f 01 00 00    	je     80104d85 <sys_unlink+0x195>
  ilock(dp);
80104c36:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104c39:	89 34 24             	mov    %esi,(%esp)
80104c3c:	e8 9f ca ff ff       	call   801016e0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104c41:	c7 44 24 04 1c 77 10 	movl   $0x8010771c,0x4(%esp)
80104c48:	80 
80104c49:	89 1c 24             	mov    %ebx,(%esp)
80104c4c:	e8 6f cf ff ff       	call   80101bc0 <namecmp>
80104c51:	85 c0                	test   %eax,%eax
80104c53:	0f 84 21 01 00 00    	je     80104d7a <sys_unlink+0x18a>
80104c59:	c7 44 24 04 1b 77 10 	movl   $0x8010771b,0x4(%esp)
80104c60:	80 
80104c61:	89 1c 24             	mov    %ebx,(%esp)
80104c64:	e8 57 cf ff ff       	call   80101bc0 <namecmp>
80104c69:	85 c0                	test   %eax,%eax
80104c6b:	0f 84 09 01 00 00    	je     80104d7a <sys_unlink+0x18a>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104c71:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104c74:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c78:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c7c:	89 34 24             	mov    %esi,(%esp)
80104c7f:	e8 6c cf ff ff       	call   80101bf0 <dirlookup>
80104c84:	85 c0                	test   %eax,%eax
80104c86:	89 c3                	mov    %eax,%ebx
80104c88:	0f 84 ec 00 00 00    	je     80104d7a <sys_unlink+0x18a>
  ilock(ip);
80104c8e:	89 04 24             	mov    %eax,(%esp)
80104c91:	e8 4a ca ff ff       	call   801016e0 <ilock>
  if(ip->nlink < 1)
80104c96:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104c9b:	0f 8e 24 01 00 00    	jle    80104dc5 <sys_unlink+0x1d5>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104ca1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ca6:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104ca9:	74 7d                	je     80104d28 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
80104cab:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104cb2:	00 
80104cb3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104cba:	00 
80104cbb:	89 34 24             	mov    %esi,(%esp)
80104cbe:	e8 1d f6 ff ff       	call   801042e0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104cc3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104cc6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104ccd:	00 
80104cce:	89 74 24 04          	mov    %esi,0x4(%esp)
80104cd2:	89 44 24 08          	mov    %eax,0x8(%esp)
80104cd6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104cd9:	89 04 24             	mov    %eax,(%esp)
80104cdc:	e8 af cd ff ff       	call   80101a90 <writei>
80104ce1:	83 f8 10             	cmp    $0x10,%eax
80104ce4:	0f 85 cf 00 00 00    	jne    80104db9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80104cea:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104cef:	0f 84 a3 00 00 00    	je     80104d98 <sys_unlink+0x1a8>
  iunlockput(dp);
80104cf5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104cf8:	89 04 24             	mov    %eax,(%esp)
80104cfb:	e8 40 cc ff ff       	call   80101940 <iunlockput>
  ip->nlink--;
80104d00:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d05:	89 1c 24             	mov    %ebx,(%esp)
80104d08:	e8 13 c9 ff ff       	call   80101620 <iupdate>
  iunlockput(ip);
80104d0d:	89 1c 24             	mov    %ebx,(%esp)
80104d10:	e8 2b cc ff ff       	call   80101940 <iunlockput>
  end_op();
80104d15:	e8 96 de ff ff       	call   80102bb0 <end_op>
}
80104d1a:	83 c4 5c             	add    $0x5c,%esp
  return 0;
80104d1d:	31 c0                	xor    %eax,%eax
}
80104d1f:	5b                   	pop    %ebx
80104d20:	5e                   	pop    %esi
80104d21:	5f                   	pop    %edi
80104d22:	5d                   	pop    %ebp
80104d23:	c3                   	ret    
80104d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104d28:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104d2c:	0f 86 79 ff ff ff    	jbe    80104cab <sys_unlink+0xbb>
80104d32:	bf 20 00 00 00       	mov    $0x20,%edi
80104d37:	eb 15                	jmp    80104d4e <sys_unlink+0x15e>
80104d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d40:	8d 57 10             	lea    0x10(%edi),%edx
80104d43:	3b 53 58             	cmp    0x58(%ebx),%edx
80104d46:	0f 83 5f ff ff ff    	jae    80104cab <sys_unlink+0xbb>
80104d4c:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104d4e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104d55:	00 
80104d56:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104d5a:	89 74 24 04          	mov    %esi,0x4(%esp)
80104d5e:	89 1c 24             	mov    %ebx,(%esp)
80104d61:	e8 2a cc ff ff       	call   80101990 <readi>
80104d66:	83 f8 10             	cmp    $0x10,%eax
80104d69:	75 42                	jne    80104dad <sys_unlink+0x1bd>
    if(de.inum != 0)
80104d6b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104d70:	74 ce                	je     80104d40 <sys_unlink+0x150>
    iunlockput(ip);
80104d72:	89 1c 24             	mov    %ebx,(%esp)
80104d75:	e8 c6 cb ff ff       	call   80101940 <iunlockput>
  iunlockput(dp);
80104d7a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d7d:	89 04 24             	mov    %eax,(%esp)
80104d80:	e8 bb cb ff ff       	call   80101940 <iunlockput>
  end_op();
80104d85:	e8 26 de ff ff       	call   80102bb0 <end_op>
}
80104d8a:	83 c4 5c             	add    $0x5c,%esp
  return -1;
80104d8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d92:	5b                   	pop    %ebx
80104d93:	5e                   	pop    %esi
80104d94:	5f                   	pop    %edi
80104d95:	5d                   	pop    %ebp
80104d96:	c3                   	ret    
80104d97:	90                   	nop
    dp->nlink--;
80104d98:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d9b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104da0:	89 04 24             	mov    %eax,(%esp)
80104da3:	e8 78 c8 ff ff       	call   80101620 <iupdate>
80104da8:	e9 48 ff ff ff       	jmp    80104cf5 <sys_unlink+0x105>
      panic("isdirempty: readi");
80104dad:	c7 04 24 40 77 10 80 	movl   $0x80107740,(%esp)
80104db4:	e8 a7 b5 ff ff       	call   80100360 <panic>
    panic("unlink: writei");
80104db9:	c7 04 24 52 77 10 80 	movl   $0x80107752,(%esp)
80104dc0:	e8 9b b5 ff ff       	call   80100360 <panic>
    panic("unlink: nlink < 1");
80104dc5:	c7 04 24 2e 77 10 80 	movl   $0x8010772e,(%esp)
80104dcc:	e8 8f b5 ff ff       	call   80100360 <panic>
80104dd1:	eb 0d                	jmp    80104de0 <sys_open>
80104dd3:	90                   	nop
80104dd4:	90                   	nop
80104dd5:	90                   	nop
80104dd6:	90                   	nop
80104dd7:	90                   	nop
80104dd8:	90                   	nop
80104dd9:	90                   	nop
80104dda:	90                   	nop
80104ddb:	90                   	nop
80104ddc:	90                   	nop
80104ddd:	90                   	nop
80104dde:	90                   	nop
80104ddf:	90                   	nop

80104de0 <sys_open>:

int
sys_open(void)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	57                   	push   %edi
80104de4:	56                   	push   %esi
80104de5:	53                   	push   %ebx
80104de6:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104de9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104dec:	89 44 24 04          	mov    %eax,0x4(%esp)
80104df0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104df7:	e8 24 f8 ff ff       	call   80104620 <argstr>
80104dfc:	85 c0                	test   %eax,%eax
80104dfe:	0f 88 d1 00 00 00    	js     80104ed5 <sys_open+0xf5>
80104e04:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104e07:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e12:	e8 79 f7 ff ff       	call   80104590 <argint>
80104e17:	85 c0                	test   %eax,%eax
80104e19:	0f 88 b6 00 00 00    	js     80104ed5 <sys_open+0xf5>
    return -1;

  begin_op();
80104e1f:	e8 1c dd ff ff       	call   80102b40 <begin_op>

  if(omode & O_CREATE){
80104e24:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104e28:	0f 85 82 00 00 00    	jne    80104eb0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104e2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e31:	89 04 24             	mov    %eax,(%esp)
80104e34:	e8 f7 d0 ff ff       	call   80101f30 <namei>
80104e39:	85 c0                	test   %eax,%eax
80104e3b:	89 c6                	mov    %eax,%esi
80104e3d:	0f 84 8d 00 00 00    	je     80104ed0 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80104e43:	89 04 24             	mov    %eax,(%esp)
80104e46:	e8 95 c8 ff ff       	call   801016e0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104e4b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104e50:	0f 84 92 00 00 00    	je     80104ee8 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104e56:	e8 35 bf ff ff       	call   80100d90 <filealloc>
80104e5b:	85 c0                	test   %eax,%eax
80104e5d:	89 c3                	mov    %eax,%ebx
80104e5f:	0f 84 93 00 00 00    	je     80104ef8 <sys_open+0x118>
80104e65:	e8 86 f8 ff ff       	call   801046f0 <fdalloc>
80104e6a:	85 c0                	test   %eax,%eax
80104e6c:	89 c7                	mov    %eax,%edi
80104e6e:	0f 88 94 00 00 00    	js     80104f08 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104e74:	89 34 24             	mov    %esi,(%esp)
80104e77:	e8 44 c9 ff ff       	call   801017c0 <iunlock>
  end_op();
80104e7c:	e8 2f dd ff ff       	call   80102bb0 <end_op>

  f->type = FD_INODE;
80104e81:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104e87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f->ip = ip;
80104e8a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104e8d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104e94:	89 c2                	mov    %eax,%edx
80104e96:	83 e2 01             	and    $0x1,%edx
80104e99:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e9c:	a8 03                	test   $0x3,%al
  f->readable = !(omode & O_WRONLY);
80104e9e:	88 53 08             	mov    %dl,0x8(%ebx)
  return fd;
80104ea1:	89 f8                	mov    %edi,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104ea3:	0f 95 43 09          	setne  0x9(%ebx)
}
80104ea7:	83 c4 2c             	add    $0x2c,%esp
80104eaa:	5b                   	pop    %ebx
80104eab:	5e                   	pop    %esi
80104eac:	5f                   	pop    %edi
80104ead:	5d                   	pop    %ebp
80104eae:	c3                   	ret    
80104eaf:	90                   	nop
    ip = create(path, T_FILE, 0, 0);
80104eb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104eb3:	31 c9                	xor    %ecx,%ecx
80104eb5:	ba 02 00 00 00       	mov    $0x2,%edx
80104eba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ec1:	e8 6a f8 ff ff       	call   80104730 <create>
    if(ip == 0){
80104ec6:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80104ec8:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104eca:	75 8a                	jne    80104e56 <sys_open+0x76>
80104ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80104ed0:	e8 db dc ff ff       	call   80102bb0 <end_op>
}
80104ed5:	83 c4 2c             	add    $0x2c,%esp
    return -1;
80104ed8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104edd:	5b                   	pop    %ebx
80104ede:	5e                   	pop    %esi
80104edf:	5f                   	pop    %edi
80104ee0:	5d                   	pop    %ebp
80104ee1:	c3                   	ret    
80104ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80104ee8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104eeb:	85 c0                	test   %eax,%eax
80104eed:	0f 84 63 ff ff ff    	je     80104e56 <sys_open+0x76>
80104ef3:	90                   	nop
80104ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80104ef8:	89 34 24             	mov    %esi,(%esp)
80104efb:	e8 40 ca ff ff       	call   80101940 <iunlockput>
80104f00:	eb ce                	jmp    80104ed0 <sys_open+0xf0>
80104f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      fileclose(f);
80104f08:	89 1c 24             	mov    %ebx,(%esp)
80104f0b:	e8 40 bf ff ff       	call   80100e50 <fileclose>
80104f10:	eb e6                	jmp    80104ef8 <sys_open+0x118>
80104f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f20 <sys_mkdir>:

int
sys_mkdir(void)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104f26:	e8 15 dc ff ff       	call   80102b40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104f2b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f2e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f32:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f39:	e8 e2 f6 ff ff       	call   80104620 <argstr>
80104f3e:	85 c0                	test   %eax,%eax
80104f40:	78 2e                	js     80104f70 <sys_mkdir+0x50>
80104f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f45:	31 c9                	xor    %ecx,%ecx
80104f47:	ba 01 00 00 00       	mov    $0x1,%edx
80104f4c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f53:	e8 d8 f7 ff ff       	call   80104730 <create>
80104f58:	85 c0                	test   %eax,%eax
80104f5a:	74 14                	je     80104f70 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104f5c:	89 04 24             	mov    %eax,(%esp)
80104f5f:	e8 dc c9 ff ff       	call   80101940 <iunlockput>
  end_op();
80104f64:	e8 47 dc ff ff       	call   80102bb0 <end_op>
  return 0;
80104f69:	31 c0                	xor    %eax,%eax
}
80104f6b:	c9                   	leave  
80104f6c:	c3                   	ret    
80104f6d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80104f70:	e8 3b dc ff ff       	call   80102bb0 <end_op>
    return -1;
80104f75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f7a:	c9                   	leave  
80104f7b:	c3                   	ret    
80104f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f80 <sys_mknod>:

int
sys_mknod(void)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104f86:	e8 b5 db ff ff       	call   80102b40 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104f8b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104f8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f92:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f99:	e8 82 f6 ff ff       	call   80104620 <argstr>
80104f9e:	85 c0                	test   %eax,%eax
80104fa0:	78 5e                	js     80105000 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80104fa2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fa5:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fa9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104fb0:	e8 db f5 ff ff       	call   80104590 <argint>
  if((argstr(0, &path)) < 0 ||
80104fb5:	85 c0                	test   %eax,%eax
80104fb7:	78 47                	js     80105000 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80104fb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fc0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104fc7:	e8 c4 f5 ff ff       	call   80104590 <argint>
     argint(1, &major) < 0 ||
80104fcc:	85 c0                	test   %eax,%eax
80104fce:	78 30                	js     80105000 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104fd0:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80104fd4:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80104fd9:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104fdd:	89 04 24             	mov    %eax,(%esp)
     argint(2, &minor) < 0 ||
80104fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104fe3:	e8 48 f7 ff ff       	call   80104730 <create>
80104fe8:	85 c0                	test   %eax,%eax
80104fea:	74 14                	je     80105000 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104fec:	89 04 24             	mov    %eax,(%esp)
80104fef:	e8 4c c9 ff ff       	call   80101940 <iunlockput>
  end_op();
80104ff4:	e8 b7 db ff ff       	call   80102bb0 <end_op>
  return 0;
80104ff9:	31 c0                	xor    %eax,%eax
}
80104ffb:	c9                   	leave  
80104ffc:	c3                   	ret    
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80105000:	e8 ab db ff ff       	call   80102bb0 <end_op>
    return -1;
80105005:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010500a:	c9                   	leave  
8010500b:	c3                   	ret    
8010500c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105010 <sys_chdir>:

int
sys_chdir(void)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	56                   	push   %esi
80105014:	53                   	push   %ebx
80105015:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105018:	e8 b3 e6 ff ff       	call   801036d0 <myproc>
8010501d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010501f:	e8 1c db ff ff       	call   80102b40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105024:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105027:	89 44 24 04          	mov    %eax,0x4(%esp)
8010502b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105032:	e8 e9 f5 ff ff       	call   80104620 <argstr>
80105037:	85 c0                	test   %eax,%eax
80105039:	78 4a                	js     80105085 <sys_chdir+0x75>
8010503b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010503e:	89 04 24             	mov    %eax,(%esp)
80105041:	e8 ea ce ff ff       	call   80101f30 <namei>
80105046:	85 c0                	test   %eax,%eax
80105048:	89 c3                	mov    %eax,%ebx
8010504a:	74 39                	je     80105085 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
8010504c:	89 04 24             	mov    %eax,(%esp)
8010504f:	e8 8c c6 ff ff       	call   801016e0 <ilock>
  if(ip->type != T_DIR){
80105054:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105059:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
8010505c:	75 22                	jne    80105080 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
8010505e:	e8 5d c7 ff ff       	call   801017c0 <iunlock>
  iput(curproc->cwd);
80105063:	8b 46 68             	mov    0x68(%esi),%eax
80105066:	89 04 24             	mov    %eax,(%esp)
80105069:	e8 92 c7 ff ff       	call   80101800 <iput>
  end_op();
8010506e:	e8 3d db ff ff       	call   80102bb0 <end_op>
  curproc->cwd = ip;
  return 0;
80105073:	31 c0                	xor    %eax,%eax
  curproc->cwd = ip;
80105075:	89 5e 68             	mov    %ebx,0x68(%esi)
}
80105078:	83 c4 20             	add    $0x20,%esp
8010507b:	5b                   	pop    %ebx
8010507c:	5e                   	pop    %esi
8010507d:	5d                   	pop    %ebp
8010507e:	c3                   	ret    
8010507f:	90                   	nop
    iunlockput(ip);
80105080:	e8 bb c8 ff ff       	call   80101940 <iunlockput>
    end_op();
80105085:	e8 26 db ff ff       	call   80102bb0 <end_op>
}
8010508a:	83 c4 20             	add    $0x20,%esp
    return -1;
8010508d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105092:	5b                   	pop    %ebx
80105093:	5e                   	pop    %esi
80105094:	5d                   	pop    %ebp
80105095:	c3                   	ret    
80105096:	8d 76 00             	lea    0x0(%esi),%esi
80105099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050a0 <sys_exec>:

int
sys_exec(void)
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	57                   	push   %edi
801050a4:	56                   	push   %esi
801050a5:	53                   	push   %ebx
801050a6:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801050ac:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801050b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801050b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050bd:	e8 5e f5 ff ff       	call   80104620 <argstr>
801050c2:	85 c0                	test   %eax,%eax
801050c4:	0f 88 84 00 00 00    	js     8010514e <sys_exec+0xae>
801050ca:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801050d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801050d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801050db:	e8 b0 f4 ff ff       	call   80104590 <argint>
801050e0:	85 c0                	test   %eax,%eax
801050e2:	78 6a                	js     8010514e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801050e4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801050ea:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801050ec:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801050f3:	00 
801050f4:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801050fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105101:	00 
80105102:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105108:	89 04 24             	mov    %eax,(%esp)
8010510b:	e8 d0 f1 ff ff       	call   801042e0 <memset>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105110:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105116:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010511a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010511d:	89 04 24             	mov    %eax,(%esp)
80105120:	e8 0b f4 ff ff       	call   80104530 <fetchint>
80105125:	85 c0                	test   %eax,%eax
80105127:	78 25                	js     8010514e <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80105129:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010512f:	85 c0                	test   %eax,%eax
80105131:	74 2d                	je     80105160 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105133:	89 74 24 04          	mov    %esi,0x4(%esp)
80105137:	89 04 24             	mov    %eax,(%esp)
8010513a:	e8 11 f4 ff ff       	call   80104550 <fetchstr>
8010513f:	85 c0                	test   %eax,%eax
80105141:	78 0b                	js     8010514e <sys_exec+0xae>
  for(i=0;; i++){
80105143:	83 c3 01             	add    $0x1,%ebx
80105146:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105149:	83 fb 20             	cmp    $0x20,%ebx
8010514c:	75 c2                	jne    80105110 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
8010514e:	81 c4 ac 00 00 00    	add    $0xac,%esp
    return -1;
80105154:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105159:	5b                   	pop    %ebx
8010515a:	5e                   	pop    %esi
8010515b:	5f                   	pop    %edi
8010515c:	5d                   	pop    %ebp
8010515d:	c3                   	ret    
8010515e:	66 90                	xchg   %ax,%ax
  return exec(path, argv);
80105160:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105166:	89 44 24 04          	mov    %eax,0x4(%esp)
8010516a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
      argv[i] = 0;
80105170:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105177:	00 00 00 00 
  return exec(path, argv);
8010517b:	89 04 24             	mov    %eax,(%esp)
8010517e:	e8 1d b8 ff ff       	call   801009a0 <exec>
}
80105183:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105189:	5b                   	pop    %ebx
8010518a:	5e                   	pop    %esi
8010518b:	5f                   	pop    %edi
8010518c:	5d                   	pop    %ebp
8010518d:	c3                   	ret    
8010518e:	66 90                	xchg   %ax,%ax

80105190 <sys_pipe>:

int
sys_pipe(void)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	53                   	push   %ebx
80105194:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105197:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010519a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801051a1:	00 
801051a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801051a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051ad:	e8 1e f4 ff ff       	call   801045d0 <argptr>
801051b2:	85 c0                	test   %eax,%eax
801051b4:	78 6d                	js     80105223 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801051b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801051bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051c0:	89 04 24             	mov    %eax,(%esp)
801051c3:	e8 d8 df ff ff       	call   801031a0 <pipealloc>
801051c8:	85 c0                	test   %eax,%eax
801051ca:	78 57                	js     80105223 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801051cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051cf:	e8 1c f5 ff ff       	call   801046f0 <fdalloc>
801051d4:	85 c0                	test   %eax,%eax
801051d6:	89 c3                	mov    %eax,%ebx
801051d8:	78 33                	js     8010520d <sys_pipe+0x7d>
801051da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051dd:	e8 0e f5 ff ff       	call   801046f0 <fdalloc>
801051e2:	85 c0                	test   %eax,%eax
801051e4:	78 1a                	js     80105200 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801051e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051e9:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
801051eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051ee:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
801051f1:	83 c4 24             	add    $0x24,%esp
  return 0;
801051f4:	31 c0                	xor    %eax,%eax
}
801051f6:	5b                   	pop    %ebx
801051f7:	5d                   	pop    %ebp
801051f8:	c3                   	ret    
801051f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105200:	e8 cb e4 ff ff       	call   801036d0 <myproc>
80105205:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010520c:	00 
    fileclose(rf);
8010520d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105210:	89 04 24             	mov    %eax,(%esp)
80105213:	e8 38 bc ff ff       	call   80100e50 <fileclose>
    fileclose(wf);
80105218:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010521b:	89 04 24             	mov    %eax,(%esp)
8010521e:	e8 2d bc ff ff       	call   80100e50 <fileclose>
}
80105223:	83 c4 24             	add    $0x24,%esp
    return -1;
80105226:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010522b:	5b                   	pop    %ebx
8010522c:	5d                   	pop    %ebp
8010522d:	c3                   	ret    
8010522e:	66 90                	xchg   %ax,%ax

80105230 <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	83 ec 28             	sub    $0x28,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
80105236:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105239:	89 44 24 04          	mov    %eax,0x4(%esp)
8010523d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105244:	e8 47 f3 ff ff       	call   80104590 <argint>
80105249:	85 c0                	test   %eax,%eax
8010524b:	78 33                	js     80105280 <sys_shm_open+0x50>
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
8010524d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105250:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105257:	00 
80105258:	89 44 24 04          	mov    %eax,0x4(%esp)
8010525c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105263:	e8 68 f3 ff ff       	call   801045d0 <argptr>
80105268:	85 c0                	test   %eax,%eax
8010526a:	78 14                	js     80105280 <sys_shm_open+0x50>
    return -1;
  return shm_open(id, pointer);
8010526c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010526f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105273:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105276:	89 04 24             	mov    %eax,(%esp)
80105279:	e8 f2 1c 00 00       	call   80106f70 <shm_open>
}
8010527e:	c9                   	leave  
8010527f:	c3                   	ret    
    return -1;
80105280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105285:	c9                   	leave  
80105286:	c3                   	ret    
80105287:	89 f6                	mov    %esi,%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105290 <sys_shm_close>:

int sys_shm_close(void) {
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	83 ec 28             	sub    $0x28,%esp
  int id;

  if(argint(0, &id) < 0)
80105296:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105299:	89 44 24 04          	mov    %eax,0x4(%esp)
8010529d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052a4:	e8 e7 f2 ff ff       	call   80104590 <argint>
801052a9:	85 c0                	test   %eax,%eax
801052ab:	78 13                	js     801052c0 <sys_shm_close+0x30>
    return -1;

  
  return shm_close(id);
801052ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052b0:	89 04 24             	mov    %eax,(%esp)
801052b3:	e8 c8 1c 00 00       	call   80106f80 <shm_close>
}
801052b8:	c9                   	leave  
801052b9:	c3                   	ret    
801052ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801052c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052c5:	c9                   	leave  
801052c6:	c3                   	ret    
801052c7:	89 f6                	mov    %esi,%esi
801052c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052d0 <sys_fork>:

int
sys_fork(void)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801052d3:	5d                   	pop    %ebp
  return fork();
801052d4:	e9 a7 e5 ff ff       	jmp    80103880 <fork>
801052d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052e0 <sys_exit>:

int
sys_exit(void)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	83 ec 08             	sub    $0x8,%esp
  exit();
801052e6:	e8 e5 e7 ff ff       	call   80103ad0 <exit>
  return 0;  // not reached
}
801052eb:	31 c0                	xor    %eax,%eax
801052ed:	c9                   	leave  
801052ee:	c3                   	ret    
801052ef:	90                   	nop

801052f0 <sys_wait>:

int
sys_wait(void)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801052f3:	5d                   	pop    %ebp
  return wait();
801052f4:	e9 f7 e9 ff ff       	jmp    80103cf0 <wait>
801052f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105300 <sys_kill>:

int
sys_kill(void)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105306:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105309:	89 44 24 04          	mov    %eax,0x4(%esp)
8010530d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105314:	e8 77 f2 ff ff       	call   80104590 <argint>
80105319:	85 c0                	test   %eax,%eax
8010531b:	78 13                	js     80105330 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010531d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105320:	89 04 24             	mov    %eax,(%esp)
80105323:	e8 28 eb ff ff       	call   80103e50 <kill>
}
80105328:	c9                   	leave  
80105329:	c3                   	ret    
8010532a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105335:	c9                   	leave  
80105336:	c3                   	ret    
80105337:	89 f6                	mov    %esi,%esi
80105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105340 <sys_getpid>:

int
sys_getpid(void)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105346:	e8 85 e3 ff ff       	call   801036d0 <myproc>
8010534b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010534e:	c9                   	leave  
8010534f:	c3                   	ret    

80105350 <sys_sbrk>:

int
sys_sbrk(void)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	53                   	push   %ebx
80105354:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105357:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010535a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010535e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105365:	e8 26 f2 ff ff       	call   80104590 <argint>
8010536a:	85 c0                	test   %eax,%eax
8010536c:	78 22                	js     80105390 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010536e:	e8 5d e3 ff ff       	call   801036d0 <myproc>
  if(growproc(n) < 0)
80105373:	8b 55 f4             	mov    -0xc(%ebp),%edx
  addr = myproc()->sz;
80105376:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105378:	89 14 24             	mov    %edx,(%esp)
8010537b:	e8 90 e4 ff ff       	call   80103810 <growproc>
80105380:	85 c0                	test   %eax,%eax
80105382:	78 0c                	js     80105390 <sys_sbrk+0x40>
    return -1;
  return addr;
80105384:	89 d8                	mov    %ebx,%eax
}
80105386:	83 c4 24             	add    $0x24,%esp
80105389:	5b                   	pop    %ebx
8010538a:	5d                   	pop    %ebp
8010538b:	c3                   	ret    
8010538c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105390:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105395:	eb ef                	jmp    80105386 <sys_sbrk+0x36>
80105397:	89 f6                	mov    %esi,%esi
80105399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053a0 <sys_sleep>:

int
sys_sleep(void)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	53                   	push   %ebx
801053a4:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801053a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801053ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053b5:	e8 d6 f1 ff ff       	call   80104590 <argint>
801053ba:	85 c0                	test   %eax,%eax
801053bc:	78 7e                	js     8010543c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
801053be:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
801053c5:	e8 d6 ed ff ff       	call   801041a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801053ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801053cd:	8b 1d a0 56 11 80    	mov    0x801156a0,%ebx
  while(ticks - ticks0 < n){
801053d3:	85 d2                	test   %edx,%edx
801053d5:	75 29                	jne    80105400 <sys_sleep+0x60>
801053d7:	eb 4f                	jmp    80105428 <sys_sleep+0x88>
801053d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801053e0:	c7 44 24 04 60 4e 11 	movl   $0x80114e60,0x4(%esp)
801053e7:	80 
801053e8:	c7 04 24 a0 56 11 80 	movl   $0x801156a0,(%esp)
801053ef:	e8 4c e8 ff ff       	call   80103c40 <sleep>
  while(ticks - ticks0 < n){
801053f4:	a1 a0 56 11 80       	mov    0x801156a0,%eax
801053f9:	29 d8                	sub    %ebx,%eax
801053fb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801053fe:	73 28                	jae    80105428 <sys_sleep+0x88>
    if(myproc()->killed){
80105400:	e8 cb e2 ff ff       	call   801036d0 <myproc>
80105405:	8b 40 24             	mov    0x24(%eax),%eax
80105408:	85 c0                	test   %eax,%eax
8010540a:	74 d4                	je     801053e0 <sys_sleep+0x40>
      release(&tickslock);
8010540c:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
80105413:	e8 78 ee ff ff       	call   80104290 <release>
      return -1;
80105418:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
8010541d:	83 c4 24             	add    $0x24,%esp
80105420:	5b                   	pop    %ebx
80105421:	5d                   	pop    %ebp
80105422:	c3                   	ret    
80105423:	90                   	nop
80105424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
80105428:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
8010542f:	e8 5c ee ff ff       	call   80104290 <release>
}
80105434:	83 c4 24             	add    $0x24,%esp
  return 0;
80105437:	31 c0                	xor    %eax,%eax
}
80105439:	5b                   	pop    %ebx
8010543a:	5d                   	pop    %ebp
8010543b:	c3                   	ret    
    return -1;
8010543c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105441:	eb da                	jmp    8010541d <sys_sleep+0x7d>
80105443:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105450 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	53                   	push   %ebx
80105454:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105457:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
8010545e:	e8 3d ed ff ff       	call   801041a0 <acquire>
  xticks = ticks;
80105463:	8b 1d a0 56 11 80    	mov    0x801156a0,%ebx
  release(&tickslock);
80105469:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
80105470:	e8 1b ee ff ff       	call   80104290 <release>
  return xticks;
}
80105475:	83 c4 14             	add    $0x14,%esp
80105478:	89 d8                	mov    %ebx,%eax
8010547a:	5b                   	pop    %ebx
8010547b:	5d                   	pop    %ebp
8010547c:	c3                   	ret    

8010547d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010547d:	1e                   	push   %ds
  pushl %es
8010547e:	06                   	push   %es
  pushl %fs
8010547f:	0f a0                	push   %fs
  pushl %gs
80105481:	0f a8                	push   %gs
  pushal
80105483:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105484:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105488:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010548a:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010548c:	54                   	push   %esp
  call trap
8010548d:	e8 de 00 00 00       	call   80105570 <trap>
  addl $4, %esp
80105492:	83 c4 04             	add    $0x4,%esp

80105495 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105495:	61                   	popa   
  popl %gs
80105496:	0f a9                	pop    %gs
  popl %fs
80105498:	0f a1                	pop    %fs
  popl %es
8010549a:	07                   	pop    %es
  popl %ds
8010549b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010549c:	83 c4 08             	add    $0x8,%esp
  iret
8010549f:	cf                   	iret   

801054a0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801054a0:	31 c0                	xor    %eax,%eax
801054a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801054a8:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801054af:	b9 08 00 00 00       	mov    $0x8,%ecx
801054b4:	66 89 0c c5 a2 4e 11 	mov    %cx,-0x7feeb15e(,%eax,8)
801054bb:	80 
801054bc:	c6 04 c5 a4 4e 11 80 	movb   $0x0,-0x7feeb15c(,%eax,8)
801054c3:	00 
801054c4:	c6 04 c5 a5 4e 11 80 	movb   $0x8e,-0x7feeb15b(,%eax,8)
801054cb:	8e 
801054cc:	66 89 14 c5 a0 4e 11 	mov    %dx,-0x7feeb160(,%eax,8)
801054d3:	80 
801054d4:	c1 ea 10             	shr    $0x10,%edx
801054d7:	66 89 14 c5 a6 4e 11 	mov    %dx,-0x7feeb15a(,%eax,8)
801054de:	80 
  for(i = 0; i < 256; i++)
801054df:	83 c0 01             	add    $0x1,%eax
801054e2:	3d 00 01 00 00       	cmp    $0x100,%eax
801054e7:	75 bf                	jne    801054a8 <tvinit+0x8>
{
801054e9:	55                   	push   %ebp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801054ea:	ba 08 00 00 00       	mov    $0x8,%edx
{
801054ef:	89 e5                	mov    %esp,%ebp
801054f1:	83 ec 18             	sub    $0x18,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801054f4:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
801054f9:	c7 44 24 04 61 77 10 	movl   $0x80107761,0x4(%esp)
80105500:	80 
80105501:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105508:	66 89 15 a2 50 11 80 	mov    %dx,0x801150a2
8010550f:	66 a3 a0 50 11 80    	mov    %ax,0x801150a0
80105515:	c1 e8 10             	shr    $0x10,%eax
80105518:	c6 05 a4 50 11 80 00 	movb   $0x0,0x801150a4
8010551f:	c6 05 a5 50 11 80 ef 	movb   $0xef,0x801150a5
80105526:	66 a3 a6 50 11 80    	mov    %ax,0x801150a6
  initlock(&tickslock, "time");
8010552c:	e8 7f eb ff ff       	call   801040b0 <initlock>
}
80105531:	c9                   	leave  
80105532:	c3                   	ret    
80105533:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105540 <idtinit>:

void
idtinit(void)
{
80105540:	55                   	push   %ebp
  pd[0] = size-1;
80105541:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105546:	89 e5                	mov    %esp,%ebp
80105548:	83 ec 10             	sub    $0x10,%esp
8010554b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010554f:	b8 a0 4e 11 80       	mov    $0x80114ea0,%eax
80105554:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105558:	c1 e8 10             	shr    $0x10,%eax
8010555b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010555f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105562:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105565:	c9                   	leave  
80105566:	c3                   	ret    
80105567:	89 f6                	mov    %esi,%esi
80105569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105570 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	57                   	push   %edi
80105574:	56                   	push   %esi
80105575:	53                   	push   %ebx
80105576:	83 ec 3c             	sub    $0x3c,%esp
80105579:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010557c:	8b 43 30             	mov    0x30(%ebx),%eax
8010557f:	83 f8 40             	cmp    $0x40,%eax
80105582:	0f 84 20 02 00 00    	je     801057a8 <trap+0x238>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105588:	83 e8 0e             	sub    $0xe,%eax
8010558b:	83 f8 31             	cmp    $0x31,%eax
8010558e:	77 08                	ja     80105598 <trap+0x28>
80105590:	ff 24 85 80 78 10 80 	jmp    *-0x7fef8780(,%eax,4)
80105597:	90                   	nop
    myproc()->stack_pages++;
    cprintf("Increased stack size to %d pages\n", myproc()->stack_pages);
    break;
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105598:	e8 33 e1 ff ff       	call   801036d0 <myproc>
8010559d:	85 c0                	test   %eax,%eax
8010559f:	90                   	nop
801055a0:	0f 84 d8 02 00 00    	je     8010587e <trap+0x30e>
801055a6:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801055aa:	0f 84 ce 02 00 00    	je     8010587e <trap+0x30e>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801055b0:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055b3:	8b 53 38             	mov    0x38(%ebx),%edx
801055b6:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801055b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
801055bc:	e8 ef e0 ff ff       	call   801036b0 <cpuid>
801055c1:	8b 73 30             	mov    0x30(%ebx),%esi
801055c4:	89 c7                	mov    %eax,%edi
801055c6:	8b 43 34             	mov    0x34(%ebx),%eax
801055c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801055cc:	e8 ff e0 ff ff       	call   801036d0 <myproc>
801055d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
801055d4:	e8 f7 e0 ff ff       	call   801036d0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055d9:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801055dc:	89 74 24 0c          	mov    %esi,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
801055e0:	8b 75 e0             	mov    -0x20(%ebp),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
801055e6:	89 7c 24 14          	mov    %edi,0x14(%esp)
801055ea:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
801055ee:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
            myproc()->pid, myproc()->name, tf->trapno,
801055f1:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055f4:	89 54 24 18          	mov    %edx,0x18(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
801055f8:	89 74 24 08          	mov    %esi,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055fc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80105600:	8b 40 10             	mov    0x10(%eax),%eax
80105603:	c7 04 24 3c 78 10 80 	movl   $0x8010783c,(%esp)
8010560a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010560e:	e8 3d b0 ff ff       	call   80100650 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105613:	e8 b8 e0 ff ff       	call   801036d0 <myproc>
80105618:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010561f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105620:	e8 ab e0 ff ff       	call   801036d0 <myproc>
80105625:	85 c0                	test   %eax,%eax
80105627:	74 0c                	je     80105635 <trap+0xc5>
80105629:	e8 a2 e0 ff ff       	call   801036d0 <myproc>
8010562e:	8b 50 24             	mov    0x24(%eax),%edx
80105631:	85 d2                	test   %edx,%edx
80105633:	75 4b                	jne    80105680 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105635:	e8 96 e0 ff ff       	call   801036d0 <myproc>
8010563a:	85 c0                	test   %eax,%eax
8010563c:	74 0d                	je     8010564b <trap+0xdb>
8010563e:	66 90                	xchg   %ax,%ax
80105640:	e8 8b e0 ff ff       	call   801036d0 <myproc>
80105645:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105649:	74 4d                	je     80105698 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010564b:	e8 80 e0 ff ff       	call   801036d0 <myproc>
80105650:	85 c0                	test   %eax,%eax
80105652:	74 1d                	je     80105671 <trap+0x101>
80105654:	e8 77 e0 ff ff       	call   801036d0 <myproc>
80105659:	8b 40 24             	mov    0x24(%eax),%eax
8010565c:	85 c0                	test   %eax,%eax
8010565e:	74 11                	je     80105671 <trap+0x101>
80105660:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105664:	83 e0 03             	and    $0x3,%eax
80105667:	66 83 f8 03          	cmp    $0x3,%ax
8010566b:	0f 84 68 01 00 00    	je     801057d9 <trap+0x269>
    exit();
}
80105671:	83 c4 3c             	add    $0x3c,%esp
80105674:	5b                   	pop    %ebx
80105675:	5e                   	pop    %esi
80105676:	5f                   	pop    %edi
80105677:	5d                   	pop    %ebp
80105678:	c3                   	ret    
80105679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105680:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105684:	83 e0 03             	and    $0x3,%eax
80105687:	66 83 f8 03          	cmp    $0x3,%ax
8010568b:	75 a8                	jne    80105635 <trap+0xc5>
    exit();
8010568d:	e8 3e e4 ff ff       	call   80103ad0 <exit>
80105692:	eb a1                	jmp    80105635 <trap+0xc5>
80105694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105698:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010569c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056a0:	75 a9                	jne    8010564b <trap+0xdb>
    yield();
801056a2:	e8 59 e5 ff ff       	call   80103c00 <yield>
801056a7:	eb a2                	jmp    8010564b <trap+0xdb>
801056a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056b0:	0f 20 d6             	mov    %cr2,%esi
    if (fa >KERNBASE-1){
801056b3:	85 f6                	test   %esi,%esi
801056b5:	0f 88 ad 01 00 00    	js     80105868 <trap+0x2f8>
801056bb:	90                   	nop
801056bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (fa < myproc()->my_sp) {
801056c0:	e8 0b e0 ff ff       	call   801036d0 <myproc>
    fa = PGROUNDDOWN(fa);
801056c5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
      if (allocuvm(myproc()->pgdir, fa - PGSIZE, fa + PGSIZE) == 0) {
801056cb:	8d be 00 f0 ff ff    	lea    -0x1000(%esi),%edi
    if (fa < myproc()->my_sp) {
801056d1:	3b b0 80 00 00 00    	cmp    0x80(%eax),%esi
801056d7:	0f 82 43 01 00 00    	jb     80105820 <trap+0x2b0>
    deallocuvm(myproc()->pgdir, fa, fa - PGSIZE) ;
801056dd:	e8 ee df ff ff       	call   801036d0 <myproc>
801056e2:	89 7c 24 08          	mov    %edi,0x8(%esp)
801056e6:	89 74 24 04          	mov    %esi,0x4(%esp)
801056ea:	8b 40 04             	mov    0x4(%eax),%eax
801056ed:	89 04 24             	mov    %eax,(%esp)
801056f0:	e8 9b 13 00 00       	call   80106a90 <deallocuvm>
    clearpteu(myproc()->pgdir, (char*)(fa - PGSIZE));
801056f5:	e8 d6 df ff ff       	call   801036d0 <myproc>
801056fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
801056fe:	8b 40 04             	mov    0x4(%eax),%eax
80105701:	89 04 24             	mov    %eax,(%esp)
80105704:	e8 d7 14 00 00       	call   80106be0 <clearpteu>
    myproc()->stack_pages++;
80105709:	e8 c2 df ff ff       	call   801036d0 <myproc>
8010570e:	83 40 7c 01          	addl   $0x1,0x7c(%eax)
    cprintf("Increased stack size to %d pages\n", myproc()->stack_pages);
80105712:	e8 b9 df ff ff       	call   801036d0 <myproc>
80105717:	8b 40 7c             	mov    0x7c(%eax),%eax
8010571a:	c7 04 24 e4 77 10 80 	movl   $0x801077e4,(%esp)
80105721:	89 44 24 04          	mov    %eax,0x4(%esp)
80105725:	e8 26 af ff ff       	call   80100650 <cprintf>
    break;
8010572a:	e9 f1 fe ff ff       	jmp    80105620 <trap+0xb0>
8010572f:	90                   	nop
    if(cpuid() == 0){
80105730:	e8 7b df ff ff       	call   801036b0 <cpuid>
80105735:	85 c0                	test   %eax,%eax
80105737:	0f 84 b3 00 00 00    	je     801057f0 <trap+0x280>
8010573d:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
80105740:	e8 6b d0 ff ff       	call   801027b0 <lapiceoi>
    break;
80105745:	e9 d6 fe ff ff       	jmp    80105620 <trap+0xb0>
8010574a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kbdintr();
80105750:	e8 ab ce ff ff       	call   80102600 <kbdintr>
    lapiceoi();
80105755:	e8 56 d0 ff ff       	call   801027b0 <lapiceoi>
    break;
8010575a:	e9 c1 fe ff ff       	jmp    80105620 <trap+0xb0>
8010575f:	90                   	nop
    uartintr();
80105760:	e8 7b 02 00 00       	call   801059e0 <uartintr>
    lapiceoi();
80105765:	e8 46 d0 ff ff       	call   801027b0 <lapiceoi>
    break;
8010576a:	e9 b1 fe ff ff       	jmp    80105620 <trap+0xb0>
8010576f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105770:	8b 7b 38             	mov    0x38(%ebx),%edi
80105773:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105777:	e8 34 df ff ff       	call   801036b0 <cpuid>
8010577c:	c7 04 24 6c 77 10 80 	movl   $0x8010776c,(%esp)
80105783:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105787:	89 74 24 08          	mov    %esi,0x8(%esp)
8010578b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010578f:	e8 bc ae ff ff       	call   80100650 <cprintf>
    lapiceoi();
80105794:	e8 17 d0 ff ff       	call   801027b0 <lapiceoi>
    break;
80105799:	e9 82 fe ff ff       	jmp    80105620 <trap+0xb0>
8010579e:	66 90                	xchg   %ax,%ax
    ideintr();
801057a0:	e8 0b c9 ff ff       	call   801020b0 <ideintr>
801057a5:	eb 96                	jmp    8010573d <trap+0x1cd>
801057a7:	90                   	nop
801057a8:	90                   	nop
801057a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801057b0:	e8 1b df ff ff       	call   801036d0 <myproc>
801057b5:	8b 70 24             	mov    0x24(%eax),%esi
801057b8:	85 f6                	test   %esi,%esi
801057ba:	75 2c                	jne    801057e8 <trap+0x278>
    myproc()->tf = tf;
801057bc:	e8 0f df ff ff       	call   801036d0 <myproc>
801057c1:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801057c4:	e8 b7 ee ff ff       	call   80104680 <syscall>
    if(myproc()->killed)
801057c9:	e8 02 df ff ff       	call   801036d0 <myproc>
801057ce:	8b 48 24             	mov    0x24(%eax),%ecx
801057d1:	85 c9                	test   %ecx,%ecx
801057d3:	0f 84 98 fe ff ff    	je     80105671 <trap+0x101>
}
801057d9:	83 c4 3c             	add    $0x3c,%esp
801057dc:	5b                   	pop    %ebx
801057dd:	5e                   	pop    %esi
801057de:	5f                   	pop    %edi
801057df:	5d                   	pop    %ebp
      exit();
801057e0:	e9 eb e2 ff ff       	jmp    80103ad0 <exit>
801057e5:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
801057e8:	e8 e3 e2 ff ff       	call   80103ad0 <exit>
801057ed:	eb cd                	jmp    801057bc <trap+0x24c>
801057ef:	90                   	nop
      acquire(&tickslock);
801057f0:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
801057f7:	e8 a4 e9 ff ff       	call   801041a0 <acquire>
      wakeup(&ticks);
801057fc:	c7 04 24 a0 56 11 80 	movl   $0x801156a0,(%esp)
      ticks++;
80105803:	83 05 a0 56 11 80 01 	addl   $0x1,0x801156a0
      wakeup(&ticks);
8010580a:	e8 d1 e5 ff ff       	call   80103de0 <wakeup>
      release(&tickslock);
8010580f:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
80105816:	e8 75 ea ff ff       	call   80104290 <release>
8010581b:	e9 1d ff ff ff       	jmp    8010573d <trap+0x1cd>
      if (allocuvm(myproc()->pgdir, fa - PGSIZE, fa + PGSIZE) == 0) {
80105820:	e8 ab de ff ff       	call   801036d0 <myproc>
80105825:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
8010582b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010582f:	89 7c 24 04          	mov    %edi,0x4(%esp)
80105833:	8b 40 04             	mov    0x4(%eax),%eax
80105836:	89 04 24             	mov    %eax,(%esp)
80105839:	e8 52 11 00 00       	call   80106990 <allocuvm>
8010583e:	85 c0                	test   %eax,%eax
80105840:	0f 85 97 fe ff ff    	jne    801056dd <trap+0x16d>
          cprintf("allocuvm failed. Number of stack pages: %d\n", myproc()->stack_pages);
80105846:	e8 85 de ff ff       	call   801036d0 <myproc>
8010584b:	8b 40 7c             	mov    0x7c(%eax),%eax
8010584e:	c7 04 24 b8 77 10 80 	movl   $0x801077b8,(%esp)
80105855:	89 44 24 04          	mov    %eax,0x4(%esp)
80105859:	e8 f2 ad ff ff       	call   80100650 <cprintf>
          exit();
8010585e:	e8 6d e2 ff ff       	call   80103ad0 <exit>
80105863:	e9 75 fe ff ff       	jmp    801056dd <trap+0x16d>
      cprintf("The address is beyond the user space");
80105868:	c7 04 24 90 77 10 80 	movl   $0x80107790,(%esp)
8010586f:	e8 dc ad ff ff       	call   80100650 <cprintf>
      exit();
80105874:	e8 57 e2 ff ff       	call   80103ad0 <exit>
80105879:	e9 3d fe ff ff       	jmp    801056bb <trap+0x14b>
8010587e:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105881:	8b 73 38             	mov    0x38(%ebx),%esi
80105884:	e8 27 de ff ff       	call   801036b0 <cpuid>
80105889:	89 7c 24 10          	mov    %edi,0x10(%esp)
8010588d:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105891:	89 44 24 08          	mov    %eax,0x8(%esp)
80105895:	8b 43 30             	mov    0x30(%ebx),%eax
80105898:	c7 04 24 08 78 10 80 	movl   $0x80107808,(%esp)
8010589f:	89 44 24 04          	mov    %eax,0x4(%esp)
801058a3:	e8 a8 ad ff ff       	call   80100650 <cprintf>
      panic("trap");
801058a8:	c7 04 24 66 77 10 80 	movl   $0x80107766,(%esp)
801058af:	e8 ac aa ff ff       	call   80100360 <panic>
801058b4:	66 90                	xchg   %ax,%ax
801058b6:	66 90                	xchg   %ax,%ax
801058b8:	66 90                	xchg   %ax,%ax
801058ba:	66 90                	xchg   %ax,%ax
801058bc:	66 90                	xchg   %ax,%ax
801058be:	66 90                	xchg   %ax,%ax

801058c0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801058c0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
801058c5:	55                   	push   %ebp
801058c6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801058c8:	85 c0                	test   %eax,%eax
801058ca:	74 14                	je     801058e0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801058cc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801058d1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801058d2:	a8 01                	test   $0x1,%al
801058d4:	74 0a                	je     801058e0 <uartgetc+0x20>
801058d6:	b2 f8                	mov    $0xf8,%dl
801058d8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801058d9:	0f b6 c0             	movzbl %al,%eax
}
801058dc:	5d                   	pop    %ebp
801058dd:	c3                   	ret    
801058de:	66 90                	xchg   %ax,%ax
    return -1;
801058e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058e5:	5d                   	pop    %ebp
801058e6:	c3                   	ret    
801058e7:	89 f6                	mov    %esi,%esi
801058e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058f0 <uartputc>:
  if(!uart)
801058f0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
801058f5:	85 c0                	test   %eax,%eax
801058f7:	74 3f                	je     80105938 <uartputc+0x48>
{
801058f9:	55                   	push   %ebp
801058fa:	89 e5                	mov    %esp,%ebp
801058fc:	56                   	push   %esi
801058fd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105902:	53                   	push   %ebx
  if(!uart)
80105903:	bb 80 00 00 00       	mov    $0x80,%ebx
{
80105908:	83 ec 10             	sub    $0x10,%esp
8010590b:	eb 14                	jmp    80105921 <uartputc+0x31>
8010590d:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105910:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105917:	e8 b4 ce ff ff       	call   801027d0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010591c:	83 eb 01             	sub    $0x1,%ebx
8010591f:	74 07                	je     80105928 <uartputc+0x38>
80105921:	89 f2                	mov    %esi,%edx
80105923:	ec                   	in     (%dx),%al
80105924:	a8 20                	test   $0x20,%al
80105926:	74 e8                	je     80105910 <uartputc+0x20>
  outb(COM1+0, c);
80105928:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010592c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105931:	ee                   	out    %al,(%dx)
}
80105932:	83 c4 10             	add    $0x10,%esp
80105935:	5b                   	pop    %ebx
80105936:	5e                   	pop    %esi
80105937:	5d                   	pop    %ebp
80105938:	f3 c3                	repz ret 
8010593a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105940 <uartinit>:
{
80105940:	55                   	push   %ebp
80105941:	31 c9                	xor    %ecx,%ecx
80105943:	89 e5                	mov    %esp,%ebp
80105945:	89 c8                	mov    %ecx,%eax
80105947:	57                   	push   %edi
80105948:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010594d:	56                   	push   %esi
8010594e:	89 fa                	mov    %edi,%edx
80105950:	53                   	push   %ebx
80105951:	83 ec 1c             	sub    $0x1c,%esp
80105954:	ee                   	out    %al,(%dx)
80105955:	be fb 03 00 00       	mov    $0x3fb,%esi
8010595a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010595f:	89 f2                	mov    %esi,%edx
80105961:	ee                   	out    %al,(%dx)
80105962:	b8 0c 00 00 00       	mov    $0xc,%eax
80105967:	b2 f8                	mov    $0xf8,%dl
80105969:	ee                   	out    %al,(%dx)
8010596a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
8010596f:	89 c8                	mov    %ecx,%eax
80105971:	89 da                	mov    %ebx,%edx
80105973:	ee                   	out    %al,(%dx)
80105974:	b8 03 00 00 00       	mov    $0x3,%eax
80105979:	89 f2                	mov    %esi,%edx
8010597b:	ee                   	out    %al,(%dx)
8010597c:	b2 fc                	mov    $0xfc,%dl
8010597e:	89 c8                	mov    %ecx,%eax
80105980:	ee                   	out    %al,(%dx)
80105981:	b8 01 00 00 00       	mov    $0x1,%eax
80105986:	89 da                	mov    %ebx,%edx
80105988:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105989:	b2 fd                	mov    $0xfd,%dl
8010598b:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
8010598c:	3c ff                	cmp    $0xff,%al
8010598e:	74 42                	je     801059d2 <uartinit+0x92>
  uart = 1;
80105990:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105997:	00 00 00 
8010599a:	89 fa                	mov    %edi,%edx
8010599c:	ec                   	in     (%dx),%al
8010599d:	b2 f8                	mov    $0xf8,%dl
8010599f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801059a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801059a7:	00 
  for(p="xv6...\n"; *p; p++)
801059a8:	bb 48 79 10 80       	mov    $0x80107948,%ebx
  ioapicenable(IRQ_COM1, 0);
801059ad:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801059b4:	e8 27 c9 ff ff       	call   801022e0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801059b9:	b8 78 00 00 00       	mov    $0x78,%eax
801059be:	66 90                	xchg   %ax,%ax
    uartputc(*p);
801059c0:	89 04 24             	mov    %eax,(%esp)
  for(p="xv6...\n"; *p; p++)
801059c3:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
801059c6:	e8 25 ff ff ff       	call   801058f0 <uartputc>
  for(p="xv6...\n"; *p; p++)
801059cb:	0f be 03             	movsbl (%ebx),%eax
801059ce:	84 c0                	test   %al,%al
801059d0:	75 ee                	jne    801059c0 <uartinit+0x80>
}
801059d2:	83 c4 1c             	add    $0x1c,%esp
801059d5:	5b                   	pop    %ebx
801059d6:	5e                   	pop    %esi
801059d7:	5f                   	pop    %edi
801059d8:	5d                   	pop    %ebp
801059d9:	c3                   	ret    
801059da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801059e0 <uartintr>:

void
uartintr(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801059e6:	c7 04 24 c0 58 10 80 	movl   $0x801058c0,(%esp)
801059ed:	e8 be ad ff ff       	call   801007b0 <consoleintr>
}
801059f2:	c9                   	leave  
801059f3:	c3                   	ret    

801059f4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801059f4:	6a 00                	push   $0x0
  pushl $0
801059f6:	6a 00                	push   $0x0
  jmp alltraps
801059f8:	e9 80 fa ff ff       	jmp    8010547d <alltraps>

801059fd <vector1>:
.globl vector1
vector1:
  pushl $0
801059fd:	6a 00                	push   $0x0
  pushl $1
801059ff:	6a 01                	push   $0x1
  jmp alltraps
80105a01:	e9 77 fa ff ff       	jmp    8010547d <alltraps>

80105a06 <vector2>:
.globl vector2
vector2:
  pushl $0
80105a06:	6a 00                	push   $0x0
  pushl $2
80105a08:	6a 02                	push   $0x2
  jmp alltraps
80105a0a:	e9 6e fa ff ff       	jmp    8010547d <alltraps>

80105a0f <vector3>:
.globl vector3
vector3:
  pushl $0
80105a0f:	6a 00                	push   $0x0
  pushl $3
80105a11:	6a 03                	push   $0x3
  jmp alltraps
80105a13:	e9 65 fa ff ff       	jmp    8010547d <alltraps>

80105a18 <vector4>:
.globl vector4
vector4:
  pushl $0
80105a18:	6a 00                	push   $0x0
  pushl $4
80105a1a:	6a 04                	push   $0x4
  jmp alltraps
80105a1c:	e9 5c fa ff ff       	jmp    8010547d <alltraps>

80105a21 <vector5>:
.globl vector5
vector5:
  pushl $0
80105a21:	6a 00                	push   $0x0
  pushl $5
80105a23:	6a 05                	push   $0x5
  jmp alltraps
80105a25:	e9 53 fa ff ff       	jmp    8010547d <alltraps>

80105a2a <vector6>:
.globl vector6
vector6:
  pushl $0
80105a2a:	6a 00                	push   $0x0
  pushl $6
80105a2c:	6a 06                	push   $0x6
  jmp alltraps
80105a2e:	e9 4a fa ff ff       	jmp    8010547d <alltraps>

80105a33 <vector7>:
.globl vector7
vector7:
  pushl $0
80105a33:	6a 00                	push   $0x0
  pushl $7
80105a35:	6a 07                	push   $0x7
  jmp alltraps
80105a37:	e9 41 fa ff ff       	jmp    8010547d <alltraps>

80105a3c <vector8>:
.globl vector8
vector8:
  pushl $8
80105a3c:	6a 08                	push   $0x8
  jmp alltraps
80105a3e:	e9 3a fa ff ff       	jmp    8010547d <alltraps>

80105a43 <vector9>:
.globl vector9
vector9:
  pushl $0
80105a43:	6a 00                	push   $0x0
  pushl $9
80105a45:	6a 09                	push   $0x9
  jmp alltraps
80105a47:	e9 31 fa ff ff       	jmp    8010547d <alltraps>

80105a4c <vector10>:
.globl vector10
vector10:
  pushl $10
80105a4c:	6a 0a                	push   $0xa
  jmp alltraps
80105a4e:	e9 2a fa ff ff       	jmp    8010547d <alltraps>

80105a53 <vector11>:
.globl vector11
vector11:
  pushl $11
80105a53:	6a 0b                	push   $0xb
  jmp alltraps
80105a55:	e9 23 fa ff ff       	jmp    8010547d <alltraps>

80105a5a <vector12>:
.globl vector12
vector12:
  pushl $12
80105a5a:	6a 0c                	push   $0xc
  jmp alltraps
80105a5c:	e9 1c fa ff ff       	jmp    8010547d <alltraps>

80105a61 <vector13>:
.globl vector13
vector13:
  pushl $13
80105a61:	6a 0d                	push   $0xd
  jmp alltraps
80105a63:	e9 15 fa ff ff       	jmp    8010547d <alltraps>

80105a68 <vector14>:
.globl vector14
vector14:
  pushl $14
80105a68:	6a 0e                	push   $0xe
  jmp alltraps
80105a6a:	e9 0e fa ff ff       	jmp    8010547d <alltraps>

80105a6f <vector15>:
.globl vector15
vector15:
  pushl $0
80105a6f:	6a 00                	push   $0x0
  pushl $15
80105a71:	6a 0f                	push   $0xf
  jmp alltraps
80105a73:	e9 05 fa ff ff       	jmp    8010547d <alltraps>

80105a78 <vector16>:
.globl vector16
vector16:
  pushl $0
80105a78:	6a 00                	push   $0x0
  pushl $16
80105a7a:	6a 10                	push   $0x10
  jmp alltraps
80105a7c:	e9 fc f9 ff ff       	jmp    8010547d <alltraps>

80105a81 <vector17>:
.globl vector17
vector17:
  pushl $17
80105a81:	6a 11                	push   $0x11
  jmp alltraps
80105a83:	e9 f5 f9 ff ff       	jmp    8010547d <alltraps>

80105a88 <vector18>:
.globl vector18
vector18:
  pushl $0
80105a88:	6a 00                	push   $0x0
  pushl $18
80105a8a:	6a 12                	push   $0x12
  jmp alltraps
80105a8c:	e9 ec f9 ff ff       	jmp    8010547d <alltraps>

80105a91 <vector19>:
.globl vector19
vector19:
  pushl $0
80105a91:	6a 00                	push   $0x0
  pushl $19
80105a93:	6a 13                	push   $0x13
  jmp alltraps
80105a95:	e9 e3 f9 ff ff       	jmp    8010547d <alltraps>

80105a9a <vector20>:
.globl vector20
vector20:
  pushl $0
80105a9a:	6a 00                	push   $0x0
  pushl $20
80105a9c:	6a 14                	push   $0x14
  jmp alltraps
80105a9e:	e9 da f9 ff ff       	jmp    8010547d <alltraps>

80105aa3 <vector21>:
.globl vector21
vector21:
  pushl $0
80105aa3:	6a 00                	push   $0x0
  pushl $21
80105aa5:	6a 15                	push   $0x15
  jmp alltraps
80105aa7:	e9 d1 f9 ff ff       	jmp    8010547d <alltraps>

80105aac <vector22>:
.globl vector22
vector22:
  pushl $0
80105aac:	6a 00                	push   $0x0
  pushl $22
80105aae:	6a 16                	push   $0x16
  jmp alltraps
80105ab0:	e9 c8 f9 ff ff       	jmp    8010547d <alltraps>

80105ab5 <vector23>:
.globl vector23
vector23:
  pushl $0
80105ab5:	6a 00                	push   $0x0
  pushl $23
80105ab7:	6a 17                	push   $0x17
  jmp alltraps
80105ab9:	e9 bf f9 ff ff       	jmp    8010547d <alltraps>

80105abe <vector24>:
.globl vector24
vector24:
  pushl $0
80105abe:	6a 00                	push   $0x0
  pushl $24
80105ac0:	6a 18                	push   $0x18
  jmp alltraps
80105ac2:	e9 b6 f9 ff ff       	jmp    8010547d <alltraps>

80105ac7 <vector25>:
.globl vector25
vector25:
  pushl $0
80105ac7:	6a 00                	push   $0x0
  pushl $25
80105ac9:	6a 19                	push   $0x19
  jmp alltraps
80105acb:	e9 ad f9 ff ff       	jmp    8010547d <alltraps>

80105ad0 <vector26>:
.globl vector26
vector26:
  pushl $0
80105ad0:	6a 00                	push   $0x0
  pushl $26
80105ad2:	6a 1a                	push   $0x1a
  jmp alltraps
80105ad4:	e9 a4 f9 ff ff       	jmp    8010547d <alltraps>

80105ad9 <vector27>:
.globl vector27
vector27:
  pushl $0
80105ad9:	6a 00                	push   $0x0
  pushl $27
80105adb:	6a 1b                	push   $0x1b
  jmp alltraps
80105add:	e9 9b f9 ff ff       	jmp    8010547d <alltraps>

80105ae2 <vector28>:
.globl vector28
vector28:
  pushl $0
80105ae2:	6a 00                	push   $0x0
  pushl $28
80105ae4:	6a 1c                	push   $0x1c
  jmp alltraps
80105ae6:	e9 92 f9 ff ff       	jmp    8010547d <alltraps>

80105aeb <vector29>:
.globl vector29
vector29:
  pushl $0
80105aeb:	6a 00                	push   $0x0
  pushl $29
80105aed:	6a 1d                	push   $0x1d
  jmp alltraps
80105aef:	e9 89 f9 ff ff       	jmp    8010547d <alltraps>

80105af4 <vector30>:
.globl vector30
vector30:
  pushl $0
80105af4:	6a 00                	push   $0x0
  pushl $30
80105af6:	6a 1e                	push   $0x1e
  jmp alltraps
80105af8:	e9 80 f9 ff ff       	jmp    8010547d <alltraps>

80105afd <vector31>:
.globl vector31
vector31:
  pushl $0
80105afd:	6a 00                	push   $0x0
  pushl $31
80105aff:	6a 1f                	push   $0x1f
  jmp alltraps
80105b01:	e9 77 f9 ff ff       	jmp    8010547d <alltraps>

80105b06 <vector32>:
.globl vector32
vector32:
  pushl $0
80105b06:	6a 00                	push   $0x0
  pushl $32
80105b08:	6a 20                	push   $0x20
  jmp alltraps
80105b0a:	e9 6e f9 ff ff       	jmp    8010547d <alltraps>

80105b0f <vector33>:
.globl vector33
vector33:
  pushl $0
80105b0f:	6a 00                	push   $0x0
  pushl $33
80105b11:	6a 21                	push   $0x21
  jmp alltraps
80105b13:	e9 65 f9 ff ff       	jmp    8010547d <alltraps>

80105b18 <vector34>:
.globl vector34
vector34:
  pushl $0
80105b18:	6a 00                	push   $0x0
  pushl $34
80105b1a:	6a 22                	push   $0x22
  jmp alltraps
80105b1c:	e9 5c f9 ff ff       	jmp    8010547d <alltraps>

80105b21 <vector35>:
.globl vector35
vector35:
  pushl $0
80105b21:	6a 00                	push   $0x0
  pushl $35
80105b23:	6a 23                	push   $0x23
  jmp alltraps
80105b25:	e9 53 f9 ff ff       	jmp    8010547d <alltraps>

80105b2a <vector36>:
.globl vector36
vector36:
  pushl $0
80105b2a:	6a 00                	push   $0x0
  pushl $36
80105b2c:	6a 24                	push   $0x24
  jmp alltraps
80105b2e:	e9 4a f9 ff ff       	jmp    8010547d <alltraps>

80105b33 <vector37>:
.globl vector37
vector37:
  pushl $0
80105b33:	6a 00                	push   $0x0
  pushl $37
80105b35:	6a 25                	push   $0x25
  jmp alltraps
80105b37:	e9 41 f9 ff ff       	jmp    8010547d <alltraps>

80105b3c <vector38>:
.globl vector38
vector38:
  pushl $0
80105b3c:	6a 00                	push   $0x0
  pushl $38
80105b3e:	6a 26                	push   $0x26
  jmp alltraps
80105b40:	e9 38 f9 ff ff       	jmp    8010547d <alltraps>

80105b45 <vector39>:
.globl vector39
vector39:
  pushl $0
80105b45:	6a 00                	push   $0x0
  pushl $39
80105b47:	6a 27                	push   $0x27
  jmp alltraps
80105b49:	e9 2f f9 ff ff       	jmp    8010547d <alltraps>

80105b4e <vector40>:
.globl vector40
vector40:
  pushl $0
80105b4e:	6a 00                	push   $0x0
  pushl $40
80105b50:	6a 28                	push   $0x28
  jmp alltraps
80105b52:	e9 26 f9 ff ff       	jmp    8010547d <alltraps>

80105b57 <vector41>:
.globl vector41
vector41:
  pushl $0
80105b57:	6a 00                	push   $0x0
  pushl $41
80105b59:	6a 29                	push   $0x29
  jmp alltraps
80105b5b:	e9 1d f9 ff ff       	jmp    8010547d <alltraps>

80105b60 <vector42>:
.globl vector42
vector42:
  pushl $0
80105b60:	6a 00                	push   $0x0
  pushl $42
80105b62:	6a 2a                	push   $0x2a
  jmp alltraps
80105b64:	e9 14 f9 ff ff       	jmp    8010547d <alltraps>

80105b69 <vector43>:
.globl vector43
vector43:
  pushl $0
80105b69:	6a 00                	push   $0x0
  pushl $43
80105b6b:	6a 2b                	push   $0x2b
  jmp alltraps
80105b6d:	e9 0b f9 ff ff       	jmp    8010547d <alltraps>

80105b72 <vector44>:
.globl vector44
vector44:
  pushl $0
80105b72:	6a 00                	push   $0x0
  pushl $44
80105b74:	6a 2c                	push   $0x2c
  jmp alltraps
80105b76:	e9 02 f9 ff ff       	jmp    8010547d <alltraps>

80105b7b <vector45>:
.globl vector45
vector45:
  pushl $0
80105b7b:	6a 00                	push   $0x0
  pushl $45
80105b7d:	6a 2d                	push   $0x2d
  jmp alltraps
80105b7f:	e9 f9 f8 ff ff       	jmp    8010547d <alltraps>

80105b84 <vector46>:
.globl vector46
vector46:
  pushl $0
80105b84:	6a 00                	push   $0x0
  pushl $46
80105b86:	6a 2e                	push   $0x2e
  jmp alltraps
80105b88:	e9 f0 f8 ff ff       	jmp    8010547d <alltraps>

80105b8d <vector47>:
.globl vector47
vector47:
  pushl $0
80105b8d:	6a 00                	push   $0x0
  pushl $47
80105b8f:	6a 2f                	push   $0x2f
  jmp alltraps
80105b91:	e9 e7 f8 ff ff       	jmp    8010547d <alltraps>

80105b96 <vector48>:
.globl vector48
vector48:
  pushl $0
80105b96:	6a 00                	push   $0x0
  pushl $48
80105b98:	6a 30                	push   $0x30
  jmp alltraps
80105b9a:	e9 de f8 ff ff       	jmp    8010547d <alltraps>

80105b9f <vector49>:
.globl vector49
vector49:
  pushl $0
80105b9f:	6a 00                	push   $0x0
  pushl $49
80105ba1:	6a 31                	push   $0x31
  jmp alltraps
80105ba3:	e9 d5 f8 ff ff       	jmp    8010547d <alltraps>

80105ba8 <vector50>:
.globl vector50
vector50:
  pushl $0
80105ba8:	6a 00                	push   $0x0
  pushl $50
80105baa:	6a 32                	push   $0x32
  jmp alltraps
80105bac:	e9 cc f8 ff ff       	jmp    8010547d <alltraps>

80105bb1 <vector51>:
.globl vector51
vector51:
  pushl $0
80105bb1:	6a 00                	push   $0x0
  pushl $51
80105bb3:	6a 33                	push   $0x33
  jmp alltraps
80105bb5:	e9 c3 f8 ff ff       	jmp    8010547d <alltraps>

80105bba <vector52>:
.globl vector52
vector52:
  pushl $0
80105bba:	6a 00                	push   $0x0
  pushl $52
80105bbc:	6a 34                	push   $0x34
  jmp alltraps
80105bbe:	e9 ba f8 ff ff       	jmp    8010547d <alltraps>

80105bc3 <vector53>:
.globl vector53
vector53:
  pushl $0
80105bc3:	6a 00                	push   $0x0
  pushl $53
80105bc5:	6a 35                	push   $0x35
  jmp alltraps
80105bc7:	e9 b1 f8 ff ff       	jmp    8010547d <alltraps>

80105bcc <vector54>:
.globl vector54
vector54:
  pushl $0
80105bcc:	6a 00                	push   $0x0
  pushl $54
80105bce:	6a 36                	push   $0x36
  jmp alltraps
80105bd0:	e9 a8 f8 ff ff       	jmp    8010547d <alltraps>

80105bd5 <vector55>:
.globl vector55
vector55:
  pushl $0
80105bd5:	6a 00                	push   $0x0
  pushl $55
80105bd7:	6a 37                	push   $0x37
  jmp alltraps
80105bd9:	e9 9f f8 ff ff       	jmp    8010547d <alltraps>

80105bde <vector56>:
.globl vector56
vector56:
  pushl $0
80105bde:	6a 00                	push   $0x0
  pushl $56
80105be0:	6a 38                	push   $0x38
  jmp alltraps
80105be2:	e9 96 f8 ff ff       	jmp    8010547d <alltraps>

80105be7 <vector57>:
.globl vector57
vector57:
  pushl $0
80105be7:	6a 00                	push   $0x0
  pushl $57
80105be9:	6a 39                	push   $0x39
  jmp alltraps
80105beb:	e9 8d f8 ff ff       	jmp    8010547d <alltraps>

80105bf0 <vector58>:
.globl vector58
vector58:
  pushl $0
80105bf0:	6a 00                	push   $0x0
  pushl $58
80105bf2:	6a 3a                	push   $0x3a
  jmp alltraps
80105bf4:	e9 84 f8 ff ff       	jmp    8010547d <alltraps>

80105bf9 <vector59>:
.globl vector59
vector59:
  pushl $0
80105bf9:	6a 00                	push   $0x0
  pushl $59
80105bfb:	6a 3b                	push   $0x3b
  jmp alltraps
80105bfd:	e9 7b f8 ff ff       	jmp    8010547d <alltraps>

80105c02 <vector60>:
.globl vector60
vector60:
  pushl $0
80105c02:	6a 00                	push   $0x0
  pushl $60
80105c04:	6a 3c                	push   $0x3c
  jmp alltraps
80105c06:	e9 72 f8 ff ff       	jmp    8010547d <alltraps>

80105c0b <vector61>:
.globl vector61
vector61:
  pushl $0
80105c0b:	6a 00                	push   $0x0
  pushl $61
80105c0d:	6a 3d                	push   $0x3d
  jmp alltraps
80105c0f:	e9 69 f8 ff ff       	jmp    8010547d <alltraps>

80105c14 <vector62>:
.globl vector62
vector62:
  pushl $0
80105c14:	6a 00                	push   $0x0
  pushl $62
80105c16:	6a 3e                	push   $0x3e
  jmp alltraps
80105c18:	e9 60 f8 ff ff       	jmp    8010547d <alltraps>

80105c1d <vector63>:
.globl vector63
vector63:
  pushl $0
80105c1d:	6a 00                	push   $0x0
  pushl $63
80105c1f:	6a 3f                	push   $0x3f
  jmp alltraps
80105c21:	e9 57 f8 ff ff       	jmp    8010547d <alltraps>

80105c26 <vector64>:
.globl vector64
vector64:
  pushl $0
80105c26:	6a 00                	push   $0x0
  pushl $64
80105c28:	6a 40                	push   $0x40
  jmp alltraps
80105c2a:	e9 4e f8 ff ff       	jmp    8010547d <alltraps>

80105c2f <vector65>:
.globl vector65
vector65:
  pushl $0
80105c2f:	6a 00                	push   $0x0
  pushl $65
80105c31:	6a 41                	push   $0x41
  jmp alltraps
80105c33:	e9 45 f8 ff ff       	jmp    8010547d <alltraps>

80105c38 <vector66>:
.globl vector66
vector66:
  pushl $0
80105c38:	6a 00                	push   $0x0
  pushl $66
80105c3a:	6a 42                	push   $0x42
  jmp alltraps
80105c3c:	e9 3c f8 ff ff       	jmp    8010547d <alltraps>

80105c41 <vector67>:
.globl vector67
vector67:
  pushl $0
80105c41:	6a 00                	push   $0x0
  pushl $67
80105c43:	6a 43                	push   $0x43
  jmp alltraps
80105c45:	e9 33 f8 ff ff       	jmp    8010547d <alltraps>

80105c4a <vector68>:
.globl vector68
vector68:
  pushl $0
80105c4a:	6a 00                	push   $0x0
  pushl $68
80105c4c:	6a 44                	push   $0x44
  jmp alltraps
80105c4e:	e9 2a f8 ff ff       	jmp    8010547d <alltraps>

80105c53 <vector69>:
.globl vector69
vector69:
  pushl $0
80105c53:	6a 00                	push   $0x0
  pushl $69
80105c55:	6a 45                	push   $0x45
  jmp alltraps
80105c57:	e9 21 f8 ff ff       	jmp    8010547d <alltraps>

80105c5c <vector70>:
.globl vector70
vector70:
  pushl $0
80105c5c:	6a 00                	push   $0x0
  pushl $70
80105c5e:	6a 46                	push   $0x46
  jmp alltraps
80105c60:	e9 18 f8 ff ff       	jmp    8010547d <alltraps>

80105c65 <vector71>:
.globl vector71
vector71:
  pushl $0
80105c65:	6a 00                	push   $0x0
  pushl $71
80105c67:	6a 47                	push   $0x47
  jmp alltraps
80105c69:	e9 0f f8 ff ff       	jmp    8010547d <alltraps>

80105c6e <vector72>:
.globl vector72
vector72:
  pushl $0
80105c6e:	6a 00                	push   $0x0
  pushl $72
80105c70:	6a 48                	push   $0x48
  jmp alltraps
80105c72:	e9 06 f8 ff ff       	jmp    8010547d <alltraps>

80105c77 <vector73>:
.globl vector73
vector73:
  pushl $0
80105c77:	6a 00                	push   $0x0
  pushl $73
80105c79:	6a 49                	push   $0x49
  jmp alltraps
80105c7b:	e9 fd f7 ff ff       	jmp    8010547d <alltraps>

80105c80 <vector74>:
.globl vector74
vector74:
  pushl $0
80105c80:	6a 00                	push   $0x0
  pushl $74
80105c82:	6a 4a                	push   $0x4a
  jmp alltraps
80105c84:	e9 f4 f7 ff ff       	jmp    8010547d <alltraps>

80105c89 <vector75>:
.globl vector75
vector75:
  pushl $0
80105c89:	6a 00                	push   $0x0
  pushl $75
80105c8b:	6a 4b                	push   $0x4b
  jmp alltraps
80105c8d:	e9 eb f7 ff ff       	jmp    8010547d <alltraps>

80105c92 <vector76>:
.globl vector76
vector76:
  pushl $0
80105c92:	6a 00                	push   $0x0
  pushl $76
80105c94:	6a 4c                	push   $0x4c
  jmp alltraps
80105c96:	e9 e2 f7 ff ff       	jmp    8010547d <alltraps>

80105c9b <vector77>:
.globl vector77
vector77:
  pushl $0
80105c9b:	6a 00                	push   $0x0
  pushl $77
80105c9d:	6a 4d                	push   $0x4d
  jmp alltraps
80105c9f:	e9 d9 f7 ff ff       	jmp    8010547d <alltraps>

80105ca4 <vector78>:
.globl vector78
vector78:
  pushl $0
80105ca4:	6a 00                	push   $0x0
  pushl $78
80105ca6:	6a 4e                	push   $0x4e
  jmp alltraps
80105ca8:	e9 d0 f7 ff ff       	jmp    8010547d <alltraps>

80105cad <vector79>:
.globl vector79
vector79:
  pushl $0
80105cad:	6a 00                	push   $0x0
  pushl $79
80105caf:	6a 4f                	push   $0x4f
  jmp alltraps
80105cb1:	e9 c7 f7 ff ff       	jmp    8010547d <alltraps>

80105cb6 <vector80>:
.globl vector80
vector80:
  pushl $0
80105cb6:	6a 00                	push   $0x0
  pushl $80
80105cb8:	6a 50                	push   $0x50
  jmp alltraps
80105cba:	e9 be f7 ff ff       	jmp    8010547d <alltraps>

80105cbf <vector81>:
.globl vector81
vector81:
  pushl $0
80105cbf:	6a 00                	push   $0x0
  pushl $81
80105cc1:	6a 51                	push   $0x51
  jmp alltraps
80105cc3:	e9 b5 f7 ff ff       	jmp    8010547d <alltraps>

80105cc8 <vector82>:
.globl vector82
vector82:
  pushl $0
80105cc8:	6a 00                	push   $0x0
  pushl $82
80105cca:	6a 52                	push   $0x52
  jmp alltraps
80105ccc:	e9 ac f7 ff ff       	jmp    8010547d <alltraps>

80105cd1 <vector83>:
.globl vector83
vector83:
  pushl $0
80105cd1:	6a 00                	push   $0x0
  pushl $83
80105cd3:	6a 53                	push   $0x53
  jmp alltraps
80105cd5:	e9 a3 f7 ff ff       	jmp    8010547d <alltraps>

80105cda <vector84>:
.globl vector84
vector84:
  pushl $0
80105cda:	6a 00                	push   $0x0
  pushl $84
80105cdc:	6a 54                	push   $0x54
  jmp alltraps
80105cde:	e9 9a f7 ff ff       	jmp    8010547d <alltraps>

80105ce3 <vector85>:
.globl vector85
vector85:
  pushl $0
80105ce3:	6a 00                	push   $0x0
  pushl $85
80105ce5:	6a 55                	push   $0x55
  jmp alltraps
80105ce7:	e9 91 f7 ff ff       	jmp    8010547d <alltraps>

80105cec <vector86>:
.globl vector86
vector86:
  pushl $0
80105cec:	6a 00                	push   $0x0
  pushl $86
80105cee:	6a 56                	push   $0x56
  jmp alltraps
80105cf0:	e9 88 f7 ff ff       	jmp    8010547d <alltraps>

80105cf5 <vector87>:
.globl vector87
vector87:
  pushl $0
80105cf5:	6a 00                	push   $0x0
  pushl $87
80105cf7:	6a 57                	push   $0x57
  jmp alltraps
80105cf9:	e9 7f f7 ff ff       	jmp    8010547d <alltraps>

80105cfe <vector88>:
.globl vector88
vector88:
  pushl $0
80105cfe:	6a 00                	push   $0x0
  pushl $88
80105d00:	6a 58                	push   $0x58
  jmp alltraps
80105d02:	e9 76 f7 ff ff       	jmp    8010547d <alltraps>

80105d07 <vector89>:
.globl vector89
vector89:
  pushl $0
80105d07:	6a 00                	push   $0x0
  pushl $89
80105d09:	6a 59                	push   $0x59
  jmp alltraps
80105d0b:	e9 6d f7 ff ff       	jmp    8010547d <alltraps>

80105d10 <vector90>:
.globl vector90
vector90:
  pushl $0
80105d10:	6a 00                	push   $0x0
  pushl $90
80105d12:	6a 5a                	push   $0x5a
  jmp alltraps
80105d14:	e9 64 f7 ff ff       	jmp    8010547d <alltraps>

80105d19 <vector91>:
.globl vector91
vector91:
  pushl $0
80105d19:	6a 00                	push   $0x0
  pushl $91
80105d1b:	6a 5b                	push   $0x5b
  jmp alltraps
80105d1d:	e9 5b f7 ff ff       	jmp    8010547d <alltraps>

80105d22 <vector92>:
.globl vector92
vector92:
  pushl $0
80105d22:	6a 00                	push   $0x0
  pushl $92
80105d24:	6a 5c                	push   $0x5c
  jmp alltraps
80105d26:	e9 52 f7 ff ff       	jmp    8010547d <alltraps>

80105d2b <vector93>:
.globl vector93
vector93:
  pushl $0
80105d2b:	6a 00                	push   $0x0
  pushl $93
80105d2d:	6a 5d                	push   $0x5d
  jmp alltraps
80105d2f:	e9 49 f7 ff ff       	jmp    8010547d <alltraps>

80105d34 <vector94>:
.globl vector94
vector94:
  pushl $0
80105d34:	6a 00                	push   $0x0
  pushl $94
80105d36:	6a 5e                	push   $0x5e
  jmp alltraps
80105d38:	e9 40 f7 ff ff       	jmp    8010547d <alltraps>

80105d3d <vector95>:
.globl vector95
vector95:
  pushl $0
80105d3d:	6a 00                	push   $0x0
  pushl $95
80105d3f:	6a 5f                	push   $0x5f
  jmp alltraps
80105d41:	e9 37 f7 ff ff       	jmp    8010547d <alltraps>

80105d46 <vector96>:
.globl vector96
vector96:
  pushl $0
80105d46:	6a 00                	push   $0x0
  pushl $96
80105d48:	6a 60                	push   $0x60
  jmp alltraps
80105d4a:	e9 2e f7 ff ff       	jmp    8010547d <alltraps>

80105d4f <vector97>:
.globl vector97
vector97:
  pushl $0
80105d4f:	6a 00                	push   $0x0
  pushl $97
80105d51:	6a 61                	push   $0x61
  jmp alltraps
80105d53:	e9 25 f7 ff ff       	jmp    8010547d <alltraps>

80105d58 <vector98>:
.globl vector98
vector98:
  pushl $0
80105d58:	6a 00                	push   $0x0
  pushl $98
80105d5a:	6a 62                	push   $0x62
  jmp alltraps
80105d5c:	e9 1c f7 ff ff       	jmp    8010547d <alltraps>

80105d61 <vector99>:
.globl vector99
vector99:
  pushl $0
80105d61:	6a 00                	push   $0x0
  pushl $99
80105d63:	6a 63                	push   $0x63
  jmp alltraps
80105d65:	e9 13 f7 ff ff       	jmp    8010547d <alltraps>

80105d6a <vector100>:
.globl vector100
vector100:
  pushl $0
80105d6a:	6a 00                	push   $0x0
  pushl $100
80105d6c:	6a 64                	push   $0x64
  jmp alltraps
80105d6e:	e9 0a f7 ff ff       	jmp    8010547d <alltraps>

80105d73 <vector101>:
.globl vector101
vector101:
  pushl $0
80105d73:	6a 00                	push   $0x0
  pushl $101
80105d75:	6a 65                	push   $0x65
  jmp alltraps
80105d77:	e9 01 f7 ff ff       	jmp    8010547d <alltraps>

80105d7c <vector102>:
.globl vector102
vector102:
  pushl $0
80105d7c:	6a 00                	push   $0x0
  pushl $102
80105d7e:	6a 66                	push   $0x66
  jmp alltraps
80105d80:	e9 f8 f6 ff ff       	jmp    8010547d <alltraps>

80105d85 <vector103>:
.globl vector103
vector103:
  pushl $0
80105d85:	6a 00                	push   $0x0
  pushl $103
80105d87:	6a 67                	push   $0x67
  jmp alltraps
80105d89:	e9 ef f6 ff ff       	jmp    8010547d <alltraps>

80105d8e <vector104>:
.globl vector104
vector104:
  pushl $0
80105d8e:	6a 00                	push   $0x0
  pushl $104
80105d90:	6a 68                	push   $0x68
  jmp alltraps
80105d92:	e9 e6 f6 ff ff       	jmp    8010547d <alltraps>

80105d97 <vector105>:
.globl vector105
vector105:
  pushl $0
80105d97:	6a 00                	push   $0x0
  pushl $105
80105d99:	6a 69                	push   $0x69
  jmp alltraps
80105d9b:	e9 dd f6 ff ff       	jmp    8010547d <alltraps>

80105da0 <vector106>:
.globl vector106
vector106:
  pushl $0
80105da0:	6a 00                	push   $0x0
  pushl $106
80105da2:	6a 6a                	push   $0x6a
  jmp alltraps
80105da4:	e9 d4 f6 ff ff       	jmp    8010547d <alltraps>

80105da9 <vector107>:
.globl vector107
vector107:
  pushl $0
80105da9:	6a 00                	push   $0x0
  pushl $107
80105dab:	6a 6b                	push   $0x6b
  jmp alltraps
80105dad:	e9 cb f6 ff ff       	jmp    8010547d <alltraps>

80105db2 <vector108>:
.globl vector108
vector108:
  pushl $0
80105db2:	6a 00                	push   $0x0
  pushl $108
80105db4:	6a 6c                	push   $0x6c
  jmp alltraps
80105db6:	e9 c2 f6 ff ff       	jmp    8010547d <alltraps>

80105dbb <vector109>:
.globl vector109
vector109:
  pushl $0
80105dbb:	6a 00                	push   $0x0
  pushl $109
80105dbd:	6a 6d                	push   $0x6d
  jmp alltraps
80105dbf:	e9 b9 f6 ff ff       	jmp    8010547d <alltraps>

80105dc4 <vector110>:
.globl vector110
vector110:
  pushl $0
80105dc4:	6a 00                	push   $0x0
  pushl $110
80105dc6:	6a 6e                	push   $0x6e
  jmp alltraps
80105dc8:	e9 b0 f6 ff ff       	jmp    8010547d <alltraps>

80105dcd <vector111>:
.globl vector111
vector111:
  pushl $0
80105dcd:	6a 00                	push   $0x0
  pushl $111
80105dcf:	6a 6f                	push   $0x6f
  jmp alltraps
80105dd1:	e9 a7 f6 ff ff       	jmp    8010547d <alltraps>

80105dd6 <vector112>:
.globl vector112
vector112:
  pushl $0
80105dd6:	6a 00                	push   $0x0
  pushl $112
80105dd8:	6a 70                	push   $0x70
  jmp alltraps
80105dda:	e9 9e f6 ff ff       	jmp    8010547d <alltraps>

80105ddf <vector113>:
.globl vector113
vector113:
  pushl $0
80105ddf:	6a 00                	push   $0x0
  pushl $113
80105de1:	6a 71                	push   $0x71
  jmp alltraps
80105de3:	e9 95 f6 ff ff       	jmp    8010547d <alltraps>

80105de8 <vector114>:
.globl vector114
vector114:
  pushl $0
80105de8:	6a 00                	push   $0x0
  pushl $114
80105dea:	6a 72                	push   $0x72
  jmp alltraps
80105dec:	e9 8c f6 ff ff       	jmp    8010547d <alltraps>

80105df1 <vector115>:
.globl vector115
vector115:
  pushl $0
80105df1:	6a 00                	push   $0x0
  pushl $115
80105df3:	6a 73                	push   $0x73
  jmp alltraps
80105df5:	e9 83 f6 ff ff       	jmp    8010547d <alltraps>

80105dfa <vector116>:
.globl vector116
vector116:
  pushl $0
80105dfa:	6a 00                	push   $0x0
  pushl $116
80105dfc:	6a 74                	push   $0x74
  jmp alltraps
80105dfe:	e9 7a f6 ff ff       	jmp    8010547d <alltraps>

80105e03 <vector117>:
.globl vector117
vector117:
  pushl $0
80105e03:	6a 00                	push   $0x0
  pushl $117
80105e05:	6a 75                	push   $0x75
  jmp alltraps
80105e07:	e9 71 f6 ff ff       	jmp    8010547d <alltraps>

80105e0c <vector118>:
.globl vector118
vector118:
  pushl $0
80105e0c:	6a 00                	push   $0x0
  pushl $118
80105e0e:	6a 76                	push   $0x76
  jmp alltraps
80105e10:	e9 68 f6 ff ff       	jmp    8010547d <alltraps>

80105e15 <vector119>:
.globl vector119
vector119:
  pushl $0
80105e15:	6a 00                	push   $0x0
  pushl $119
80105e17:	6a 77                	push   $0x77
  jmp alltraps
80105e19:	e9 5f f6 ff ff       	jmp    8010547d <alltraps>

80105e1e <vector120>:
.globl vector120
vector120:
  pushl $0
80105e1e:	6a 00                	push   $0x0
  pushl $120
80105e20:	6a 78                	push   $0x78
  jmp alltraps
80105e22:	e9 56 f6 ff ff       	jmp    8010547d <alltraps>

80105e27 <vector121>:
.globl vector121
vector121:
  pushl $0
80105e27:	6a 00                	push   $0x0
  pushl $121
80105e29:	6a 79                	push   $0x79
  jmp alltraps
80105e2b:	e9 4d f6 ff ff       	jmp    8010547d <alltraps>

80105e30 <vector122>:
.globl vector122
vector122:
  pushl $0
80105e30:	6a 00                	push   $0x0
  pushl $122
80105e32:	6a 7a                	push   $0x7a
  jmp alltraps
80105e34:	e9 44 f6 ff ff       	jmp    8010547d <alltraps>

80105e39 <vector123>:
.globl vector123
vector123:
  pushl $0
80105e39:	6a 00                	push   $0x0
  pushl $123
80105e3b:	6a 7b                	push   $0x7b
  jmp alltraps
80105e3d:	e9 3b f6 ff ff       	jmp    8010547d <alltraps>

80105e42 <vector124>:
.globl vector124
vector124:
  pushl $0
80105e42:	6a 00                	push   $0x0
  pushl $124
80105e44:	6a 7c                	push   $0x7c
  jmp alltraps
80105e46:	e9 32 f6 ff ff       	jmp    8010547d <alltraps>

80105e4b <vector125>:
.globl vector125
vector125:
  pushl $0
80105e4b:	6a 00                	push   $0x0
  pushl $125
80105e4d:	6a 7d                	push   $0x7d
  jmp alltraps
80105e4f:	e9 29 f6 ff ff       	jmp    8010547d <alltraps>

80105e54 <vector126>:
.globl vector126
vector126:
  pushl $0
80105e54:	6a 00                	push   $0x0
  pushl $126
80105e56:	6a 7e                	push   $0x7e
  jmp alltraps
80105e58:	e9 20 f6 ff ff       	jmp    8010547d <alltraps>

80105e5d <vector127>:
.globl vector127
vector127:
  pushl $0
80105e5d:	6a 00                	push   $0x0
  pushl $127
80105e5f:	6a 7f                	push   $0x7f
  jmp alltraps
80105e61:	e9 17 f6 ff ff       	jmp    8010547d <alltraps>

80105e66 <vector128>:
.globl vector128
vector128:
  pushl $0
80105e66:	6a 00                	push   $0x0
  pushl $128
80105e68:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105e6d:	e9 0b f6 ff ff       	jmp    8010547d <alltraps>

80105e72 <vector129>:
.globl vector129
vector129:
  pushl $0
80105e72:	6a 00                	push   $0x0
  pushl $129
80105e74:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105e79:	e9 ff f5 ff ff       	jmp    8010547d <alltraps>

80105e7e <vector130>:
.globl vector130
vector130:
  pushl $0
80105e7e:	6a 00                	push   $0x0
  pushl $130
80105e80:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105e85:	e9 f3 f5 ff ff       	jmp    8010547d <alltraps>

80105e8a <vector131>:
.globl vector131
vector131:
  pushl $0
80105e8a:	6a 00                	push   $0x0
  pushl $131
80105e8c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105e91:	e9 e7 f5 ff ff       	jmp    8010547d <alltraps>

80105e96 <vector132>:
.globl vector132
vector132:
  pushl $0
80105e96:	6a 00                	push   $0x0
  pushl $132
80105e98:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105e9d:	e9 db f5 ff ff       	jmp    8010547d <alltraps>

80105ea2 <vector133>:
.globl vector133
vector133:
  pushl $0
80105ea2:	6a 00                	push   $0x0
  pushl $133
80105ea4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105ea9:	e9 cf f5 ff ff       	jmp    8010547d <alltraps>

80105eae <vector134>:
.globl vector134
vector134:
  pushl $0
80105eae:	6a 00                	push   $0x0
  pushl $134
80105eb0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105eb5:	e9 c3 f5 ff ff       	jmp    8010547d <alltraps>

80105eba <vector135>:
.globl vector135
vector135:
  pushl $0
80105eba:	6a 00                	push   $0x0
  pushl $135
80105ebc:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105ec1:	e9 b7 f5 ff ff       	jmp    8010547d <alltraps>

80105ec6 <vector136>:
.globl vector136
vector136:
  pushl $0
80105ec6:	6a 00                	push   $0x0
  pushl $136
80105ec8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105ecd:	e9 ab f5 ff ff       	jmp    8010547d <alltraps>

80105ed2 <vector137>:
.globl vector137
vector137:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $137
80105ed4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105ed9:	e9 9f f5 ff ff       	jmp    8010547d <alltraps>

80105ede <vector138>:
.globl vector138
vector138:
  pushl $0
80105ede:	6a 00                	push   $0x0
  pushl $138
80105ee0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105ee5:	e9 93 f5 ff ff       	jmp    8010547d <alltraps>

80105eea <vector139>:
.globl vector139
vector139:
  pushl $0
80105eea:	6a 00                	push   $0x0
  pushl $139
80105eec:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105ef1:	e9 87 f5 ff ff       	jmp    8010547d <alltraps>

80105ef6 <vector140>:
.globl vector140
vector140:
  pushl $0
80105ef6:	6a 00                	push   $0x0
  pushl $140
80105ef8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105efd:	e9 7b f5 ff ff       	jmp    8010547d <alltraps>

80105f02 <vector141>:
.globl vector141
vector141:
  pushl $0
80105f02:	6a 00                	push   $0x0
  pushl $141
80105f04:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105f09:	e9 6f f5 ff ff       	jmp    8010547d <alltraps>

80105f0e <vector142>:
.globl vector142
vector142:
  pushl $0
80105f0e:	6a 00                	push   $0x0
  pushl $142
80105f10:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105f15:	e9 63 f5 ff ff       	jmp    8010547d <alltraps>

80105f1a <vector143>:
.globl vector143
vector143:
  pushl $0
80105f1a:	6a 00                	push   $0x0
  pushl $143
80105f1c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105f21:	e9 57 f5 ff ff       	jmp    8010547d <alltraps>

80105f26 <vector144>:
.globl vector144
vector144:
  pushl $0
80105f26:	6a 00                	push   $0x0
  pushl $144
80105f28:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105f2d:	e9 4b f5 ff ff       	jmp    8010547d <alltraps>

80105f32 <vector145>:
.globl vector145
vector145:
  pushl $0
80105f32:	6a 00                	push   $0x0
  pushl $145
80105f34:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105f39:	e9 3f f5 ff ff       	jmp    8010547d <alltraps>

80105f3e <vector146>:
.globl vector146
vector146:
  pushl $0
80105f3e:	6a 00                	push   $0x0
  pushl $146
80105f40:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105f45:	e9 33 f5 ff ff       	jmp    8010547d <alltraps>

80105f4a <vector147>:
.globl vector147
vector147:
  pushl $0
80105f4a:	6a 00                	push   $0x0
  pushl $147
80105f4c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105f51:	e9 27 f5 ff ff       	jmp    8010547d <alltraps>

80105f56 <vector148>:
.globl vector148
vector148:
  pushl $0
80105f56:	6a 00                	push   $0x0
  pushl $148
80105f58:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105f5d:	e9 1b f5 ff ff       	jmp    8010547d <alltraps>

80105f62 <vector149>:
.globl vector149
vector149:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $149
80105f64:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105f69:	e9 0f f5 ff ff       	jmp    8010547d <alltraps>

80105f6e <vector150>:
.globl vector150
vector150:
  pushl $0
80105f6e:	6a 00                	push   $0x0
  pushl $150
80105f70:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105f75:	e9 03 f5 ff ff       	jmp    8010547d <alltraps>

80105f7a <vector151>:
.globl vector151
vector151:
  pushl $0
80105f7a:	6a 00                	push   $0x0
  pushl $151
80105f7c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105f81:	e9 f7 f4 ff ff       	jmp    8010547d <alltraps>

80105f86 <vector152>:
.globl vector152
vector152:
  pushl $0
80105f86:	6a 00                	push   $0x0
  pushl $152
80105f88:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105f8d:	e9 eb f4 ff ff       	jmp    8010547d <alltraps>

80105f92 <vector153>:
.globl vector153
vector153:
  pushl $0
80105f92:	6a 00                	push   $0x0
  pushl $153
80105f94:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105f99:	e9 df f4 ff ff       	jmp    8010547d <alltraps>

80105f9e <vector154>:
.globl vector154
vector154:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $154
80105fa0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105fa5:	e9 d3 f4 ff ff       	jmp    8010547d <alltraps>

80105faa <vector155>:
.globl vector155
vector155:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $155
80105fac:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105fb1:	e9 c7 f4 ff ff       	jmp    8010547d <alltraps>

80105fb6 <vector156>:
.globl vector156
vector156:
  pushl $0
80105fb6:	6a 00                	push   $0x0
  pushl $156
80105fb8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105fbd:	e9 bb f4 ff ff       	jmp    8010547d <alltraps>

80105fc2 <vector157>:
.globl vector157
vector157:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $157
80105fc4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105fc9:	e9 af f4 ff ff       	jmp    8010547d <alltraps>

80105fce <vector158>:
.globl vector158
vector158:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $158
80105fd0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105fd5:	e9 a3 f4 ff ff       	jmp    8010547d <alltraps>

80105fda <vector159>:
.globl vector159
vector159:
  pushl $0
80105fda:	6a 00                	push   $0x0
  pushl $159
80105fdc:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105fe1:	e9 97 f4 ff ff       	jmp    8010547d <alltraps>

80105fe6 <vector160>:
.globl vector160
vector160:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $160
80105fe8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105fed:	e9 8b f4 ff ff       	jmp    8010547d <alltraps>

80105ff2 <vector161>:
.globl vector161
vector161:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $161
80105ff4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105ff9:	e9 7f f4 ff ff       	jmp    8010547d <alltraps>

80105ffe <vector162>:
.globl vector162
vector162:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $162
80106000:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106005:	e9 73 f4 ff ff       	jmp    8010547d <alltraps>

8010600a <vector163>:
.globl vector163
vector163:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $163
8010600c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106011:	e9 67 f4 ff ff       	jmp    8010547d <alltraps>

80106016 <vector164>:
.globl vector164
vector164:
  pushl $0
80106016:	6a 00                	push   $0x0
  pushl $164
80106018:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010601d:	e9 5b f4 ff ff       	jmp    8010547d <alltraps>

80106022 <vector165>:
.globl vector165
vector165:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $165
80106024:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106029:	e9 4f f4 ff ff       	jmp    8010547d <alltraps>

8010602e <vector166>:
.globl vector166
vector166:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $166
80106030:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106035:	e9 43 f4 ff ff       	jmp    8010547d <alltraps>

8010603a <vector167>:
.globl vector167
vector167:
  pushl $0
8010603a:	6a 00                	push   $0x0
  pushl $167
8010603c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106041:	e9 37 f4 ff ff       	jmp    8010547d <alltraps>

80106046 <vector168>:
.globl vector168
vector168:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $168
80106048:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010604d:	e9 2b f4 ff ff       	jmp    8010547d <alltraps>

80106052 <vector169>:
.globl vector169
vector169:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $169
80106054:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106059:	e9 1f f4 ff ff       	jmp    8010547d <alltraps>

8010605e <vector170>:
.globl vector170
vector170:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $170
80106060:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106065:	e9 13 f4 ff ff       	jmp    8010547d <alltraps>

8010606a <vector171>:
.globl vector171
vector171:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $171
8010606c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106071:	e9 07 f4 ff ff       	jmp    8010547d <alltraps>

80106076 <vector172>:
.globl vector172
vector172:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $172
80106078:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010607d:	e9 fb f3 ff ff       	jmp    8010547d <alltraps>

80106082 <vector173>:
.globl vector173
vector173:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $173
80106084:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106089:	e9 ef f3 ff ff       	jmp    8010547d <alltraps>

8010608e <vector174>:
.globl vector174
vector174:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $174
80106090:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106095:	e9 e3 f3 ff ff       	jmp    8010547d <alltraps>

8010609a <vector175>:
.globl vector175
vector175:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $175
8010609c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801060a1:	e9 d7 f3 ff ff       	jmp    8010547d <alltraps>

801060a6 <vector176>:
.globl vector176
vector176:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $176
801060a8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801060ad:	e9 cb f3 ff ff       	jmp    8010547d <alltraps>

801060b2 <vector177>:
.globl vector177
vector177:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $177
801060b4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801060b9:	e9 bf f3 ff ff       	jmp    8010547d <alltraps>

801060be <vector178>:
.globl vector178
vector178:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $178
801060c0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801060c5:	e9 b3 f3 ff ff       	jmp    8010547d <alltraps>

801060ca <vector179>:
.globl vector179
vector179:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $179
801060cc:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801060d1:	e9 a7 f3 ff ff       	jmp    8010547d <alltraps>

801060d6 <vector180>:
.globl vector180
vector180:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $180
801060d8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801060dd:	e9 9b f3 ff ff       	jmp    8010547d <alltraps>

801060e2 <vector181>:
.globl vector181
vector181:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $181
801060e4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801060e9:	e9 8f f3 ff ff       	jmp    8010547d <alltraps>

801060ee <vector182>:
.globl vector182
vector182:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $182
801060f0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801060f5:	e9 83 f3 ff ff       	jmp    8010547d <alltraps>

801060fa <vector183>:
.globl vector183
vector183:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $183
801060fc:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106101:	e9 77 f3 ff ff       	jmp    8010547d <alltraps>

80106106 <vector184>:
.globl vector184
vector184:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $184
80106108:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010610d:	e9 6b f3 ff ff       	jmp    8010547d <alltraps>

80106112 <vector185>:
.globl vector185
vector185:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $185
80106114:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106119:	e9 5f f3 ff ff       	jmp    8010547d <alltraps>

8010611e <vector186>:
.globl vector186
vector186:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $186
80106120:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106125:	e9 53 f3 ff ff       	jmp    8010547d <alltraps>

8010612a <vector187>:
.globl vector187
vector187:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $187
8010612c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106131:	e9 47 f3 ff ff       	jmp    8010547d <alltraps>

80106136 <vector188>:
.globl vector188
vector188:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $188
80106138:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010613d:	e9 3b f3 ff ff       	jmp    8010547d <alltraps>

80106142 <vector189>:
.globl vector189
vector189:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $189
80106144:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106149:	e9 2f f3 ff ff       	jmp    8010547d <alltraps>

8010614e <vector190>:
.globl vector190
vector190:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $190
80106150:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106155:	e9 23 f3 ff ff       	jmp    8010547d <alltraps>

8010615a <vector191>:
.globl vector191
vector191:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $191
8010615c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106161:	e9 17 f3 ff ff       	jmp    8010547d <alltraps>

80106166 <vector192>:
.globl vector192
vector192:
  pushl $0
80106166:	6a 00                	push   $0x0
  pushl $192
80106168:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010616d:	e9 0b f3 ff ff       	jmp    8010547d <alltraps>

80106172 <vector193>:
.globl vector193
vector193:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $193
80106174:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106179:	e9 ff f2 ff ff       	jmp    8010547d <alltraps>

8010617e <vector194>:
.globl vector194
vector194:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $194
80106180:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106185:	e9 f3 f2 ff ff       	jmp    8010547d <alltraps>

8010618a <vector195>:
.globl vector195
vector195:
  pushl $0
8010618a:	6a 00                	push   $0x0
  pushl $195
8010618c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106191:	e9 e7 f2 ff ff       	jmp    8010547d <alltraps>

80106196 <vector196>:
.globl vector196
vector196:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $196
80106198:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010619d:	e9 db f2 ff ff       	jmp    8010547d <alltraps>

801061a2 <vector197>:
.globl vector197
vector197:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $197
801061a4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801061a9:	e9 cf f2 ff ff       	jmp    8010547d <alltraps>

801061ae <vector198>:
.globl vector198
vector198:
  pushl $0
801061ae:	6a 00                	push   $0x0
  pushl $198
801061b0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801061b5:	e9 c3 f2 ff ff       	jmp    8010547d <alltraps>

801061ba <vector199>:
.globl vector199
vector199:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $199
801061bc:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801061c1:	e9 b7 f2 ff ff       	jmp    8010547d <alltraps>

801061c6 <vector200>:
.globl vector200
vector200:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $200
801061c8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801061cd:	e9 ab f2 ff ff       	jmp    8010547d <alltraps>

801061d2 <vector201>:
.globl vector201
vector201:
  pushl $0
801061d2:	6a 00                	push   $0x0
  pushl $201
801061d4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801061d9:	e9 9f f2 ff ff       	jmp    8010547d <alltraps>

801061de <vector202>:
.globl vector202
vector202:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $202
801061e0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801061e5:	e9 93 f2 ff ff       	jmp    8010547d <alltraps>

801061ea <vector203>:
.globl vector203
vector203:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $203
801061ec:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801061f1:	e9 87 f2 ff ff       	jmp    8010547d <alltraps>

801061f6 <vector204>:
.globl vector204
vector204:
  pushl $0
801061f6:	6a 00                	push   $0x0
  pushl $204
801061f8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801061fd:	e9 7b f2 ff ff       	jmp    8010547d <alltraps>

80106202 <vector205>:
.globl vector205
vector205:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $205
80106204:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106209:	e9 6f f2 ff ff       	jmp    8010547d <alltraps>

8010620e <vector206>:
.globl vector206
vector206:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $206
80106210:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106215:	e9 63 f2 ff ff       	jmp    8010547d <alltraps>

8010621a <vector207>:
.globl vector207
vector207:
  pushl $0
8010621a:	6a 00                	push   $0x0
  pushl $207
8010621c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106221:	e9 57 f2 ff ff       	jmp    8010547d <alltraps>

80106226 <vector208>:
.globl vector208
vector208:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $208
80106228:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010622d:	e9 4b f2 ff ff       	jmp    8010547d <alltraps>

80106232 <vector209>:
.globl vector209
vector209:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $209
80106234:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106239:	e9 3f f2 ff ff       	jmp    8010547d <alltraps>

8010623e <vector210>:
.globl vector210
vector210:
  pushl $0
8010623e:	6a 00                	push   $0x0
  pushl $210
80106240:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106245:	e9 33 f2 ff ff       	jmp    8010547d <alltraps>

8010624a <vector211>:
.globl vector211
vector211:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $211
8010624c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106251:	e9 27 f2 ff ff       	jmp    8010547d <alltraps>

80106256 <vector212>:
.globl vector212
vector212:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $212
80106258:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010625d:	e9 1b f2 ff ff       	jmp    8010547d <alltraps>

80106262 <vector213>:
.globl vector213
vector213:
  pushl $0
80106262:	6a 00                	push   $0x0
  pushl $213
80106264:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106269:	e9 0f f2 ff ff       	jmp    8010547d <alltraps>

8010626e <vector214>:
.globl vector214
vector214:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $214
80106270:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106275:	e9 03 f2 ff ff       	jmp    8010547d <alltraps>

8010627a <vector215>:
.globl vector215
vector215:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $215
8010627c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106281:	e9 f7 f1 ff ff       	jmp    8010547d <alltraps>

80106286 <vector216>:
.globl vector216
vector216:
  pushl $0
80106286:	6a 00                	push   $0x0
  pushl $216
80106288:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010628d:	e9 eb f1 ff ff       	jmp    8010547d <alltraps>

80106292 <vector217>:
.globl vector217
vector217:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $217
80106294:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106299:	e9 df f1 ff ff       	jmp    8010547d <alltraps>

8010629e <vector218>:
.globl vector218
vector218:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $218
801062a0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801062a5:	e9 d3 f1 ff ff       	jmp    8010547d <alltraps>

801062aa <vector219>:
.globl vector219
vector219:
  pushl $0
801062aa:	6a 00                	push   $0x0
  pushl $219
801062ac:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801062b1:	e9 c7 f1 ff ff       	jmp    8010547d <alltraps>

801062b6 <vector220>:
.globl vector220
vector220:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $220
801062b8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801062bd:	e9 bb f1 ff ff       	jmp    8010547d <alltraps>

801062c2 <vector221>:
.globl vector221
vector221:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $221
801062c4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801062c9:	e9 af f1 ff ff       	jmp    8010547d <alltraps>

801062ce <vector222>:
.globl vector222
vector222:
  pushl $0
801062ce:	6a 00                	push   $0x0
  pushl $222
801062d0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801062d5:	e9 a3 f1 ff ff       	jmp    8010547d <alltraps>

801062da <vector223>:
.globl vector223
vector223:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $223
801062dc:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801062e1:	e9 97 f1 ff ff       	jmp    8010547d <alltraps>

801062e6 <vector224>:
.globl vector224
vector224:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $224
801062e8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801062ed:	e9 8b f1 ff ff       	jmp    8010547d <alltraps>

801062f2 <vector225>:
.globl vector225
vector225:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $225
801062f4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801062f9:	e9 7f f1 ff ff       	jmp    8010547d <alltraps>

801062fe <vector226>:
.globl vector226
vector226:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $226
80106300:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106305:	e9 73 f1 ff ff       	jmp    8010547d <alltraps>

8010630a <vector227>:
.globl vector227
vector227:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $227
8010630c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106311:	e9 67 f1 ff ff       	jmp    8010547d <alltraps>

80106316 <vector228>:
.globl vector228
vector228:
  pushl $0
80106316:	6a 00                	push   $0x0
  pushl $228
80106318:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010631d:	e9 5b f1 ff ff       	jmp    8010547d <alltraps>

80106322 <vector229>:
.globl vector229
vector229:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $229
80106324:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106329:	e9 4f f1 ff ff       	jmp    8010547d <alltraps>

8010632e <vector230>:
.globl vector230
vector230:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $230
80106330:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106335:	e9 43 f1 ff ff       	jmp    8010547d <alltraps>

8010633a <vector231>:
.globl vector231
vector231:
  pushl $0
8010633a:	6a 00                	push   $0x0
  pushl $231
8010633c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106341:	e9 37 f1 ff ff       	jmp    8010547d <alltraps>

80106346 <vector232>:
.globl vector232
vector232:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $232
80106348:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010634d:	e9 2b f1 ff ff       	jmp    8010547d <alltraps>

80106352 <vector233>:
.globl vector233
vector233:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $233
80106354:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106359:	e9 1f f1 ff ff       	jmp    8010547d <alltraps>

8010635e <vector234>:
.globl vector234
vector234:
  pushl $0
8010635e:	6a 00                	push   $0x0
  pushl $234
80106360:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106365:	e9 13 f1 ff ff       	jmp    8010547d <alltraps>

8010636a <vector235>:
.globl vector235
vector235:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $235
8010636c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106371:	e9 07 f1 ff ff       	jmp    8010547d <alltraps>

80106376 <vector236>:
.globl vector236
vector236:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $236
80106378:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010637d:	e9 fb f0 ff ff       	jmp    8010547d <alltraps>

80106382 <vector237>:
.globl vector237
vector237:
  pushl $0
80106382:	6a 00                	push   $0x0
  pushl $237
80106384:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106389:	e9 ef f0 ff ff       	jmp    8010547d <alltraps>

8010638e <vector238>:
.globl vector238
vector238:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $238
80106390:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106395:	e9 e3 f0 ff ff       	jmp    8010547d <alltraps>

8010639a <vector239>:
.globl vector239
vector239:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $239
8010639c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801063a1:	e9 d7 f0 ff ff       	jmp    8010547d <alltraps>

801063a6 <vector240>:
.globl vector240
vector240:
  pushl $0
801063a6:	6a 00                	push   $0x0
  pushl $240
801063a8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801063ad:	e9 cb f0 ff ff       	jmp    8010547d <alltraps>

801063b2 <vector241>:
.globl vector241
vector241:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $241
801063b4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801063b9:	e9 bf f0 ff ff       	jmp    8010547d <alltraps>

801063be <vector242>:
.globl vector242
vector242:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $242
801063c0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801063c5:	e9 b3 f0 ff ff       	jmp    8010547d <alltraps>

801063ca <vector243>:
.globl vector243
vector243:
  pushl $0
801063ca:	6a 00                	push   $0x0
  pushl $243
801063cc:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801063d1:	e9 a7 f0 ff ff       	jmp    8010547d <alltraps>

801063d6 <vector244>:
.globl vector244
vector244:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $244
801063d8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801063dd:	e9 9b f0 ff ff       	jmp    8010547d <alltraps>

801063e2 <vector245>:
.globl vector245
vector245:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $245
801063e4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801063e9:	e9 8f f0 ff ff       	jmp    8010547d <alltraps>

801063ee <vector246>:
.globl vector246
vector246:
  pushl $0
801063ee:	6a 00                	push   $0x0
  pushl $246
801063f0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801063f5:	e9 83 f0 ff ff       	jmp    8010547d <alltraps>

801063fa <vector247>:
.globl vector247
vector247:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $247
801063fc:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106401:	e9 77 f0 ff ff       	jmp    8010547d <alltraps>

80106406 <vector248>:
.globl vector248
vector248:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $248
80106408:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010640d:	e9 6b f0 ff ff       	jmp    8010547d <alltraps>

80106412 <vector249>:
.globl vector249
vector249:
  pushl $0
80106412:	6a 00                	push   $0x0
  pushl $249
80106414:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106419:	e9 5f f0 ff ff       	jmp    8010547d <alltraps>

8010641e <vector250>:
.globl vector250
vector250:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $250
80106420:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106425:	e9 53 f0 ff ff       	jmp    8010547d <alltraps>

8010642a <vector251>:
.globl vector251
vector251:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $251
8010642c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106431:	e9 47 f0 ff ff       	jmp    8010547d <alltraps>

80106436 <vector252>:
.globl vector252
vector252:
  pushl $0
80106436:	6a 00                	push   $0x0
  pushl $252
80106438:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010643d:	e9 3b f0 ff ff       	jmp    8010547d <alltraps>

80106442 <vector253>:
.globl vector253
vector253:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $253
80106444:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106449:	e9 2f f0 ff ff       	jmp    8010547d <alltraps>

8010644e <vector254>:
.globl vector254
vector254:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $254
80106450:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106455:	e9 23 f0 ff ff       	jmp    8010547d <alltraps>

8010645a <vector255>:
.globl vector255
vector255:
  pushl $0
8010645a:	6a 00                	push   $0x0
  pushl $255
8010645c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106461:	e9 17 f0 ff ff       	jmp    8010547d <alltraps>
80106466:	66 90                	xchg   %ax,%ax
80106468:	66 90                	xchg   %ax,%ax
8010646a:	66 90                	xchg   %ax,%ax
8010646c:	66 90                	xchg   %ax,%ax
8010646e:	66 90                	xchg   %ax,%ax

80106470 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106470:	55                   	push   %ebp
80106471:	89 e5                	mov    %esp,%ebp
80106473:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106476:	e8 35 d2 ff ff       	call   801036b0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010647b:	31 c9                	xor    %ecx,%ecx
8010647d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c = &cpus[cpuid()];
80106482:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106488:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010648d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106491:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
80106496:	83 c0 70             	add    $0x70,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106499:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010649d:	31 c9                	xor    %ecx,%ecx
8010649f:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064a3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064a8:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064ac:	31 c9                	xor    %ecx,%ecx
801064ae:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801064b2:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064b7:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801064bb:	31 c9                	xor    %ecx,%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064bd:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
801064c1:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064c5:	c6 40 15 92          	movb   $0x92,0x15(%eax)
801064c9:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064cd:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
801064d1:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801064d5:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
801064d9:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
801064dd:	66 89 50 20          	mov    %dx,0x20(%eax)
  pd[0] = size-1;
801064e1:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064e6:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
801064ea:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064ee:	c6 40 14 00          	movb   $0x0,0x14(%eax)
801064f2:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064f6:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
801064fa:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801064fe:	66 89 48 22          	mov    %cx,0x22(%eax)
80106502:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106506:	c6 40 27 00          	movb   $0x0,0x27(%eax)
8010650a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
8010650e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106512:	c1 e8 10             	shr    $0x10,%eax
80106515:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106519:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010651c:	0f 01 10             	lgdtl  (%eax)
}
8010651f:	c9                   	leave  
80106520:	c3                   	ret    
80106521:	eb 0d                	jmp    80106530 <walkpgdir>
80106523:	90                   	nop
80106524:	90                   	nop
80106525:	90                   	nop
80106526:	90                   	nop
80106527:	90                   	nop
80106528:	90                   	nop
80106529:	90                   	nop
8010652a:	90                   	nop
8010652b:	90                   	nop
8010652c:	90                   	nop
8010652d:	90                   	nop
8010652e:	90                   	nop
8010652f:	90                   	nop

80106530 <walkpgdir>:
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
//static pte_t *
pte_t*
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106530:	55                   	push   %ebp
80106531:	89 e5                	mov    %esp,%ebp
80106533:	57                   	push   %edi
80106534:	56                   	push   %esi
80106535:	53                   	push   %ebx
80106536:	83 ec 1c             	sub    $0x1c,%esp
80106539:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010653c:	8b 55 08             	mov    0x8(%ebp),%edx
8010653f:	89 fb                	mov    %edi,%ebx
80106541:	c1 eb 16             	shr    $0x16,%ebx
80106544:	8d 1c 9a             	lea    (%edx,%ebx,4),%ebx
  if(*pde & PTE_P){
80106547:	8b 33                	mov    (%ebx),%esi
80106549:	f7 c6 01 00 00 00    	test   $0x1,%esi
8010654f:	74 27                	je     80106578 <walkpgdir+0x48>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106551:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80106557:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010655d:	89 fa                	mov    %edi,%edx
}
8010655f:	83 c4 1c             	add    $0x1c,%esp
  return &pgtab[PTX(va)];
80106562:	c1 ea 0a             	shr    $0xa,%edx
80106565:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
}
8010656b:	5b                   	pop    %ebx
  return &pgtab[PTX(va)];
8010656c:	8d 04 16             	lea    (%esi,%edx,1),%eax
}
8010656f:	5e                   	pop    %esi
80106570:	5f                   	pop    %edi
80106571:	5d                   	pop    %ebp
80106572:	c3                   	ret    
80106573:	90                   	nop
80106574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106578:	8b 45 10             	mov    0x10(%ebp),%eax
8010657b:	85 c0                	test   %eax,%eax
8010657d:	74 31                	je     801065b0 <walkpgdir+0x80>
8010657f:	e8 4c bf ff ff       	call   801024d0 <kalloc>
80106584:	85 c0                	test   %eax,%eax
80106586:	89 c6                	mov    %eax,%esi
80106588:	74 26                	je     801065b0 <walkpgdir+0x80>
    memset(pgtab, 0, PGSIZE);
8010658a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106591:	00 
80106592:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106599:	00 
8010659a:	89 04 24             	mov    %eax,(%esp)
8010659d:	e8 3e dd ff ff       	call   801042e0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801065a2:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801065a8:	83 c8 07             	or     $0x7,%eax
801065ab:	89 03                	mov    %eax,(%ebx)
801065ad:	eb ae                	jmp    8010655d <walkpgdir+0x2d>
801065af:	90                   	nop
}
801065b0:	83 c4 1c             	add    $0x1c,%esp
      return 0;
801065b3:	31 c0                	xor    %eax,%eax
}
801065b5:	5b                   	pop    %ebx
801065b6:	5e                   	pop    %esi
801065b7:	5f                   	pop    %edi
801065b8:	5d                   	pop    %ebp
801065b9:	c3                   	ret    
801065ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801065c0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801065c0:	55                   	push   %ebp
801065c1:	89 e5                	mov    %esp,%ebp
801065c3:	57                   	push   %edi
801065c4:	56                   	push   %esi
801065c5:	89 c6                	mov    %eax,%esi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801065c7:	8d b9 ff 0f 00 00    	lea    0xfff(%ecx),%edi
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801065cd:	53                   	push   %ebx
  a = PGROUNDUP(newsz);
801065ce:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801065d4:	83 ec 2c             	sub    $0x2c,%esp
  for(; a  < oldsz; a += PGSIZE){
801065d7:	39 d7                	cmp    %edx,%edi
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801065d9:	89 d3                	mov    %edx,%ebx
801065db:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801065de:	72 3b                	jb     8010661b <deallocuvm.part.0+0x5b>
801065e0:	eb 6e                	jmp    80106650 <deallocuvm.part.0+0x90>
801065e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801065e8:	8b 08                	mov    (%eax),%ecx
801065ea:	f6 c1 01             	test   $0x1,%cl
801065ed:	74 22                	je     80106611 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801065ef:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
801065f5:	74 64                	je     8010665b <deallocuvm.part.0+0x9b>
        panic("kfree");
      char *v = P2V(pa);
801065f7:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
      kfree(v);
801065fd:	89 0c 24             	mov    %ecx,(%esp)
80106600:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106603:	e8 18 bd ff ff       	call   80102320 <kfree>
      *pte = 0;
80106608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010660b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106611:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106617:	39 df                	cmp    %ebx,%edi
80106619:	73 35                	jae    80106650 <deallocuvm.part.0+0x90>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010661b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106622:	00 
80106623:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106627:	89 34 24             	mov    %esi,(%esp)
8010662a:	e8 01 ff ff ff       	call   80106530 <walkpgdir>
    if(!pte)
8010662f:	85 c0                	test   %eax,%eax
80106631:	75 b5                	jne    801065e8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106633:	89 fa                	mov    %edi,%edx
80106635:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
8010663b:	8d ba 00 f0 3f 00    	lea    0x3ff000(%edx),%edi
  for(; a  < oldsz; a += PGSIZE){
80106641:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106647:	39 df                	cmp    %ebx,%edi
80106649:	72 d0                	jb     8010661b <deallocuvm.part.0+0x5b>
8010664b:	90                   	nop
8010664c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }
  return newsz;
}
80106650:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106653:	83 c4 2c             	add    $0x2c,%esp
80106656:	5b                   	pop    %ebx
80106657:	5e                   	pop    %esi
80106658:	5f                   	pop    %edi
80106659:	5d                   	pop    %ebp
8010665a:	c3                   	ret    
        panic("kfree");
8010665b:	c7 04 24 2a 72 10 80 	movl   $0x8010722a,(%esp)
80106662:	e8 f9 9c ff ff       	call   80100360 <panic>
80106667:	89 f6                	mov    %esi,%esi
80106669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106670 <mappages>:
{
80106670:	55                   	push   %ebp
80106671:	89 e5                	mov    %esp,%ebp
80106673:	57                   	push   %edi
80106674:	56                   	push   %esi
80106675:	53                   	push   %ebx
80106676:	83 ec 1c             	sub    $0x1c,%esp
80106679:	8b 45 0c             	mov    0xc(%ebp),%eax
8010667c:	8b 75 14             	mov    0x14(%ebp),%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010667f:	8b 4d 10             	mov    0x10(%ebp),%ecx
    *pte = pa | perm | PTE_P;
80106682:	83 4d 18 01          	orl    $0x1,0x18(%ebp)
  a = (char*)PGROUNDDOWN((uint)va);
80106686:	89 c7                	mov    %eax,%edi
80106688:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
8010668e:	29 fe                	sub    %edi,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106690:	8d 44 08 ff          	lea    -0x1(%eax,%ecx,1),%eax
    *pte = pa | perm | PTE_P;
80106694:	89 75 14             	mov    %esi,0x14(%ebp)
80106697:	89 fe                	mov    %edi,%esi
80106699:	8b 7d 14             	mov    0x14(%ebp),%edi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010669c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010669f:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
801066a6:	eb 15                	jmp    801066bd <mappages+0x4d>
    if(*pte & PTE_P)
801066a8:	f6 00 01             	testb  $0x1,(%eax)
801066ab:	75 45                	jne    801066f2 <mappages+0x82>
    *pte = pa | perm | PTE_P;
801066ad:	0b 5d 18             	or     0x18(%ebp),%ebx
    if(a == last)
801066b0:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
    *pte = pa | perm | PTE_P;
801066b3:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801066b5:	74 31                	je     801066e8 <mappages+0x78>
    a += PGSIZE;
801066b7:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801066bd:	8b 45 08             	mov    0x8(%ebp),%eax
801066c0:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
801066c3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
801066ca:	00 
801066cb:	89 74 24 04          	mov    %esi,0x4(%esp)
801066cf:	89 04 24             	mov    %eax,(%esp)
801066d2:	e8 59 fe ff ff       	call   80106530 <walkpgdir>
801066d7:	85 c0                	test   %eax,%eax
801066d9:	75 cd                	jne    801066a8 <mappages+0x38>
}
801066db:	83 c4 1c             	add    $0x1c,%esp
      return -1;
801066de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066e3:	5b                   	pop    %ebx
801066e4:	5e                   	pop    %esi
801066e5:	5f                   	pop    %edi
801066e6:	5d                   	pop    %ebp
801066e7:	c3                   	ret    
801066e8:	83 c4 1c             	add    $0x1c,%esp
  return 0;
801066eb:	31 c0                	xor    %eax,%eax
}
801066ed:	5b                   	pop    %ebx
801066ee:	5e                   	pop    %esi
801066ef:	5f                   	pop    %edi
801066f0:	5d                   	pop    %ebp
801066f1:	c3                   	ret    
      panic("remap");
801066f2:	c7 04 24 50 79 10 80 	movl   $0x80107950,(%esp)
801066f9:	e8 62 9c ff ff       	call   80100360 <panic>
801066fe:	66 90                	xchg   %ax,%ax

80106700 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106700:	a1 a4 56 11 80       	mov    0x801156a4,%eax
{
80106705:	55                   	push   %ebp
80106706:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106708:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010670d:	0f 22 d8             	mov    %eax,%cr3
}
80106710:	5d                   	pop    %ebp
80106711:	c3                   	ret    
80106712:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106720 <switchuvm>:
{
80106720:	55                   	push   %ebp
80106721:	89 e5                	mov    %esp,%ebp
80106723:	57                   	push   %edi
80106724:	56                   	push   %esi
80106725:	53                   	push   %ebx
80106726:	83 ec 1c             	sub    $0x1c,%esp
80106729:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010672c:	85 f6                	test   %esi,%esi
8010672e:	0f 84 cd 00 00 00    	je     80106801 <switchuvm+0xe1>
  if(p->kstack == 0)
80106734:	8b 46 08             	mov    0x8(%esi),%eax
80106737:	85 c0                	test   %eax,%eax
80106739:	0f 84 da 00 00 00    	je     80106819 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010673f:	8b 7e 04             	mov    0x4(%esi),%edi
80106742:	85 ff                	test   %edi,%edi
80106744:	0f 84 c3 00 00 00    	je     8010680d <switchuvm+0xed>
  pushcli();
8010674a:	e8 11 da ff ff       	call   80104160 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010674f:	e8 dc ce ff ff       	call   80103630 <mycpu>
80106754:	89 c3                	mov    %eax,%ebx
80106756:	e8 d5 ce ff ff       	call   80103630 <mycpu>
8010675b:	89 c7                	mov    %eax,%edi
8010675d:	e8 ce ce ff ff       	call   80103630 <mycpu>
80106762:	83 c7 08             	add    $0x8,%edi
80106765:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106768:	e8 c3 ce ff ff       	call   80103630 <mycpu>
8010676d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106770:	ba 67 00 00 00       	mov    $0x67,%edx
80106775:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
8010677c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106783:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
8010678a:	83 c1 08             	add    $0x8,%ecx
8010678d:	c1 e9 10             	shr    $0x10,%ecx
80106790:	83 c0 08             	add    $0x8,%eax
80106793:	c1 e8 18             	shr    $0x18,%eax
80106796:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010679c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
801067a3:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801067a9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801067ae:	e8 7d ce ff ff       	call   80103630 <mycpu>
801067b3:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801067ba:	e8 71 ce ff ff       	call   80103630 <mycpu>
801067bf:	b9 10 00 00 00       	mov    $0x10,%ecx
801067c4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801067c8:	e8 63 ce ff ff       	call   80103630 <mycpu>
801067cd:	8b 56 08             	mov    0x8(%esi),%edx
801067d0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
801067d6:	89 48 0c             	mov    %ecx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801067d9:	e8 52 ce ff ff       	call   80103630 <mycpu>
801067de:	66 89 58 6e          	mov    %bx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801067e2:	b8 28 00 00 00       	mov    $0x28,%eax
801067e7:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801067ea:	8b 46 04             	mov    0x4(%esi),%eax
801067ed:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801067f2:	0f 22 d8             	mov    %eax,%cr3
}
801067f5:	83 c4 1c             	add    $0x1c,%esp
801067f8:	5b                   	pop    %ebx
801067f9:	5e                   	pop    %esi
801067fa:	5f                   	pop    %edi
801067fb:	5d                   	pop    %ebp
  popcli();
801067fc:	e9 1f da ff ff       	jmp    80104220 <popcli>
    panic("switchuvm: no process");
80106801:	c7 04 24 56 79 10 80 	movl   $0x80107956,(%esp)
80106808:	e8 53 9b ff ff       	call   80100360 <panic>
    panic("switchuvm: no pgdir");
8010680d:	c7 04 24 81 79 10 80 	movl   $0x80107981,(%esp)
80106814:	e8 47 9b ff ff       	call   80100360 <panic>
    panic("switchuvm: no kstack");
80106819:	c7 04 24 6c 79 10 80 	movl   $0x8010796c,(%esp)
80106820:	e8 3b 9b ff ff       	call   80100360 <panic>
80106825:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106830 <inituvm>:
{
80106830:	55                   	push   %ebp
80106831:	89 e5                	mov    %esp,%ebp
80106833:	57                   	push   %edi
80106834:	56                   	push   %esi
80106835:	53                   	push   %ebx
80106836:	83 ec 2c             	sub    $0x2c,%esp
80106839:	8b 75 10             	mov    0x10(%ebp),%esi
8010683c:	8b 55 08             	mov    0x8(%ebp),%edx
8010683f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106842:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106848:	77 64                	ja     801068ae <inituvm+0x7e>
8010684a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
8010684d:	e8 7e bc ff ff       	call   801024d0 <kalloc>
  memset(mem, 0, PGSIZE);
80106852:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106859:	00 
8010685a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106861:	00 
80106862:	89 04 24             	mov    %eax,(%esp)
  mem = kalloc();
80106865:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106867:	e8 74 da ff ff       	call   801042e0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010686c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010686f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106875:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010687c:	00 
8010687d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106881:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106888:	00 
80106889:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106890:	00 
80106891:	89 14 24             	mov    %edx,(%esp)
80106894:	e8 d7 fd ff ff       	call   80106670 <mappages>
  memmove(mem, init, sz);
80106899:	89 75 10             	mov    %esi,0x10(%ebp)
8010689c:	89 7d 0c             	mov    %edi,0xc(%ebp)
8010689f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801068a2:	83 c4 2c             	add    $0x2c,%esp
801068a5:	5b                   	pop    %ebx
801068a6:	5e                   	pop    %esi
801068a7:	5f                   	pop    %edi
801068a8:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801068a9:	e9 d2 da ff ff       	jmp    80104380 <memmove>
    panic("inituvm: more than a page");
801068ae:	c7 04 24 95 79 10 80 	movl   $0x80107995,(%esp)
801068b5:	e8 a6 9a ff ff       	call   80100360 <panic>
801068ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801068c0 <loaduvm>:
{
801068c0:	55                   	push   %ebp
801068c1:	89 e5                	mov    %esp,%ebp
801068c3:	57                   	push   %edi
801068c4:	56                   	push   %esi
801068c5:	53                   	push   %ebx
801068c6:	83 ec 1c             	sub    $0x1c,%esp
  if((uint) addr % PGSIZE != 0)
801068c9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801068d0:	0f 85 a0 00 00 00    	jne    80106976 <loaduvm+0xb6>
  for(i = 0; i < sz; i += PGSIZE){
801068d6:	8b 75 18             	mov    0x18(%ebp),%esi
801068d9:	31 db                	xor    %ebx,%ebx
801068db:	85 f6                	test   %esi,%esi
801068dd:	75 1a                	jne    801068f9 <loaduvm+0x39>
801068df:	eb 7f                	jmp    80106960 <loaduvm+0xa0>
801068e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068e8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068ee:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801068f4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801068f7:	76 67                	jbe    80106960 <loaduvm+0xa0>
801068f9:	8b 45 0c             	mov    0xc(%ebp),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801068fc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106903:	00 
80106904:	01 d8                	add    %ebx,%eax
80106906:	89 44 24 04          	mov    %eax,0x4(%esp)
8010690a:	8b 45 08             	mov    0x8(%ebp),%eax
8010690d:	89 04 24             	mov    %eax,(%esp)
80106910:	e8 1b fc ff ff       	call   80106530 <walkpgdir>
80106915:	85 c0                	test   %eax,%eax
80106917:	74 51                	je     8010696a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80106919:	8b 00                	mov    (%eax),%eax
      n = PGSIZE;
8010691b:	bf 00 10 00 00       	mov    $0x1000,%edi
80106920:	8b 4d 14             	mov    0x14(%ebp),%ecx
    pa = PTE_ADDR(*pte);
80106923:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = PGSIZE;
80106928:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
8010692e:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106931:	05 00 00 00 80       	add    $0x80000000,%eax
80106936:	89 44 24 04          	mov    %eax,0x4(%esp)
8010693a:	8b 45 10             	mov    0x10(%ebp),%eax
8010693d:	01 d9                	add    %ebx,%ecx
8010693f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106943:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106947:	89 04 24             	mov    %eax,(%esp)
8010694a:	e8 41 b0 ff ff       	call   80101990 <readi>
8010694f:	39 f8                	cmp    %edi,%eax
80106951:	74 95                	je     801068e8 <loaduvm+0x28>
}
80106953:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106956:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010695b:	5b                   	pop    %ebx
8010695c:	5e                   	pop    %esi
8010695d:	5f                   	pop    %edi
8010695e:	5d                   	pop    %ebp
8010695f:	c3                   	ret    
80106960:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106963:	31 c0                	xor    %eax,%eax
}
80106965:	5b                   	pop    %ebx
80106966:	5e                   	pop    %esi
80106967:	5f                   	pop    %edi
80106968:	5d                   	pop    %ebp
80106969:	c3                   	ret    
      panic("loaduvm: address should exist");
8010696a:	c7 04 24 af 79 10 80 	movl   $0x801079af,(%esp)
80106971:	e8 ea 99 ff ff       	call   80100360 <panic>
    panic("loaduvm: addr must be page aligned");
80106976:	c7 04 24 50 7a 10 80 	movl   $0x80107a50,(%esp)
8010697d:	e8 de 99 ff ff       	call   80100360 <panic>
80106982:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106990 <allocuvm>:
{
80106990:	55                   	push   %ebp
80106991:	89 e5                	mov    %esp,%ebp
80106993:	57                   	push   %edi
80106994:	56                   	push   %esi
80106995:	53                   	push   %ebx
80106996:	83 ec 2c             	sub    $0x2c,%esp
80106999:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
8010699c:	85 ff                	test   %edi,%edi
8010699e:	0f 88 8f 00 00 00    	js     80106a33 <allocuvm+0xa3>
  if(newsz < oldsz)
801069a4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
801069a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801069aa:	0f 82 85 00 00 00    	jb     80106a35 <allocuvm+0xa5>
  a = PGROUNDUP(oldsz);
801069b0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801069b6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801069bc:	39 df                	cmp    %ebx,%edi
801069be:	77 57                	ja     80106a17 <allocuvm+0x87>
801069c0:	eb 7e                	jmp    80106a40 <allocuvm+0xb0>
801069c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801069c8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801069cf:	00 
801069d0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069d7:	00 
801069d8:	89 04 24             	mov    %eax,(%esp)
801069db:	e8 00 d9 ff ff       	call   801042e0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801069e0:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801069e6:	89 44 24 0c          	mov    %eax,0xc(%esp)
801069ea:	8b 45 08             	mov    0x8(%ebp),%eax
801069ed:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801069f4:	00 
801069f5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801069fc:	00 
801069fd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106a01:	89 04 24             	mov    %eax,(%esp)
80106a04:	e8 67 fc ff ff       	call   80106670 <mappages>
80106a09:	85 c0                	test   %eax,%eax
80106a0b:	78 43                	js     80106a50 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80106a0d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a13:	39 df                	cmp    %ebx,%edi
80106a15:	76 29                	jbe    80106a40 <allocuvm+0xb0>
    mem = kalloc();
80106a17:	e8 b4 ba ff ff       	call   801024d0 <kalloc>
    if(mem == 0){
80106a1c:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106a1e:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106a20:	75 a6                	jne    801069c8 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106a22:	c7 04 24 cd 79 10 80 	movl   $0x801079cd,(%esp)
80106a29:	e8 22 9c ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
80106a2e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106a31:	77 47                	ja     80106a7a <allocuvm+0xea>
      return 0;
80106a33:	31 c0                	xor    %eax,%eax
}
80106a35:	83 c4 2c             	add    $0x2c,%esp
80106a38:	5b                   	pop    %ebx
80106a39:	5e                   	pop    %esi
80106a3a:	5f                   	pop    %edi
80106a3b:	5d                   	pop    %ebp
80106a3c:	c3                   	ret    
80106a3d:	8d 76 00             	lea    0x0(%esi),%esi
80106a40:	83 c4 2c             	add    $0x2c,%esp
80106a43:	89 f8                	mov    %edi,%eax
80106a45:	5b                   	pop    %ebx
80106a46:	5e                   	pop    %esi
80106a47:	5f                   	pop    %edi
80106a48:	5d                   	pop    %ebp
80106a49:	c3                   	ret    
80106a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106a50:	c7 04 24 e5 79 10 80 	movl   $0x801079e5,(%esp)
80106a57:	e8 f4 9b ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
80106a5c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106a5f:	76 0d                	jbe    80106a6e <allocuvm+0xde>
80106a61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106a64:	89 fa                	mov    %edi,%edx
80106a66:	8b 45 08             	mov    0x8(%ebp),%eax
80106a69:	e8 52 fb ff ff       	call   801065c0 <deallocuvm.part.0>
      kfree(mem);
80106a6e:	89 34 24             	mov    %esi,(%esp)
80106a71:	e8 aa b8 ff ff       	call   80102320 <kfree>
      return 0;
80106a76:	31 c0                	xor    %eax,%eax
80106a78:	eb bb                	jmp    80106a35 <allocuvm+0xa5>
80106a7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106a7d:	89 fa                	mov    %edi,%edx
80106a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80106a82:	e8 39 fb ff ff       	call   801065c0 <deallocuvm.part.0>
      return 0;
80106a87:	31 c0                	xor    %eax,%eax
80106a89:	eb aa                	jmp    80106a35 <allocuvm+0xa5>
80106a8b:	90                   	nop
80106a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a90 <deallocuvm>:
{
80106a90:	55                   	push   %ebp
80106a91:	89 e5                	mov    %esp,%ebp
80106a93:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a96:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106a99:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106a9c:	39 d1                	cmp    %edx,%ecx
80106a9e:	73 08                	jae    80106aa8 <deallocuvm+0x18>
}
80106aa0:	5d                   	pop    %ebp
80106aa1:	e9 1a fb ff ff       	jmp    801065c0 <deallocuvm.part.0>
80106aa6:	66 90                	xchg   %ax,%ax
80106aa8:	89 d0                	mov    %edx,%eax
80106aaa:	5d                   	pop    %ebp
80106aab:	c3                   	ret    
80106aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ab0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106ab0:	55                   	push   %ebp
80106ab1:	89 e5                	mov    %esp,%ebp
80106ab3:	56                   	push   %esi
80106ab4:	53                   	push   %ebx
80106ab5:	83 ec 10             	sub    $0x10,%esp
80106ab8:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106abb:	85 f6                	test   %esi,%esi
80106abd:	74 59                	je     80106b18 <freevm+0x68>
80106abf:	31 c9                	xor    %ecx,%ecx
80106ac1:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106ac6:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ac8:	31 db                	xor    %ebx,%ebx
80106aca:	e8 f1 fa ff ff       	call   801065c0 <deallocuvm.part.0>
80106acf:	eb 12                	jmp    80106ae3 <freevm+0x33>
80106ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ad8:	83 c3 01             	add    $0x1,%ebx
80106adb:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106ae1:	74 27                	je     80106b0a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106ae3:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106ae6:	f6 c2 01             	test   $0x1,%dl
80106ae9:	74 ed                	je     80106ad8 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106aeb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(i = 0; i < NPDENTRIES; i++){
80106af1:	83 c3 01             	add    $0x1,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106af4:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106afa:	89 14 24             	mov    %edx,(%esp)
80106afd:	e8 1e b8 ff ff       	call   80102320 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80106b02:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106b08:	75 d9                	jne    80106ae3 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
80106b0a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106b0d:	83 c4 10             	add    $0x10,%esp
80106b10:	5b                   	pop    %ebx
80106b11:	5e                   	pop    %esi
80106b12:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106b13:	e9 08 b8 ff ff       	jmp    80102320 <kfree>
    panic("freevm: no pgdir");
80106b18:	c7 04 24 01 7a 10 80 	movl   $0x80107a01,(%esp)
80106b1f:	e8 3c 98 ff ff       	call   80100360 <panic>
80106b24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106b30 <setupkvm>:
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	56                   	push   %esi
80106b34:	53                   	push   %ebx
80106b35:	83 ec 20             	sub    $0x20,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
80106b38:	e8 93 b9 ff ff       	call   801024d0 <kalloc>
80106b3d:	85 c0                	test   %eax,%eax
80106b3f:	89 c6                	mov    %eax,%esi
80106b41:	74 75                	je     80106bb8 <setupkvm+0x88>
  memset(pgdir, 0, PGSIZE);
80106b43:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b4a:	00 
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106b4b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106b50:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b57:	00 
80106b58:	89 04 24             	mov    %eax,(%esp)
80106b5b:	e8 80 d7 ff ff       	call   801042e0 <memset>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106b60:	8b 53 0c             	mov    0xc(%ebx),%edx
80106b63:	8b 43 04             	mov    0x4(%ebx),%eax
80106b66:	89 34 24             	mov    %esi,(%esp)
80106b69:	89 54 24 10          	mov    %edx,0x10(%esp)
80106b6d:	8b 53 08             	mov    0x8(%ebx),%edx
80106b70:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106b74:	29 c2                	sub    %eax,%edx
80106b76:	8b 03                	mov    (%ebx),%eax
80106b78:	89 54 24 08          	mov    %edx,0x8(%esp)
80106b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b80:	e8 eb fa ff ff       	call   80106670 <mappages>
80106b85:	85 c0                	test   %eax,%eax
80106b87:	78 17                	js     80106ba0 <setupkvm+0x70>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106b89:	83 c3 10             	add    $0x10,%ebx
80106b8c:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106b92:	72 cc                	jb     80106b60 <setupkvm+0x30>
80106b94:	89 f0                	mov    %esi,%eax
}
80106b96:	83 c4 20             	add    $0x20,%esp
80106b99:	5b                   	pop    %ebx
80106b9a:	5e                   	pop    %esi
80106b9b:	5d                   	pop    %ebp
80106b9c:	c3                   	ret    
80106b9d:	8d 76 00             	lea    0x0(%esi),%esi
      freevm(pgdir);
80106ba0:	89 34 24             	mov    %esi,(%esp)
80106ba3:	e8 08 ff ff ff       	call   80106ab0 <freevm>
}
80106ba8:	83 c4 20             	add    $0x20,%esp
      return 0;
80106bab:	31 c0                	xor    %eax,%eax
}
80106bad:	5b                   	pop    %ebx
80106bae:	5e                   	pop    %esi
80106baf:	5d                   	pop    %ebp
80106bb0:	c3                   	ret    
80106bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106bb8:	31 c0                	xor    %eax,%eax
80106bba:	eb da                	jmp    80106b96 <setupkvm+0x66>
80106bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106bc0 <kvmalloc>:
{
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106bc6:	e8 65 ff ff ff       	call   80106b30 <setupkvm>
80106bcb:	a3 a4 56 11 80       	mov    %eax,0x801156a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106bd0:	05 00 00 00 80       	add    $0x80000000,%eax
80106bd5:	0f 22 d8             	mov    %eax,%cr3
}
80106bd8:	c9                   	leave  
80106bd9:	c3                   	ret    
80106bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106be0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106be0:	55                   	push   %ebp
80106be1:	89 e5                	mov    %esp,%ebp
80106be3:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106be6:	8b 45 0c             	mov    0xc(%ebp),%eax
80106be9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106bf0:	00 
80106bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bf5:	8b 45 08             	mov    0x8(%ebp),%eax
80106bf8:	89 04 24             	mov    %eax,(%esp)
80106bfb:	e8 30 f9 ff ff       	call   80106530 <walkpgdir>
  if(pte == 0)
80106c00:	85 c0                	test   %eax,%eax
80106c02:	74 05                	je     80106c09 <clearpteu+0x29>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106c04:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106c07:	c9                   	leave  
80106c08:	c3                   	ret    
    panic("clearpteu");
80106c09:	c7 04 24 12 7a 10 80 	movl   $0x80107a12,(%esp)
80106c10:	e8 4b 97 ff ff       	call   80100360 <panic>
80106c15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c20 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106c20:	55                   	push   %ebp
80106c21:	89 e5                	mov    %esp,%ebp
80106c23:	57                   	push   %edi
80106c24:	56                   	push   %esi
80106c25:	53                   	push   %ebx
80106c26:	83 ec 2c             	sub    $0x2c,%esp
    pde_t *d;
    pte_t *pte;
    uint pa, i, flags;
    char *mem;

    if((d = setupkvm()) == 0)
80106c29:	e8 02 ff ff ff       	call   80106b30 <setupkvm>
80106c2e:	85 c0                	test   %eax,%eax
80106c30:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106c33:	0f 84 d5 01 00 00    	je     80106e0e <copyuvm+0x1ee>
        return 0;
    for(i = 0; i < sz; i += PGSIZE){
80106c39:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c3c:	85 c0                	test   %eax,%eax
80106c3e:	0f 84 bc 00 00 00    	je     80106d00 <copyuvm+0xe0>
80106c44:	31 db                	xor    %ebx,%ebx
80106c46:	eb 51                	jmp    80106c99 <copyuvm+0x79>
            panic("copyuvm: page not present");
        pa = PTE_ADDR(*pte);
        flags = PTE_FLAGS(*pte);
        if((mem = kalloc()) == 0)
            goto bad;
        memmove(mem, (char*)P2V(pa), PGSIZE);
80106c48:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106c4e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c55:	00 
80106c56:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106c5a:	89 04 24             	mov    %eax,(%esp)
80106c5d:	e8 1e d7 ff ff       	call   80104380 <memmove>
        if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106c62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c65:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106c6b:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106c6f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c76:	00 
80106c77:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106c7b:	89 44 24 10          	mov    %eax,0x10(%esp)
80106c7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c82:	89 04 24             	mov    %eax,(%esp)
80106c85:	e8 e6 f9 ff ff       	call   80106670 <mappages>
80106c8a:	85 c0                	test   %eax,%eax
80106c8c:	78 58                	js     80106ce6 <copyuvm+0xc6>
    for(i = 0; i < sz; i += PGSIZE){
80106c8e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c94:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106c97:	76 67                	jbe    80106d00 <copyuvm+0xe0>
        if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106c99:	8b 45 08             	mov    0x8(%ebp),%eax
80106c9c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106ca3:	00 
80106ca4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106ca8:	89 04 24             	mov    %eax,(%esp)
80106cab:	e8 80 f8 ff ff       	call   80106530 <walkpgdir>
80106cb0:	85 c0                	test   %eax,%eax
80106cb2:	0f 84 5d 01 00 00    	je     80106e15 <copyuvm+0x1f5>
        if(!(*pte & PTE_P))
80106cb8:	8b 30                	mov    (%eax),%esi
80106cba:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106cc0:	0f 84 5b 01 00 00    	je     80106e21 <copyuvm+0x201>
        pa = PTE_ADDR(*pte);
80106cc6:	89 f7                	mov    %esi,%edi
        flags = PTE_FLAGS(*pte);
80106cc8:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106cce:	89 75 e4             	mov    %esi,-0x1c(%ebp)
        pa = PTE_ADDR(*pte);
80106cd1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
        if((mem = kalloc()) == 0)
80106cd7:	e8 f4 b7 ff ff       	call   801024d0 <kalloc>
80106cdc:	85 c0                	test   %eax,%eax
80106cde:	89 c6                	mov    %eax,%esi
80106ce0:	0f 85 62 ff ff ff    	jne    80106c48 <copyuvm+0x28>
        goto bad;
    clearpteu(pgdir, (char *)(i) );
  return d;

bad:
  freevm(d);
80106ce6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ce9:	89 04 24             	mov    %eax,(%esp)
80106cec:	e8 bf fd ff ff       	call   80106ab0 <freevm>
  return 0;
80106cf1:	31 c0                	xor    %eax,%eax
}
80106cf3:	83 c4 2c             	add    $0x2c,%esp
80106cf6:	5b                   	pop    %ebx
80106cf7:	5e                   	pop    %esi
80106cf8:	5f                   	pop    %edi
80106cf9:	5d                   	pop    %ebp
80106cfa:	c3                   	ret    
80106cfb:	90                   	nop
80106cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct proc *curproc = myproc();
80106d00:	e8 cb c9 ff ff       	call   801036d0 <myproc>
80106d05:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for(i = u; i > u - (curproc->stack_pages) * PGSIZE; i -= PGSIZE){
80106d08:	8b 40 7c             	mov    0x7c(%eax),%eax
80106d0b:	f7 d8                	neg    %eax
80106d0d:	c1 e0 0c             	shl    $0xc,%eax
80106d10:	05 00 f0 ff 7f       	add    $0x7ffff000,%eax
80106d15:	3d ff ef ff 7f       	cmp    $0x7fffefff,%eax
80106d1a:	0f 87 0d 01 00 00    	ja     80106e2d <copyuvm+0x20d>
80106d20:	bb 00 f0 ff 7f       	mov    $0x7ffff000,%ebx
80106d25:	eb 65                	jmp    80106d8c <copyuvm+0x16c>
80106d27:	90                   	nop
        memmove(mem, (char*)P2V(pa), PGSIZE);
80106d28:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106d2e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106d35:	00 
80106d36:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106d3a:	89 04 24             	mov    %eax,(%esp)
80106d3d:	e8 3e d6 ff ff       	call   80104380 <memmove>
        if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106d42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d45:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106d4b:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106d4f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106d56:	00 
80106d57:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106d5b:	89 44 24 10          	mov    %eax,0x10(%esp)
80106d5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d62:	89 04 24             	mov    %eax,(%esp)
80106d65:	e8 06 f9 ff ff       	call   80106670 <mappages>
80106d6a:	85 c0                	test   %eax,%eax
80106d6c:	0f 88 74 ff ff ff    	js     80106ce6 <copyuvm+0xc6>
    for(i = u; i > u - (curproc->stack_pages) * PGSIZE; i -= PGSIZE){
80106d72:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106d75:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106d7b:	8b 40 7c             	mov    0x7c(%eax),%eax
80106d7e:	f7 d8                	neg    %eax
80106d80:	c1 e0 0c             	shl    $0xc,%eax
80106d83:	05 00 f0 ff 7f       	add    $0x7ffff000,%eax
80106d88:	39 d8                	cmp    %ebx,%eax
80106d8a:	73 4a                	jae    80106dd6 <copyuvm+0x1b6>
        if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106d8c:	8b 45 08             	mov    0x8(%ebp),%eax
80106d8f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106d96:	00 
80106d97:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106d9b:	89 04 24             	mov    %eax,(%esp)
80106d9e:	e8 8d f7 ff ff       	call   80106530 <walkpgdir>
80106da3:	85 c0                	test   %eax,%eax
80106da5:	74 6e                	je     80106e15 <copyuvm+0x1f5>
        if(!(*pte & PTE_P))
80106da7:	8b 30                	mov    (%eax),%esi
80106da9:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106daf:	74 70                	je     80106e21 <copyuvm+0x201>
        pa = PTE_ADDR(*pte);
80106db1:	89 f7                	mov    %esi,%edi
        flags = PTE_FLAGS(*pte);
80106db3:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106db9:	89 75 e4             	mov    %esi,-0x1c(%ebp)
        pa = PTE_ADDR(*pte);
80106dbc:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
        if((mem = kalloc()) == 0)
80106dc2:	e8 09 b7 ff ff       	call   801024d0 <kalloc>
80106dc7:	85 c0                	test   %eax,%eax
80106dc9:	89 c6                	mov    %eax,%esi
80106dcb:	0f 85 57 ff ff ff    	jne    80106d28 <copyuvm+0x108>
80106dd1:	e9 10 ff ff ff       	jmp    80106ce6 <copyuvm+0xc6>
80106dd6:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
    if(allocuvm(pgdir, i + PGSIZE, i) == 0)
80106ddc:	89 44 24 04          	mov    %eax,0x4(%esp)
80106de0:	8b 45 08             	mov    0x8(%ebp),%eax
80106de3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80106de7:	89 04 24             	mov    %eax,(%esp)
80106dea:	e8 a1 fb ff ff       	call   80106990 <allocuvm>
80106def:	85 c0                	test   %eax,%eax
80106df1:	0f 84 ef fe ff ff    	je     80106ce6 <copyuvm+0xc6>
    clearpteu(pgdir, (char *)(i) );
80106df7:	8b 45 08             	mov    0x8(%ebp),%eax
80106dfa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106dfe:	89 04 24             	mov    %eax,(%esp)
80106e01:	e8 da fd ff ff       	call   80106be0 <clearpteu>
  return d;
80106e06:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e09:	e9 e5 fe ff ff       	jmp    80106cf3 <copyuvm+0xd3>
        return 0;
80106e0e:	31 c0                	xor    %eax,%eax
80106e10:	e9 de fe ff ff       	jmp    80106cf3 <copyuvm+0xd3>
            panic("copyuvm: pte should exist");
80106e15:	c7 04 24 1c 7a 10 80 	movl   $0x80107a1c,(%esp)
80106e1c:	e8 3f 95 ff ff       	call   80100360 <panic>
            panic("copyuvm: page not present");
80106e21:	c7 04 24 36 7a 10 80 	movl   $0x80107a36,(%esp)
80106e28:	e8 33 95 ff ff       	call   80100360 <panic>
    for(i = u; i > u - (curproc->stack_pages) * PGSIZE; i -= PGSIZE){
80106e2d:	b8 00 00 00 80       	mov    $0x80000000,%eax
80106e32:	bb 00 f0 ff 7f       	mov    $0x7ffff000,%ebx
80106e37:	eb a3                	jmp    80106ddc <copyuvm+0x1bc>
80106e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e40 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e46:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e49:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106e50:	00 
80106e51:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e55:	8b 45 08             	mov    0x8(%ebp),%eax
80106e58:	89 04 24             	mov    %eax,(%esp)
80106e5b:	e8 d0 f6 ff ff       	call   80106530 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106e60:	8b 00                	mov    (%eax),%eax
80106e62:	89 c2                	mov    %eax,%edx
80106e64:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106e67:	83 fa 05             	cmp    $0x5,%edx
80106e6a:	75 0c                	jne    80106e78 <uva2ka+0x38>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106e6c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e71:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106e76:	c9                   	leave  
80106e77:	c3                   	ret    
    return 0;
80106e78:	31 c0                	xor    %eax,%eax
}
80106e7a:	c9                   	leave  
80106e7b:	c3                   	ret    
80106e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e80 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	57                   	push   %edi
80106e84:	56                   	push   %esi
80106e85:	53                   	push   %ebx
80106e86:	83 ec 1c             	sub    $0x1c,%esp
80106e89:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106e8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e8f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106e92:	85 db                	test   %ebx,%ebx
80106e94:	75 3a                	jne    80106ed0 <copyout+0x50>
80106e96:	eb 68                	jmp    80106f00 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106e98:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e9b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106e9d:	89 7c 24 04          	mov    %edi,0x4(%esp)
    n = PGSIZE - (va - va0);
80106ea1:	29 ca                	sub    %ecx,%edx
80106ea3:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106ea9:	39 da                	cmp    %ebx,%edx
80106eab:	0f 47 d3             	cmova  %ebx,%edx
    memmove(pa0 + (va - va0), buf, n);
80106eae:	29 f1                	sub    %esi,%ecx
80106eb0:	01 c8                	add    %ecx,%eax
80106eb2:	89 54 24 08          	mov    %edx,0x8(%esp)
80106eb6:	89 04 24             	mov    %eax,(%esp)
80106eb9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106ebc:	e8 bf d4 ff ff       	call   80104380 <memmove>
    len -= n;
    buf += n;
80106ec1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106ec4:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    buf += n;
80106eca:	01 d7                	add    %edx,%edi
  while(len > 0){
80106ecc:	29 d3                	sub    %edx,%ebx
80106ece:	74 30                	je     80106f00 <copyout+0x80>
    pa0 = uva2ka(pgdir, (char*)va0);
80106ed0:	8b 45 08             	mov    0x8(%ebp),%eax
    va0 = (uint)PGROUNDDOWN(va);
80106ed3:	89 ce                	mov    %ecx,%esi
80106ed5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106edb:	89 74 24 04          	mov    %esi,0x4(%esp)
    va0 = (uint)PGROUNDDOWN(va);
80106edf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106ee2:	89 04 24             	mov    %eax,(%esp)
80106ee5:	e8 56 ff ff ff       	call   80106e40 <uva2ka>
    if(pa0 == 0)
80106eea:	85 c0                	test   %eax,%eax
80106eec:	75 aa                	jne    80106e98 <copyout+0x18>
  }
  return 0;
}
80106eee:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106ef1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ef6:	5b                   	pop    %ebx
80106ef7:	5e                   	pop    %esi
80106ef8:	5f                   	pop    %edi
80106ef9:	5d                   	pop    %ebp
80106efa:	c3                   	ret    
80106efb:	90                   	nop
80106efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f00:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106f03:	31 c0                	xor    %eax,%eax
}
80106f05:	5b                   	pop    %ebx
80106f06:	5e                   	pop    %esi
80106f07:	5f                   	pop    %edi
80106f08:	5d                   	pop    %ebp
80106f09:	c3                   	ret    
80106f0a:	66 90                	xchg   %ax,%ax
80106f0c:	66 90                	xchg   %ax,%ax
80106f0e:	66 90                	xchg   %ax,%ax

80106f10 <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
80106f10:	55                   	push   %ebp
80106f11:	89 e5                	mov    %esp,%ebp
80106f13:	83 ec 18             	sub    $0x18,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
80106f16:	c7 44 24 04 74 7a 10 	movl   $0x80107a74,0x4(%esp)
80106f1d:	80 
80106f1e:	c7 04 24 c0 56 11 80 	movl   $0x801156c0,(%esp)
80106f25:	e8 86 d1 ff ff       	call   801040b0 <initlock>
  acquire(&(shm_table.lock));
80106f2a:	c7 04 24 c0 56 11 80 	movl   $0x801156c0,(%esp)
80106f31:	e8 6a d2 ff ff       	call   801041a0 <acquire>
80106f36:	b8 f4 56 11 80       	mov    $0x801156f4,%eax
80106f3b:	90                   	nop
80106f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
80106f40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106f46:	83 c0 0c             	add    $0xc,%eax
    shm_table.shm_pages[i].frame =0;
80106f49:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    shm_table.shm_pages[i].refcnt =0;
80106f50:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for (i = 0; i< 64; i++) {
80106f57:	3d f4 59 11 80       	cmp    $0x801159f4,%eax
80106f5c:	75 e2                	jne    80106f40 <shminit+0x30>
  }
  release(&(shm_table.lock));
80106f5e:	c7 04 24 c0 56 11 80 	movl   $0x801156c0,(%esp)
80106f65:	e8 26 d3 ff ff       	call   80104290 <release>
}
80106f6a:	c9                   	leave  
80106f6b:	c3                   	ret    
80106f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f70 <shm_open>:

int shm_open(int id, char **pointer) {
80106f70:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106f71:	31 c0                	xor    %eax,%eax
int shm_open(int id, char **pointer) {
80106f73:	89 e5                	mov    %esp,%ebp
}
80106f75:	5d                   	pop    %ebp
80106f76:	c3                   	ret    
80106f77:	89 f6                	mov    %esi,%esi
80106f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f80 <shm_close>:


int shm_close(int id) {
80106f80:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106f81:	31 c0                	xor    %eax,%eax
int shm_close(int id) {
80106f83:	89 e5                	mov    %esp,%ebp
}
80106f85:	5d                   	pop    %ebp
80106f86:	c3                   	ret    
