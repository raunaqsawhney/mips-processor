	.file	1 "SumArray.c"
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
	.frame	$fp,56,$31		# vars= 48, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-56
	sw	$fp,52($sp)
	move	$fp,$sp
	sw	$0,0($fp)
	sw	$0,4($fp)
	sw	$0,0($fp)
	j	.L2
	nop

.L3:
	lw	$2,0($fp)
	sll	$2,$2,2
	addu	$2,$fp,$2
	lw	$3,0($fp)
	sw	$3,8($2)
	lw	$2,0($fp)
	addiu	$2,$2,1
	sw	$2,0($fp)
.L2:
	lw	$2,0($fp)
	slt	$2,$2,10
	bne	$2,$0,.L3
	nop

	sw	$0,0($fp)
	j	.L4
	nop

.L5:
	lw	$2,0($fp)
	sll	$2,$2,2
	addu	$2,$fp,$2
	lw	$2,8($2)
	lw	$3,4($fp)
	addu	$2,$3,$2
	sw	$2,4($fp)
	lw	$2,0($fp)
	addiu	$2,$2,1
	sw	$2,0($fp)
.L4:
	lw	$2,0($fp)
	slt	$2,$2,10
	bne	$2,$0,.L5
	nop

	lw	$2,4($fp)
	move	$sp,$fp
	lw	$fp,52($sp)
	addiu	$sp,$sp,56
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.ident	"GCC: (Sourcery G++ Lite 2011.03-52) 4.5.2"
