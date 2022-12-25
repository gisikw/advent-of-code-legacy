.text
message1:
  .asciz "Part 1 not yet implemented\n"
len1 = . - message1
message2:
  .asciz "Part 2 not yet implemented\n"
len2 = . - message2

.global _start
_start:
    // x1 holds argv to start
    ldr x11, [x1, 16]   // x1 is a pointer of pointers of 8 length, select argv[2]
    ldrb w11, [x11]     // load a 32-bit word into register 11, from the pointer
    sub w11, w11, #'0'  // subtract the ascii value for "0"
    cmp w11, #2         // are we left with 2?
    b.eq part2

    part1:
      mov x0, #1        // x0 = STDOUT file descriptor
      adr x1, message1  // x1 = the message pointer
      mov x2, len1      // x2 = the message length
      mov x16, #4       // syscall number for "write"
      svc 0             // do the syscall
      b end

    part2:
      mov x0, #1        // x0 = STDOUT file descriptor
      adr x1, message2  // x1 = the message pointer
      mov x2, len2      // x2 = the message length
      mov x16, #4       // syscall number for "write"
      svc 0             // do the syscall

    end:
        mov x0, #0      // x0 = exit status
        mov x16, #1    // x8 = syscall number for "exit"
        svc 0         // invoke syscall
