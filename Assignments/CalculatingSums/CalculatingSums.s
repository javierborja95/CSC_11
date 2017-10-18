.global main

.section.rodata
prompt:        .asciz "Enter a positive value for N: : "
outputIntSums: .asciz "The sum of all the integers from 1 to %d is: %d\n"
outputSqrSums: .asciz "The sum of all the squares  from 1 to %d is: %d\n"
errorMsg:      .asciz "Invalid value for N, must be positive!\n"
specifier:     .asciz "%d"

.data
//count: .word 0
input: .word 0
//intSum: .word 0
//sqrSum: .word 0

.text
main: 
	push {lr}
	
	//Input Data
	ldr r0, = prompt    //Load instruction
	bl printf           //Display instruction
	ldr r0, = spec1	    //Load single format specifier
	ldr r1, = input     //r1 points to input
	bl scanf            //Call to scanf
	ldr r1, = input     //r1 points to input
	ldr r1, [r1]        //r1 contains the value of input
	cmp r1, #0          //Compare input to zero
	ble error           //If(input <= 0) branch to error
	ldr r4, #0          //r4 will be the integer sum
	ldr r5, #0          //r5 will be the sqr sum
	ldr r6, #0          //r6 will be the counter
	
	//Process Data
while_CountLtInput
	cmp r6, r1          //Compare counter and input
	bge output          //if(counter>=input) branch to output
	add r6, #1          //counter++
	sum r4, r4, r6      //intSum=intSum + counter
	mul r7, r6, r6      //r7=square of the counter
	sum r5, r5, r7      //sqrSum=sqrSum + square of counter
	bal while_CountLtInput //Always branch to beginning of loop
	
	//Output Data
output:
	ldr r0, = outputIntSums //Load output message
	                    //r1 already contains input
	mov r2, r4          //Move integer sum to r2 
	bl scanf            //Call scanf
	ldr r0, = outputSqrSums //Load output message
	ldr r1, = input     //r1 points to input
	ldr r1, [r1]        //r1 has value of input
	mov r2, r5          //Move square of sums to r2
	bl scanf            //Call scanf
	bal end             //Branch to end of program
error:
	ldr r0, = errorMsg  //Load error message
	bl scanf            //Call to scanf

end:
	pop {pc}