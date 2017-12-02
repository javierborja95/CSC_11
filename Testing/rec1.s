.text
.global main
main:
	push {lr}

	mov r0, #32
	bl isEven

	cmp r0, #1
	beq EVEN
	bal ODD
EVEN:
	ldr r0, =even
	bl printf
	bal RETURN
ODD:
	ldr r0, =odd
	bl printf
RETURN:
	mov r0, #0
	pop {pc}

odd: .asciz "odd\n"
even: .asciz "even\n"
