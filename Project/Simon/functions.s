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

.equ G_TONE, 165
.equ R_TONE, 440
.equ Y_TONE, 277
.equ B_TONE, 330

.global menu		//void menu();
.global getInput	//int getInput(pin1,pin2,pin3,pin4);
.global buzz		//void buzz(color,time);
//All parameters are type INT

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

.data
menu_msg: .asciz "green: start game\nred:set combination\nyellow: nothing\nblue: quit\n"
