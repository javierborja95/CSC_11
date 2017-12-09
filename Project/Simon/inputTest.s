.equ GREEN_IN, 26
.equ RED_IN, 27
.equ YELLOW_IN, 28
.equ BLUE_IN, 29

.equ LOW, 0
.equ HIGH, 1
.equ INPUT, 0
.equ OUTPUT, 1

.equ GREEN, 1
.equ RED, 2
.equ YELLOW, 3
.equ BLUE, 4

.global main
.text
main:
	push {lr}

	bl wiringPiSetup	//Setting pins

	mov r0, #GREEN_IN
	mov r1, #INPUT
	bl pinMode
	mov r0, #RED_IN
	mov r1, #INPUT
	bl pinMode
	mov r0, #YELLOW_IN
	mov r1, #INPUT
	bl pinMode
	mov r0, #BLUE_IN
	mov r1, #INPUT
	bl pinMode

	mov r4, #GREEN_IN	//r4=green_in
	mov r5, #RED_IN		//r5=red_in
	mov r6, #YELLOW_IN	//r6=yellow_in
	mov r7, #BLUE_IN	//r7=blue_in
loop:
	ldr r0, =msg0
	bl printf

	mov r0, r4
	bl digitalRead
	cmp r0, #HIGH
	bne green_false		//if(green_in==low) branch next
	mov r1, #GREEN
	ldr r0, =msg1
	bl printf
green_false:
	mov r0, r5
	bl digitalRead
	cmp r0, #HIGH
	bne red_false		//if(red_in==low) branch next
	mov r1, #RED
	ldr r0, =msg1
	bl printf
red_false:
	mov r0, r6
	bl digitalRead
	cmp r0, #HIGH
	bne yellow_false	//if(yellow_in==low) branch next
	mov r1, #YELLOW
	ldr r0, =msg1
	bl printf
yellow_false:
	mov r0, r7
	bl digitalRead
	cmp r0, #HIGH
	bne loop		//if(blue_in==low) branch next
	mov r1, #BLUE
 				//if(blue==high) return blue
	ldr r0, =msg1
	bl printf

	bal loop

	pop {pc}

msg0: .asciz "0\n"
msg1: .asciz "%d\n"
