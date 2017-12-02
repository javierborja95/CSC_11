equ. LOW, 0
equ. HIGH, 1
equ. INPUT, 0
equ. OUTPUT, 1

equ. GREEN_IN, 1
equ. RED_IN, 2
equ. YELLOW_IN, 3
equ. BLUE_IN, 4

equ. GREEN_OUT, 6
equ. RED_OUT, 7
equ. YELLOW_OUT, 8
equ. BLUE_OUT, 9

equ. BUZZER, 10

equ. GREEN, 0
equ. RED, 1
equ. YELLOW, 2
equ. BLUE, 3

equ. SHORT, 500
equ. LONG, 1000

equ. G_TONE, 0
equ. R_TONE, 0
equ. Y_TONE, 0
equ. B_TONE, 0

.section .data
msg: .asciz "game start"


.text
.global main
main:
	push {lr}

	bl wiringPiSetup	//Setting pins

	mov r0, #GREEN_OUT
	mov r1, #OUTPUT
	bl pinMode
	mov r0, #RED_OUT
	mov r1, #OUTPUT
	bl pinMode
	mov r0, #YELLOW_OUT
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

loop:

	bl menu 		//Display menu
	mov r0, #GREEN_IN
	mov r1, #RED_IN
	mov r2, #YELLOW_IN
	mov r3, #BLUE_IN
	bl getInput
	mov r4, r0		//r4=input
	mov r2, #LONG		//Long delay for buzz

	cmp r4, #GREEN
	bne play_false		//if(!green) branch to play_false
	mov r0, #GREEN_OUT
	bl buzz
play_false:
	cmp r4, #RED
	bne setArr_false	//if(!red) branch to setArr_false
	mov r0, #RED_OUT
	bl buzz
setArr_false
	cmp r4, #YELLOW
	bne yello_false		//if(!yellow) branch to yellow_false
	mov r0, #YELLOW_OUT
	bl buzz
yellow_false:
	mov r0, #BLUE_OUT
	bl buzz
	bal end_loop		//if(blue) exit
end_loop:
	mov r0, =#1000		//Delay for 1s
	bl delay
	bal loop

exit:

	mov r0, #0
	pop {pc}