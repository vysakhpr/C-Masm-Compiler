	.file	"input.c"
	.section	.rodata
	.align 8
.LC0:
	.string	"The sum of x and y is %d  and x is %d"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$10, -8(%rbp)
	movl	$15, -4(%rbp)
	movl	-8(%rbp), %eax
	movl	-4(%rbp), %edx
	addl	%eax, %edx
	movl	-8(%rbp), %eax
	imull	-4(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -4(%rbp)
	movl	-8(%rbp), %edx
	movl	-4(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 4.8.2-19ubuntu1) 4.8.2"
	.section	.note.GNU-stack,"",@progbits
