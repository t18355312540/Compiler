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
