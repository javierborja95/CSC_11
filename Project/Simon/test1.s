.global test

.section .data
msg: .asciz "test\n"

test:
	push {r4, r5, lr}

	ldr r0, =msg
	bl printf

	pop {r4, r5, pc}
