.equ LOW, 0
.equ HIGH, 1
.equ INPUT, 0
.equ OUTPUT, 1

.equ GREEN_OUT, 24
.equ RED_OUT, 22
//.equ YELLOW_OUT, 0 //yellow=green+blue
.equ BLUE_OUT, 25

.global main
.text
main:
	push {lr}

	bl wiringPiSetup	//Setting pins

	mov r0, #GREEN_OUT
	mov r1, #OUTPUT
	bl pinMode
	mov r0, #RED_OUT
	mov r1, #OUTPUT
	bl pinMode
	mov r0, #BLUE_OUT
	mov r1, #OUTPUT
	bl pinMode

	mov r0, #RED_OUT
	mov r1, #HIGH
	bl digitalWrite		//Turn on RED LED

	ldr r0, =#2000
	bl delay		//Delay

	mov r0, #RED_OUT
	mov r1, #LOW
	bl digitalWrite		//Turn off RED LED

	mov r0, #GREEN_OUT
	mov r1, #HIGH
	bl digitalWrite		//Turn on Green LED

	ldr r0, =#2000
	bl delay		//Delay

	mov r0, #GREEN_OUT
	mov r1, #LOW
	bl digitalWrite		//Turn off Green LED

	mov r0, #BLUE_OUT
	mov r1, #HIGH
	bl digitalWrite		//Turn on BLUE LED

	ldr r0, =#2000
	bl delay		//Delay

	mov r0, #BLUE_OUT
	mov r1, #LOW
	bl digitalWrite		//Turn off BLUE LED

	mov r0, #GREEN_OUT
	mov r1, #HIGH
	bl digitalWrite		//Turn on Green LED

	mov r0, #RED_OUT
	mov r1, #HIGH
	bl digitalWrite		//Turn on GREEN LED

	ldr r0, =#2000
	bl delay		//Delay

	mov r0, #RED_OUT
	mov r1, #LOW
	bl digitalWrite		//Turn off BLUE LED

	mov r0, #GREEN_OUT
	mov r1, #LOW
	bl digitalWrite		//Turn on Green LED


	mov r0, #0
	pop {pc}

	bl digitalWrite		//Turn off Green LED