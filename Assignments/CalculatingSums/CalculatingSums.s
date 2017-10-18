.text
.global main
.rodata
prompt: 	   .asciz "Enter a positive integer: "
outputIntSums: .asciz "The sum of all the integers from 1 to %d is: %d\n"
outputSqrSums: .asciz "The sum of all the squares from 1 to %d is: %d\n"
errorMsg:      .asciz "Error: Input must be an integer greater than 0\n"
specifier:     .asciz "%d"
.data
//count: .word 0
input: .word 0
//intSum: .word 0
//sqrSum: .word 0

main: 
	push {lr}
	
	//Input Data
	ldr r0, = prompt	//Load instruction
	bl printf           //Display instruction
	ldr r0, = spec1	    //Load single format specifier
	ldr r1, = input     //r1 points to input
	bl scanf            //Call to scanf
	ldr r1, = input     //r1 points to input
	ldr r1, [r1]        //r1 contains the value of input
	cmp r1, #0			//Compare input to zero
	ble error           //If(input <= 0) branch to error
	ldr r4, #0          //r4 will be the integer sum
	ldr r5, #0          //r5 will be the sqr sum
	ldr r6, #0          //r6 will be the counter
	
	//Process Data
while_CountLtInput
	cmp r6, r1          //Compare counter and input
	bge output          //if(counter>=input) branch to output
	add r6, #1          //counter++
	
	bal while_CountLtInput //Always branch to beginning of loop
	
	//Output Data
output:
error:
	ldr r0, = errorMsg  //Load error message
	bl scanf            //Call to scanf
end:
	pop {pc}