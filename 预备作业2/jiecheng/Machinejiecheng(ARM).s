i:
        .word   2
f:
        .word   1
n:
factorial(int):
        push    {r7}
        sub     sp, sp, #12
        add     r7, sp, #0
        str     r0, [r7, #4]
        ldr     r3, [r7, #4]
        cmp     r3, #0
        bge     .L4
        mov     r3, #-1
        b       .L3
.L5:
        movw    r3, #:lower16:f
        movt    r3, #:upper16:f
        ldr     r2, [r3]
        movw    r3, #:lower16:i
        movt    r3, #:upper16:i
        ldr     r3, [r3]
        mul     r2, r3, r2
        movw    r3, #:lower16:f
        movt    r3, #:upper16:f
        str     r2, [r3]
        movw    r3, #:lower16:i
        movt    r3, #:upper16:i
        ldr     r3, [r3]
        adds    r2, r3, #1
        movw    r3, #:lower16:i
        movt    r3, #:upper16:i
        str     r2, [r3]
.L4:
        movw    r3, #:lower16:i
        movt    r3, #:upper16:i
        ldr     r3, [r3]
        ldr     r2, [r7, #4]
        cmp     r2, r3
        bge     .L5
        movw    r3, #:lower16:f
        movt    r3, #:upper16:f
        ldr     r3, [r3]
.L3:
        mov     r0, r3
        adds    r7, r7, #12
        mov     sp, r7
        ldr     r7, [sp], #4
        bx      lr
.LC0:
        .ascii  "%d\000"
main:
        push    {r7, lr}
        add     r7, sp, #0
        movw    r1, #:lower16:n
        movt    r1, #:upper16:n
        movw    r0, #:lower16:.LC0
        movt    r0, #:upper16:.LC0
        bl      __isoc99_scanf
        movw    r3, #:lower16:n
        movt    r3, #:upper16:n
        ldr     r3, [r3]
        mov     r0, r3
        bl      factorial(int)
        mov     r2, r0
        movw    r3, #:lower16:n
        movt    r3, #:upper16:n
        str     r2, [r3]
        movw    r3, #:lower16:n
        movt    r3, #:upper16:n
        ldr     r3, [r3]
        mov     r1, r3
        movw    r0, #:lower16:.LC0
        movt    r0, #:upper16:.LC0
        bl      printf
        movs    r3, #0
        mov     r0, r3
        pop     {r7, pc}