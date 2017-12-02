.global menu		//void menu();
.global getInput	//int getInput(pin1,pin2,pin3,pin4);
.global buzz		//void buzz(pin,tone,time);
//All parameters are type INT

.section .data
menu_msg: .asciz "green: start game\nred:set combination\nyellow: nothing\nblue: quit\n"


/* 	getInput
	purpose- detects input
	parameter- all four input pins
	input-     high tactile button
	output-    x
	return-    first tactile button pressed in r0
*/
.func getInput
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
	ba getInput_return	//if(green==high) return green
green_false:
	mov r0, r5
	bl digitalRead
	cmp r0, #HIGH
	bne red_false		//if(red_in==low) branch next
	mov r0, #RED
	ba getInput_return	//if(red==high) return red
red_false:
	mov r0, r6
	bl digitalRead
	cmp r0, #HIGH
	bne yellow_false	//if(yellow_in==low) branch next
	mov r0, #YELLOW
	ba getInput_return	//if(yellow==high) return yellow
yellow_false:
	mov r0, r7
	bl digitalRead
	cmp r0, #HIGH
	bne blue_false		//if(blue_in==low) branch next
	mov r0, #BLUE
	ba getInput_return	//if(blue==high) return blue

getInput_return:
	pop {r4, r5, r6, r7, pc}

.endfunc


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

/* 	buzz
	purpose- lights and buzzes based on color
	parameter- pin color, tone, time
	input-     x
	output-    sound and light based on color
	return-    same color in r0
*/
.func buzz
buzz:
	push {r4, r5, lr}
	mov r4, r0	//r4=pin color
	mov r5, r1	//r5=tone
	mov r6, r2	//r6=time

	mov r0, r4
	mov r1, #HIGH
	bl digitalWrite

	//sound

	ldr r0, =r6
	bl delay

	mov r0, r4
	mov r1, #LOW
	bl digitalWrite

	
	pop {r4, r5, pc}

.endfunc