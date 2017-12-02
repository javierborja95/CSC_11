.equ PIN, 5 //6,10,11
.equ HIGH, 1
.equ INPUT, 0

.section .data
pattern: .asciz "%d\n"

.text
.global main
main:
	push {lr}

	bl wiringPiSetup

	mov r0, #PIN
	mov r1, #INPUT
	bl pinMode

loop:
	mov r0, #PIN
	bl digitalRead

	cmp r0, #HIGH
	bne false
	ldr r0, =pattern
	mov r1, #1
	bl printf
	bal loop
false:
	ldr r0, =pattern
	mov r1, #PIN
	bl printf
	bal loop

	mov r0, #1
	pop {pc}
	
	
