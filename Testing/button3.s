.equ LOW, 0
.equ HIGH, 1
.equ INPUT, 0
.equ OUTPUT, 1

.equ LED_TACTILE, 1
.equ EXIT_TACTILE, 6
.equ LED_OUTPUT, 22

.data
out_msg: .asciz "%d\n"

//int main()
.text
.global main
main:
	push {lr} 
	bl wiringPiSetup 
	//pinMode(1, INPUT);
	mov r0, #LED_TACTILE
	mov r1, #INPUT
	bl pinMode
	//pinMode(6, INPUT);
	mov r0, #EXIT_TACTILE
	mov r1, #INPUT
	bl pinMode
	//pinMode(22, OUTPUT);
	///mov r0, #LED_OUTPUT
	///mov r1, #OUTPUT
	///bl pinMode
	//while(digitalRead(6)==0)
whl_loop:
	mov r0, #EXIT_TACTILE
	bl digitalRead
	cmp r0, #HIGH
	beq whl_done
	//{
		//int r = digitalRead(1);
	mov r0, #LED_TACTILE
	bl digitalRead
	///mov r4, r0
		//printf("%d\n", r);
	mov r1, r0
	ldr r0, =out_msg
	bl printf
	///mov r0, #LED_OUTPUT
	///mov r1, r4
	///bl digitalWrite
	bal whl_loop
whl_done:
	mov r0, #0
	pop {pc}
	//}
	//return 0;
//}