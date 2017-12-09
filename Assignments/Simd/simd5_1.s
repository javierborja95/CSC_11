.fpu neon

.section .data
.align 8
x: .float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
y: .float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0

.section .rodata
.align 8
scan_fmt: .asciz "%f %f %f %f %f %f %f %f"
prompt: .asciz "Enter eight float values (seperated by space): "

stride1_out: .asciz "Strides of 1: %lf, %lf, %lf, %lf, %lf, %lf, %lf, %lf\n"
stride2_out: .asciz "Strides of 1: %f, %f, %f, %f, %f, %f, %f, %f\n"
stride4_out: .asciz "Strides of 1: %f, %f, %f, %f, %f, %f, %f, %f\n"

.section .text
.align 8
.global main
main:
	push {lr}
	ldr r0, =prompt
	bl printf
	ldr r0, =scan_fmt
	ldr r1, =x
	add r2, r1, #8
	add r3, r1, #16
	add r4, r1, #56
	push {r4}	// aapcs states fourth pointer must be on stack
	add r4, #-8
	push {r4}
	add r4, #-8
	push {r4}
	add r4, #-8
	push {r4}
	add r4, #-8
	push {r4}
	bl scanf
	add sp, #40	// set sp back to what it was before push {r4}'s

//////////////////////////////////////////////////////////////////////
	ldr r5, =x
	ldr r6, =y
	vld1.f32 {q0,q1}, [r5]
	vst1.f32 {q0,q1}, [r6]

	add fp, sp, #0
	sub sp, sp, #56
	ldr r0, =stride1_out
	mov r1, r6
	flds s0, [r1]
	vcvt.f64.f32  d5, s0    // convert first value to double
    vmov r2, r3, d5       // pass in r2/r3

	flds s0, [r1, #8]
	fcvtds d6, s0    // convert second value to double
	fstd d6, [sp]

	flds s0, [r1, #16]		// third
	fcvtds d6, s0
	fstd d6, [sp, #16]

	flds s0, [r1, #24]		// fourth
	fcvtds d6, s0
	fstd d6, [sp, #32]
	
	flds s0, [r1, #32]		// fifth value
	fcvtds d6, s0
	fstd d6, [sp, #48]

	flds s0, [r1, #40]		// sixth value
	fcvtds d6, s0
	fstd d6, [sp, #64]
	
	flds s0, [r1, #48]		// seventh
	fcvtds d6, s0
	fstd d6, [sp, #80]

	flds s0, [r1, #56]		// eighth
	fcvtds d6, s0
	fstd d6, [sp, #96]
	
	bl printf
	add sp, #96

//////////////////////////////////////////////////////////////////
/*
	ldr r5, =x
	ldr r6, =y
	vld1.32 {q0}, [r5]
	vst2.32 {q0}, [r6]

	add fp, sp, #24
	sub sp, sp, #28
	ldr r0, =stride2_out
	mov r1, r6
	flds s0, [r1]
	vcvt.f64.f32  d5, s0    // convert first value to double
  vmov r2, r3, d5       // pass in r2/r3

	flds s0, [r1, #4]
	fcvtds d6, s0    // convert second value to double
	vstr d6, [sp]

	flds s0, [r1, #8]
	fcvtds d6, s0
	vstr d6, [sp, #8]

	flds s0, [r1, #12]
	fcvtds d6, s0
	vstr d6, [sp, #16]
	bl printf
	add sp, #28
*/
//////////////////////////////////////////////////////////////////
	pop {pc}
