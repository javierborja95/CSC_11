.text
.global main
.data
instruct1: .asciz "Hello! Welcome to Two Integers.\n\nEnter an integer for first number: "
instruct2: .asciz "Enter an integer for second number: "
num1: .word 0
num2: .word 0
sum:  .word 0
diff: .word 0
prod: .word 0
spec1: .asciz "%d"
spec3: .asciz "%d,%d,%d"
out1: .asciz "The sum of %d and %d is %d\n\n"
out2: .asciz "The difference of %d and %d is %d\n\n"
out3: .asciz "The product of %d and %d is %d\n\n"

main: 
	push {lr}

	//Input Data
	ldr r0, = instruct1 //Load first instruction
	bl printf	    //Display first instruction
	ldr r0, = spec 1    //Load single format specifier 
	ldr r1, = num1      //r1 points to first number
	bl scanf            //Call to scanf
	ldr r0, = instruct2 //Load second instruction
	bl printf	    //Display second instruction
	ldr r0, = spec 1    //Load single format specifier 
	ldr r1, = num2      //r1 points to second number
	bl scanf            //Call to scanf

	//Process Data
	ldr r0 = num1       //r0 points to first number
	ldr r0, [r0]        //r0 contains value of first number
	ldr r1 = num2       //r1 points to first number
	ldr r1, [r1]        //r1 contains value of first number
	ldr r2, = sum       //r2 points to sum
	ldr r3, = diff	    //r3 points to difference
	ldr r4, = prod      //r4 points to product
	add r5, r0, r1      //r5=num1+num2
	str r2, r5          //Store result to sum label
	sub r5, r1, r0      //r5=num2-num1
	str r3, r5          //Store result to difference label
	mul r5, r0, r1      //r5=num1*num2
	str r4, r5          //Store result to product label

	//Output Data
	ldr r0, = spec3     //Load triple format specifier
	ldr r1, = out1      //Load first output
	ldr r2, = num1      //r2 points to first number
	ldr r2, [r2]        //r2 contains value of first number
	ldr r3, = num2      //r3 points to second number
	ldr r3, [r3]        //r3 contains value of second number
	ldr r4, = sum       //r4 points to the sum
	ldr r4, [r4]        //r4 contains value of sum
	bl printf           //Display sum string

	ldr r0, = spec3     //Load triple format specifier
	ldr r1, = out2      //Load second output
	ldr r2, = num1      //r2 points to first number
	ldr r2, [r2]        //r2 contains value of first number
	ldr r3, = num2      //r3 points to second number
	ldr r3, [r3]        //r3 contains value of second number
	ldr r4, = diff      //r4 points to the difference
	ldr r4, [r4]        //r4 contains value of difference
	bl printf           //Display difference string

	ldr r0, = spec3     //Load triple format specifier
	ldr r1, = out3      //Load third output
	ldr r2, = num1      //r2 points to first number
	ldr r2, [r2]        //r2 contains value of first number
	ldr r3, = num2      //r3 points to second number
	ldr r3, [r3]        //r3 contains value of second number
	ldr r4, = prod      //r4 points to the product
	ldr r4, [r4]        //r4 contains value of product
	bl printf           //Display product string
	

	pop {pc}