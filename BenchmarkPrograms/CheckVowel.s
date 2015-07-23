	.file	1 "CheckVowel.c"
	.section .mdebug.abi32
	.previous
	.gnu_attribute 4, 1
	.rdata
	.align	2
.LC0:
	.ascii	"CheckVowel!\012\000"
	.space	7
	.text
	.align	2
	.globl	main
	.set	nomips16
	.set	nomicromips
	.ent	main
	.type	main, @function
main:
	.frame	$fp,40,$31		# vars= 32, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-40
	sw	$fp,36($sp)
	move	$fp,$sp
	sw	$0,0($fp)
	sw	$0,4($fp)
	lui	$2,%hi(.LC0)
	lw	$5,%lo(.LC0)($2)
	addiu	$3,$2,%lo(.LC0)
	lw	$4,4($3)
	addiu	$3,$2,%lo(.LC0)
	lw	$3,8($3)
	sw	$5,8($fp)
	sw	$4,12($fp)
	sw	$3,16($fp)
	addiu	$2,$2,%lo(.LC0)
	lbu	$2,12($2)
	sb	$2,20($fp)
	sb	$0,21($fp)
	sb	$0,22($fp)
	sb	$0,23($fp)
	sb	$0,24($fp)
	sb	$0,25($fp)
	sb	$0,26($fp)
	sb	$0,27($fp)
	sw	$0,0($fp)
	j	.L2
	nop

.L5:
	lw	$2,0($fp)
	addu	$2,$fp,$2
	lbu	$3,8($2)
	li	$2,97			# 0x61
	beq	$3,$2,.L3
	nop

	lw	$2,0($fp)
	addu	$2,$fp,$2
	lbu	$3,8($2)
	li	$2,65			# 0x41
	beq	$3,$2,.L3
	nop

	lw	$2,0($fp)
	addu	$2,$fp,$2
	lbu	$3,8($2)
	li	$2,101			# 0x65
	beq	$3,$2,.L3
	nop

	lw	$2,0($fp)
	addu	$2,$fp,$2
	lbu	$3,8($2)
	li	$2,69			# 0x45
	beq	$3,$2,.L3
	nop

	lw	$2,0($fp)
	addu	$2,$fp,$2
	lbu	$3,8($2)
	li	$2,105			# 0x69
	beq	$3,$2,.L3
	nop

	lw	$2,0($fp)
	addu	$2,$fp,$2
	lbu	$3,8($2)
	li	$2,73			# 0x49
	beq	$3,$2,.L3
	nop

	lw	$2,0($fp)
	addu	$2,$fp,$2
	lbu	$3,8($2)
	li	$2,111			# 0x6f
	beq	$3,$2,.L3
	nop

	lw	$2,0($fp)
	addu	$2,$fp,$2
	lbu	$3,8($2)
	li	$2,79			# 0x4f
	beq	$3,$2,.L3
	nop

	lw	$2,0($fp)
	addu	$2,$fp,$2
	lbu	$3,8($2)
	li	$2,117			# 0x75
	beq	$3,$2,.L3
	nop

	lw	$2,0($fp)
	addu	$2,$fp,$2
	lbu	$3,8($2)
	li	$2,85			# 0x55
	bne	$3,$2,.L4
	nop

.L3:
	lw	$2,4($fp)
	addiu	$2,$2,1
	sw	$2,4($fp)
.L4:
	lw	$2,0($fp)
	addiu	$2,$2,1
	sw	$2,0($fp)
.L2:
	lw	$2,0($fp)
	slt	$2,$2,20
	bne	$2,$0,.L5
	nop

	move	$2,$0
	move	$sp,$fp
	lw	$fp,36($sp)
	addiu	$sp,$sp,40
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.ident	"GCC: (Sourcery G++ Lite 2011.03-52) 4.5.2"
