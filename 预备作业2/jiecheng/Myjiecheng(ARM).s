#��ֵȫ�ֱ���
i:
        .word   2
f:
        .word   1
n:
        .zero   4
#����factorial����
factorial(int):
#Ϊ��������16���ֽڳ��ȵ�ջ֡�ڴ档
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
		#x0�Ĵ�����ֵ��i��������w0�б���
        adrp    x0, i
        add     x0, x0, :lo12:i
        ldr     w0, [x0]
        #w1����n��ֵ
        ldr     w1, [sp, 12]
        #i<=n
        cmp     w1, w0
        #������������ת��L5��
        bge     .L5
        #��������������������fֵ
        adrp    x0, f
        add     x0, x0, :lo12:f
        ldr     w0, [x0]
.L3:
        add     sp, sp, 16
        ret
#����ȫ�ֱ���%d
.LC0:
        .string "%d"
main:
		 #����LC0�ε�ֵ������scanf��������n��ֵ
        stp     x29, x30, [sp, -16]!
        add     x29, sp, 0
        adrp    x0, n
        add     x1, x0, :lo12:n
        adrp    x0, .LC0
        add     x0, x0, :lo12:.LC0
        bl      scanf
        #w0����n��ֵ���벢����factorial����
        adrp    x0, n
        add     x0, x0, :lo12:n
        ldr     w0, [x0]
        bl      factorial(int)
        #��n��ֵfactorial�ķ���ֵ
        mov     w1, w0
        adrp    x0, n
        add     x0, x0, :lo12:n
        str     w1, [x0]
        adrp    x0, n
        #����%d,n������printf�������
        add     x0, x0, :lo12:n
        ldr     w1, [x0]
        adrp    x0, .LC0
        add     x0, x0, :lo12:.LC0
        bl      printf
        #return
        mov     w0, 0
        ldp     x29, x30, [sp], 16
        ret