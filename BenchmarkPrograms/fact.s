	.file	1 "fact.c"
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
	.frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	sw	$0,16($fp)
	j	.L2
	nop

.L3:
	lw	$4,16($fp)
	jal	factorial
	nop

	sw	$2,20($fp)
	lw	$2,16($fp)
	addiu	$2,$2,1
	sw	$2,16($fp)
.L2:
	lw	$2,16($fp)
	slt	$2,$2,10
	bne	$2,$0,.L3
	nop

	move	$2,$0
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.align	2
	.globl	factorial
	.set	nomips16
	.set	nomicromips
	.ent	factorial
	.type	factorial, @function
factorial:
	.frame	$fp,24,$31		# vars= 0, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-24
	sw	$31,20($sp)
	sw	$fp,16($sp)
	move	$fp,$sp
	sw	$4,24($fp)
	lw	$2,24($fp)
	bne	$2,$0,.L5
	nop

	li	$2,1			# 0x1
	j	.L6
	nop

.L5:
	lw	$2,24($fp)
	addiu	$2,$2,-1
	move	$4,$2
	jal	factorial
	nop

	move	$3,$2
	lw	$2,24($fp)
	mul	$2,$3,$2
.L6:
	move	$sp,$fp
	lw	$31,20($sp)
	lw	$fp,16($sp)
	addiu	$sp,$sp,24
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	factorial
	.size	factorial, .-factorial
	.ident	"GCC: (Sourcery G++ Lite 2011.03-52) 4.5.2"
