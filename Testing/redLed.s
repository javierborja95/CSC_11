.equ INPUT, 0
.equ OUTPUT, 1
.equ LOW, 0
.equ HIGH, 1
.equ MY_PIN, 21

.global main
main:
	push {lr}
	bl wiringPiSetup

	mov r0, #MY_PIN //pinMode(21,OUTPUT); //set the wpi 21 pin output
	mov r1, #OUTPUT
	bl pinMode

	mov r0,#MY_PIN
	mov r1,#HIGH
	bl digitalWrite

	ldr r0, =#10000//delay(10000); //delay for 10 s
	bl delay

	mov r0, #MY_PIN
	mov r1, #LOW
	bl digitalWrite

	mov r0, #0
	pop {pc}
