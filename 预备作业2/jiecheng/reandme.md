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



依照上述c 语言代码编写其汇编语言版本。
小组成员依据实验指导要求，将全局变量，常量%d和函数factorial写成汇编代码形式，然后在 main主 程序段中调用scanf、factorial、printf 等函数实现对阶乘程序的输入输出，具体arm程序如下。

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

