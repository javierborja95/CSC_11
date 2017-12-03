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
.equ MEDIUM, 750

.equ G_TONE, 660 //Elow
.equ R_TONE, 880 //A
.equ Y_TONE, 1109 //C#
.equ B_TONE, 1319 //Ehigh

.global menu		//void menu();
.global getInput	//int getInput(pin1,pin2,pin3,pin4);
.global buzz		//void buzz(color,time);
.global setArr		//void setArr(*array,arraySize);
.global getArr		//void getArr(*array,maxTurns)
.global play		//void play(*array, maxTurns)
.global compare		//int compare(*array, turn)
//All parameters are integers

/////////////////////////////////////////////////////////////////
/* 	getInput
	purpose- detects input
	parameter- all four input pins
	input-     high tactile button
	output-    x
	return-    first tactile button pressed in r0
*/
getInput:
	push {r4, r5, r6, r7, lr}
	mov r4, r0	//r4=green_in
	mov r5, r1	//r5=red_in
	mov r6, r2	//r6=yellow_in
	mov r7, r3	//r7=blue_in
blue_false:
	mov r0, r4
	bl digitalRead
	cmp r0, #HIGH
	bne green_false		//if(green_in==low) branch next
	mov r0, #GREEN
	bal getInput_return	//if(green==high) return green
green_false:
	mov r0, r5
	bl digitalRead
	cmp r0, #HIGH
	bne red_false		//if(red_in==low) branch next
	mov r0, #RED
	bal getInput_return	//if(red==high) return red
red_false:
	mov r0, r6
	bl digitalRead
	cmp r0, #HIGH
	bne yellow_false	//if(yellow_in==low) branch next
	mov r0, #YELLOW
	bal getInput_return	//if(yellow==high) return yellow
yellow_false:
	mov r0, r7
	bl digitalRead
	cmp r0, #HIGH
	bne blue_false		//if(blue_in==low) branch next
	mov r0, #BLUE
	bal getInput_return	//if(blue==high) return blue
getInput_return:
	pop {r4, r5, r6, r7, pc}

/////////////////////////////////////////////////////////////////
/* menu
	purpose- displays menu
	parameters- x
	input-      x
	output-     menu
	return-     x
*/
menu:
	push {lr}
	ldr r0, =menu_msg
	bl printf
	pop {pc}

/////////////////////////////////////////////////////////////////
/* 	buzz
	purpose- lights and buzzes based on color
	parameter- pin color, time
	input-     x
	output-    sound and light based on color
	return-    x
*/
buzz:
	push {r4, lr}
	mov r4, r1		//R4=time
	cmp r0, #GREEN
	bne not_Green
	mov r0, #GREEN_OUT
	mov r1, #HIGH
	bl digitalWrite		//Turn on Green LED
	mov r0, #BUZZER
	ldr r1, =#G_TONE
	bl softToneWrite	//Turn on Green sound
	mov r0, r4
	bl delay		//Delay
	mov r0, #GREEN_OUT
	mov r1, #LOW
	bl digitalWrite		//Turn off Green LED
	bal buzz_Return
not_Green:
	cmp r0, #RED
	bne not_Red
	mov r0, #RED_OUT
	mov r1, #HIGH
	bl digitalWrite		//Turn on Red LED
	mov r0, #BUZZER
	ldr r1, =#R_TONE
	bl softToneWrite	//Turn on Red sound
	mov r0, r4
	bl delay		//Delay
	mov r0, #RED_OUT
	mov r1, #LOW
	bl digitalWrite		//Turn off Red LED
	bal buzz_Return
not_Red:
	cmp r0, #YELLOW
	bne not_Yellow
	mov r0, #RED_OUT
	mov r1, #HIGH
	bl digitalWrite		//Turn on Red LED
	mov r0, #GREEN_OUT
	mov r1, #HIGH
	bl digitalWrite		//Turn on Green LED
	mov r0, #BUZZER
	ldr r1, =#Y_TONE
	bl softToneWrite	//Turn on Yellow sound
	mov r0, r4
	bl delay		//Delay
	mov r0, #RED_OUT
	mov r1, #LOW
	bl digitalWrite		//Turn off Red LED
	mov r0, #GREEN_OUT
	mov r1, #LOW
	bl digitalWrite		//Turn off Green LED
	bal buzz_Return
not_Yellow:
	mov r0, #BLUE_OUT
	mov r1, #HIGH
	bl digitalWrite		//Turn on Blue LED
	mov r0, #BUZZER
	ldr r1, =#B_TONE
	bl softToneWrite	//Turn on Blue sound
	mov r0, r4
	bl delay		//Delay
	mov r0, #BLUE_OUT
	mov r1, #LOW
	bl digitalWrite		//Turn off Blue LED
buzz_Return:
	mov r0, #BUZZER
	mov r1, #0
	bl softToneWrite	//Quiet the buzzer

	pop {r4, pc}
