.text
.global main
main:
	push {lr}

	mov r0, #22
	push {r0}
	mov r0, #55
	push {r0}

	bl test

	add sp, #8	//Balance
	pop {pc}

.text
.global test
test:
	push {lr}
	ldr r5, [sp,#8]
	ldr r6, [sp,#4]
	pop {pc}