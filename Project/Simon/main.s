.equ LOW, 0
.equ HIGH, 1
.equ INPUT, 0
.equ OUTPUT, 1

.equ GREEN_IN, 26
.equ RED_IN, 27
.equ YELLOW_IN, 28
.equ BLUE_IN, 29

.equ GREEN_OUT, 24
.equ RED_OUT, 22
//.equ YELLOW_OUT, 0 //yellow=green+blue
.equ BLUE_OUT, 25

.equ BUZZER, 2

.equ GREEN, 0
.equ RED, 1
.equ YELLOW, 2
.equ BLUE, 3

.equ SHORT, 500
.equ LONG, 1000

.equ G_TONE, 660 //Elow
.equ R_TONE, 880 //A
.equ Y_TONE, 1109 //C#
.equ B_TONE, 1319 //Ehigh

.global main
.text
main:
	push {lr}

	mov r0, #GREEN_IN
	push {r0}
	mov r0, #RED_IN
	push {r0}
	mov r0, #YELLOW_IN
	push {r0}
	mov r0, #BLUE_IN
	push {r0}
	mov r0, #GREEN_OUT
	push {r0}
	mov r0, #RED_OUT
	push {r0}
	mov r0, #BLUE_OUT
	push {r0}
	mov r0, #BUZZER
	push {r0}
	add sp, #32		//Balance stack

	ldr r0, =pins
	bl setPins		//Setting pins

	bl menu 		//Display menu
loop:
	ldr r0, =#LONG		//Delay for 1s
	bl delay
	mov r0, #GREEN_IN
	mov r1, #RED_IN
	mov r2, #YELLOW_IN
	mov r3, #BLUE_IN
	bl getInput		//r0=input //input=color
	mov r4, r0		//r4=input
	ldr r1, =#LONG		//Long delay for buzz
	bl buzz			//Branch link to buzz

	cmp r4, #GREEN
	bne play_false		//if(!green) branch to play_false
	ldr r0, =array		//r0 points to array
	mov r1, #32		//r1=maxTurns
	bl play			//Play game
	bal loop		//loop again
play_false:
	cmp r4, #RED
	bne setArr_false	//if(!red) branch to setArr_false
	ldr r0, =array		//r0 points to array
	mov r1, #32		//r1= arraySize
	bl setArr		//Create new array
	bal loop		//loop again
setArr_false:
	cmp r4, #YELLOW
	bne getArr_false	//if(!yellow) exit
	ldr r0, =#LONG		//Delay for 1s
	bl delay
	ldr r0, =array		//r0 points to array
	mov r1, #32		//r1=maxTurns
	bl getArr		//display solution array
	bal loop
getArr_false:

	mov r0, #0
	pop {pc}

.data
msg: .asciz "game start\n"

.section .bss
.balign 4
array: .skip 128 	//array[size] size=32, 32*4bytes=128 bytes
pins: .skip 32		//pins[size]  size=8,  8*4 bytes=32 bytes
