.equ LOW, 0
.equ HIGH, 1
.equ INPUT, 0
.equ OUTPUT, 1

.equ GREEN_IN, 6
.equ RED_IN, 10
.equ YELLOW_IN, 11
.equ BLUE_IN, 31

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

	bl wiringPiSetup	//Setting pins

	mov r0, #BUZZER
	bl softToneCreate

	mov r0, #GREEN_OUT
	mov r1, #OUTPUT
	bl pinMode
	mov r0, #RED_OUT
	mov r1, #OUTPUT
	bl pinMode
	mov r0, #BLUE_OUT
	mov r1, #OUTPUT
	bl pinMode

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
