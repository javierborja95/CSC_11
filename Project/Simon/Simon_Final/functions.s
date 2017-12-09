.equ LOW, 0
.equ HIGH, 1
.equ INPUT, 0
.equ OUTPUT, 1

.equ GREEN, 0
.equ RED, 1
.equ YELLOW, 2
.equ BLUE, 3

.equ SHORT, 500
.equ LONG, 1000
.equ MEDIUM, 550

.equ G_TONE, 660 //Elow
.equ R_TONE, 880 //A
.equ Y_TONE, 1109 //C#
.equ B_TONE, 1319 //Ehigh

.global setPins		//void setPins(*pins,pin#s in stack)
.global menu		//void menu();
.global getInput	//int getInput(*pin);
.global buzz		//void buzz(color,time,*pin);
.global setArr		//void setArr(*array,arraySize);
.global getArr		//void getArr(*array,maxTurns);
.global play		//void play(*array, maxTurns,*pins);
.global compare		//int compare(*array, turn, *pin);
.global sounds		//void sounds(int,buzzer pin);
.global getRand		//int(*seed);
//All parameters are integers or pointers to integer arrays
/////////////////////////////////////////////////////////////////
/* 	setPins
	purpose- Sets pins
	parameter- pointer to pin array, in stack: input, output, buzzer pins
	input-     x
	output-    x
	return-    x
*/
.func setPins
setPins:
	push {r4, lr}
	mov r4, r0	//r4=pointer to array
	bl wiringPiSetup	//Setting pins

	mov r2, #0
	ldr r0, [sp, #36]	//Green_input
	str r0, [r4, r2, LSL #2]//Store Green_input in array
	mov r1, #INPUT
	bl pinMode
	mov r2, #1
	ldr r0, [sp, #32]	//Red_input
	str r0, [r4, r2, LSL #2]//Store Red_input in array
	mov r1, #INPUT
	bl pinMode
	mov r2, #2
	ldr r0, [sp, #28]	//Yellow_input
	str r0, [r4, r2, LSL #2]//Store Yellow_input in array
	mov r1, #INPUT
	bl pinMode
	mov r2, #3
	ldr r0, [sp, #24]	//Blue_input
	str r0, [r4, r2, LSL #2]//Store Blue_input in array
	mov r1, #INPUT
	bl pinMode

	mov r2, #4
	ldr r0, [sp, #20]	//Green_output
	str r0, [r4, r2, LSL #2]//Store Green_output in array
	mov r1, #OUTPUT
	bl pinMode
	mov r2, #5
	ldr r0, [sp, #16]	//Red_output
	str r0, [r4, r2, LSL #2]//Store Red_output in array
	mov r1, #OUTPUT
	bl pinMode
	mov r2, #6
	ldr r0, [sp, #12]	//Blue_output
	str r0, [r4, r2, LSL #2]//Store Blue_output in array
	mov r1, #OUTPUT
	bl pinMode

	mov r2, #7
	ldr r0, [sp, #8]	//Buzzer
	str r0, [r4, r2, LSL #2]//Store buzzer in array
	bl softToneCreate

	pop {r4, pc}
.endfunc
/////////////////////////////////////////////////////////////////
/* 	getInput
	purpose- detects input
	parameter- pin array
	input-     high tactile button
	output-    x
	return-    first tactile button pressed in r0
*/
.func getInput
getInput:
	push {r4, lr}
	mov r4, r0	//r4=pin array
blue_false:
	mov r1, #0
	ldr r0, [r4, r1, LSL #2]//r0=pinArray[0+(0*4)]==Green_in
	bl digitalRead
	cmp r0, #HIGH
	bne green_false		//if(green_in==low) branch next
	mov r0, #GREEN
	bal getInput_return	//if(green==high) return green
green_false:
	mov r1, #1
	ldr r0, [r4, r1, LSL #2]//r0=pinArray[0+(1*4)]==Red_in
	bl digitalRead
	cmp r0, #HIGH
	bne red_false		//if(red_in==low) branch next
	mov r0, #RED
	bal getInput_return	//if(red==high) return red
red_false:
	mov r1, #2
	ldr r0, [r4, r1, LSL #2]//r0=pinArray[0+(2*4)]==Yellow_in
	bl digitalRead
	cmp r0, #HIGH
	bne yellow_false	//if(yellow_in==low) branch next
	mov r0, #YELLOW
	bal getInput_return	//if(yellow==high) return yellow
yellow_false:
	mov r1, #3
	ldr r0, [r4, r1, LSL #2]//r0=pinArray[0+(3*4)]==Blue_in
	bl digitalRead
	cmp r0, #HIGH
	bne blue_false		//if(blue_in==low) branch next
	mov r0, #BLUE
	bal getInput_return	//if(blue==high) return blue
getInput_return:
	pop {r4, pc}
.endfunc
/////////////////////////////////////////////////////////////////
/* menu
	purpose- displays menu
	parameters- x
	input-      x
	output-     menu
	return-     x
*/
.func menu
menu:
	push {lr}
	ldr r0, =menu_msg
	bl printf
	pop {pc}
.endfunc

.data
menu_msg: .asciz "green: start game\nred: set combination\nyellow: view combination\nblue: quit\n"
/////////////////////////////////////////////////////////////////
/* 	buzz
	purpose- lights and buzzes based on color
	parameter- pin color, time, pin array
	input-     x
	output-    sound and light based on color
	return-    x
*/
.func buzz
buzz:
	push {r4, r5, r6, r7, lr}
	mov r4, r1		//R4=time
	mov r5, r2		//r5=pin array
	mov r6, r0		//r6=color
	cmp r0, #GREEN
	bne not_Green
	mov r1, #4
	ldr r7, [r5, r1, LSL #2]//r0=pinArray[0+(4*4)]==Green_out
	mov r0, r7		//r0=Green_out
	mov r1, #HIGH
	bl digitalWrite		//Turn on Green LED
	mov r1, #7
	ldr r0, [r5, r1, LSL #2]//r0=pinArray[0+(7*4)]==Buzzer
	ldr r1, =#G_TONE
	bl softToneWrite	//Turn on Green sound
	mov r0, r4
	bl delay		//Delay
	mov r0, r7		//r0=Green_out
	mov r1, #LOW
	bl digitalWrite		//Turn off Green LED
	bal buzz_Return
not_Green:
	cmp r0, #RED
	bne not_Red
	mov r1, #5
	ldr r7, [r5, r1, LSL #2]//r0=pinArray[0+(5*4)]==Red_out
	mov r0, r7		//r0=Red_out
	mov r1, #HIGH
	bl digitalWrite		//Turn on Red LED
	mov r1, #7
	ldr r0, [r5, r1, LSL #2]//r0=pinArray[0+(7*4)]==Buzzer
	ldr r1, =#R_TONE
	bl softToneWrite	//Turn on Red sound
	mov r0, r4
	bl delay		//Delay
	mov r0, r7		//r0=Red_out
	mov r1, #LOW
	bl digitalWrite		//Turn off Red LED
	bal buzz_Return
not_Red:
	cmp r0, #YELLOW
	bne not_Yellow
	mov r1, #5
	ldr r7, [r5, r1, LSL #2]//r0=pinArray[0+(5*4)]==Red_out
	mov r0, r7		//r0=Red_out
	mov r1, #HIGH
	bl digitalWrite		//Turn on Red LED
	mov r1, #4
	ldr r7, [r5, r1, LSL #2]//r0=pinArray[0+(4*4)]==Green_out
	mov r0, r7		//r0=Green_out
	mov r1, #HIGH
	bl digitalWrite		//Turn on Green LED
	mov r1, #7
	ldr r0, [r5, r1, LSL #2]//r0=pinArray[0+(7*4)]==Buzzer
	ldr r1, =#Y_TONE
	bl softToneWrite	//Turn on Yellow sound
	mov r0, r4
	bl delay		//Delay
	mov r1, #5
	ldr r7, [r5, r1, LSL #2]//r0=pinArray[0+(5*4)]==Red_out
	mov r0, r7		//r0=Red_out
	mov r1, #LOW
	bl digitalWrite		//Turn off Red LED
	mov r1, #4
	ldr r7, [r5, r1, LSL #2]//r0=pinArray[0+(4*4)]==Green_out
	mov r0, r7		//r0=Green_out
	mov r1, #LOW
	bl digitalWrite		//Turn off Green LED
	bal buzz_Return
not_Yellow:
	mov r1, #6
	ldr r7, [r5, r1, LSL #2]//r0=pinArray[0+(6*4)]==Blue_out
	mov r0, r7		//r0=Blue_out
	mov r1, #HIGH
	bl digitalWrite		//Turn on Blue LED
	mov r1, #7
	ldr r0, [r5, r1, LSL #2]//r0=pinArray[0+(7*4)]==Buzzer
	ldr r1, =#B_TONE
	bl softToneWrite	//Turn on Blue sound
	mov r0, r4
	bl delay		//Delay
	mov r0, r7		//r0=Blue_out
	mov r1, #LOW
	bl digitalWrite		//Turn off Blue LED
buzz_Return:
	mov r1, #7
	ldr r0, [r5, r1, LSL #2]//r0=pinArray[0+(7*4)]==Buzzer
	mov r1, #0
	bl softToneWrite	//Quiet the buzzer

	pop {r4, r5, r6, r7, pc}
.endfunc
/////////////////////////////////////////////////////////////////
/* setArr
	purpose- Sets color array
	parameters- Pointer to array, size of array, seed
	input-      x
	output-     x
	return-     x but modifies array
*/
.func setArr
setArr:
	push {r4, r5, r6, r7, lr}
	mov r4, r0	//r4=pointer to array
	mov r5, #0	//for(int i=0;...
	mov r6, r1	//...i<arrSize;...
	mov r7, r3	//r7= pointer to seed
init_loop:
	mov r0, #130
	bl delay
	cmp r5, r6
	bge init_done	//branch if greater than or equal
	bl getRand	//r0=random int
	mov r1, #4
	bl div_mod	//r0=i%4
	str r0, [r4,+r5, LSL #2] //store i%4 into array[0+(r4<<2)]
				 // [0+(r4<<2)]==[0+i*4]
	add r5, #1	//...i++)
	bal init_loop
init_done:
	pop {r4, r5, r6, r7, pc}
.endfunc
/////////////////////////////////////////////////////////////////
/* 	getArr
	purpose- Displays the color array
	parameter- Pointer to array, Max array to display, pin array
	input-     x
	output-    Outputs colors and their corresponding sounds
	return-    x
*/
.func getArr
getArr:
	push {r4, r5, r6, r7, lr}
	mov r4, #0		//for(int i=0;...
	mov r6, r0		//r6=pointer to array
	mov r5, r1		//r5=# of indexes to display
	mov r7, r2		//r7=pin array
getArr_loop:
	mov r0, #50
	bl delay
	cmp r4, r5		//...i<maxTurns;...
	bge getArr_done		//branch if(i>=maxTurns)
	ldr r0, [r6,+r4, LSL #2]//r0=&array[0+(i*4)]
	//ldr r0, [r0]		//r0=&array[0+(i*4)]
	mov r1, #SHORT		//Short output
	mov r2, r7		//r7=pin array
	bl buzz			//Output color
	add r4, #1		//...i++)
	bal getArr_loop
getArr_done:
	pop {r4, r5, r6, r7, pc}
.endfunc
/////////////////////////////////////////////////////////////////
/* 	play
	purpose- Plays a game of Simon
	parameter- Pointer to array, Max number of turns, Pointer to pins
	input-     computer generated pattern
	output-    pattern, new color every turn
	return-    x
*/
.func play
play:
	push {r4, r5, r6, r7, lr}

	mov r4, r0		//r4=pointer to array
	mov r5, #1		//for(int i=1;...
	mov r6, r1		//r6=maxTurns
	mov r7, r2		//r7=pin array

	mov r0, #0
	mov r2, #7
	ldr r1, [r7, r2, LSL #2]//r1=pinArray[0+(7*4)]==Buzzer
	bl sounds
	ldr r0, =#LONG		//Delay for 1s
	bl delay
play_loop:
	ldr r0, =#LONG		//Delay for 1s
	bl delay
	cmp r5, r6		//...i<=maxTurns...
	bgt win			//if(i>maxTurns) win
	mov r0, r4		//r0=*array
	mov r1, r5		//r1=i=turn
	mov r2, r7		//r2=pin array
	bl getArr		//display array up to turn
	mov r0, r4		//r0=pointer to array
	mov r1, r5		//r5=current turn
	mov r2, r7		//r2=pin array
	bl compare		//compare user input to array
	cmp r0, #0		//compare returns win or lose
	bne lose		//if(lose=true) exit
	add r5, #1		//...i++)
	bal play_loop
lose:
	mov r0, #1		//1=losing sound
	mov r2, #7
	ldr r1, [r7, r2, LSL #2]//r0=pinArray[0+(7*4)]==Buzzer
	bl sounds
win:
play_exit:
	pop {r4, r5, r6, r7, pc}
.endfunc
/////////////////////////////////////////////////////////////////
/* 	sounds
	purpose- Plays sounds for game
	parameter- 0 for game start, 1 for game lose, r1 buzzer pin
	input-     x
	output-    a game start sound, or game lose sound
	return-    x
*/
.func sounds
sounds:
	push {r4, lr}
	mov r4, r1	//r1=buzzer pin
	cmp r0, #0
	bne lose_sound

	mov r0, r1
	ldr r1, =#300	//Tone
	bl softToneWrite
	ldr r0, =#200	//Delay for .2s
	bl delay
	mov r0, r1
	ldr r1, =#0
	bl softToneWrite
	ldr r0, =#200	//Delay for .2s
	bl delay
	mov r0, r1
	ldr r1, =#800	//Tone
	bl softToneWrite
	ldr r0, =#200	//Delay for .2s
	bl delay
	mov r0, r1
	ldr r1, =#0
	bl softToneWrite
	ldr r0, =#200	//Delay for .2s
	bl delay
	mov r0, r1
	ldr r1, =#1000	//Tone
	bl softToneWrite
	ldr r0, =#1600	//Delay for 1.6s
	bl delay
	mov r0, r1
	ldr r1, =#0
	bl softToneWrite
	bal sounds_return	//Return
lose_sound:
	mov r0, r1
	ldr r1, =#1000	//Tone
	bl softToneWrite
	ldr r0, =#200	//Delay for .2s
	bl delay
	mov r0, r1
	ldr r1, =#0
	bl softToneWrite
	ldr r0, =#200	//Delay for .2s
	bl delay
	mov r0, r1
	ldr r1, =#800	//Tone
	bl softToneWrite
	ldr r0, =#200	//Delay for .2s
	bl delay
	mov r0, r1
	ldr r1, =#0
	bl softToneWrite
	ldr r0, =#200	//Delay for .2s
	bl delay
	mov r0, r1
	ldr r1, =#300	//Tone
	bl softToneWrite
	ldr r0, =#1600	//Delay for 1.6s
	bl delay
	mov r0, r1
	ldr r1, =#0
	bl softToneWrite
sounds_return:
	pop {r4, pc}
.endfunc
/////////////////////////////////////////////////////////////////
/* 	compare
	purpose- compares user input to array
	parameter- Pointer to array, turn, pin array
	input-     pattern
	output-    buzz and if you lose, then display losing pattern
	return-    1 for loss else return
*/
.func compare
compare:
	push {r4, r5, r6, r7, r8, lr}
	mov r4, #0		//for(int i=0;...
	mov r6, r0		//r6=pointer to array
	mov r5, r1		//r5=turn
	mov r8, r2		//r8=pin array
compare_loop:
	mov r0, #0		//return 0 if didn't lose
	cmp r4, r5		//...i<turn;...
	bge compare_done	//branch if(i>=maxTurns)
	mov r0, r8		//r0=pin array
	bl getInput		//r0=input
	mov r7, r0		//r7=r0
	ldr r1, =#MEDIUM	//Medium output
	mov r2, r8		//r2=pin array
	bl buzz			//Output color
	ldr r2, [r6,+r4, LSL #2]//r2=array[0+(i*4)]
	cmp r7, r2		//compare input with array
	bne compare_lose
	add r4, #1		//...i++)
	bal compare_loop
compare_lose:
	mov r0, #1		//Return 1 for loss
compare_done:

	pop {r4, r5, r6, r7, r8, pc}
.endfunc
/////////////////////////////////////////////////////////////////
/* 	getRand
	purpose- semi-random number generator,
	for multiple random numbers, use delay() between function calls
	parameter- x
	input-     x
	output-    x
	return-    random integer
*/
.func getRand
getRand:
	push {lr}
	
	bl clock	//r0=system clock
	mov r1, #53
	mul r0, r1	//r0*=53
	
	pop {pc}
.endfunc
/////////////////////////////////////////////////////////////////
