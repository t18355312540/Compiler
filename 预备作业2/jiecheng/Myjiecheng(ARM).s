#赋值全局变量
i:
        .word   2
f:
        .word   1
n:
        .zero   4
#定义factorial函数
factorial(int):
#为函数分配16个字节长度的栈帧内存。
        sub     sp, sp, #16
        str     w0, [sp, 12]
        ldr     w0, [sp, 12]
        #if (n < 0)
        cmp     w0, 0
        bge     .L4
        #return -1;
        mov     w0, -1
        b       .L3
.L5:
        adrp    x0, f
        add     x0, x0, :lo12:f
        ldr     w1, [x0]
        adrp    x0, i
        add     x0, x0, :lo12:i
        #f = f * i;
        ldr     w0, [x0]
        mul     w1, w1, w0
        adrp    x0, f
        add     x0, x0, :lo12:f
        str     w1, [x0]
        adrp    x0, i
        add     x0, x0, :lo12:i
        #i = i + 1;
        ldr     w0, [x0]
        add     w1, w0, 1
        adrp    x0, i
        add     x0, x0, :lo12:i
        str     w1, [x0]
.L4:
		#x0寄存器赋值成i，并放在w0中保存
        adrp    x0, i
        add     x0, x0, :lo12:i
        ldr     w0, [x0]
        #w1保存n的值
        ldr     w1, [sp, 12]
        #i<=n
        cmp     w1, w0
        #满足条件，跳转至L5段
        bge     .L5
        #不满足条件，函数返回f值
        adrp    x0, f
        add     x0, x0, :lo12:f
        ldr     w0, [x0]
.L3:
        add     sp, sp, 16
        ret
#保存全局变量%d
.LC0:
        .string "%d"
main:
		 #传入LC0段的值，调用scanf函数输入n的值
        stp     x29, x30, [sp, -16]!
        add     x29, sp, 0
        adrp    x0, n
        add     x1, x0, :lo12:n
        adrp    x0, .LC0
        add     x0, x0, :lo12:.LC0
        bl      scanf
        #w0储存n的值传入并调用factorial函数
        adrp    x0, n
        add     x0, x0, :lo12:n
        ldr     w0, [x0]
        bl      factorial(int)
        #给n赋值factorial的返回值
        mov     w1, w0
        adrp    x0, n
        add     x0, x0, :lo12:n
        str     w1, [x0]
        adrp    x0, n
        #传入%d,n并调用printf函数输出
        add     x0, x0, :lo12:n
        ldr     w1, [x0]
        adrp    x0, .LC0
        add     x0, x0, :lo12:.LC0
        bl      printf
        #return
        mov     w0, 0
        ldp     x29, x30, [sp], 16
        ret