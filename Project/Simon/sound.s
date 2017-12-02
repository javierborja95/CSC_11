.equ LOW, 0
.equ HIGH, 1
.equ OUTPUT, 1
.equ PIN, 2

.equ GREEN, 165
.equ RED, 440
.equ YELLOW, 277
.equ BLUE, 330

.global main
.text
main:
	//push {lr}

	bl wiringPiSetup
	mov r0, #PIN
	bl softToneCreate

	mov r0, #PIN
	ldr r1, =#GREEN
	bl softToneWrite

	ldr r0, =#1000	//Delay for 1s
	bl delay

	mov r0, #PIN
	ldr r1, =#RED
	bl softToneWrite

	ldr r0, =#1000	//Delay for 1s
	bl delay

	mov r0, #PIN
	ldr r1, =#YELLOW
	bl softToneWrite

	ldr r0, =#1000	//Delay for 1s
	bl delay

	mov r0, #PIN
	ldr r1, =#BLUE
	bl softToneWrite

	ldr r0, =#1000	//Delay for 1s
	bl delay

	mov r0, #PIN
	mov r1, #0
	bl softToneWrite

	mov r0, #0
	//pop {pc}
