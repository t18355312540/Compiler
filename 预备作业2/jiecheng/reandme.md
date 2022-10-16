对于预备工作 1 中的阶乘程序进行该改写来体现体现C语言中 的阶乘特性，并考虑了相关的边界情况。主要改动是将变量均改变成全局变量，阶乘使用factorial函数进行计算，main函数仅负责输入输出。改写后的C代码如下：

```c
#include <stdio.h>
int i = 2, f = 1;
int n=0;
int factorial(int n)
{
    
    if (n < 0)
        return -1;
    while (i <= n)
    {
        f = f * i;
        i = i + 1;
    }
    return f;
}

int main()
{
    scanf("%d", &n);
    n = factorial(n);
    printf("%d", n);
    return 0;
}
```



依照上述c 语言代码编写其汇编语言版本,分为X86体系的AT&T汇编和ARM体系下的arm汇编两种方式进行实验。

#### arm汇编

小组成员依据实验指导要求，在arm汇编中出于编程方便，将涉及的参数f、i、n定义为全局变量，提取出常量%d，将程序主体部分专门写成一个函数factorial在 main主 程序段中调用scanf、factorial、printf 等函数实现对阶乘程序的输入输出，其中编写的arm汇编程序如下。

```
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
```



小组成员也通过gcc编译器输出了arm汇编代码如下：

```
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
```

不难看出，gcc输出的ARM汇编程序在分段和跳转等重要程序步骤和小组成员手工编写的汇编程序表现一直。存在一些细节上的差异，如小组成员编写的汇编程序为函数分配16个字节长度的栈帧内存，而gcc输出的ARM汇编程序为函数分配12个字节长度的栈帧内存。小组成员使用到了W0、W1等ARM64下新增的的32位零寄存器，而gcc输出的ARM汇编程序只使用了传统的r0、r1、r2等传统ARM32位寄存器。在函数调用这一方面，小组成员对于scanf函数直接调用scanf进行输入，而 gcc输出的ARM汇编程序对于scantf的调用处理上有所不同，使用__isoc99_scanf函数进行输入。除此之外在寄存器 的使用方面也存在一些差异等。

#### AT&T汇编

小组成员依据实验指导要求，将全局变量，常量%d和函数factorial写成汇编代码形式，然后在 main主 程序段中调用scanf、factorial、printf 等函数实现对阶乘程序的输入输出，同样实现了X86体系下的AT&T汇编代码，具体程序如下。

```
# 函数 factorial
	.text
	.globl	factorial
	.type	factorial, @function
factorial:
	# if n<=0
   	 movl n, %eax
     cmpl $0, %eax
   	 jl L2
    #while (i <= n)
	movl i, %ebx
	cmpl %ebx,%eax
	jle L3
	ret
  	#return -1;
      L2:  
               movl -1(%esp), %eax
               ret
    #f=f*i  i++
       L3:  movl f, %eax
             movl 4(%esp), %ebx
             imull 8(%esp), %eax
             addl $1, i

# 常量
    .section .rodata
STR0:
    .string "%d"
# 全局变量 将f、i、n均设为全局变量
	.globl	f
	.data
	.align 4
	.type	f, @object
	.size	f, 4
f:
	.long	i

	.globl	i
	.data
	.align 4
	.type	i, @object
	.size	i, 4
i:
	.long	2

	.globl	n
	.data
	.align 4
	.type	n, @object
	.size	n, 4
n:
	.long	0
# 主函数
    .text
    .globl main
    .type main, @function
main:
# scanf("%d", &n);
    pushl $n
    pushl $STR0
    call scanf
    addl $8, %esp
#n = factorial(n);
	pushl n
	call factorial
    	addl $8, %esp
# printf("%d", n);
	pushl n
    	pushl $STR0
    	call printf
    	addl $8, %esp
# return 0;
 	 xorl %eax, %eax
    	ret
# 可执行堆栈段
    .section .note.GNU-stack,"",@progbits

```

其中编写汇编代码过程中最初遇到错误出现错误，因此考虑将全局变量不能放置在汇编程序开头单独声明为全局标识符，并使用.long 标签对 32 位整型变量进行初始化，同时加上.global 标识符将该变量设为全局变量，便于后续代码调用。

小组成员也对jiecheng程序使用gcc -s命令输出了gcc的编译结果，经过比较后发现， gcc 的汇编代码更长，且加入了更多的编译器标记。在代码逻辑上与小组成员编写的代码基本一致，但进行了相关的优化。值得注意的是gcc编译出的汇编代码在程序结束返回部分额外增加了堆栈完整性检查，因此gcc给出的汇编程序存在两个 ret 指令，分别是正常返回（return 0）和堆栈异常时的返回。

```
.file	"jiecheng.c"
.text
.globl	factorial
.type	factorial, @function

factorial:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)
	movl	$2, -8(%rbp)
	movl	$1, -4(%rbp)
	cmpl	$0, -20(%rbp)
	jns	.L4
	movl	$-1, %eax
	jmp	.L3
.L5:
	movl	-4(%rbp), %eax
	imull	-8(%rbp), %eax
	movl	%eax, -4(%rbp)
	addl	$1, -8(%rbp)
.L4:
	movl	-8(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jle	.L5
	movl	-4(%rbp), %eax
.L3:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	factorial, .-factorial
	.section	.rodata
.LC0:
	.string	"%d"
	.text
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-12(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	movl	-12(%rbp), %eax
	movl	%eax, %edi
	call	factorial
	movl	%eax, -12(%rbp)
	movl	-12(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	xorq	%fs:40, %rdx
	je	.L8
	call	__stack_chk_fail@PLT
.L8:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
```