/////////////////////////////////////////////////////////////////
/* setArr
	purpose- Sets color array
	parameters- Pointer to array, size of array, seed
	input-      x
	output-     x
	return-     x but modifies array
*/
setArr:
	push {r4, r5, r6, r7, lr}
	mov r4, r0	//r4=pointer to array
	mov r5, #0	//for(int i=0;...
	mov r6, r1	//...i<arrSize;...
	mov r7, r3	//r7= pointer to seed
init_loop:
	cmp r5, r6
	bge init_done	//branch if greater than or equal
	//bl rand
	mov r0, r5
	mov r1, #4
	bl div_mod	//r0=i%4
	str r0, [r4,+r5, LSL #2] //store i%4 into array[0+(r4<<2)]
				 // [0+(r4<<2)]==[0+i*4]
	add r5, #1	//...i++)
	bal init_loop
init_done:
	pop {r4, r5, r6, r7, pc}

/////////////////////////////////////////////////////////////////
/* 	getArr
	purpose- Displays the color array
	parameter- Pointer to array, Max array to display
	input-     x
	output-    Outputs colors and their corresponding sounds
	return-    x
*/
getArr:
	push {r4, r5, r6, lr}
	mov r4, #0		//for(int i=0;...
	mov r6, r0		//r6=pointer to array
	mov r5, r1		//r5=# of indexes to display
getArr_loop:
	cmp r4, r5		//...i<maxTurns;...
	bge getArr_done		//branch if(i>=maxTurns)
	ldr r0, [r6,+r4, LSL #2]//r0=&array[0+(i*4)]
	//ldr r0, [r0]		//r0=&array[0+(i*4)]
	mov r1, #SHORT		//Short output
	bl buzz			//Output color
	add r4, #1		//...i++)
	bal getArr_loop
getArr_done:
	pop {r4, r5, r6, pc}

/////////////////////////////////////////////////////////////////
/* 	play
	purpose- Plays a game of Simon
	parameter- Pointer to array, Max number of turns
	input-     computer generated pattern
	output-    pattern, new color every turn
	return-    x
*/
play:
	push {r4, r5, r6, r7, lr}

	mov r4, r0		//r4=pointer to array
	mov r5, #1		//for(int i=1;...
	mov r6, r1		//r6=maxTurns

	ldr r0, =#LONG		//Delay for 1s
	bl delay
play_loop:
	ldr r0, =#LONG		//Delay for 1s
	bl delay
	cmp r5, r6		//...i<=maxTurns...
	bgt win			//if(i>maxTurns) win
	mov r0, r4		//r0=*array
	mov r1, r5		//r1=i=turn
	bl getArr		//display array up to turn
	mov r0, r4		//r0=pointer to array
	mov r1, r5		//r5=current turn
	bl compare		//compare user input to array
	cmp r0, #0		//compare returns win or lose
	bne lose		//if(lose=true) exit
	add r5, #1		//...i++)
	bal play_loop
lose:
	mov r0, #BUZZER
	ldr r1, =#1000
	bl softToneWrite
	ldr r0, =#200	//Delay for .2s
	bl delay
	mov r0, #BUZZER
	ldr r1, =#0
	bl softToneWrite
	ldr r0, =#200	//Delay for .2s
	bl delay
	mov r0, #BUZZER
	ldr r1, =#800
	bl softToneWrite
	ldr r0, =#200	//Delay for .2s
	bl delay
	mov r0, #BUZZER
	ldr r1, =#0
	bl softToneWrite
	ldr r0, =#200	//Delay for .2s
	bl delay
	mov r0, #BUZZER
	ldr r1, =#300
	bl softToneWrite
	ldr r0, =#1600	//Delay for 3s
	bl delay
	mov r0, #BUZZER
	ldr r1, =#0
	bl softToneWrite
win:
play_exit:
	pop {r4, r5, r6, r7, pc}

/////////////////////////////////////////////////////////////////
/* 	compare
	purpose- compares user input to array
	parameter- Pointer to array, turn
	input-     pattern
	output-    buzz and if you lose, then display losing pattern
	return-    1 for loss else return
*/
compare:
	push {r4, r5, r6, r7, lr}
	mov r4, #0		//for(int i=0;...
	mov r6, r0		//r6=pointer to array
	mov r5, r1		//r5=turn
compare_loop:
	mov r0, #0		//return 0 if didn't lose
	cmp r4, r5		//...i<turn;...
	bge compare_done	//branch if(i>=maxTurns)
	mov r0, #GREEN_IN
	mov r1, #RED_IN
	mov r2, #YELLOW_IN
	mov r3, #BLUE_IN
	bl getInput		//r0=input
	mov r7, r0		//r7=r0
	ldr r1, =#MEDIUM	//Medium output
	bl buzz			//Output color
	ldr r2, [r6,+r4, LSL #2]//r2=array[0+(i*4)]
	cmp r7, r2		//compare input with array
	bne compare_lose
	add r4, #1		//...i++)
	bal compare_loop
compare_lose:
	mov r0, #1		//Return 1 for loss
compare_done:

	pop {r4, r5, r6, r7, pc}

/////////////////////////////////////////////////////////////////

.data
menu_msg: .asciz "green: start game\nred: set combination\nyellow: view combination\nblue: quit\n"
