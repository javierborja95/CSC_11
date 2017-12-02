.equ LOW, 0
.equ HIGH, 1
.equ INPUT, 0
.equ OUTPUT, 1

.equ RED_IN, 10
.equ RED_OUT, 15
.equ GREEN_IN, 11
.equ GREEN_OUT, 16
.equ BLUE_IN, 31
.equ BLUE_OUT, 1

.section .data
pattern: .asciz "%d\n"

.text
.global main
main:
	push {lr}

	//Initialize
	bl wiringPiSetup

	mov r0, #RED_IN
	mov r1, #INPUT
	bl pinMode
	
	mov r0, #RED_OUT
	mov r1, #OUTPUT
	bl pinMode

	mov r0, #GREEN_IN
	mov r1, #INPUT
	bl pinMode

	mov r0, #GREEN_OUT
	mov r1, #OUTPUT
	bl pinMode

	mov r0, #BLUE_IN
	mov r1, #INPUT
	bl pinMode

	mov r0, #BLUE_OUT
	mov r1, #OUTPUT
	bl pinMode

loop:
	mov r0, #RED_IN
	mov r0, #LOW
	bl digitalWrite

	mov r0, #RED_OUT
	mov r1, #LOW
	bl digitalWrite

	mov r0, #GREEN_OUT
	mov r1, #LOW
	bl digitalWrite

	mov r0, #GREEN_IN
	mov r1, #LOW
	bl digitalWrite

	mov r0, #BLUE_IN
	mov r1, #LOW
	bl digitalWrite

	mov r0, #BLUE_OUT
	mov r1, #LOW
	bl digitalWrite

	mov r0, #RED_IN
	bl digitalRead
	cmp r0, #HIGH
	bne redFalse
	mov r0, #RED_OUT
	mov r1, #HIGH
	bl digitalWrite
	ldr r0, =pattern
	mov r1, #1
	bl printf
redFalse:
	mov r0, #GREEN_IN
	bl digitalRead
	cmp r0, #HIGH
	bne greenFalse
	mov r0, #GREEN_OUT
	mov r1, #HIGH
	bl digitalWrite
	ldr r0, =pattern
	mov r1, #2
	bl printf
greenFalse:
	mov r0, #BLUE_IN
	bl digitalRead
	cmp r0, #HIGH
	bne blueFalse
	mov r0, #BLUE_OUT
	mov r1, #HIGH
	bl digitalWrite
	ldr r0, =pattern
	mov r1, #3
	bl printf
blueFalse:
	bal loop

	mov r0, #0
	pop {pc}

