	.file	1 "Swap.c"
	.section .mdebug.abi32
	.previous
	.gnu_attribute 4, 1
	.text
	.align	2
	.globl	main
	.set	nomips16
	.set	nomicromips
	.ent	main
	.type	main, @function
main:
	.frame	$fp,40,$31		# vars= 16, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-40
	sw	$31,36($sp)
	sw	$fp,32($sp)
	move	$fp,$sp
	li	$2,5			# 0x5
	sw	$2,24($fp)
	li	$2,9			# 0x9
	sw	$2,28($fp)
	addiu	$2,$fp,24
	sw	$2,16($fp)
	addiu	$2,$fp,28
	sw	$2,20($fp)
	lw	$4,16($fp)
	lw	$5,20($fp)
	jal	swap
	nop

	lw	$2,16($fp)
	lw	$2,0($2)
	sw	$2,24($fp)
	lw	$2,20($fp)
	lw	$2,0($2)
	sw	$2,28($fp)
	lw	$3,24($fp)
	lw	$2,28($fp)
	addu	$2,$3,$2
	move	$sp,$fp
	lw	$31,36($sp)
	lw	$fp,32($sp)
	addiu	$sp,$sp,40
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.align	2
	.globl	swap
	.set	nomips16
	.set	nomicromips
	.ent	swap
	.type	swap, @function
swap:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	sw	$fp,12($sp)
	move	$fp,$sp
	sw	$4,16($fp)
	sw	$5,20($fp)
	lw	$2,16($fp)
	lw	$2,0($2)
	sw	$2,0($fp)
	lw	$2,20($fp)
	lw	$3,0($2)
	lw	$2,16($fp)
	sw	$3,0($2)
	lw	$2,20($fp)
	lw	$3,0($fp)
	sw	$3,0($2)
	move	$sp,$fp
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	swap
	.size	swap, .-swap
	.ident	"GCC: (Sourcery G++ Lite 2011.03-52) 4.5.2"
