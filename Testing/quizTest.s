.fpu neon		
.data
x: .word 12,34,45,56,67,78,89,90
y: .word 32,43,54,65,76,87,98,99
z: .word  0,0,0,0,0,0,0,0
.text
.global main
main:
push {lr}
mov R0, #165
mov R1, #17

add R1, R0, lsr #3
mov R0, R0, lsl #2
mov PC, LR

pop {pc}

