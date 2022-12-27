// Thanks to https://github.com/below/HelloSilicon for the M2-compatible macros!

#include <sys/syscall.h>

.equ	O_CREAT,	0x00000200
.equ	O_WRONLY,	1
.equ	O_RDONLY,	0
.equ	S_RDWR,		0666
.equ	AT_FDCWD,	-2

.macro	readFile	fd, buffer, length
		mov			x0, \fd
		adrp		x1, \buffer@PAGE
		add			x1, x1, \buffer@PAGEOFF
		mov			x2, #\length
		mov			x16, #SYS_read
		svc			#0x80
.endm

.macro	writeFile	fd, buffer, length
		mov			x0, \fd
		adrp		x1, \buffer@PAGE
		add			x1, x1, \buffer@PAGEOFF
		mov			x2, \length
		mov			x16, #SYS_write
		svc			#0x80
.endm

.macro	flushClose	fd
		mov			x0, \fd
		mov			x16, #SYS_fsync
		svc			#0x80
		mov			x0, \fd
		mov			x16, #SYS_close
		svc			#0x80
.endm

.equ	BUFFERLEN,	1

.global	_start
.align	4
_start:	mov 		x7, #2 						// Account for \n and null read
		mov 		x8, #0 						// TODO: offset
		mov			x12, x1  					// Save off argv

		ldr 		x15, [x1, 16]
		ldrb 		w15, [x15] 					// w15 is the ARGV[1] "part"

		mov 		x0, #AT_FDCWD 				// Open the input file
		ldr 		x1, [x12, 8]
		mov 		x2, O_RDONLY
		mov 		x3, #S_RDWR
		mov 		x16, #SYS_openat
		svc 		#0x80

		mov 		x11, x0 					// Save off the fd

		adrp  		x14, buffer@PAGE
		add  		x14, x14, buffer@PAGEOFF

loop: 	readFile 	x11, buffer, BUFFERLEN
		add 		x8, x8, #1
		ldrb 		w6, [x14]
		cmp 		w6, #'('
		b.eq 		up
		add 		x7, x7, #-1
		b 			cont	

up:		add 		x7, x7, #1

cont:	mov 		x10, x0
		cmp 		x7, #1
		b.eq 		part2

part1:	cmp 		x10, #BUFFERLEN
		b.eq 		loop
		b 			answer

part2: 	cmp 		w15, #'2'
		b.ne 		part1
		mov 		x7, x8

answer:	mov 		x10, #10
		mov 		x9, #0

		// If the number is negative, print '-' and make it positive
		cmp 		x7, #0
		bge 		digits
		mov 		x8, #-1
		mul 		x7, x7, x8
		mov 		x13, #0x2d
		str 		x13, [x14]
		writeFile 	#1, buffer, #1

digits:	add 		x9, x9, #1
		udiv 		x8, x7, x10
		msub 		x11, x8, x10, x7
		mov 		x7, x8
		str 		x11, [sp, #-16]!
		cmp 		x7, #0
		b.ne 		digits

print: 	ldr 		x7, [sp], #16
		add 		x7, x7, #'0'
		str 		x7, [x14]
		writeFile 	#1, buffer, #1
		add 		x9, x9, #-1
		cmp 		x9, #0
		b.ne 		print

		// Write out a newline
		mov 		x13, #0x0a
		str 		x13, [x14]
		writeFile 	#1, buffer, #1

done:	flushClose 	x11
		mov 		x0, #1
		mov 		x16, #SYS_fsync
		svc 		#0x80

exit:	mov 		x0, #0
		mov 		x16, #1
		svc 		#0x80

.data
buffer: .fill BUFFERLEN + 1, 1, 0
