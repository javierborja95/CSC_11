.equ SEED, 12

.text
.balign 4
.global main
main:
	push {lr}
	mov r0, #SEED
	bl srand

	ldr r4, =array
	mov r5, #0	//for(int i=0;...
	mov r6, #32	//...i<32;...
init_loop:
	cmp r5, r6
	bge init_done	//branch if greater than or equal
	//bl rand
	mov r0, r5	//r0=i%4
	mov r1, #4
	bl mod
	str r0, [r4,+r5, LSL #2] //store i%4 into array[0+(r4<<2)]
				 // [0+(r4<<2)]==[0+i*4]
	add r5, #1	//...i++)
	bal init_loop
init_done:
	ldr r0, =array
	mov r1, #32
	bl output_array

	mov r0, #0
	pop {pc}


output_array:
	push {r4,r5,r6,lr}
	mov r5, #0	// R5 contains starting index for output
	mov r4, r0	// R4 contains the array base address
	mov r6, r1	// R6 contains size of array
oa_loop:cmp r5, r6	// Is R5 equal to the number of elements to output?
	beq oa_done	// If so, we're done!
	ldr r2, [r4,+r5, LSL #2]// R2 contains a[R4+(R5 << 2)]
	mov r1, r5	// output our index as well
	ldr r0, =output_str // R0 contains pointer to our output string
	bl printf
	add r5, #1	// increment our index by 1
	bal oa_loop	// jump back up to oa_loop for next element
oa_done:
	pop {r4,r5,r6,pc}

.section .bss
.balign 4

array: .skip 128 //32 indexes*4bytes = 128 bytes


.section .rodata
output_str: .asciz "a[%d]=%d\n"

.text
.global mod
mod:
	push {r4, r5, lr}
	cmp r0, r1
	beq mod_zero    //return zero if x==mod#
	mov r4, r0	//r4=x
	mov r5, r1	//r5=mod
	mov r1, r4	//r1=x
	mov r0, #0
mod_loop:		//01=x/mod
	sub r1, r1, r5	//r1=x-mod
	cmp r1, #0
	ble mod_loop_end//Branch if division results in (x<=0)
	add r0, #1	//r0 keeps track of # of divides
	bal mod_loop
mod_loop_end:
	cmp r0, #0	//If (r0==0) return 0
	beq mod_zero
	mul r0, r5	//r0=r0*mod
	sub r0, r4, r0	//remainder=x-r0
	bal mod_return
mod_zero:
	mov r0, #0	//return n%n
mod_return:
	pop {r4, r5, pc}
