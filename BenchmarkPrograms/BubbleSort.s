	.file	1 "BubbleSort.c"
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
	.frame	$fp,56,$31		# vars= 32, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-56
	sw	$31,52($sp)
	sw	$fp,48($sp)
	move	$fp,$sp
	li	$2,12			# 0xc
	sw	$2,16($fp)
	li	$2,9			# 0x9
	sw	$2,20($fp)
	li	$2,4			# 0x4
	sw	$2,24($fp)
	li	$2,99			# 0x63
	sw	$2,28($fp)
	li	$2,120			# 0x78
	sw	$2,32($fp)
	li	$2,1			# 0x1
	sw	$2,36($fp)
	li	$2,3			# 0x3
	sw	$2,40($fp)
	li	$2,10			# 0xa
	sw	$2,44($fp)
	addiu	$2,$fp,16
	move	$4,$2
	li	$5,8			# 0x8
	jal	bubble_srt
	nop

	move	$2,$0
	move	$sp,$fp
	lw	$31,52($sp)
	lw	$fp,48($sp)
	addiu	$sp,$sp,56
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.align	2
	.globl	bubble_srt
	.set	nomips16
	.set	nomicromips
	.ent	bubble_srt
	.type	bubble_srt, @function
bubble_srt:
	.frame	$fp,24,$31		# vars= 16, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-24
	sw	$fp,20($sp)
	move	$fp,$sp
	sw	$4,24($fp)
	sw	$5,28($fp)
	sw	$0,0($fp)
	j	.L3
	nop

.L7:
	li	$2,1			# 0x1
	sw	$2,4($fp)
	j	.L4
	nop

.L6:
	lw	$2,4($fp)
	addiu	$2,$2,-1
	sll	$2,$2,2
	lw	$3,24($fp)
	addu	$2,$3,$2
	lw	$3,0($2)
	lw	$2,4($fp)
	sll	$2,$2,2
	lw	$4,24($fp)
	addu	$2,$4,$2
	lw	$2,0($2)
	slt	$2,$2,$3
	beq	$2,$0,.L5
	nop

	lw	$2,4($fp)
	addiu	$2,$2,-1
	sll	$2,$2,2
	lw	$3,24($fp)
	addu	$2,$3,$2
	lw	$2,0($2)
	sw	$2,8($fp)
	lw	$2,4($fp)
	addiu	$2,$2,-1
	sll	$2,$2,2
	lw	$3,24($fp)
	addu	$2,$3,$2
	lw	$3,4($fp)
	sll	$3,$3,2
	lw	$4,24($fp)
	addu	$3,$4,$3
	lw	$3,0($3)
	sw	$3,0($2)
	lw	$2,4($fp)
	sll	$2,$2,2
	lw	$3,24($fp)
	addu	$2,$3,$2
	lw	$3,8($fp)
	sw	$3,0($2)
.L5:
	lw	$2,4($fp)
	addiu	$2,$2,1
	sw	$2,4($fp)
.L4:
	lw	$3,28($fp)
	lw	$2,0($fp)
	subu	$3,$3,$2
	lw	$2,4($fp)
	slt	$2,$2,$3
	bne	$2,$0,.L6
	nop

	lw	$2,0($fp)
	addiu	$2,$2,1
	sw	$2,0($fp)
.L3:
	lw	$3,0($fp)
	lw	$2,28($fp)
	slt	$2,$3,$2
	bne	$2,$0,.L7
	nop

	move	$sp,$fp
	lw	$fp,20($sp)
	addiu	$sp,$sp,24
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	bubble_srt
	.size	bubble_srt, .-bubble_srt
	.ident	"GCC: (Sourcery G++ Lite 2011.03-52) 4.5.2"
