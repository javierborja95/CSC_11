.global main

.text

main:
	push {lr}

	mov r0, #65
	mov r1, #10
	bl mystery

	pop {pc}

.data
msg: .asciz "%d\n"

.section .text
mystery:
	push {lr}
	add r1, r0, lsr#3
	mov r0, r0, lsl#2
	pop {pc}

	
