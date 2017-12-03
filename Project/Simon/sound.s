.equ LOW, 0
.equ HIGH, 1
.equ OUTPUT, 1
.equ PIN, 2

.equ GREEN, 300
.equ RED, 1600
.equ YELLOW, 800
.equ BLUE, 1000

.global main
.text
main:
	//push {lr}

	bl wiringPiSetup
	mov r0, #PIN
	bl softToneCreate

	mov r0, #PIN
	ldr r1, =#1000
	bl softToneWrite

	ldr r0, =#200	//Delay for 1s
	bl delay

	mov r0, #PIN
	ldr r1, =#0
	bl softToneWrite

	ldr r0, =#200	//Delay for 1s
	bl delay

	mov r0, #PIN
	ldr r1, =#800
	bl softToneWrite

	ldr r0, =#200	//Delay for 1s
	bl delay

	mov r0, #PIN
	ldr r1, =#0
	bl softToneWrite

	ldr r0, =#200	//Delay for 1s
	bl delay

	mov r0, #PIN
	ldr r1, =#300
	bl softToneWrite

	ldr r0, =#1600	//Delay for 3s
	bl delay

	mov r0, #PIN
	ldr r1, =#0
	bl softToneWrite

	mov r0, #0
	pop {pc}
