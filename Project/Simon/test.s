.text
.global main
main:
	push {lr}

	bl test

	mov r0, #0
	pop {pc}
