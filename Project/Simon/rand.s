.global main
.text
main:
	push {lr}

	mov r7, #50
	mov r4, r5
loop:	
	mov r0, #13
	bl delay

	bl clock
	//mov r1, #53
	//mul r0, r1
	mov r1, #4
	bl div_mod	//r0=i%4
	
	mov r1, r0
	ldr r0, =msg
	
	bl printf
	
	cmp r7, #0
	beq exit
	
	sub r7, #1
	bal loop
exit:
	pop {pc}
	

.section .data
msg: .asciz "%d\n"

